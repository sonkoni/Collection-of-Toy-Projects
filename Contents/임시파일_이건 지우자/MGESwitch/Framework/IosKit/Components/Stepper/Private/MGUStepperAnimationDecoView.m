//
//  MGUStepperAnimationDecoView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUStepperAnimationDecoView.h"

@interface MGUStepperAnimationDecoView ()  <CAAnimationDelegate>
@property (nonatomic, strong) NSMutableArray <CALayer *>*decoLayers;
@property (nonatomic, strong) NSMutableArray <dispatch_group_t>*dispatchGroups;
@end

@implementation MGUStepperAnimationDecoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUStepperAnimationDecoView *self) {
    self->_impactColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    self->_highlighted = NO; // 디폴트 NO.
    self->_decoLayers = [NSMutableArray arrayWithCapacity:10];
    self->_dispatchGroups = [NSMutableArray arrayWithCapacity:10];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 0.0f;
    self.layer.masksToBounds = YES;
}

- (CALayer *)setupDecoLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = self.layer.bounds;
    layer.contentsScale = self.layer.contentsScale; // 또는 UIScreen.mainScreen.scale
    layer.cornerRadius = self.cornerRadius;
    layer.backgroundColor = self.impactColor.CGColor;
    layer.opacity = 0.0f;
    [self.layer addSublayer:layer];
    [self.decoLayers addObject:layer];
    [self.dispatchGroups addObject:dispatch_group_create()];
    return layer;
}


#pragma mark - Action
- (void)highlightingAnimation {
    if (self.highlighted == YES) { // 이미 highlighted 이라면 나가
        return;
    } else {
        self.highlighted = YES;
    }
    
    CALayer *layer = [self setupDecoLayer];
    dispatch_group_t dispatchGroup = [self.dispatchGroups lastObject];
    dispatch_group_enter(dispatchGroup);
    dispatch_group_enter(dispatchGroup);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue         = @(0.0f);
    opacityAnimation.toValue           = @(1.0f);
    
    CABasicAnimation *scaleAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    if (self.decoLayers.count > 1) {
        scaleAnimation.fromValue       = @(1.0f);
        self.decoLayers[self.decoLayers.count - 2].hidden = YES;
    } else {
        scaleAnimation.fromValue       = @(0.7f);
    }
    
    scaleAnimation.toValue             = @(1.0f);

    CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
    groupAnimation.duration            = 0.15f;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.animations          = @[opacityAnimation, scaleAnimation];
    groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
    groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
    
    [CATransaction setCompletionBlock:^{
        dispatch_group_leave(dispatchGroup);
    }];
    [layer addAnimation:groupAnimation forKey:@"GroupAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        [self realUnHighlightingAnimationWithLayer:layer];
    });
}

- (void)realUnHighlightingAnimationWithLayer:(CALayer *)layer {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue         = @(1.0f);
    opacityAnimation.toValue           = @(0.0f);
    
    CABasicAnimation *scaleAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue           = @(1.0f);
    scaleAnimation.toValue             = @(1.0f);
    
    CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
    groupAnimation.duration            = 0.15;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.animations          = @[opacityAnimation, scaleAnimation];
    groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
    groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
    
    [CATransaction setCompletionBlock:^{
        
    }];
    //[self.decoLayer removeAnimationForKey:@"GroupAnimationKey"];
    //! - animationDidStop:finished: 를 받으려면, delegate 설정과 - setValue:forKey: 가
    //! - addAnimation:forKey: 보다 먼저 등장해야한다.
    groupAnimation.delegate = self;
    [groupAnimation setValue:@"DeleteGroupAnimationKey" forKey:@"DeleteKey"];
    [layer addAnimation:groupAnimation forKey:@"DeleteGroupAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (void)unHighlightingAnimation {
    if (self.highlighted == NO) { // 이미 unHighlighted 이라면 나가
        return;
    } else {
        self.highlighted = NO;
    }
    dispatch_group_leave([self.dispatchGroups lastObject]);
    return;
}


#pragma mark - 델리게이트 메서드 <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"DeleteKey"] isEqualToString:@"DeleteGroupAnimationKey"]) {
        [[self.decoLayers objectAtIndex:0] removeFromSuperlayer];
        if (self.decoLayers.count > 0) {
            [self.decoLayers removeObjectAtIndex:0];
        }
        
        if (self.dispatchGroups.count > 0) {
            [self.dispatchGroups removeObjectAtIndex:0];
        }
    }
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    NSAssert(FALSE, @"- initWithCoder: 사용금지.");
    return self;
}

@end
