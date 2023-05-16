//
//  MGUOnOffButtonLockSkin.m
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//

#import "MGUOnOffButtonLockSkin.h"
#import "MGUOnOffButtonLockSkinLockView.h"
#import "UIView+AutoLayout.h"
@import GraphicsKit;

#define BorderWidthDeleteKey (@"BorderWidthDeleteKey")
#define ShadowOpacityDeleteKey (@"ShadowOpacityDeleteKey")
#define InnerShadowOpacityDeleteKey (@"InnerShadowOpacityDeleteKey")
static NSString * const BorderWidthAnimationKey = @"BorderWidthAnimationKey"; // const를 앞으로 한칸 땡겨도 같은 뜻이다.
static NSString * const ShadowOpacityAnimationKey = @"ShadowOpacityAnimationKey"; // const를 앞으로 한칸 땡겨도 같은 뜻이다.
static NSString * const InnerShadowOpacityAnimationKey = @"InnerShadowOpacityAnimationKey"; // const를 앞으로 한칸 땡겨도 같은 뜻이다.

@interface MGUOnOffButtonLockSkin () <CAAnimationDelegate>
@property (nonatomic, strong) UIView *outContainer;  // 그래디언트를 가지고 있다. shadow 없음.
@property (nonatomic, strong) UIView *centerContainer; // 눌러지는 버튼

//! outContainer Part
@property (nonatomic, strong) MGEGradientView *gradientView1;

//! centerContainer Part
@property (nonatomic, strong) MGEGradientView *gradientViewC1;
@property (nonatomic, strong) CALayer *centerInnerShadowContainer;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayerC1;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayerC2;

@property (nonatomic, assign) CGFloat duration; // 디폴트 0.1;

//! Lock Image Part
@property (nonatomic, strong) MGUOnOffButtonLockSkinLockView *lockView;
@property (nonatomic, strong) MGEDisplayLink *lockViewDisplayLink;
@end

@implementation MGUOnOffButtonLockSkin

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.outContainer layoutIfNeeded];
    [self.centerContainer layoutIfNeeded];
    
    CGFloat centerContainerRadius =
    MIN(self.centerContainer.layer.bounds.size.width / 2.0, self.centerContainer.layer.bounds.size.height / 2.0);
    
    self.centerInnerShadowContainer.frame = self.centerContainer.layer.bounds;
    self.innerShadowLayerC1.frame = self.centerInnerShadowContainer.bounds;
    self.innerShadowLayerC2.frame = self.centerInnerShadowContainer.bounds;
    
    self.outContainer.layer.cornerRadius = [self currentRadius];
    self.gradientView1.layer.cornerRadius = [self currentRadius];
    
    self.centerContainer.layer.cornerRadius = centerContainerRadius;
    self.gradientViewC1.layer.cornerRadius = centerContainerRadius;
    self.centerInnerShadowContainer.cornerRadius = centerContainerRadius;
    self.innerShadowLayerC1.cornerRadius = centerContainerRadius;
    self.innerShadowLayerC2.cornerRadius = centerContainerRadius;
    
    [self updateCenterOuterShadowPath];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUOnOffButtonLockSkin *self) {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    self->_duration = 0.1;
    [self setupOutContainer];
    [self setupCenterContainer];
    [self setupLockView];
}

- (void)setupOutContainer {
    _outContainer = [[UIView alloc] initWithFrame:self.bounds];
    self.outContainer.clipsToBounds = NO;
    self.outContainer.layer.masksToBounds = NO;
    [self addSubview:self.outContainer];
    [self.outContainer mgrPinEdgesToSuperviewEdges];
    self.outContainer.backgroundColor = [UIColor clearColor];
    
    self.outContainer.layer.cornerRadius = [self currentRadius];
    
    _gradientView1 = [[MGEGradientView alloc] initWithFrame:self.outContainer.bounds];
    self.gradientView1.layer.cornerRadius = [self currentRadius];
    self.gradientView1.alpha = 1.0;
    self.gradientView1.gradientLayer.type = kCAGradientLayerAxial;
    self.gradientView1.gradientLayer.locations = @[@0.0, @1.0];
    UIColor *startColor = [UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1.0];
    self.gradientView1.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.gradientView1.gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    self.gradientView1.colors = @[startColor, endColor];
    [self.outContainer addSubview:self.gradientView1];
    [self.gradientView1 mgrPinEdgesToSuperviewEdges];
}

