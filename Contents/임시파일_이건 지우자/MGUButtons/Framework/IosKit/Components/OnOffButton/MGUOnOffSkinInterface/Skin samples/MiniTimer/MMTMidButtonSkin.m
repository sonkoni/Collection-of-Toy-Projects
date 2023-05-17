//
//  MGUOnOffSkin.m
//  Empty Project
//
//  Created by Kwan Hyun Son on 2021/11/15.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MMTMidButtonSkin.h"
#import "UIView+AutoLayout.h"
@import GraphicsKit;
//#import "UIView+AutoLayout.h"

#define BorderWidthDeleteKey (@"BorderWidthDeleteKey")
#define ShadowOpacityDeleteKey (@"ShadowOpacityDeleteKey")
#define InnerShadowOpacityDeleteKey (@"InnerShadowOpacityDeleteKey")
static NSString * const BorderWidthAnimationKey = @"BorderWidthAnimationKey"; // const를 앞으로 한칸 땡겨도 같은 뜻이다.
static NSString * const ShadowOpacityAnimationKey = @"ShadowOpacityAnimationKey"; // const를 앞으로 한칸 땡겨도 같은 뜻이다.
static NSString * const InnerShadowOpacityAnimationKey = @"InnerShadowOpacityAnimationKey"; // const를 앞으로 한칸 땡겨도 같은 뜻이다.

@interface MMTMidButtonSkin () <CAAnimationDelegate>
@property (nonatomic, strong) UIView *outContainer;  // out Shadow를 표현한다.
@property (nonatomic, strong) UIView *centerContainer; // 눌러지는 버튼

//! outContainer Part
@property (nonatomic, strong) MGEGradientView *gradientView1;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayer1;

//! centerContainer Part
@property (nonatomic, strong) MGEGradientView *gradientViewC1;
@property (nonatomic, strong) CALayer *centerInnerShadowContainer;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayerC1;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayerC2;

@property (nonatomic, assign) CGFloat duration; // 디폴트 0.1;
@end

@implementation MMTMidButtonSkin

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.mainContainer layoutIfNeeded];
    [self.outContainer layoutIfNeeded];
    [self.centerContainer layoutIfNeeded];
    
    CGFloat centerContainerRadius =
    MIN(self.centerContainer.layer.bounds.size.width / 2.0, self.centerContainer.layer.bounds.size.height / 2.0);
    
    
    self.innerShadowLayer1.frame = self.outContainer.layer.bounds;
    self.centerInnerShadowContainer.frame = self.centerContainer.layer.bounds;
    self.innerShadowLayerC1.frame = self.centerInnerShadowContainer.bounds;
    self.innerShadowLayerC2.frame = self.centerInnerShadowContainer.bounds;
    
//    [self.inContainer layoutIfNeeded];
    self.outContainer.layer.cornerRadius = [self currentRadius];
    self.gradientView1.layer.cornerRadius = [self currentRadius];
    self.innerShadowLayer1.cornerRadius = [self currentRadius];
    
    self.centerContainer.layer.cornerRadius = centerContainerRadius;
    self.gradientViewC1.layer.cornerRadius = centerContainerRadius;
    self.centerInnerShadowContainer.cornerRadius = centerContainerRadius;
    self.innerShadowLayerC1.cornerRadius = centerContainerRadius;
    self.innerShadowLayerC2.cornerRadius = centerContainerRadius;
    
//    self.inContainer.layer.cornerRadius = [self currentRadius];
    [self updateOuterShadowPath];
    [self updateCenterOuterShadowPath];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    _duration = 0.1;
    [self setupOutContainer];
    [self setupCenterContainer];
    
}

- (void)setupOutContainer { // out Shadow 담당.
    _outContainer = [[UIView alloc] initWithFrame:self.bounds];
    self.outContainer.clipsToBounds = NO;
    self.outContainer.layer.masksToBounds = NO;
    [self addSubview:self.outContainer];
    [self.outContainer mgrPinEdgesToSuperviewEdges];
    self.outContainer.backgroundColor = [UIColor clearColor];
    
    self.outContainer.layer.cornerRadius = [self currentRadius];
    self.outContainer.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    self.outContainer.layer.shadowOpacity = 0.3;
    self.outContainer.layer.shadowOffset = CGSizeMake(-1.0, 2.0);
    self.outContainer.layer.shadowRadius = 2.0;
    [self updateOuterShadowPath];
    
    _gradientView1 = [[MGEGradientView alloc] initWithFrame:self.outContainer.bounds];
    self.gradientView1.layer.cornerRadius = [self currentRadius];
    self.gradientView1.alpha = 1.0;
    self.gradientView1.gradientLayer.type = kCAGradientLayerAxial;
    self.gradientView1.gradientLayer.locations = @[@0.0, @1.0];
    UIColor *startColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    self.gradientView1.gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    self.gradientView1.gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    self.gradientView1.colors = @[startColor, endColor];
    [self.outContainer addSubview:self.gradientView1];
    [self.gradientView1 mgrPinEdgesToSuperviewEdges];

    _innerShadowLayer1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.02].CGColor
                                                             innerShadowOffset:CGSizeMake(-1.0, 1.0)
                                                         innerShadowBlurRadius:0.0];
    self.innerShadowLayer1.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayer1.frame = self.outContainer.layer.bounds;
    [self.outContainer.layer addSublayer:self.innerShadowLayer1];
}

