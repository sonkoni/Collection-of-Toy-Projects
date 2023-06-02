//
//  WaveView.m
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "WaveView.h"

@interface WaveShapeView : UIView
@end
@implementation WaveShapeView
+ (Class)layerClass {
    return [CAShapeLayer class];
}
@end

@interface WaveView ()
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) WaveShapeView *topWaveShapeView;
@property (nonatomic, strong) WaveShapeView *bottomWaveShapeView;
@end

@implementation WaveView

#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                 topWaveColor:(UIColor *)topWaveColor
              bottomWaveColor:(UIColor *)bottomWaveColor  {
    self = [super initWithFrame:frame];
    if (self) {
        _topWaveColor = topWaveColor;
        _bottomWaveColor = bottomWaveColor;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(WaveView *self) {
    self->_topWaveColor = [UIColor mgrColorFromHexString:@"4AA1D3"];
    self->_bottomWaveColor = [UIColor mgrColorFromHexString:@"AFDCF3"];
    
    self->_scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self->_scrollContentView = [UIView new];
    self.scrollContentView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollView mgrPinEdgesToSuperviewEdges];
    [self.scrollContentView mgrPinEdgesToSuperviewEdges];
    [self.scrollContentView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:3.0].active = YES;
    [self.scrollContentView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    
    self->_topWaveShapeView = [WaveShapeView new];
    self->_bottomWaveShapeView = [WaveShapeView new];
    
    [self.scrollContentView addSubview:self.topWaveShapeView];
    [self.scrollContentView addSubview:self.bottomWaveShapeView];
    [self.topWaveShapeView mgrPinHorizontalEdgesToSuperviewEdges];
    [self.bottomWaveShapeView mgrPinHorizontalEdgesToSuperviewEdges];
    [self.topWaveShapeView.topAnchor constraintEqualToAnchor:self.scrollContentView.topAnchor].active = YES;
    [self.bottomWaveShapeView.bottomAnchor constraintEqualToAnchor:self.scrollContentView.bottomAnchor].active = YES;
    
    self->_topWaveHeightConstraint = [self.topWaveShapeView.heightAnchor constraintEqualToAnchor:self.scrollContentView.heightAnchor multiplier:0.15];
    self->_bottomWaveHeightConstraint = [self.bottomWaveShapeView.heightAnchor constraintEqualToAnchor:self.scrollContentView.heightAnchor multiplier:0.45];
    self.bottomWaveHeightConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.bottomWaveShapeView.heightAnchor constraintGreaterThanOrEqualToConstant:300.0].active = YES;
    
    self.topWaveHeightConstraint.active = YES;
    self.bottomWaveHeightConstraint.active = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.scrollView layoutIfNeeded];
    [self drawWaveLayer];
}

- (void)drawWaveLayer {
    NSInteger waveCountOnScence = 9;
    NSInteger totalWaveCount = waveCountOnScence * 3;
    CGRect largeframe = self.topWaveShapeView.bounds;
    CGSize oneSineSize = CGSizeMake(largeframe.size.width / 27.0, largeframe.size.width / 27.0 / 10.0);
    
    UIBezierPath *path = [UIBezierPath mgrSinePathWithRectOrigin:CGPointMake(0.0, largeframe.size.height)
                                                    oneCycleSize:oneSineSize
                                          parallelMovementDegree:-45
                                                           count:totalWaveCount];
    CGPoint currentPoint = path.currentPoint;
    [path addLineToPoint:CGPointMake(currentPoint.x, 0.0)];
    [path addLineToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(0.0, currentPoint.y)];
    CAShapeLayer *layer = (CAShapeLayer *)(self.topWaveShapeView.layer);
    layer.path = path.CGPath;
    layer.fillColor = [self topWaveColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    
    largeframe = self.bottomWaveShapeView.bounds;
    oneSineSize = CGSizeMake(largeframe.size.width / 27.0, largeframe.size.width / 27.0 / 10.0);
    path = [UIBezierPath mgrSinePathWithRectLeftBottomPoint:CGPointZero
                                               oneCycleSize:oneSineSize
                                     parallelMovementDegree:-45
                                                      count:totalWaveCount];
    currentPoint = path.currentPoint;
    [path addLineToPoint:CGPointMake(currentPoint.x, largeframe.size.height)];
    [path addLineToPoint:CGPointMake(0.0, largeframe.size.height)];
    [path addLineToPoint:CGPointMake(0.0, currentPoint.y)];
    
    layer = (CAShapeLayer *)(self.bottomWaveShapeView.layer);
    layer.path = path.CGPath;
    layer.fillColor = [self bottomWaveColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }

@end
