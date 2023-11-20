//
//  MGUSwipeExpansionStyle.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//
//! 쭉 당겼을 때, 아무런 효과가 없다면 사용하지 않는다. 이 파일 자체를 사용하지 않는다.
//! Target과 Trigger의 조합으로 expand를 실시한다. 이 두개의 조합으로 offset이 같은 위치에서 expand되지 않는 창의적인 expand가 발생할 수 있다.
//! Target - expand가 일어날 수 있는 offset을 알려주는 역할을한다.
//! Trigger - Target 객체가 알려주는 offset과 무관하게 expand가 될 수 있는 추가적인 trigger이다.
//! leading expand에서는 trigger이 존재하지 않으므로 Target에서 정해준 offset이 넘어야만 발동하며, trailing expand에서는 추가적인 trigger가
//! 존재하여 이것으로도 expand가 발동하게 되므로 gesture의 위치를 강제적으로 옮기는 알고리즘이 들어가있다.
//! swiper controller의 => if (expanded && !actionsView.expanded && targetOffset > currentOffset) { ...

#import <UIKit/UIKit.h>
#import <IosKit/MGUSwipeAction.h>
#import <IosKit/MGUSwipeableInterface.h>
@class MGUSwipeTableViewCell;
@class MGUSwipeCollectionViewCell;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Target Class
/*!
 * @class Target
 * @abstract SwipeController에서 SwipeExpansionStyle의 - (CGFloat)targetOffsetFor:(__kindof  UIView <MGUSwipeableInterface>*)view를 측정하기 위해 존재한다. 기본 expand 조건
 * @discussion 길이로 정할 것인지, 비율로 정할 것인지 결정할 수 있다.
 * @warning 그래도 기본적으로 actionsView.preferredWidth + minimumOverscroll 보다 커야한다.
 */
@interface MGUSwipeTarget : NSObject <NSCopying>

/*!
 @enum       TargetType
 @abstract   Describes 기본 expand 발동에 대한 방식을 정한다.
 @constant   TargetTypePercentage  일정한 비율 : cell의 targetValue 퍼센트 만큼의 길이가 움직였다면 발동.
 @constant   TargetTypeEdgeInset   일정한 offset : cell의 self.targetValue를 뺀만큼 땡긴다. 100(cell 길이) - 30(targetValue) = 70을 땡긴다.
 */
typedef NS_ENUM(NSUInteger, MGUSwipeTargetType) {
    MGUTargetTypePercentage = 1, // 0은 피하는 것이 좋다.
    MGUTargetTypeEdgeInset
};

@property (nonatomic, assign) MGUSwipeTargetType targetType;
@property (nonatomic, assign) CGFloat targetValue;

- (CGFloat)offsetFor:(__kindof  UIView <MGUSwipeableInterface>*)view minimumOverscroll:(CGFloat)minimumOverscroll;
- (instancetype)initWithType:(MGUSwipeTargetType)targetType targetValue:(CGFloat)targetValue NS_DESIGNATED_INITIALIZER;
@end


#pragma mark - Trigger Class
/*!
 * @class Trigger
 * @abstract 기본 expand 조건(Target Clss) 이외에도 expand가 발생할 수 있도록하는 조건을 알려줄 수 있는 클래스이다.
 * @discussion 조건의 종류를 일정한 길이로 할 것인지, 비율로할 것인지 정할 수 있다.
 */
@interface MGUSwipeTrigger : NSObject

/*!
 @enum       TriggerType
 @abstract   Describes trigger 발동에 대한 방식을 정한다.
 @constant   TriggerTypeTouchThreshold  일정한 비율 => 손가락의 위치가 어느 정도 멀리 위치하면(이동과 무관하게) 발동. 0.8 에 trailing이면 왼쪽 끝에쯤에 닿으면 발동.
 @constant   TriggerTypeOverscroll      일정한 offset = actionsView.preferredWidth + triggerValue를 초과하면 발동된다.
 */
typedef NS_ENUM(NSUInteger, MGUSwipeTriggerType) {
    MGUSwipeTriggerTypeTouchThreshold = 1,
    MGUSwipeTriggerTypeOverscroll
};

@property (nonatomic, assign) MGUSwipeTriggerType triggerType;
@property (nonatomic, assign) CGFloat triggerValue; // 비율(TriggerTypeTouchThreshold) 또는 길이(TriggerTypeOverscroll)

- (BOOL)isTriggeredView:(__kindof  UIView <MGUSwipeableInterface>*)view
                gesture:(UIPanGestureRecognizer *)gesture
            inSuperview:(UIView *)superview
         referenceFrame:(CGRect)referenceFrame;

- (instancetype)initWithType:(MGUSwipeTriggerType)triggerType triggerValue:(CGFloat)triggerValue NS_DESIGNATED_INITIALIZER;

@end


typedef NS_ENUM(NSUInteger, MGUSwipeCompletionAnimationType) {
    MGUSwipeCompletionAnimationTypeFill = 1,
    MGUSwipeCompletionAnimationTypeFillReverse,
    MGUSwipeCompletionAnimationTypeBounce = NSNotFound //  단순히 판별만함.
};

#pragma mark - SwipeExpansionStyle Class
//! SwipeExpansionStyle 클래스는 쭉 당겼을 때, 어떠한 효과를 보여줄지를 결정하는 클래스이다.
@interface MGUSwipeExpansionStyle : NSObject

@property (nonatomic, strong) MGUSwipeTarget *target;
@property (nonatomic, strong) NSArray <MGUSwipeTrigger *>*additionalTriggers; // SwipeExpansionStyleTrigger
@property (nonatomic, assign) BOOL elasticOverscroll; // 사용하지 않는 것이 좋을듯. convenience에서 NO로 해버렸다.
@property (nonatomic, assign) MGUSwipeCompletionAnimationType completionAnimationType;

@property (nonatomic, assign) CGFloat minimumTargetOverscroll; //디폴트  20
@property (nonatomic, assign) CGFloat targetOverscrollElasticity; // 디폴트 0.2
@property (nonatomic, assign) CGFloat minimumExpansionTranslation; // 디폴트 8.0

- (instancetype)initWithTarget:(MGUSwipeTarget *)target
            additionalTriggers:(NSArray <MGUSwipeTrigger *>*)additionalTriggers // 걸릴 수 있는 trigger를 걸어 놓는다. 하나라도 걸리면 발동!
             elasticOverscroll:(BOOL)elasticOverscroll
           completionAnimation:(MGUSwipeCompletionAnimationType)completionAnimationType NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTarget:(MGUSwipeTarget *)target; // 애매하다. 사용할 필요가 없을듯.

+ (instancetype)selection;
+ (instancetype)fill;
+ (instancetype)fillReverse;

//! 원래 + (instancetype)fill 이거였는데, 이름이 충돌하고 움직임이 구려서 사용하지 않겠다.
+ (instancetype)fill__; // 구리다. 사용하지 말자.

- (BOOL)shouldExpandView:(__kindof  UIView <MGUSwipeableInterface>*)view
                 gesture:(UIPanGestureRecognizer *)gesture
             inSuperview:(UIView *)superview
             withinFrame:(CGRect)frame; // CGRectNull 가능.

- (CGFloat)targetOffsetFor:(__kindof  UIView <MGUSwipeableInterface>*)view;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