- (void)setupCenterContainer {
    CGRect frame =
    MGERectCenteredInRectSize(self.bounds, CGSizeMake(self.bounds.size.width * (53.0/38.0), self.bounds.size.height * (53.0/63.0)));
    _centerContainer = [[UIView alloc] initWithFrame:frame];
    self.centerContainer.clipsToBounds = NO;
    self.centerContainer.layer.masksToBounds = NO;
    self.centerContainer.layer.cornerRadius = MIN(self.centerContainer.layer.bounds.size.width / 2.0, self.centerContainer.layer.bounds.size.height / 2.0);
    self.centerContainer.layer.borderColor = [UIColor blackColor].CGColor;
    self.centerContainer.layer.borderWidth = 0.0;
    [self addSubview:self.centerContainer];
    [self.centerContainer mgrPinCenterToSuperviewCenter];
    [self.centerContainer.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:(53.0/63.0)].active = YES;
    [self.centerContainer.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:(53.0/63.0)].active = YES;
    self.centerContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    self.centerContainer.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    self.centerContainer.layer.shadowOpacity = 0.5;
    self.centerContainer.layer.shadowOffset = CGSizeMake(-1.0, 2.0);
    self.centerContainer.layer.shadowRadius = 4.0;
    [self updateCenterOuterShadowPath];
    
    _gradientViewC1 = [[MGEGradientView alloc] initWithFrame:self.centerContainer.bounds];
    self.gradientViewC1.layer.cornerRadius = self.centerContainer.layer.cornerRadius;
    self.gradientViewC1.alpha = 1.0;
    self.gradientViewC1.gradientLayer.type = kCAGradientLayerAxial;
    self.gradientViewC1.gradientLayer.locations = @[@0.0, @1.0];
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:0.2]; // 흰색 20%
    UIColor *endColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.gradientViewC1.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.gradientViewC1.gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    self.gradientViewC1.colors = @[startColor, endColor];
    [self.centerContainer addSubview:self.gradientViewC1];
    [self.gradientViewC1 mgrPinEdgesToSuperviewEdges];
    
    
    _centerInnerShadowContainer = [CALayer layer];
    [self.centerContainer.layer addSublayer:self.centerInnerShadowContainer];
    self.centerInnerShadowContainer.frame = self.centerContainer.layer.bounds;
    
    _innerShadowLayerC1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5].CGColor
                                                             innerShadowOffset:CGSizeMake(0.5, -0.5)
                                                         innerShadowBlurRadius:0.0];
    self.innerShadowLayerC1.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayerC1.frame = self.centerContainer.layer.bounds;
    [self.centerInnerShadowContainer addSublayer:self.innerShadowLayerC1];
    
    _innerShadowLayerC2 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.1].CGColor
                                                             innerShadowOffset:CGSizeMake(-0.5, 0.5)
                                                         innerShadowBlurRadius:0.0];
    self.innerShadowLayerC2.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayerC2.frame = self.centerContainer.layer.bounds;
    [self.centerInnerShadowContainer addSublayer:self.innerShadowLayerC2];
}