- (void)setupCenterContainer {
    CGRect frame =
    MGERectCenteredInRectSize(self.bounds, CGSizeMake(self.bounds.size.width * (23.68/25.0), self.bounds.size.height * (23.68/25.0)));
    _centerContainer = [[UIView alloc] initWithFrame:frame];
    self.centerContainer.clipsToBounds = NO;
    self.centerContainer.layer.masksToBounds = NO;
    self.centerContainer.layer.cornerRadius = MIN(self.centerContainer.layer.bounds.size.width / 2.0, self.centerContainer.layer.bounds.size.height / 2.0);
    self.centerContainer.layer.borderColor = [UIColor blackColor].CGColor;
    self.centerContainer.layer.borderWidth = 0.0;
    [self addSubview:self.centerContainer];
    [self.centerContainer mgrPinCenterToSuperviewCenter];
    
    [self.centerContainer.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:(23.68/25.0)].active = YES;
    [self.centerContainer.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:(23.68/25.0)].active = YES;
    self.centerContainer.backgroundColor = [UIColor clearColor];
    
    // self.centerContainer.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    // self.centerContainer.layer.shadowOpacity = 0.5;
    // self.centerContainer.layer.shadowOffset = CGSizeMake(-1.0, 3.0);
    // self.centerContainer.layer.shadowRadius = 3.0;
    [self updateCenterOuterShadowPath];
    
    _gradientViewC1 = [[MGEGradientView alloc] initWithFrame:self.centerContainer.bounds];
    self.gradientViewC1.layer.cornerRadius = self.centerContainer.layer.cornerRadius;
    self.gradientViewC1.alpha = 1.0;
    self.gradientViewC1.gradientLayer.type = kCAGradientLayerAxial;
    self.gradientViewC1.gradientLayer.locations = @[@0.0, @1.0];
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:1.0]; // 흰색 100%
    UIColor *endColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.gradientViewC1.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.gradientViewC1.gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    self.gradientViewC1.colors = @[startColor, endColor];
    [self.centerContainer addSubview:self.gradientViewC1];
    [self.gradientViewC1 mgrPinEdgesToSuperviewEdges];
    
    _centerInnerShadowContainer = [CALayer layer];
    [self.centerContainer.layer addSublayer:self.centerInnerShadowContainer];
    self.centerInnerShadowContainer.frame = self.centerContainer.layer.bounds;
    
    _innerShadowLayerC1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor
                                                             innerShadowOffset:CGSizeZero
                                                         innerShadowBlurRadius:0.0];
    self.innerShadowLayerC1.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayerC1.frame = self.centerContainer.layer.bounds;
    [self.centerInnerShadowContainer addSublayer:self.innerShadowLayerC1];
    
    _innerShadowLayerC2 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.2].CGColor
                                                             innerShadowOffset:CGSizeZero
                                                         innerShadowBlurRadius:1.0];
    self.innerShadowLayerC2.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayerC2.frame = self.centerContainer.layer.bounds;
    [self.centerInnerShadowContainer addSublayer:self.innerShadowLayerC2];
}

- (void)setupLockView {
    _lockView = [MGUOnOffButtonLockSkinLockView new];
    [self addSubview:self.lockView];
    [self.lockView mgrPinEdgesToSuperviewEdges];
}


#pragma mark - 세터 & 게터


