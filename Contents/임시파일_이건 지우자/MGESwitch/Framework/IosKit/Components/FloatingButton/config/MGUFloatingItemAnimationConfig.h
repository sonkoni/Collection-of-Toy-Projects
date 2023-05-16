//
//  JJItemAnimationConfiguration.h
//  MGUFloatingButton
//
//  Created by Kwan Hyun Son on 16/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUFloatingButton;
@class MGUFloatingItemPreparation;
@class MGUFloatingItemsLayout;

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 인터페이스

@interface MGUFloatingItemAnimationConfig : NSObject

@property (nonatomic) NSTimeInterval duration;        // 0.3f;  디폴트
@property (nonatomic) CGFloat        dampingRatio;    // 0.55f; 디폴트
@property (nonatomic) NSTimeInterval interItemDelay;  // 0.1f;  디폴트


//! MGUFloatingItemPreparation 클래스는 MGUFloatingItemAnimationConfig의 클래스만의 Property이다.
//! MGUFloatingItemPreparation의 prepare 프라퍼티(블락)만 설정한다.
@property (nonatomic) MGUFloatingItemPreparation *closedStatePreparation;

//! MGRItemLayout 클래스는 MGUFloatingItemAnimationConfig의 클래스만의 Property이다.
@property (nonatomic) MGUFloatingItemsLayout *itemsLayout;

- (instancetype)initWithItemSpaceForPopUp:(CGFloat)itemSpace;   // 인수를 넣지 않으면, 디폴트 인수는 12.0
- (instancetype)initWithItemSpaceForSlideIn:(CGFloat)interItemSpacing
                           firstItemSpacing:(CGFloat)firstItemSpacing; // firstItemSpacing 0.0이면 무시.
- (instancetype)initWithRadiusForCircularPopUp:(CGFloat)radius; // 인수를 넣지 않으면, 디폴트 인수는 100.0f , 현재 앱에서는 이 메서드를 사용하고 있지 않다.
- (instancetype)initWithRadiusForCircularSlideIn:(CGFloat)radius; // 인수를 넣지 않으면, 디폴트 인수는 100.0f ,


#pragma mark - MGUFloatingItemPreparation, MGRItemLayout 클래스에서만 사용되는 클래스 메서드
//! 객체가 아니라, 각의 반환이다.
+ (CGFloat)angleForItemAt:(NSInteger)index
            numberOfItems:(NSInteger)numberOfItems
             actionButton:(MGUFloatingButton *)actionButton;
@end
NS_ASSUME_NONNULL_END


