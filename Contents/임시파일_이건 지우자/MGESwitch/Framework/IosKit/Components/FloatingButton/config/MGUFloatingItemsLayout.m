#import "MGUFloatingItemsLayout.h"
#import "MGUFloatingItem.h"
#import "MGUFloatingButton.h"
#import "MGUFloatingItemAnimationConfig.h"

@implementation MGUFloatingItemsLayout

//! 지정초기화 메서드 : 수동으로 블락을 작성하여 넣을 수 있다.
- (instancetype)initWithLayout:(MGRLayoutBlock)layoutBlock {
    self = [super init];
    if (self) {
        _layoutBlock = layoutBlock;
    }
    return self;
}

- (instancetype)initWithItemSpaceForVerticalLayoutBlock:(CGFloat)interItemSpacing
                                       firstItemSpacing:(CGFloat)firstItemSpacing {
    MGRLayoutBlock layoutBlock = ^void(NSMutableArray <MGUFloatingItem *> *items, MGUFloatingButton *actionButton) {
        MGUFloatingItem *previousItem;
        UIView * previousView;
        CGFloat spacing = interItemSpacing;
        for (MGUFloatingItem *item in items) {
            if (previousItem == nil) { // first item
                previousView = actionButton;
                if (firstItemSpacing > 0.0) {
                    spacing = firstItemSpacing;
                } else {
                    spacing = interItemSpacing;
                }
            } else {
                previousView = previousItem;
                spacing = interItemSpacing;
            }
            
            [item.bottomAnchor constraintEqualToAnchor:previousView.topAnchor constant:-spacing].active = YES;
            [item.circleView.centerXAnchor constraintEqualToAnchor:actionButton.centerXAnchor].active = YES;
            previousItem = item;
        }
    };
    
    return [self initWithLayout:layoutBlock];
    
}


- (instancetype)initWithRadiusForCircularLayoutBlock:(CGFloat)radius {
    MGRLayoutBlock layoutBlock = ^void(NSMutableArray <MGUFloatingItem *> *items, MGUFloatingButton *actionButton) {
        NSInteger numberOfItems = items.count;
        NSInteger index = 0;
        
        for (MGUFloatingItem *item in items) {
            
            CGFloat angle = [MGUFloatingItemAnimationConfig angleForItemAt:index
                                                            numberOfItems:numberOfItems
                                                             actionButton:actionButton];
            CGFloat horizontalDistance = radius * cos(angle);
            CGFloat verticalDistance   = radius * sin(angle);
            [item.circleView.centerXAnchor constraintEqualToAnchor:actionButton.centerXAnchor
                                                          constant:horizontalDistance].active = YES;
            [item.circleView.centerYAnchor constraintEqualToAnchor:actionButton.centerYAnchor
                                                          constant:verticalDistance].active = YES;
            index = index + 1;
        }
    };
    
    return [self initWithLayout:layoutBlock];
}


@end
