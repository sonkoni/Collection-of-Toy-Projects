//
//  NSOutlineView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//


#import "NSOutlineView+Extension.h"
#import <Quartz/Quartz.h>

@implementation NSOutlineView (Extension)

- (void)mgrExpandItem:(id)item animated:(BOOL)animated {
    [self mgrExpandItem:item recursively:NO animated:animated];
}

- (void)mgrCollapseItem:(id)item animated:(BOOL)animated {
    [self mgrCollapseItem:item recursively:NO animated:animated];
}

- (void)mgrExpandItem:(id)item recursively:(BOOL)recursively animated:(BOOL)animated {
    if (animated == NO) {
        [self expandItem:item expandChildren:recursively];
    } else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.2;
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.animator expandItem:item expandChildren:recursively]; // nil은 루트 BOOL 은 recursively
        } completionHandler:^{}];
    }
}

- (void)mgrCollapseItem:(id)item recursively:(BOOL)recursively animated:(BOOL)animated {
    if (animated == NO) {
        [self collapseItem:item collapseChildren:recursively];
    } else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.2;
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.animator collapseItem:item collapseChildren:recursively]; // nil은 루트 BOOL 은 recursively
        } completionHandler:^{}];
    }
}

- (void)mgrSetupSourceList {
    [self sizeLastColumnToFit]; // 마지막 열의 크기를 조절하여, 아웃라인뷰(테이블 뷰)가 clip view에 딱 맞춰지도록한다.
    
    self.indentationMarkerFollowsCell = YES;
    
    // 참고로 IB에서 NSTableViewSelectionHighlightStyleSourceList(Highlight = Source List)로 해야 이쁘다. 그렇게 했음
    // setFloatsGroupRows:는 접고 펴면서 - outlineView:isGroupItem:가 YES에 해당하는 행에 대하여 floating 적용여부
    // (Highlight = Source List)에 해당하는 outline view는 floating을 NO로 해야한다.(애플 지침)
    // (Highlight = Source List) 일때, floating하면, 접고 필때, 제일 윗 열이 움직인다.
    // 위키 Api:AppKit/NSTableView/floatsGroupRows 에 그림으로 설명했다.
    // 그냥 다른 것도 NO로 하자.(디폴트가 YES이므로 명심하자.) 보기 싫다.
    // IB 상에서도 설정가능하다.
    self.floatsGroupRows = NO;
    self.allowsColumnReordering = YES;
    self.allowsColumnResizing = YES;
    self.headerView = nil;
    
    /* 위키 Api:AppKit/NSTableView/rowSizeStyle 참고바람.
     NSTableViewRowSizeStyleDefault  <- NSTableViewSelectionHighlightStyleSourceList에서는 이거 사용하자. 귀찮다.
     NSTableViewRowSizeStyleCustom   <- 일반적. but NSTableViewSelectionHighlightStyleSourceList 일때는 잘 사용 안함
     NSTableViewRowSizeStyleSmall
     NSTableViewRowSizeStyleMedium <- NSTableViewRowSizeStyleDefault와 크기가 비슷하다.
     NSTableViewRowSizeStyleLarge
     */
    // 주의 - setRowSizeStyle: 의 디폴트 값은 NSTableViewRowSizeStyleCustom이다.
    // 행마다 사이즈를 달리하려면, 델리게이트 메서드 - tableView:heightOfRow:를 써라.
    // IB 상에서도 설정가능하다.
    self.rowSizeStyle = NSTableViewRowSizeStyleDefault;
    
    
//    self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList; // Deprecated. 아래처럼 설정하라고 함.
    self.style = NSTableViewStyleSourceList;
    self.gridColor = [NSColor gridColor];
    self.backgroundColor = [NSColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:0.8];
    self.focusRingType = NSFocusRingTypeDefault;
    
    NSScrollView *scrollView = self.enclosingScrollView;
    if (scrollView == nil) {
        NSCAssert(FALSE, @"scrollView를 먼저 설정하라.");
    }
    scrollView.borderType = NSNoBorder;
    scrollView.scrollerKnobStyle = NSScrollerKnobStyleDefault;
    scrollView.findBarPosition = NSScrollViewFindBarPositionAboveContent;
    scrollView.drawsBackground = NO;
    scrollView.horizontalScrollElasticity = NSScrollElasticityAutomatic;
    scrollView.verticalScrollElasticity = NSScrollElasticityAutomatic;
    scrollView.usesPredominantAxisScrolling = NO;
    scrollView.verticalLineScroll = 28.0;
    scrollView.horizontalLineScroll = 28.0;
    scrollView.verticalPageScroll = 10.0;
    scrollView.horizontalPageScroll = 10.0;
//    scrollView.scrollsDynamically = YES; // 이것이 XIB의 Copy On Scroll 인 것 같다.
    scrollView.hasHorizontalScroller = YES;
    scrollView.hasVerticalScroller = YES;
    scrollView.autohidesScrollers = YES;
    scrollView.allowsMagnification = NO;
}

@end
