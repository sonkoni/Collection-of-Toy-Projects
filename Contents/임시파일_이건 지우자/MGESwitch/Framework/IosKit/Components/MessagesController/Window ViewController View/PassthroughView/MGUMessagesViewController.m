//
//  MGUMessagesViewController.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "UIWindow+Extension.h"
#import "MGUMessagesViewController.h"
#import "MGUMessagesConfig.h"
#import "MGUMessagesPassthroughView.h"
#import "MGUMessagesPassthroughWindow.h"

@interface MGUMessagesViewController ()
@property (nonatomic, strong, nullable) UIWindow *window;
@property (nonatomic, weak, nullable) UIWindow *previousKeyWindow;
@end

@implementation MGUMessagesViewController

+ (MGUMessagesViewController *)newInstanceConfig:(MGUMessagesConfig *)config {
    if (config.windowViewController!= nil) {
        MGUMessagesViewController *windowViewController = config.windowViewController(config);
        if (windowViewController != nil) {
            return windowViewController;
        }
    }
    
    return [[MGUMessagesViewController alloc] initWithConfig:config];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.config.preferredStatusBarStyle;
//    return config.preferredStatusBarStyle ?? super.preferredStatusBarStyle
}

- (BOOL)prefersStatusBarHidden {
    return self.config.prefersStatusBarHidden;
//    return config.prefersStatusBarHidden ?? super.prefersStatusBarHidden
}

- (BOOL)shouldAutorotate {
    return self.config.shouldAutorotate;
}

- (instancetype)init {
    return [self initWithConfig:[MGUMessagesConfig new]];
}


- (void)loadView {
    self.view = [MGUMessagesPassthroughView new];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithConfig:(MGUMessagesConfig *)config {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUMessagesViewController *self) {
    self.window = [[MGUMessagesPassthroughWindow alloc] initWithHitTestView:self.view];
    self.window.rootViewController = self;
    
    UIWindowLevel windowLevel = self.config.windowLevel;
    if (MGEFloatIsNull(windowLevel) == YES) {
        windowLevel = UIWindowLevelNormal;
    }

    self.window.windowLevel = windowLevel;
    self.window.overrideUserInterfaceStyle = self.config.overrideUserInterfaceStyle;
}

- (void)install {
    self.window.windowScene = self.config.windowScene;
    _previousKeyWindow = [UIWindow mgrKeyWindow];
    CGRect frame = CGRectNull;
    if (self.config.windowScene != nil) {
        frame = self.config.windowScene.coordinateSpace.bounds;
    }
    
    [self showBecomeKey:self.config.shouldBecomeKeyWindow frame:frame];
}

- (void)uninstall {
    if (self.window.isKeyWindow == YES) {
        [self.previousKeyWindow makeKeyWindow];
    }
    
    self.window.windowScene = nil;
    self.window.hidden = YES;
    self.window = nil;
}


- (void)showBecomeKey:(BOOL)becomeKey frame:(CGRect)frame {
    if (self.window == nil) {
        return;
    }
    
    if (CGRectIsNull(frame) == NO) {
        self.window.frame = frame;
    } else {
        self.window.frame = [UIScreen mainScreen].bounds;
    }
    
    if (becomeKey == YES) {
        [self.window makeKeyAndVisible];
    } else {
        self.window.hidden = NO;
    }
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { NSCAssert(FALSE, @"- initWithNibName:bundle: 사용금지."); return nil; }
@end
