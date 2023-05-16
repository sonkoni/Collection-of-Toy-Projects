//
//  JJItemAnimationConfiguration.m
//  MGUFloatingButton
//
//  Created by Kwan Hyun Son on 16/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUFloatingItemAnimationConfig.h"
#import "MGUFloatingItemPreparation.h"
#import "MGUFloatingItemsLayout.h"
#import "MGUFloatingButton.h"

@implementation MGUFloatingItemAnimationConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
    //
    // - init 메서드를 통해서도 초기화 가능하다. 반드시 init 메서드는 존재해야한다.
}


#pragma mark - 생성 & 소멸
//! 편의 초기화한다 : 인수를 넣지 않으면, 디폴트 인수는 12.0f
- (instancetype)initWithItemSpaceForPopUp:(CGFloat)itemSpace {
    self = [self init];
    if (self) {
        self.itemsLayout = [[MGUFloatingItemsLayout alloc] initWithItemSpaceForVerticalLayoutBlock:itemSpace firstItemSpacing:0.0];
        // _closedStatePreparation = [[MGUFloatingItemPreparation alloc] initWithScaleForPrepareBlock:0.4f]; // 디폴트
    }
    return self;
}

//! 편의 초기화한다 : 인수를 넣지 않으면, 디폴트 인수는 12.0, 0.0(0.0 이면 무시. interItemSpacing 를 사용함.)
- (instancetype)initWithItemSpaceForSlideIn:(CGFloat)interItemSpacing firstItemSpacing:(CGFloat)firstItemSpacing {
    self = [self init];
    if (self) {
        self.itemsLayout  = [[MGUFloatingItemsLayout alloc] initWithItemSpaceForVerticalLayoutBlock:interItemSpacing
                                                                           firstItemSpacing:firstItemSpacing];
        self.closedStatePreparation = [[MGUFloatingItemPreparation alloc] initWithHorizontalOffsetForPrepareBlock:50.f scale:0.4f];
    }
    return self;
    
}

//! 편의 초기화한다 : 인수를 넣지 않으면, 디폴트 인수는 100.0f. 나타날 위치에서 커진다.
- (instancetype)initWithRadiusForCircularPopUp:(CGFloat)radius {
    self = [self init];
    if (self) {
        self.itemsLayout = [[MGUFloatingItemsLayout alloc] initWithRadiusForCircularLayoutBlock:radius];
        // _closedStatePreparation = [[MGUFloatingItemPreparation alloc] initWithScaleForPrepareBlock:0.4f]; // 디폴트
    }
    return self;
}

//! 편의 초기화한다 : 인수를 넣지 않으면, 디폴트 인수는 100.0f. 메인버튼에서 뻗어나간다.
- (instancetype)initWithRadiusForCircularSlideIn:(CGFloat)radius {
    self = [self init];
    if (self) {
        self.itemsLayout  = [[MGUFloatingItemsLayout alloc] initWithRadiusForCircularLayoutBlock:radius];
        self.closedStatePreparation = [[MGUFloatingItemPreparation alloc] initWithCircularOffsetForPrepareBlock:radius * 0.75f scale:0.4f];
    }
    return self;
}

- (void)commonInit {
    _closedStatePreparation = [[MGUFloatingItemPreparation alloc] initWithScaleForPrepareBlock:0.4f];
    _itemsLayout             = [[MGUFloatingItemsLayout alloc] initWithItemSpaceForVerticalLayoutBlock:12.0f firstItemSpacing:0.0];
    
    _duration       = 0.3f;
    _dampingRatio   = 0.55f;
    _interItemDelay = 0.1f;
}


#pragma mark - MGUFloatingItemPreparation, MGRItemLayout 클래스에서만 사용되는 클래스 메서드
//! MGUFloatingItemPreparation, MGRItemLayout 클래스에서만 사용되는 클래스 메서드이다. 객체가 아니라, 각의 반환이다.
+ (CGFloat)angleForItemAt:(NSInteger)index
            numberOfItems:(NSInteger)numberOfItems
             actionButton:(MGUFloatingButton *)actionButton {
    
    if (numberOfItems <= 0 || index < 0 || index >= numberOfItems) {
        NSAssert(false, @"에러!!");
    }
    CGFloat startAngle;
    
    if ( actionButton.isOnLeftSideOfScreen == YES) {
        startAngle = M_PI * 2.0f;
    } else {
        startAngle = M_PI;
    }
    
    CGFloat endAngle = 1.5 * M_PI;
    
    if (numberOfItems == 1) {
        return (startAngle + endAngle) / 2.0f;
    } else if ( numberOfItems == 2 &&  index == 0) {
        return startAngle + (0.1 * (endAngle - startAngle));
    } else if (numberOfItems == 2 &&  index == 1) {
        return endAngle - (0.1 * (endAngle - startAngle));
    } else {
        return startAngle + ((CGFloat)index * (endAngle - startAngle) / ((CGFloat)numberOfItems - 1 ));
    }
    //
    //
    /* 제일 위의 if 문은 swift의 다음과 같다.
     precondition(numberOfItems > 0)
     precondition(index >= 0)
     precondition(index < numberOfItems)*/
}
@end
