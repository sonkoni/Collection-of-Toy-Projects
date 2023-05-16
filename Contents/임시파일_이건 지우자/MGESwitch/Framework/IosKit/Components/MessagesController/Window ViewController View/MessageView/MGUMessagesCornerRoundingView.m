//
//  MGUMessagesCornerRoundingView.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "MGUMessagesCornerRoundingView.h"

@interface MGUMessagesCornerRoundingView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign, readonly) CGSize cornerRadii; // @dynamic
@end

@implementation MGUMessagesCornerRoundingView
@dynamic cornerRadii;

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
    [self updateMaskPath];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUMessagesCornerRoundingView *self) {
    self->_cornerRadius = 0.0;
    self->_roundsLeadingCorners = NO;
    self->_roundedCorners = UIRectCornerAllCorners;
    self->_shapeLayer = [CAShapeLayer layer];
    self.layer.mask = self.shapeLayer;
}


#pragma mark - 세터 & 게터
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateMaskPath];
}

- (CGSize)cornerRadii {
    return CGSizeMake(self.cornerRadius, self.cornerRadius);
}

- (void)setRoundedCorners:(UIRectCorner)roundedCorners {
    _roundedCorners = roundedCorners;
    [self updateMaskPath];
}


#pragma mark - Action
- (void)updateMaskPath {
    CGPathRef newPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds
                                              byRoundingCorners:self.roundedCorners
                                                    cornerRadii:self.cornerRadii].CGPath;

    NSArray <NSString *>*animationKeys = [self.layer animationKeys];
    CABasicAnimation *foundAnimation = [animationKeys mgrMap:^id (NSString *animationKey) {
        CABasicAnimation *animation = [self.layer animationForKey:animationKey];
        if ([animation isKindOfClass:[CABasicAnimation class]] && [animation.keyPath isEqualToString:@"bounds.size"]) {
            return animation;
        } else {
            return nil;
        }
    }].firstObject;
    
    if (foundAnimation != nil) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = foundAnimation.duration;
        animation.timingFunction = foundAnimation.timingFunction;
        animation.fromValue = (__bridge id _Nullable)(self.shapeLayer.path);
        animation.toValue = (__bridge id _Nullable)(newPath);
        [self.shapeLayer addAnimation:animation forKey:@"path"];
        self.shapeLayer.path = newPath;
    } else {
        self.shapeLayer.path = newPath;
    }
}

@end
