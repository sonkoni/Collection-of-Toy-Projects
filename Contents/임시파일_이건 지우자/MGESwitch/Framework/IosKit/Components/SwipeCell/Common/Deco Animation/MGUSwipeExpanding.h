//
//  MGUSwipeExpanding.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//
//  Created by Kwan Hyun Son on 2021/04/21.
//! @File MGUSwipeExpanding.h 파일
//! @abstract SwipeActionsView 전체에 대한 expand가 발생할 경우(expand도 아예 막을 수 있다.) 애니메이션이다.
//! @discussion 이 파일은 더 이상 건드리지 않을듯하다.

#import <UIKit/UIKit.h>
@class MGUSwipeActionButton;

NS_ASSUME_NONNULL_BEGIN

typedef struct CG_BOXABLE MGUSwipeExpansionAnimationTimingParameters {
    CGFloat duration;
    CGFloat delay;
} MGUSwipeExpansionAnimationTimingParameters;

static MGUSwipeExpansionAnimationTimingParameters const MGUSwipeExpansionAnimationTimingParametersDefault = {0.6, 0.0};

CG_INLINE MGUSwipeExpansionAnimationTimingParameters MGUSwipeExpansionAnimationTimingParametersMake(CGFloat duration, CGFloat delay) {
    MGUSwipeExpansionAnimationTimingParameters timingParameters = {duration, delay};
    return timingParameters;
}

/*!
 * @protocol SwipeExpanding
 * @abstract expanding이 발생할 때, 버튼에 애니메이션을 줄 프로토콜. 이 파일은 더 이상 건드리지 않을듯하다.
 * @discussion expanding이 발생할 때, 버튼의 애니메이션을 주고 싶다면 해당 프로토콜을 설정한다.
 */
@protocol MGUSwipeExpanding <NSObject>
@optional
@required
//! expanding 애니메이션이 존재하면 무조건 사용. duration 0.6이고 expand 일때는 delay 0.1이고 collapsed 일때는 0.0
- (MGUSwipeExpansionAnimationTimingParameters)animationTimingParameters:(NSArray <MGUSwipeActionButton *>* __unused)buttons
                                                           expanding:(BOOL)expanding;

//! expanding 애니메이션에서 추가적인 애니메이션에서 발동함. circular 형식에서만 발동함.
- (void)actionButton:(MGUSwipeActionButton * __unused)button
           didChange:(BOOL)expanding
  otherActionButtons:(NSArray <MGUSwipeActionButton *>*)otherActionButtons;
@end


// configuration.expansionDelegate --- [ScaleAndAlphaExpansion new]
// action.transitionDelegate --- [ScaleTransition new];
@interface MGUSwipeScaleAndAlphaExpansion : NSObject <MGUSwipeExpanding>
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat interButtonDelay;

- (instancetype)initWithDuration:(CGFloat)duration
                           scale:(CGFloat)scale
                interButtonDelay:(CGFloat)interButtonDelay;


//! <SwipeExpanding> 메서드.
- (MGUSwipeExpansionAnimationTimingParameters)animationTimingParameters:(NSArray <MGUSwipeActionButton *>* __unused)buttons
                                                           expanding:(BOOL)expanding;
- (void)actionButton:(MGUSwipeActionButton * __unused)button
           didChange:(BOOL)expanding
  otherActionButtons:(NSArray <MGUSwipeActionButton *>*)otherActionButtons;
@end

NS_ASSUME_NONNULL_END

