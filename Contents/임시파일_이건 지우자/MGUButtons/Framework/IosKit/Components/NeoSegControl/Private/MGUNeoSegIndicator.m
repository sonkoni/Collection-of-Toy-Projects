//
//  MGUNeoSegIndicator.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUNeoSegIndicator.h"
#import "MGUNeoSegConfiguration.h"
#import "UIView+Extension.h"
@import GraphicsKit;


#pragma mark - MGUNeoSegIndicatorPrivateView : Priavete Class
@interface MGUNeoSegIndicatorPrivateView : UIView
@property (nonatomic) BOOL     drawsGradientBackground;
@property (nonatomic) UIColor *gradientTopColor;
@property (nonatomic) UIColor *gradientBottomColor;
@end
@implementation MGUNeoSegIndicatorPrivateView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // drawRect: 에서 만들면, 문제가 cornerRadius가 clipsToBounds를 하지 않은 이상 먹지 않아버리는 버그가 존재한다.
    if ( self.drawsGradientBackground == YES ) {
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[ (__bridge id)[self.gradientTopColor    CGColor],
                                  (__bridge id)[self.gradientBottomColor CGColor] ];
    } else {
        self.layer.backgroundColor = [self.backgroundColor CGColor];
    }
    // 아래는 디폴트 값이다. 그래디언트를 그릴 때에는 디폴트 값을 그대로 사용할 것이다.
    // gradientLayer.startPoint = CGPointMake(0.5,0.0);
    // gradientLayer.endPoint   = CGPointMake(0.5,1.0);
    // gradientLayer.type       = kCAGradientLayerAxial;
    // gradientLayer.frame      = rect;
    // 자신이 어딘가에 붙고 프레임이 zero가 아닐때, 발동된다.
    // setNeedsDisplay 메서드는 drawRect:를 강제로 호출한다.
    // layoutSubviews ~ setNeedsLayout 이고, drawRect: ~ setNeedsDisplay
}

- (void)setDrawsGradientBackground:(BOOL)drawsGradientBackground {
    _drawsGradientBackground = drawsGradientBackground;
    [self setNeedsLayout];
}

- (void)setGradientTopColor:(UIColor *)gradientTopColor {
    _gradientTopColor = gradientTopColor;
    [self setNeedsLayout];
}

- (void)setGradientBottomColor:(UIColor *)gradientBottomColor {
    _gradientBottomColor = gradientBottomColor;
    [self setNeedsLayout];
}

@end


#pragma mark - MGUSegmentIndicator Class
@interface MGUNeoSegIndicator ()
@property (nonatomic) MGUNeoSegIndicatorPrivateView *privateView;
@property (nonatomic) NSLayoutConstraint *privateViewHeightConstraint; // priority를 조정하여, Bar 스타일을 만들어 낸다.
@end

@implementation MGUNeoSegIndicator
@dynamic borderWidth;
@dynamic borderColor;
@dynamic drawsGradientBackground;
@dynamic gradientTopColor;
@dynamic gradientBottomColor;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(MGUNeoSegConfiguration *)config {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.opaque              = NO;
        self.layer.masksToBounds = NO;
        self.clipsToBounds       = NO;
            
        _shrink                      = NO;
        _privateView = [MGUNeoSegIndicatorPrivateView new];
        self.privateView.clipsToBounds = NO;
        self.privateView.layer.masksToBounds = NO;
        self.privateView.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.2].CGColor;
        self.privateView.layer.shadowRadius = 1.0f;
        self.privateView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            
        [self addSubview:self.privateView];
        self.privateView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.privateView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [self.privateView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [self.privateView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        NSLayoutConstraint *topConstraint = [self.privateView.topAnchor constraintEqualToAnchor:self.topAnchor];
        topConstraint.priority = UILayoutPrioritySceneSizeStayPut;
        topConstraint.active = YES;
        _privateViewHeightConstraint = [self.privateView.heightAnchor constraintEqualToConstant:5.0f];
        self.privateViewHeightConstraint.priority = UILayoutPriorityDefaultLow; // or UILayoutPriorityDefaultHigh
        self.privateViewHeightConstraint.active = YES; // bar 형태로 사용할 수도 있게 priority를 조정한다.
        
        self.borderColor             = config.indicatorBorderColor;
        self.borderWidth             = config.indicatorBorderWidth;
        self.segmentIndicatorShadowHidden = config.indicatorShadowHidden;
        self.isSegmentIndicatorBarStyle = config.isIndicatorBarStyle;
        self.backgroundColor         = config.indicatorBackgroundColor;
        
        self.drawsGradientBackground = config.drawsIndicatorGradientBackground;
        self.gradientTopColor        = config.indicatorGradientTopColor;
        self.gradientBottomColor     = config.indicatorGradientBottomColor;

    }
    return self;
}

