//
//  MGAPreferencesTabViewController.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGAPreferencesTabViewController.h"
#import "MGAPreferencePane.h"
#import "MGASegmentedControlStyleViewController.h"
#import "MGAToolbarItemStyleViewController.h"
#import "MGALocalization.h"
@import BaseKit;
#import "NSView+Extension.h"

@interface MGAPreferencesTabViewController ()
@property (nonatomic, strong) NSMutableArray <NSViewController <MGAPreferencePane>*>*preferencePanes;
@property (nonatomic, assign) MGAPreferencesStyle style;
@property (nonatomic, strong) id <MGAPreferencesStyleController>preferencesStyleController;
@property (nonatomic, strong, readonly) NSArray <NSToolbarItemIdentifier>*toolbarItemIdentifiers; // @dynamic
@property (nonatomic, assign) NSInteger activeTab; // 디폴트 NSNotFount
@property (nonatomic, assign, readonly) BOOL isKeepingWindowCentered; // @dynamic

// Cached constraints that pin `childViewController` views to the content view.
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *>*activeChildViewConstraints;
@end

@implementation MGAPreferencesTabViewController
@dynamic preferencePanesCount;
@dynamic window;
@dynamic toolbarItemIdentifiers;
@dynamic isKeepingWindowCentered;
@dynamic activeViewController;

- (void)transitionFromViewController:(NSViewController *)fromViewController
                    toViewController:(NSViewController *)toViewController
                             options:(NSViewControllerTransitionOptions)options
                   completionHandler:(void (^)(void))completion {
    NSViewControllerTransitionOptions options2 = NSViewControllerTransitionCrossfade|
                                                 NSViewControllerTransitionSlideUp|
                                                 NSViewControllerTransitionSlideDown|
                                                 NSViewControllerTransitionSlideForward|
                                                 NSViewControllerTransitionSlideBackward|
                                                 NSViewControllerTransitionSlideLeft|
                                                 NSViewControllerTransitionSlideRight;
    NSViewControllerTransitionOptions result = options & options2;
    
    BOOL isAnimated = (result != NSViewControllerTransitionNone) ? YES : NO;

    if (isAnimated == YES) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
            context.allowsImplicitAnimation = YES;
            context.duration = 0.25;
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self setWindowFrameFor:toViewController animated:YES];
            [super transitionFromViewController:fromViewController
                               toViewController:toViewController
                                        options:options
                              completionHandler:completion];
          } completionHandler:^{}];
    } else {
        [super transitionFromViewController:fromViewController
                           toViewController:toViewController
                                    options:options
                          completionHandler:completion];
    }
}

- (void)loadView {
    self.view = [NSView new];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _animated = YES;
    _preferencePanes = [NSMutableArray array];
    _activeTab = NSNotFound;
    _activeChildViewConstraints = [NSMutableArray array];
}


#pragma mark - 세터 & 게터
- (NSArray <NSToolbarItemIdentifier>*)toolbarItemIdentifiers {
    NSArray <NSToolbarItemIdentifier>*result = [self.preferencesStyleController toolbarItemIdentifiers];
    if (result != nil) {
        return result;
    } else {
        return @[];
    }
}

- (BOOL)isKeepingWindowCentered {
    return self.preferencesStyleController.isKeepingWindowCentered;
}

- (NSViewController *)activeViewController {
    if (self.activeTab == NSNotFound) {
        return nil;
    } else {
        return self.preferencePanes[self.activeTab];
    }
}


#pragma mark - <NSToolbarDelegate>
- (NSArray <NSToolbarItemIdentifier>*)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return self.toolbarItemIdentifiers;
}


- (NSArray <NSToolbarItemIdentifier>*)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return self.toolbarItemIdentifiers;
}

- (NSArray <NSToolbarItemIdentifier>*)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    if (self.style == MGAPreferencesStyleSegmentedControl) {
        return @[];
    } else {
        return self.toolbarItemIdentifiers;
    }
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:NSToolbarFlexibleSpaceItemIdentifier] == YES) {
        return nil;
    }
    return [self.preferencesStyleController toolbarItemPreferenceIdentifier:itemIdentifier];
}


