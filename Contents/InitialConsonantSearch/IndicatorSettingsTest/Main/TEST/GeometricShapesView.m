//
//  GeometricShapesView.m
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/15.
//

#import "GeometricShapesView.h"

@interface GeometricShapesView ()
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer; // @dynamic
@end

@implementation GeometricShapesView
@dynamic shapeLayer;

+ (Class)layerClass {
    return [CAShapeLayer class];
}

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
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawGeometricShapes];
}

#pragma mark - 생성 & 소멸

- (instancetype)initWithType:(GeometricShapesViewType)type {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _geometricShapesType = type;
    }
    return self;
}

static void CommonInit(GeometricShapesView *self) {
    self->_borderColor = [UIColor blackColor];
    self->_borderWidth = 2.0;
    self->_backColor = [UIColor cyanColor];
}

#pragma mark - 세터 & 게터
- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)(self.layer);
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsLayout];
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    [self setNeedsLayout];
}

- (void)setGeometricShapesType:(GeometricShapesViewType)geometricShapesType {
    _geometricShapesType = geometricShapesType;
    [self setNeedsLayout];
}

#pragma mark - Actions

- (void)drawGeometricShapes {
    if (self.geometricShapesType == GeometricShapesViewTypeEllipse) {
        [self drawEllipse];
    } else if (self.geometricShapesType == GeometricShapesViewTypeRectangle) {
        [self drawRectangle];
    } else if (self.geometricShapesType == GeometricShapesViewTypeTriangle) {
        [self drawTriangle];
    } else {
        NSCAssert(FALSE, @"정상이 아닌 값이 들어왔다");
    }
    
    CAShapeLayer *shapeLayer = self.shapeLayer;
    shapeLayer.strokeColor = self.borderColor.CGColor;
    shapeLayer.lineWidth = self.borderWidth;
    shapeLayer.fillColor = self.backColor.CGColor;
}

- (void)drawEllipse {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.shapeLayer.path = path.CGPath;
}

- (void)drawRectangle {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.shapeLayer.path = path.CGPath;
}

- (void)drawTriangle {
    CGPoint p1 = CGPointMake(self.bounds.size.width / 2.0, 0.0);
    CGPoint p2 = CGPointMake(0.0, self.bounds.size.height);
    CGPoint p3 = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path closePath];
    self.shapeLayer.path = path.CGPath;
}

@end