#pragma mark - Action
- (void)setSkinType:(MGUOnOffSkinType)skinType animated:(BOOL)animated {
    if (animated == NO) {
        [self.centerContainer.layer removeAllAnimations];
        [self.centerInnerShadowContainer removeAllAnimations];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (skinType == MGUOnOffSkinTypeOn) {
            self.centerContainer.layer.borderWidth = 1.0;
            self.centerContainer.layer.shadowOpacity = 0.0;
            self.centerInnerShadowContainer.hidden = YES;
        } else if (skinType == MGUOnOffSkinTypeOff) {
            self.centerContainer.layer.borderWidth = 0.0;
            self.centerContainer.layer.shadowOpacity = 0.5;
            self.centerInnerShadowContainer.hidden = NO;
        } else { // MGUOnOffSkinTypeTouchDown1, MGUOnOffSkinTypeTouchDown2 off <=> on
            self.centerContainer.layer.borderWidth = 1.5;
            self.centerContainer.layer.shadowOpacity = 0.0;
            self.centerInnerShadowContainer.hidden = YES;
        }
        [CATransaction commit];
        return; //! 나가자.
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
        self.centerContainer.layer.shadowOpacity = shadowOpacity; // 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
        [CATransaction commit];
    } else {
        CGFloat borderWidth;
        CGFloat shadowOpacity;
        if (skinType == MGUOnOffSkinTypeOn) { // 눌러진 상태에서 온상태로 가는 것.
            borderWidth = 1.5;
            shadowOpacity = 0.0;
        } else if (skinType == MGUOnOffSkinTypeOff) { // 눌러진 상태에서 오프상태로 가는 것.
            borderWidth = 1.5;
            shadowOpacity = 0.0;
        } else if (skinType == MGUOnOffSkinTypeTouchDown1) { // 오프 상태에서 눌러진 상태로 가는 것.
            borderWidth = 0.0;
            shadowOpacity = 0.5;
        } else { // MGUOnOffSkinTypeTouchDown2 // 온 상태에서 눌러진 상태로 가는 것.
            borderWidth = 1.0;
            shadowOpacity = 0.0;
        }
        borderWidthAnimation.fromValue = @(borderWidth);
        shadowOpacityAnimation.fromValue = @(shadowOpacity);
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
            opacity = 0.0;
        }
        innerShadowOpacityAnimation.fromValue = @(opacity);
    }
    
    //! To Value 이다.
    CGFloat borderWidth;
    CGFloat shadowOpacity;
    CGFloat opacity;
    if (skinType == MGUOnOffSkinTypeOn) { // 눌러진 상태에서 온상태로 가는 것. 평평한 상태이다.
        borderWidth = 1.0; // 보더가 그려져야한다.
        shadowOpacity = 0.0;
        opacity = 0.0; // 센터의 이너 쉐도우가 없어져야한다.
    } else if (skinType == MGUOnOffSkinTypeOff) { // 눌러진 상태에서 오프상태로 가는 것.
        borderWidth = 0.0;
        shadowOpacity = 0.5;
        opacity = 1.0;
    } else if (skinType == MGUOnOffSkinTypeTouchDown1) { // 오프 상태에서 눌러진 상태로 가는 것.
        borderWidth = 1.5;
        shadowOpacity = 0.0;
        opacity = 0.0;
    } else { // MGUOnOffSkinTypeTouchDown2 // 온 상태에서 눌러진 상태로 가는 것.
        borderWidth = 1.5;
        shadowOpacity = 0.0;
        opacity = 0.0;
    }
    
    borderWidthAnimation.toValue = @(borderWidth);
    shadowOpacityAnimation.toValue = @(shadowOpacity);
    innerShadowOpacityAnimation.toValue = @(opacity);
    
    borderWidthAnimation.duration = self.duration;
    borderWidthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    borderWidthAnimation.fillMode = kCAFillModeForwards;
    borderWidthAnimation.removedOnCompletion = NO;
    
    shadowOpacityAnimation.duration = self.duration;
    shadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shadowOpacityAnimation.fillMode = kCAFillModeForwards;
    shadowOpacityAnimation.removedOnCompletion = NO;
    
    innerShadowOpacityAnimation.duration = self.duration;
    innerShadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    innerShadowOpacityAnimation.fillMode = kCAFillModeForwards;
    innerShadowOpacityAnimation.removedOnCompletion = NO;
    
    borderWidthAnimation.delegate = self;
    shadowOpacityAnimation.delegate = self;
    innerShadowOpacityAnimation.delegate = self;
    [borderWidthAnimation setValue:BorderWidthAnimationKey forKey:BorderWidthDeleteKey];
    [shadowOpacityAnimation setValue:ShadowOpacityAnimationKey forKey:ShadowOpacityDeleteKey];
    [innerShadowOpacityAnimation setValue:InnerShadowOpacityAnimationKey forKey:InnerShadowOpacityDeleteKey];
    
    [self.centerContainer.layer addAnimation:borderWidthAnimation forKey:BorderWidthAnimationKey];
    [self.centerContainer.layer addAnimation:shadowOpacityAnimation forKey:ShadowOpacityAnimationKey];
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
            self.centerContainer.layer.shadowOpacity = [animation.toValue doubleValue];
            [self.centerContainer.layer removeAnimationForKey:ShadowOpacityAnimationKey];
        } else if ([[anim valueForKey:InnerShadowOpacityDeleteKey] isEqualToString:InnerShadowOpacityAnimationKey]) {
            self.centerInnerShadowContainer.opacity = [animation.toValue doubleValue];
            [self.centerInnerShadowContainer removeAnimationForKey:InnerShadowOpacityAnimationKey];
        }
    }
}

#pragma mark - Helper
- (void)updateOuterShadowPath {
    self.outContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.outContainer.layer.bounds
                                                               byRoundingCorners:UIRectCornerAllCorners
                                                                     cornerRadii:CGSizeMake([self currentRadius],
                                                                                            [self currentRadius])].CGPath;
}

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