- (void)setIsSegmentIndicatorBarStyle:(BOOL)isSegmentIndicatorBarStyle {
    _isSegmentIndicatorBarStyle = isSegmentIndicatorBarStyle;
    if (isSegmentIndicatorBarStyle == YES) {
        self.privateViewHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    } else {
        self.privateViewHeightConstraint.priority = UILayoutPriorityDefaultLow;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.privateView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return [self.privateView backgroundColor];
}

#pragma mark - 세터 & 게터
- (void)setBorderColor:(UIColor *)borderColor {
    self.privateView.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.privateView.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.privateView.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.privateView.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.privateView.layer.cornerRadius = cornerRadius;
    [self.privateView setNeedsDisplay];
}


#pragma mark - Gradient Background 관련.
- (void)setDrawsGradientBackground:(BOOL)drawsGradientBackground {
    [self.privateView setDrawsGradientBackground:drawsGradientBackground];
}

- (void)setGradientTopColor:(UIColor *)gradientTopColor {
    [self.privateView setGradientTopColor:gradientTopColor];
}

- (void)setGradientBottomColor:(UIColor *)gradientBottomColor {
    [self.privateView setGradientBottomColor:gradientBottomColor];
}

- (BOOL)drawsGradientBackground {
    return self.privateView.drawsGradientBackground;
}

- (UIColor *)gradientTopColor {
    return self.privateView.gradientTopColor;
}

- (UIColor *)gradientBottomColor {
    return self.privateView.gradientBottomColor;
}

- (void)setSegmentIndicatorShadowHidden:(BOOL)segmentIndicatorShadowHidden {
    _segmentIndicatorShadowHidden = segmentIndicatorShadowHidden;
    if (segmentIndicatorShadowHidden == YES) {
        self.privateView.layer.shadowOpacity = 0.0f;
    } else {
        self.privateView.layer.shadowOpacity = 1.0f;
    }
}


#pragma mark - Action
- (void)shrink:(BOOL)isShrink frame:(CGRect)frame {
    if (_shrink == isShrink) {
        return;
    }
    
    _shrink = isShrink;
    [self moveToFrame:frame animated:YES];
}

- (void)moveToFrame:(CGRect)frame animated:(BOOL)animated {
    CGFloat cornerRadius = MIN(self.cornerRadius, frame.size.height / 2.0); // 반 넘게 깎이면 안된다.
    
    if (animated == NO) {
        self.frame = frame;
        self.privateView.layer.cornerRadius = cornerRadius;
        return; //! animated NO이면 실행하고 나간다.
    }
    
    void (^animationsBlock)(void) = ^{
        self.frame = frame;
        self.privateView.layer.cornerRadius = cornerRadius;
        [self layoutIfNeeded];
        [self.privateView layoutIfNeeded];
    };
    
    UIViewPropertyAnimator *animator =
    [[UIViewPropertyAnimator alloc] initWithDuration:0.3
                                        dampingRatio:1.3
                                          animations:animationsBlock];
    [animator startAnimation];

}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(FALSE, @"- initWithCoder: 사용금지.");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(FALSE, @"- initWithFrame: 사용금지.");
    return nil;
}

@end
