//
//  MGUSwipeAction.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeAction.h"
#import "MGUSwipeActionTransitioning.h"

@interface MGUSwipeAction ()
@end

@implementation MGUSwipeAction
@dynamic hasBackgroundColor;

#pragma mark - 생성 & 소멸
+ (instancetype)swipeActionWithStyle:(MGUSwipeActionStyle)style
                               title:(NSString * _Nullable)title
                             handler:(MGUSwipeActionHandler)handler {
    return [[MGUSwipeAction alloc] initPrivateWithStyle:style title:title handler:handler];
}

- (instancetype)initPrivateWithStyle:(MGUSwipeActionStyle)style
                               title:(NSString * _Nullable)title
                             handler:(MGUSwipeActionHandler)handler {
    self = [super init];
    if (self) {
//        _hidesWhenSelected = NO;
        _title = title;
        _style = style;
        _handler = handler;
        
    }
    return self;
}


#pragma mark - 세터 & 게터
- (BOOL)hasBackgroundColor {
    if ([self.backgroundColor isEqual:[UIColor clearColor]] == NO &&
        self.backgroundEffect == nil) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
