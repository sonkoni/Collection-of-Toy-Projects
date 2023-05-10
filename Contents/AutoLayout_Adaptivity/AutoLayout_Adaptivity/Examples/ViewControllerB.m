//
//  ViewControllerC.m
//  AutoLayout_Adaptivity
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

#import "ViewControllerB.h"

@interface BackView : UIView
@end
@implementation BackView
+ (Class)layerClass {
    return [CAShapeLayer class];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updatePath];
}
- (void)updatePath {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    NSInteger length = self.layer.bounds.size.width;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.layer.bounds];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(length, length)];
    [bezierPath moveToPoint:CGPointMake(0.0, length)];
    [bezierPath addLineToPoint:CGPointMake(length, 0.0)];
    [bezierPath closePath];
    
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor; // dashed line의 색깔.
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.lineDashPattern = @[@(5), @(5)];
    shapeLayer.lineWidth = 2.0;  // dased line의 굵기
}
@end

@interface ViewControllerB ()
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint; // strong으로 잡아야 active 전환에서 문제를 방지한다.
@property (nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;
@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.targetView.translatesAutoresizingMaskIntoConstraints = NO;
    self.targetView.layer.cornerRadius = 25.0;
    UIBarButtonItem *rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(runAction:)];
    rightBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


#pragma mark - Actions
- (void)runAction:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    [UIView animateKeyframesWithDuration:1.0
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionAutoreverse
                              animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:0.25
                                      animations:^{
            self.centerXConstraint.active = NO;
            self.centerYConstraint.active = NO;
            self.centerXConstraint = [self.targetView.centerXAnchor constraintEqualToAnchor:self.targetView.superview.leadingAnchor];
            self.centerYConstraint = [self.targetView.centerYAnchor constraintEqualToAnchor:self.targetView.superview.topAnchor];
            self.centerXConstraint.active = YES;
            self.centerYConstraint.active = YES;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.25
                                relativeDuration:0.25
                                      animations:^{
            self.centerXConstraint.active = NO;
            self.centerYConstraint.active = NO;
            self.centerXConstraint = [self.targetView.centerXAnchor constraintEqualToAnchor:self.targetView.superview.trailingAnchor];
            self.centerYConstraint = [self.targetView.centerYAnchor constraintEqualToAnchor:self.targetView.superview.topAnchor];
            self.centerXConstraint.active = YES;
            self.centerYConstraint.active = YES;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:0.5
                                      animations:^{
            self.centerXConstraint.active = NO;
            self.centerYConstraint.active = NO;
            self.centerXConstraint = [self.targetView.centerXAnchor constraintEqualToAnchor:self.targetView.superview.centerXAnchor];
            self.centerYConstraint = [self.targetView.centerYAnchor constraintEqualToAnchor:self.targetView.superview.centerYAnchor];
            self.centerXConstraint.active = YES;
            self.centerYConstraint.active = YES;
            [self.view layoutIfNeeded];
        }];
    }
                              completion:^(BOOL finished) {
        sender.enabled = YES;
    }];
}
@end
