//
//  MGULivelyButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGULivelyButton.h"
#import "MGULivelyButton+Style.h"

@interface MGULivelyButton()

@property (nonatomic, assign, readonly) CGFloat dimension;
@property (nonatomic, assign, readonly) CGPoint offset;
@property (nonatomic, assign, readonly) CGPoint centerPoint; // 바운드의 중심이다.

@property (nonatomic, strong) CALayer *maskLayer; // None 일때 주변으로 흩어지는 line layer의 path를 감추기 위함이다.
@property (nonatomic, strong) CAShapeLayer *line0Layer;
@property (nonatomic, strong) CAShapeLayer *line1Layer;
@property (nonatomic, strong) CAShapeLayer *line2Layer;
@property (nonatomic, strong) CAShapeLayer *line3Layer;
@property (nonatomic, strong, readonly) NSArray <CAShapeLayer *>*shapeLayers; // 위의 순서대로 들어있다.

@property (nonatomic, assign) BOOL highlightGuardActivated;
@property (nonatomic, assign) CGRect previousRect;
@end

@implementation MGULivelyButton
@dynamic dimension;
@dynamic offset;
@dynamic centerPoint;
@dynamic shapeLayers;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)dealloc {
    for (CALayer* layer in [self.layer sublayers]) {
        [layer removeAllAnimations];
    }
    
    [self.layer removeAllAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.bounds, CGRectZero) == NO && CGRectEqualToRect(self.bounds, self.previousRect) == NO) {
        _previousRect = self.bounds;
        for(CAShapeLayer *layer in self.shapeLayers) {
            layer.frame = self.layer.bounds;
        }
        
        //! None 상태의 4개의 점 line layer의 path를 감추기 위함이다.
        self.maskLayer.frame = CGRectInset(self.layer.bounds,
                                           -self.config.lineWidth,
                                           -self.config.lineWidth);
        [self setStyle:self.buttonStyle animated:NO];
    }
}


#pragma mark - 생성 & 소멸

- (instancetype)initWithFrame:(CGRect)frame
                        style:(MGULivelyButtonStyle)style
                configuration:(MGULivelyButtonConfiguration * _Nullable)configuration {
    self = [self initWithFrame:frame];
    if (self) {
        _buttonStyle = style;
        if ((configuration != nil) && ([configuration isEqualToDefaultConfiguration] == NO)) {
            self.config = configuration;
        }
    }
    return self;
    
}

static void CommonInit(MGULivelyButton *self) {
    self->_previousRect = CGRectZero;
    
    self.highlightGuardActivated = NO;
    self->_maskLayer = [CALayer layer];
    self.maskLayer.backgroundColor = [UIColor redColor].CGColor;
    self.layer.mask = self.maskLayer;

    self.line0Layer = [CAShapeLayer layer];
    self.line1Layer = [CAShapeLayer layer];
    self.line2Layer = [CAShapeLayer layer];
    self.line3Layer = [CAShapeLayer layer];
    
    self->_config = [MGULivelyButtonConfiguration defaultConfiguration];
    
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = self->_config.strokeColor.CGColor;
        layer.lineWidth = self->_config.lineWidth;
        layer.lineJoin = kCALineJoinRound;
        layer.lineCap = kCALineCapRound;
        layer.contentsScale = self.layer.contentsScale;
        layer.path = [UIBezierPath bezierPath].CGPath;
        [self.layer addSublayer:layer];
    }];
        
    [self addTarget:self action:@selector(showHighlight:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(showHighlight:) forControlEvents:UIControlEventTouchDragEnter];
    
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchCancel];

}


#pragma mark - 세터 & 게터
- (CGFloat)dimension {
    // 버튼이 정사각형이 아닌 경우, 오프셋은 CGPath를 중앙에 유지하는 데 사용된다.
    CGFloat width   = CGRectGetWidth(self.frame)  - (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
    CGFloat height  = CGRectGetHeight(self.frame) - (self.contentEdgeInsets.top  + self.contentEdgeInsets.bottom);

    CGFloat dimension = MIN(width, height);
    return dimension - self.config.margin;
}

- (CGPoint)offset {
    return CGPointMake((CGRectGetWidth(self.frame) - self.dimension) / 2.0f,
                       (CGRectGetHeight(self.frame) - self.dimension) / 2.0f);
}

- (CGPoint)centerPoint {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (NSArray <CAShapeLayer *>*)shapeLayers {
    return @[self.line0Layer, self.line1Layer, self.line2Layer, self.line3Layer];
}

- (void)setButtonStyle:(MGULivelyButtonStyle)buttonStyle {
    [self setStyle:buttonStyle animated:NO];
}

#pragma mark - 컨트롤

- (void)setConfig:(MGULivelyButtonConfiguration *)configuration {
    if (configuration == nil) {
        _config = [MGULivelyButtonConfiguration defaultConfiguration];
    } else {
        _config = configuration;
    }
    
    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
        layer.lineWidth = _config.lineWidth;
        layer.strokeColor = _config.strokeColor.CGColor;
    }];
}

//! 버튼을 눌렀을 때(이벤트)에 애니메이션을 적용한다.
- (void)showHighlight:(id)sender {
    if (self.highlightGuardActivated == YES) { // 이미 버튼이 눌러져있다면 나와라.
      return;
    }

    self.highlightGuardActivated = YES;

    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
        layer.strokeColor = self.config.highlightedStrokeColor.CGColor;
    }];
    
    float highlightScale = self.config.scale;
    CASpringAnimation *scaleAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale.xy"];
     scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue   = @(highlightScale);
    scaleAnimation.duration  = scaleAnimation.settlingDuration;
    scaleAnimation.damping   = 20.0f;
    scaleAnimation.initialVelocity = 0.0f;
    scaleAnimation.stiffness       = 1000.0f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey"];
    
}

//! 버튼 릴리스 이벤트에 애니메이션을 적용한다(예 : touch up inside 또는 touch up outside).
- (void)showUnHighlight:(id)sender {
    if (self.highlightGuardActivated == NO) {
      return;
    }

    self.highlightGuardActivated = NO;

    [self.shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
        layer.strokeColor = self.config.strokeColor.CGColor;
    }];
    
    float highlightScale = self.config.scale;
    CASpringAnimation *scaleAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale.xy"];
     scaleAnimation.fromValue = @(highlightScale);
    scaleAnimation.toValue   = @(1.0);
    scaleAnimation.duration  = scaleAnimation.settlingDuration;
    scaleAnimation.damping   = 100.0f;
    scaleAnimation.initialVelocity = 20.0f;
    scaleAnimation.stiffness       = 100.0f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey__"];
    
    return;
}

- (void)setStyle:(MGULivelyButtonStyle)style animated:(BOOL)animated {
    _buttonStyle = style;
    [self _setStyle:style animated:animated];
}

@end