#pragma mark - <MGAPreferencesStyleControllerDelegate>
- (void)activateTabPreferenceIdentifier:(NSToolbarItemIdentifier)preferenceIdentifier animated:(BOOL)animated {
    __block NSInteger index = NSNotFound;
    [self.preferencePanes enumerateObjectsUsingBlock:^(NSViewController <MGAPreferencePane>*vc, NSUInteger idx, BOOL *stop) {
        if ([vc.preferencePaneIdentifier isEqualToString:preferenceIdentifier] == YES) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == NSNotFound) {
        [self activateTabIndex:0 animated:YES];
    } else {
        [self activateTabIndex:index animated:YES];
    }
}

- (void)activateTabIndex:(NSInteger)index animated:(BOOL)animated {
    MGR_DEFER {
        self.activeTab = index;
        [self.preferencesStyleController selectTabIndex:index];
        [self updateWindowTitleTabIndex:index];
    };

    if (self.activeTab == NSNotFound) {
        [self immediatelyDisplayTabIndex:index];
    } else if (index != self.activeTab) {
        [self animateTabTransitionIndex:index animated:animated];
    }
}

#pragma mark ---- private
- (void)animateTabTransitionIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.activeTab == NSNotFound) {
        NSCAssert(FALSE, @"animateTabTransition called before a tab was displayed; transition only works from one tab to another");
        [self immediatelyDisplayTabIndex:index];
        return;
    }
    
    NSLog(@"animateTabTransitionIndex:... 실행됨.");
    NSViewController <MGAPreferencePane>*fromViewController = self.preferencePanes[self.activeTab];
    NSViewController <MGAPreferencePane>*toViewController = self.preferencePanes[index];

    // View controller animations only work on macOS 10.14 and newer.
    NSViewControllerTransitionOptions options = NSViewControllerTransitionNone;
    if (@available(macOS 10.14, *)) {
        if (animated == YES && self.isAnimated == YES) {
            options = NSViewControllerTransitionCrossfade;
        }
    }
    
    [self.view removeConstraints:self.activeChildViewConstraints];

    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                               options:options
                     completionHandler:^{
        self.activeChildViewConstraints = [toViewController.view mgrPinEdgesToSuperviewEdges].mutableCopy;
    }];
}

- (void)immediatelyDisplayTabIndex:(NSInteger)index {
    NSViewController <MGAPreferencePane>*toViewController = self.preferencePanes[index];
    [self.view addSubview:toViewController.view];
    self.activeChildViewConstraints = [toViewController.view mgrPinEdgesToSuperviewEdges].mutableCopy;
    [self setWindowFrameFor:toViewController animated:NO];
}

- (void)updateWindowTitleTabIndex:(NSInteger)tabIndex {
    if (self.preferencePanes.count > 1) {
        self.window.title = self.preferencePanes[tabIndex].preferencePaneTitle;
    } else {
        NSString *preferences = [MGALocalization subscriptIdentifier:MGALocalizationIdentifierPreferences];
        NSString *appName = [[NSBundle mainBundle] mgrAppName];
        self.window.title = [NSString stringWithFormat:@"%@ %@", appName, preferences];
    }
}


#pragma mark ----
//@property (nonatomic, assign, getter = isAnimated) BOOL animated; // 디폴트 true
- (NSWindow *)window {
    return self.view.window;
}

- (NSInteger)preferencePanesCount {
    return self.preferencePanes.count;
}

- (void)configurePreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes
                           style:(MGAPreferencesStyle)style {
    self.preferencePanes = preferencePanes.mutableCopy;
    self.style = style;
    self.childViewControllers = preferencePanes;

    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"PreferencesToolbar"];
    toolbar.allowsUserCustomization = NO;
    toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    toolbar.showsBaselineSeparator = YES;
    toolbar.delegate = self;

    if (style == MGAPreferencesStyleSegmentedControl) {
        self.preferencesStyleController =
        [[MGASegmentedControlStyleViewController alloc] initWithPreferencePanes:preferencePanes];
    } else if (style == MGAPreferencesStyleToolbarItems) {
        self.preferencesStyleController =
        [[MGAToolbarItemStyleViewController alloc] initWithPreferencePanes:preferencePanes
                                                                   toolbar:toolbar
                                                        centerToolbarItems:NO];
    } else {
        NSCAssert(FALSE, @"잘못 들어왔다.");
    }
    
    self.preferencesStyleController.delegate = self;

    // Called last so that `preferencesStyleController` can be asked for items.
    self.window.toolbar = toolbar;
}


#pragma mark - Public Action
- (void)restoreInitialTab {
    if (self.activeTab == NSNotFound) {
        [self activateTabIndex:0 animated:NO];
    }
}


#pragma mark - Action
- (void)setWindowFrameFor:(NSViewController *)viewController animated:(BOOL)animated {
    if (self.window == nil) {
        NSAssert(FALSE, @"self.window == nil 이다.");
    }
    
    //! 이걸 넣어줘야하는 듯...
    [self.view addSubview:viewController.view];
    NSSize contentSize = viewController.view.fittingSize;
    
    CGSize newWindowSize = [self.window frameRectForContentRect:(CGRect){CGPointZero, contentSize}].size;
    CGRect frame = self.window.frame;
    frame.origin.y += frame.size.height - newWindowSize.height;
    frame.size = newWindowSize;
    
    if (self.isKeepingWindowCentered == YES) {
        CGFloat horizontalDiff = (self.window.frame.size.width - newWindowSize.width) / 2.0;
        frame.origin.x += horizontalDiff;
    }
    
    NSWindow *animatableWindow = animated ? [self.window animator] : self.window;
    [animatableWindow setFrame:frame display:NO];
}

@end
