//
//  MGUSwipeExpansionStyle.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeExpansionStyle.h"
#import "MGUSwipeTableViewCell.h"
#import "MGUSwipeActionsView.h"

#define DEFAULT_TARGET_INSET 30.0 // 애플에서 사용하는 값이다.

@implementation MGUSwipeTarget

- (instancetype)init {
    return [self initWithType:MGUTargetTypePercentage targetValue:0.0];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    /** ❊ 중요 : super의 - isEqual: 메서드가 pointer 값의 동일성 비교결과라면 호출금지다.
     super의 - isEqual:이 pointer 값의 동일성 비교결과가 아니라면 주석 부분을 풀어준다.
    if ([super isEqual:object] == NO) {
        return NO;
    }
    */
    
    return [self isEqualToTarget:(__typeof(self))object];
}

- (id)copyWithZone:(NSZone *)zone {
    MGUSwipeTarget *target = [[[self class] allocWithZone:zone] init];
/*  super가 NSCopying 프로토콜을 따른다면 이걸 사용해야한다.
    MGUStepperConfiguration *configuration = [super copyWithZone:zone];
*/
    if (target) {
        /** 스칼라 : 언제나 딥카피이다. **/
        target->_targetType = _targetType;
        target->_targetValue = _targetValue;
    }

    return target;
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    /** ❊ 중요 : super의 - hash 메서드가 pointer 값이라면 호출금지다.
     super의 - hash가 pointer 값이 아니라면 아니라면 주석 부분을 풀어준다.
     NSUInteger result = [super hash];
    */

    //! 스칼라.
    NSUInteger result = [[NSNumber numberWithUnsignedInteger:_targetType] hash];
    result = prime * result + [[NSNumber numberWithDouble:_targetValue] hash];
    
    return result;
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToTarget:(MGUSwipeTarget *)target {
    if (self == target) {
        return YES;
    }

    if (target == nil) {
        return NO;
    }

    //! 스칼라일 경우는 단순히 둘만 비교해도 된다.
    BOOL haveEqualTargetType = (self.targetType == target.targetType);
    BOOL haveEqualTargetValue = (self.targetValue == target.targetValue);
    
    return haveEqualTargetType && haveEqualTargetValue;
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithType:(MGUSwipeTargetType)targetType targetValue:(CGFloat)targetValue {
    self = [super init];
    if (self) {
        self.targetType = targetType; // 세터에 검사하는 메서드가 존재한다.
        _targetValue = targetValue;
    }
    return self;
}

- (CGFloat)offsetFor:(__kindof  UIView <MGUSwipeableInterface>*)view minimumOverscroll:(CGFloat)minimumOverscroll {
    MGUSwipeActionsView *actionsView = view.actionsView;
    if (actionsView == nil) {
        return DBL_MAX;
    }
    
    CGFloat offset = ({
        CGFloat reslut = view.frame.size.width;
        if (self.targetType == MGUTargetTypePercentage) {
            reslut = (reslut * self.targetValue); // cell의 targetValue 퍼센트 만큼의 길이가 움직였다면 발동.
        } else { // TargetTypeEdgeInset
            //! trailing 일 경우, safe area inset의 left를 고려하여 해당 값을 더해줘야한다.
            CGFloat targetValue = MAX(view.scrollView.safeAreaInsets.left, view.scrollView.safeAreaInsets.right);
            targetValue = targetValue + self.targetValue;
            reslut = (reslut - targetValue); // cell의 self.targetValue를 뺀만큼 땡긴다. 100(cell 길이) - 30(targetValue) = 70을 땡긴다.
        }
        reslut;
    });
    //! actionsView.preferredWidth : 실제 컨텐츠의 총 길이(버튼), minimumOverscroll 손가락 넓이정도
    return MAX(actionsView.preferredWidth + minimumOverscroll, offset);
}


#pragma mark - 세터 & 게터
- (void)setTargetType:(MGUSwipeTargetType)targetType {
    if (targetType == MGUTargetTypePercentage || targetType ==     MGUTargetTypeEdgeInset) {
        _targetType = targetType;
    } else {
        NSCAssert(FALSE, @"TargetType이 잘못 입력되었다.");
    }
}

@end


@implementation MGUSwipeTrigger

- (instancetype)init {
    return [self initWithType:    MGUSwipeTriggerTypeTouchThreshold triggerValue:0.0];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithType:(MGUSwipeTriggerType)triggerType triggerValue:(CGFloat)triggerValue {
    self = [super init];
    if (self) {
        self.triggerType = triggerType; // 세터에 검사하는 메서드가 존재한다.
        _triggerValue = triggerValue;
    }
    return self;
}


#pragma mark - 세터 & 게터
- (void)setTriggerType:(MGUSwipeTriggerType)triggerType {
    if (triggerType ==     MGUSwipeTriggerTypeTouchThreshold || triggerType == MGUSwipeTriggerTypeOverscroll) {
        _triggerType = triggerType;
    } else {
        NSCAssert(FALSE, @"TriggerType이 잘못 입력되었다.");
    }
}

- (BOOL)isTriggeredView:(__kindof  UIView <MGUSwipeableInterface>*)view
                gesture:(UIPanGestureRecognizer *)gesture
            inSuperview:(UIView *)superview
         referenceFrame:(CGRect)referenceFrame {
    
    MGUSwipeActionsView *actionsView = view.actionsView;
    if (actionsView == nil) {
        return NO;
    }
    
    if (self.triggerType ==     MGUSwipeTriggerTypeTouchThreshold) { // 손가락의 위치가 어느 정도 멀리 위치하면(이동과 무관하게) 발동.
        CGFloat location = [gesture locationInView:superview].x - referenceFrame.origin.x;
        CGFloat locationRatio =
        ((actionsView.orientation == MGUSwipeActionsOrientationLeft)? location : referenceFrame.size.width - location) / referenceFrame.size.width;
        return locationRatio > self.triggerValue;
    } else {
        return ABS(CGRectGetMinX(view.frame)) > actionsView.preferredWidth + self.triggerValue;
    }
}

@end

@implementation MGUSwipeExpansionStyle


#pragma mark - convenience initializer
+ (instancetype)selection {
    MGUSwipeTarget *target = [[MGUSwipeTarget alloc] initWithType:MGUTargetTypePercentage targetValue:0.5];    
    return [[MGUSwipeExpansionStyle alloc] initWithTarget:target
                                    additionalTriggers:@[]
                                     elasticOverscroll:NO // 원래는 YES였다.
                                   completionAnimation:    MGUSwipeCompletionAnimationTypeBounce];
}


+ (instancetype)fill {
    return [MGUSwipeExpansionStyle fillWithType:MGUSwipeCompletionAnimationTypeFill];
}

+ (instancetype)fillReverse {
    return [MGUSwipeExpansionStyle fillWithType:    MGUSwipeCompletionAnimationTypeFillReverse];
}

+ (instancetype)fillWithType:(MGUSwipeCompletionAnimationType)completionAnimationType {
    // cell width의 30을 뺀 만큼의 많은 길이를 움직일때.maxOffset
    MGUSwipeTarget *target = [[MGUSwipeTarget alloc] initWithType:    MGUTargetTypeEdgeInset targetValue:DEFAULT_TARGET_INSET];
    // 손가락의 위치가 어느 정도 멀리 위치하면(이동과 무관하게) 발동.
    MGUSwipeTrigger *trigger = [[MGUSwipeTrigger alloc] initWithType:    MGUSwipeTriggerTypeTouchThreshold triggerValue:0.8];
    return [[MGUSwipeExpansionStyle alloc] initWithTarget:target
                                    additionalTriggers:@[trigger]
                                     elasticOverscroll:NO
                                   completionAnimation:completionAnimationType];
}

+ (instancetype)fill__ {
    // cell width의 30을 뺀 만큼의 많은 길이를 움직일때.maxOffset
    MGUSwipeTarget *target = [[MGUSwipeTarget alloc] initWithType:    MGUTargetTypeEdgeInset targetValue:DEFAULT_TARGET_INSET];
    // actionsView.preferredWidth + 30.0 이동시 발동
    MGUSwipeTrigger *trigger = [[MGUSwipeTrigger alloc] initWithType:MGUSwipeTriggerTypeOverscroll triggerValue:DEFAULT_TARGET_INSET];
    
    MGUSwipeCompletionAnimationType completionAnimation = MGUSwipeCompletionAnimationTypeFill;
    return [[MGUSwipeExpansionStyle alloc] initWithTarget:target
                                    additionalTriggers:@[trigger]
                                     elasticOverscroll:NO
                                   completionAnimation:completionAnimation];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithTarget:(MGUSwipeTarget *)target
            additionalTriggers:(NSArray <MGUSwipeTrigger *>*)additionalTriggers
             elasticOverscroll:(BOOL)elasticOverscroll
           completionAnimation:(MGUSwipeCompletionAnimationType)completionAnimationType {
    self = [super init];
    if (self) {
        CommonInit(self);
        _target = target;
        _additionalTriggers = additionalTriggers;
        _elasticOverscroll = elasticOverscroll;
        _completionAnimationType = completionAnimationType;
    }
    return self;
}


- (instancetype)initWithTarget:(MGUSwipeTarget *)target {
    return [self initWithTarget:target
             additionalTriggers:@[]
              elasticOverscroll:NO
            completionAnimation:    MGUSwipeCompletionAnimationTypeBounce];
}


static void CommonInit(MGUSwipeExpansionStyle *self) {
    self->_minimumTargetOverscroll = 20.0; //디폴트  20
    self->_targetOverscrollElasticity = 0.2; // 디폴트 0.2
    self->_minimumExpansionTranslation = 8.0; // 디폴트 8.0
}

- (BOOL)shouldExpandView:(__kindof  UIView <MGUSwipeableInterface>*)view
                 gesture:(UIPanGestureRecognizer *)gesture
             inSuperview:(UIView *)superview
             withinFrame:(CGRect)frame {
    
    MGUSwipeActionsView *actionsView = view.actionsView;
    UIView *gestureView = gesture.view;
    if (actionsView == nil || gestureView == nil) {
        return NO;
    }
    
    //! 최소 touch begin 이후로 이정도는 움직여라. 8.0
    if (ABS([gesture translationInView:gestureView].x) <= self.minimumExpansionTranslation) {
        return NO;
    }

    CGFloat xDelta;
    if (CGRectIsNull(frame) == YES) {
        xDelta = floor(ABS(CGRectGetMinX(view.frame)));
    } else {
        xDelta = floor(ABS(CGRectGetMinX(frame)));
    }
    
    if (xDelta <= actionsView.preferredWidth) {
        return NO;
    } else if (xDelta > [self targetOffsetFor:view]) {
        return YES;
    }
    
    CGRect referenceFrame;
    if (CGRectIsNull(frame) == YES) {
        referenceFrame = superview.bounds;
    } else {
        referenceFrame = view.frame;
    }
    
    for (MGUSwipeTrigger *trigger in self.additionalTriggers) {
        if ([trigger isTriggeredView:view gesture:gesture inSuperview:superview referenceFrame:referenceFrame]) {
            return YES;
        }
    }

    return NO;
}

//! expand가 될 수 있는 maximum 영역. 이것보다 작은 offset에서 expand될 수 있다.
- (CGFloat)targetOffsetFor:(__kindof  UIView <MGUSwipeableInterface>*)view {
    return  [self.target offsetFor:view minimumOverscroll:self.minimumTargetOverscroll];
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
