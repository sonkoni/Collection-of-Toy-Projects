#import "MGUFloatingItemPreparation.h"
#import "MGUFloatingItem.h"
#import "MGUFloatingButton.h"
#import "MGUFloatingItemAnimationConfig.h"


@implementation MGUFloatingItemPreparation


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 & 소멸 메서드

//! 지정초기화 메서드 : 수동으로 블락을 작성하여 넣을 수 있다.
- (instancetype)initWithPrepareBlock:(MGRPrepareBlock)prepareBlock {
    self = [super init];
    if (self) {
        self.prepareBlock = prepareBlock;
    }
    return self;
}


- (instancetype)initWithScaleForPrepareBlock:(CGFloat)ratio {
    MGRPrepareBlock prepare = ^void(MGUFloatingItem *item,
                                    NSInteger index,
                                    NSInteger numberOfItems,
                                    MGUFloatingButton *actionButton) {
        [item scaleBy:ratio translationX:0.0 translationY:0.0];
        item.alpha = 0.0f;
    };
    
    return [self initWithPrepareBlock:prepare];
}


- (instancetype)initWithOffsetForPrepareBlock:(CGFloat)translationX
                                 translationY:(CGFloat)translationY
                                        scale:(CGFloat)scale {
    MGRPrepareBlock prepare = ^void(MGUFloatingItem *item,
                                    NSInteger index,
                                    NSInteger numberOfItems,
                                    MGUFloatingButton *actionButton) {
        [item scaleBy:scale translationX:translationX translationY:translationY];
        item.alpha = 0.0f;
    };
    
    return [self initWithPrepareBlock:prepare];
}

- (instancetype)initWithHorizontalOffsetForPrepareBlock:(CGFloat)distance
                                                  scale:(CGFloat)scale {
    MGRPrepareBlock prepare = ^void(MGUFloatingItem *item,
                                    NSInteger index,
                                    NSInteger numberOfItems,
                                    MGUFloatingButton *actionButton) {
        CGFloat translationX;
        if (actionButton.isOnLeftSideOfScreen == YES) {
            translationX = -distance;
        } else {
            translationX = distance;
        }
        
        [item scaleBy:scale translationX:translationX translationY:0.0];
        item.alpha = 0.0f;
    };
    return [self initWithPrepareBlock:prepare];
}

- (instancetype)initWithCircularOffsetForPrepareBlock:(CGFloat)distance
                                                scale:(CGFloat)scale {
    MGRPrepareBlock prepare = ^void(MGUFloatingItem *item,
                                    NSInteger index,
                                    NSInteger numberOfItems,
                                    MGUFloatingButton *actionButton) {
        CGFloat itemAngle = [MGUFloatingItemAnimationConfig angleForItemAt:index
                                                            numberOfItems:numberOfItems
                                                             actionButton:actionButton];
        CGFloat transitionAngle = itemAngle + M_PI;
        CGFloat translationX    = distance * cos(transitionAngle);
        CGFloat translationY    = distance * sin(transitionAngle);
        [item scaleBy:scale translationX:translationX translationY:translationY];
        item.alpha = 0.0f;
    };
    return [self initWithPrepareBlock:prepare];
}

@end