#pragma mark - Action
- (void)setSkinType:(MGUOnOffSkinType)skinType animated:(BOOL)animated {
    
    // 애니메이션을 주기 애매하다. 그냥 때리자.
    if (skinType == MGUOnOffSkinTypeOn || skinType == MGUOnOffSkinTypeOff) { // 튀어나온 상태
        UIColor *startColor = [UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0];
        UIColor *endColor = [UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1.0];
        self.gradientView1.colors = @[startColor, endColor];
        startColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        endColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
        self.gradientViewC1.colors = @[startColor, endColor];
    } else if (skinType == MGUOnOffSkinTypeTouchDown1 || skinType == MGUOnOffSkinTypeTouchDown2) {
        UIColor *startColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
        UIColor *endColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.gradientView1.colors = @[startColor, endColor];
        startColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
        endColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
        self.gradientViewC1.colors = @[startColor, endColor];
    }
    
    if (animated == NO) {
        [self.centerContainer.layer removeAllAnimations];
        [self.centerInnerShadowContainer removeAllAnimations];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (skinType == MGUOnOffSkinTypeOn) {
            self.centerContainer.layer.borderWidth = 0.0;
            // self.centerContainer.layer.shadowOpacity = 0.0;
            self.centerInnerShadowContainer.hidden = NO;
            [self.lockView setProgress:1.0];
            self.lockView.transform = CGAffineTransformIdentity;
        } else if (skinType == MGUOnOffSkinTypeOff) {
            self.centerContainer.layer.borderWidth = 0.0;
            // self.centerContainer.layer.shadowOpacity = 0.5;
            self.centerInnerShadowContainer.hidden = NO;
            [self.lockView setProgress:0.0];
            self.lockView.transform = CGAffineTransformIdentity;
        } else { // MGUOnOffSkinTypeTouchDown1, MGUOnOffSkinTypeTouchDown2 off <=> on
            self.centerContainer.layer.borderWidth = 1.5;
            // self.centerContainer.layer.shadowOpacity = 0.0;
            self.centerInnerShadowContainer.hidden = YES;
        }
        [CATransaction commit];
        return; //! 나가자.
    }
    
    if (skinType == MGUOnOffSkinTypeOn || skinType == MGUOnOffSkinTypeOff) {
        CGFloat startProgress = self.lockView.progress;
        CGFloat finishProgress = (skinType == MGUOnOffSkinTypeOff) ? 0.0 : 1.0;
        [self.lockViewDisplayLink invalidate];
        self.lockViewDisplayLink = nil;
        self.lockViewDisplayLink =
        [MGEDisplayLink displayLinkWithDuration:self.duration
                             easingFunctionType:MGEEasingFunctionTypeEaseOutSine
                                  progressBlock:^(CGFloat progress) {
            self.lockView.progress = MGELerpDouble(progress, startProgress, finishProgress);
        }
                                completionBlock:^{
            
        }];
        [self.lockViewDisplayLink startAnimationWithStartProgress:0.0];
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.duration
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveEaseOut
                                                         animations:^{
            self.lockView.transform = CGAffineTransformIdentity;
        } completion:^(UIViewAnimatingPosition finalPosition) {}];
    } else {
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.duration
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveEaseOut
                                                         animations:^{
            self.lockView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97);
        } completion:^(UIViewAnimatingPosition finalPosition) {}];
    }
    
    
    CABasicAnimation *borderWidthAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    CABasicAnimation *innerShadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    if (self.centerContainer.layer.presentationLayer != nil) {
        CGFloat borderWidth = self.centerContainer.layer.presentationLayer.borderWidth;
        CGFloat shadowOpacity = self.centerContainer.layer.presentationLayer.shadowOpacity;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.centerContainer.layer.borderWidth = borderWidth;   // 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
        // self.centerContainer.layer.shadowOpacity = shadowOpacity; // 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
        [CATransaction commit];
    } else {
        CGFloat borderWidth;
        CGFloat shadowOpacity;
        if (skinType == MGUOnOffSkinTypeOn) { // 눌러진 상태에서 온상태로 가는 것.
            borderWidth = 1.5;
            // shadowOpacity = 0.0;
        } else if (skinType == MGUOnOffSkinTypeOff) { // 눌러진 상태에서 오프상태로 가는 것.
            borderWidth = 1.5;
            // shadowOpacity = 0.0;
        } else if (skinType == MGUOnOffSkinTypeTouchDown1) { // 오프 상태에서 눌러진 상태로 가는 것.
            borderWidth = 0.0;
            // shadowOpacity = 0.5;
        } else { // MGUOnOffSkinTypeTouchDown2 // 온 상태에서 눌러진 상태로 가는 것.
            borderWidth = 0.0;
            // shadowOpacity = 0.0;
        }
        borderWidthAnimation.fromValue = @(borderWidth);
        // shadowOpacityAnimation.fromValue = @(shadowOpacity);
    }
    
    if (self.centerInnerShadowContainer.presentationLayer != nil) {
        CGFloat opacity = self.centerInnerShadowContainer.presentationLayer.opacity;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.centerInnerShadowContainer.opacity = opacity;
        [CATransaction commit];
    } else {
        //! From Value 이다.
        CGFloat opacity;
        if (skinType == MGUOnOffSkinTypeOn) { // 눌러진 상태에서 온상태로 가는 것.
            opacity = 0.0;
        } else if (skinType == MGUOnOffSkinTypeOff) { // 눌러진 상태에서 오프상태로 가는 것.
            opacity = 0.0;
        } else if (skinType == MGUOnOffSkinTypeTouchDown1) { // 오프 상태에서 눌러진 상태로 가는 것.
            opacity = 1.0;
        } else { // MGUOnOffSkinTypeTouchDown2 // 온 상태에서 눌러진 상태로 가는 것.
            opacity = 1.0;
        }
        innerShadowOpacityAnimation.fromValue = @(opacity);
    }
    
    //! To Value 이다.
    CGFloat borderWidth;
    // CGFloat shadowOpacity;
    CGFloat opacity;
    if (skinType == MGUOnOffSkinTypeOn) { // 눌러진 상태에서 온상태로 가는 것. 평평한 상태이다.
        borderWidth = 0.0; // 보더가 그려져야한다.
        // shadowOpacity = 0.0;
        opacity = 1.0;
    } else if (skinType == MGUOnOffSkinTypeOff) { // 눌러진 상태에서 오프상태로 가는 것.
        borderWidth = 0.0;
        // shadowOpacity = 0.5;
        opacity = 1.0;
    } else if (skinType == MGUOnOffSkinTypeTouchDown1) { // 오프 상태에서 눌러진 상태로 가는 것.
        borderWidth = 1.5;
        // shadowOpacity = 0.0;
        opacity = 0.0;
    } else { // MGUOnOffSkinTypeTouchDown2 // 온 상태에서 눌러진 상태로 가는 것.
        borderWidth = 1.5;
        // shadowOpacity = 0.0;
        opacity = 0.0;
    }
    
    borderWidthAnimation.toValue = @(borderWidth);
    // shadowOpacityAnimation.toValue = @(shadowOpacity);
    innerShadowOpacityAnimation.toValue = @(opacity);
    borderWidthAnimation.duration = self.duration;
    borderWidthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    borderWidthAnimation.fillMode = kCAFillModeForwards;
    borderWidthAnimation.removedOnCompletion = NO;
    
    // shadowOpacityAnimation.duration = self.duration;
    // shadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    // shadowOpacityAnimation.fillMode = kCAFillModeForwards;
    // shadowOpacityAnimation.removedOnCompletion = NO;
    
    innerShadowOpacityAnimation.duration = self.duration;
    innerShadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    innerShadowOpacityAnimation.fillMode = kCAFillModeForwards;
    innerShadowOpacityAnimation.removedOnCompletion = NO;

    borderWidthAnimation.delegate = self;
    // shadowOpacityAnimation.delegate = self;
    innerShadowOpacityAnimation.delegate = self;
    [borderWidthAnimation setValue:BorderWidthAnimationKey forKey:BorderWidthDeleteKey];
    // [shadowOpacityAnimation setValue:ShadowOpacityAnimationKey forKey:ShadowOpacityDeleteKey];
    [innerShadowOpacityAnimation setValue:InnerShadowOpacityAnimationKey forKey:InnerShadowOpacityDeleteKey];
    [self.centerContainer.layer addAnimation:borderWidthAnimation forKey:BorderWidthAnimationKey];
    // [self.centerContainer.layer addAnimation:shadowOpacityAnimation forKey:ShadowOpacityAnimationKey];
    [self.centerInnerShadowContainer addAnimation:innerShadowOpacityAnimation forKey:InnerShadowOpacityAnimationKey];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) { // 성공.
        CABasicAnimation *animation = (CABasicAnimation *)anim;
        if ([[anim valueForKey:BorderWidthDeleteKey] isEqualToString:BorderWidthAnimationKey]) {
            self.centerContainer.layer.borderWidth = [animation.toValue doubleValue];
            [self.centerContainer.layer removeAnimationForKey:BorderWidthAnimationKey];
        } else if ([[anim valueForKey:ShadowOpacityDeleteKey] isEqualToString:ShadowOpacityAnimationKey]) {
            // self.centerContainer.layer.shadowOpacity = [animation.toValue doubleValue];
            // [self.centerContainer.layer removeAnimationForKey:ShadowOpacityAnimationKey];
        } else if ([[anim valueForKey:InnerShadowOpacityDeleteKey] isEqualToString:InnerShadowOpacityAnimationKey]) {
            self.centerInnerShadowContainer.opacity = [animation.toValue doubleValue];
            [self.centerInnerShadowContainer removeAnimationForKey:InnerShadowOpacityAnimationKey];
        }
    }
}


#pragma mark - Helper
//- (void)updateOuterShadowPath {
//    self.outContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.outContainer.layer.bounds
//                                                               byRoundingCorners:UIRectCornerAllCorners
//                                                                     cornerRadii:CGSizeMake([self currentRadius],
//                                                                                            [self currentRadius])].CGPath;
//}

- (void)updateCenterOuterShadowPath {
    CGFloat radius = MIN(self.centerContainer.layer.bounds.size.width / 2.0, self.centerContainer.layer.bounds.size.height / 2.0);
    self.centerContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.centerContainer.layer.bounds
                                                                  byRoundingCorners:UIRectCornerAllCorners
                                                                        cornerRadii:CGSizeMake(radius, radius)].CGPath;
}

- (CGFloat)currentRadius {
    return MIN(self.bounds.size.height, self.bounds.size.width) / 2.0;
}

@end
