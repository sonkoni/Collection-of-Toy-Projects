//
//  MGUSwipeDecoEdgeView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeDecoEdgeView.h"

@interface MGUSwipeDecoEdgeView ()
@property (nonatomic, strong) UIView *swipeableDecoLeftEdgeView;  // 스와이프 시에 양쪽 끝에서 라디어스로 인하여 보여지는 부분을 매꿔주는 뷰
@property (nonatomic, strong) UIView *swipeableDecoRightEdgeView; // 스와이프 시에 양쪽 끝에서 라디어스로 인하여 보여지는 부분을 매꿔주는 뷰
@property (nonatomic, strong) CAShapeLayer *shapeLayer; // mask layer
@end

@implementation MGUSwipeDecoEdgeView
@dynamic swipeDecoLeftColor;
@dynamic swipeDecoRightColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.frame = self.layer.bounds;
    [self updatePath];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUSwipeDecoEdgeView *self) {
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
 
    self->_shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.fillRule = kCAFillRuleEvenOdd;
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.fillColor = [UIColor redColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.frame = self.layer.bounds;
    self.layer.mask = self.shapeLayer;
    self->_cornerRadius = 0.0;
    
    UIStackView *stackView = [UIStackView new];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    self->_swipeableDecoLeftEdgeView = [UIView new];
    self->_swipeableDecoRightEdgeView = [UIView new];
    self.swipeableDecoLeftEdgeView.backgroundColor = [UIColor clearColor];
    self.swipeableDecoRightEdgeView.backgroundColor = [UIColor clearColor];
    [stackView addArrangedSubview:self.swipeableDecoLeftEdgeView];
    [stackView addArrangedSubview:self.swipeableDecoRightEdgeView];
    [self addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}


#pragma mark - 세터 & 게터
- (void)setSwipeDecoLeftColor:(UIColor *)swipeDecoLeftColor {
    self.swipeableDecoLeftEdgeView.backgroundColor = swipeDecoLeftColor;
}

- (void)setSwipeDecoRightColor:(UIColor *)swipeDecoRightColor {
    self.swipeableDecoRightEdgeView.backgroundColor = swipeDecoRightColor;
}

- (UIColor *)swipeDecoLeftColor {
    return self.swipeableDecoLeftEdgeView.backgroundColor;
}

- (UIColor *)swipeDecoRightColor {
    return self.swipeableDecoRightEdgeView.backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updatePath];
}


#pragma mark - Action
- (void)updatePath {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    self.shapeLayer.path = path.CGPath;
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    NSCAssert(FALSE, @"- initWithCoder: 사용금지.");
    return self;
}
@end
