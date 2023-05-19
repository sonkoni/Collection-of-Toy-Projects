//
//  MGUSwipeActionTransitioning.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//
//  Created by Kwan Hyun Son on 2021/04/21.
//! @File MGUSwipeActionTransitioning.h 파일
//! @abstract 각 SwipeActionButton에 대한 애니메이션이다.
//! @discussion

#import <UIKit/UIKit.h>
@class MGUSwipeActionTransitioningContext;
@class MGUSwipeActionButton;

NS_ASSUME_NONNULL_BEGIN

//! 스와이프로 action button이 등장할때 애니메이션을 주기 위해 사용한다.
//! 예를 들어 원형 버튼의 형태로 나올때, 일정한 때가 오면 버튼이 커지는 효과가 그것이다.
//! 사용하지 않아도 된다.
//! 새로운 것도 만들 수 있을 것 같다. 지금 이 프로젝트에서는 <MGUSwipeActionTransitioning> 프로토콜을 따르는 객체는
//! MGUSwipeTransitionAnimation 클래스 뿐이다.
@protocol MGUSwipeActionTransitioning <NSObject>
@optional
@required
- (void)didTransitionWithContext:(MGUSwipeActionTransitioningContext *)context;
@end

//! <MGUSwipeActionTransitioning> 프로토콜 메서드의 인자에서만 사용된다. 등장 애니메이션에 사용할 각종 정보를 담고 있다.
@interface MGUSwipeActionTransitioningContext : NSObject

+ (instancetype)transitioningContextWithActionIdentifier:(NSString * _Nullable)actionIdentifier
                                                  button:(MGUSwipeActionButton *)button
                                       newPercentVisible:(CGFloat)newPercentVisible
                                       oldPercentVisible:(CGFloat)oldPercentVisible
                                             wrapperView:(UIView *)wrapperView;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("new not available. Use +transitioningContextWithActionIdentifier:button:newPercentVisible:oldPercentVisible:wrapperView: instead")));
- (instancetype)init __attribute__((unavailable("new not available. Use +transitioningContextWithActionIdentifier:button:newPercentVisible:oldPercentVisible:wrapperView: instead")));

@end

// configuration.expansionDelegate --- [ScaleAndAlphaExpansion new]
// action.transitionDelegate --- [ScaleTransition new];
@interface MGUSwipeTransitionAnimation : NSObject <MGUSwipeActionTransitioning>

typedef NS_ENUM(NSUInteger, MGUSwipeTransitionAnimationType) {
    MGUSwipeTransitionAnimationTypeDefault = 1, // 작아졌다 => identity
    MGUSwipeTransitionAnimationTypeSpring, // identity => 좌우 상하 => identity
    MGUSwipeTransitionAnimationTypeRotate, // identity => y축으로 살짝 회전 => identity
    MGUSwipeTransitionAnimationTypeFavorite, // favorite switch의 on off 스타일
    MGUSwipeTransitionAnimationTypeNone // 애니메이션이 없다.
};

@property (nonatomic, assign) MGUSwipeTransitionAnimationType transitionAnimationType;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat initialScale;
@property (nonatomic, assign) CGFloat threshold; // 애니메이션이 발동하는 기준이된다. (0.0 ~ 1.0)

- (instancetype)initWithTransitionAnimationWithType:(MGUSwipeTransitionAnimationType)transitionAnimationType
                                           duration:(CGFloat)duration      // 디폴트 0.15
                                       initialScale:(CGFloat)initialScale  // 디폴트 0.8
                                          threshold:(CGFloat)threshold NS_DESIGNATED_INITIALIZER; // 디폴트 0.5 - 50% 나오면 발동한다.

+ (instancetype)transitionAnimationWithType:(MGUSwipeTransitionAnimationType)transitioningType;

//! <MGUSwipeActionTransitioning>
- (void)didTransitionWithContext:(MGUSwipeActionTransitioningContext *)context;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
