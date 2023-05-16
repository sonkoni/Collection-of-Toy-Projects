//
//  MGASegmentedControlStyleViewController.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGASegmentedControlStyleViewController.h"
#import "MGAPreferencePane.h"
#import "NSArray+Filtering.h"

static NSToolbarItemIdentifier const toolbarSegmentedControlItem = @"toolbarSegmentedControlItem";

static NSUserInterfaceItemIdentifier const toolbarSegmentedControl = @"toolbarSegmentedControl";


@interface MGASegmentedControlStyleViewController ()
@property (nonatomic, strong) NSMutableArray <NSViewController <MGAPreferencePane>*>*preferencePanes;
@end

@implementation MGASegmentedControlStyleViewController
@dynamic segmentedControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)loadView {
    self.view = [self createSegmentedControlPreferencePanes:self.preferencePanes];
}

#pragma mark - 생성 & 소멸
- (instancetype)initWithPreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.preferencePanes = preferencePanes.mutableCopy;
    }
    return self;
}

- (NSSegmentedControl *)createSegmentedControlPreferencePanes:(NSMutableArray <NSViewController <MGAPreferencePane>*>*)preferencePanes {
    NSSegmentedControl *segmentedControl = [NSSegmentedControl new];
    segmentedControl.segmentCount = preferencePanes.count;
    segmentedControl.segmentStyle = NSSegmentStyleTexturedSquare;
    segmentedControl.target = self;
    segmentedControl.action = @selector(segmentedControlAction:);
    segmentedControl.identifier = toolbarSegmentedControl;

    NSSegmentedCell *cell = segmentedControl.cell;
    if ([cell isKindOfClass:[NSSegmentedCell class]] == YES) {
        cell.controlSize = NSControlSizeRegular;
        cell.trackingMode = NSSegmentSwitchTrackingSelectOne;
    }
    
    CGSize insets = CGSizeMake(36.0, 12.0);
    CGSize maxSize = CGSizeZero;
    for (NSViewController <MGAPreferencePane>*preferencePane in preferencePanes) {
        NSString *title = preferencePane.preferencePaneTitle;
        NSDictionary <NSAttributedStringKey, id>*attrs =
        @{NSFontAttributeName : [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeRegular]]};
        NSSize titleSize = [title sizeWithAttributes:attrs];
        maxSize = CGSizeMake(MAX(titleSize.width, maxSize.width), MAX(titleSize.height, maxSize.height));
    }
    
    CGSize segmentSize = CGSizeMake(maxSize.width + insets.width, maxSize.height + insets.height);
    
    CGFloat segmentBorderWidth = (CGFloat)(preferencePanes.count) + 1;
    CGFloat segmentWidth = segmentSize.width * (CGFloat)(preferencePanes.count) + segmentBorderWidth;
    CGFloat segmentHeight = segmentSize.height;
    segmentedControl.frame = CGRectMake(0.0, 0.0, segmentWidth, segmentHeight);

    [preferencePanes enumerateObjectsUsingBlock:^(NSViewController <MGAPreferencePane>*vc, NSUInteger idx, BOOL * stop) {
        [segmentedControl setLabel:vc.preferencePaneTitle forSegment:idx];
        [segmentedControl setWidth:segmentSize.width forSegment:idx];
        NSSegmentedCell *cell = segmentedControl.cell;
        if ([cell isKindOfClass:[NSSegmentedCell class]] == YES) {
            [cell setTag:idx forSegment:idx];
        }
    }];
    
    return segmentedControl;
}


#pragma mark - 세터 & 게터
- (NSSegmentedControl *)segmentedControl {
    return (NSSegmentedControl *)(self.view);
}

- (void)setSegmentedControl:(NSSegmentedControl *)segmentedControl {
    self.view = segmentedControl;
}


#pragma mark - <MGAPreferencesStyleController>
- (BOOL)isKeepingWindowCentered {
    return YES;
}

- (NSArray <NSToolbarItemIdentifier>*)toolbarItemIdentifiers {
    return @[NSToolbarFlexibleSpaceItemIdentifier, toolbarSegmentedControlItem, NSToolbarFlexibleSpaceItemIdentifier];
}


- (NSToolbarItem *)toolbarItemPreferenceIdentifier:(NSToolbarItemIdentifier)preferenceIdentifier {
    NSToolbarItemIdentifier toolbarItemIdentifier = preferenceIdentifier;
    if ([toolbarItemIdentifier isEqualToString:toolbarSegmentedControlItem] == NO) {
        NSAssert(FALSE, @"toolbarSegmentedControlItem 이 아니다.");
    }
    
    // When the segments outgrow the window, we need to provide a group of
    // NSToolbarItems with custom menu item labels and action handling for the
    // context menu that pops up at the right edge of the window.
    NSToolbarItemGroup *toolbarItemGroup =
    [[NSToolbarItemGroup alloc] initWithItemIdentifier:toolbarItemIdentifier];
    toolbarItemGroup.view = self.segmentedControl;
    toolbarItemGroup.subitems =
    [self.preferencePanes mgrMapUsingBlock:^id (NSViewController <MGAPreferencePane>*obj, NSUInteger idx, BOOL *stop) {
        NSToolbarItem *item =
        [[NSToolbarItem alloc] initWithItemIdentifier:[NSString stringWithFormat:@"segment-%@", obj.preferencePaneTitle]];
        item.label = obj.preferencePaneTitle;
        
        NSMenuItem *menuItem =
        [[NSMenuItem alloc] initWithTitle:obj.preferencePaneTitle
                                   action:@selector(segmentedControlMenuAction:)
                            keyEquivalent:@""];
        
        menuItem.tag = idx;
        menuItem.target = self;
        item.menuFormRepresentation = menuItem;
        return item;
    }];
    return toolbarItemGroup;
}

- (void)selectTabIndex:(NSInteger)index {
    self.segmentedControl.selectedSegment = index;
}


#pragma mark - Action
- (void)segmentedControlAction:(NSSegmentedControl *)control {
    [self.delegate activateTabIndex:control.selectedSegment animated:YES];
}


- (void)segmentedControlMenuAction:(NSMenuItem *)menuItem {
    [self.delegate activateTabIndex:menuItem.tag animated:YES];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
