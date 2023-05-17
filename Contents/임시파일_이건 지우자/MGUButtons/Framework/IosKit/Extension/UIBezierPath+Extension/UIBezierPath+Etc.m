//
//  UIBezierPath+Etc.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/08/26.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UIBezierPath+Etc.h"

@implementation UIBezierPath (Etc)

- (UIBezierPath *)mgrCreateCopyByStrokingPath:(const CGAffineTransform *)transform {
    CGPathRef cgPath = CGPathCreateCopyByStrokingPath(self.CGPath, // 선분자체를 면으로 만들고 그 면을 둘러싼 선을 반환한다.
                                                      transform,   // <- 보통 NULL 인듯.
                                                      self.lineWidth,
                                                      self.lineCapStyle,
                                                      self.lineJoinStyle,
                                                      self.miterLimit); // <- 보통 miterLimit 는  0.0인듯.
    UIBezierPath *result = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGPathRelease(cgPath);
    return result;
}

+ (instancetype)mgrBezierPathWithRoundedRect:(CGRect)rect
                           byRoundingCorners:(UIRectCorner)corners
                                cornerRadius:(CGFloat)cornerRadius {
    CGPoint topPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint bottomPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint leftPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPoint rightPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    
    CGFloat maxRadius = MIN(rect.size.width, rect.size.height) / 2.0;
    maxRadius = MIN(maxRadius, cornerRadius);
    
    CGFloat widthStraight_2 = (rect.size.width / 2.0) - maxRadius;
    CGFloat heightStraight_2 = (rect.size.height / 2.0) - maxRadius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftPoint.x, leftPoint.y + heightStraight_2)];
    [path addLineToPoint:CGPointMake(leftPoint.x, leftPoint.y - heightStraight_2)];
    if ((corners == UIRectCornerAllCorners) || (corners & UIRectCornerTopLeft)) {
        [path addArcWithCenter:CGPointMake(leftPoint.x + maxRadius, leftPoint.y - heightStraight_2)
                        radius:maxRadius
                    startAngle:M_PI
                      endAngle:-M_PI_2
                     clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
        [path addLineToPoint:CGPointMake(topPoint.x - widthStraight_2, topPoint.y)];
    }
    [path addLineToPoint:CGPointMake(topPoint.x + widthStraight_2, topPoint.y)];
    if ((corners == UIRectCornerAllCorners) || (corners & UIRectCornerTopRight)) {
        [path addArcWithCenter:CGPointMake(topPoint.x + widthStraight_2, topPoint.y + maxRadius)
                        radius:maxRadius
                    startAngle:-M_PI_2
                      endAngle:-0
                     clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
        [path addLineToPoint:CGPointMake(rightPoint.x, rightPoint.y - heightStraight_2)];
    }
    [path addLineToPoint:CGPointMake(rightPoint.x, rightPoint.y + heightStraight_2)];
    if ((corners == UIRectCornerAllCorners) || (corners & UIRectCornerBottomRight)) {
        [path addArcWithCenter:CGPointMake(rightPoint.x - maxRadius, rightPoint.y + heightStraight_2)
                        radius:maxRadius
                    startAngle:0
                      endAngle:M_PI_2
                     clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(bottomPoint.x + widthStraight_2, bottomPoint.y)];
    }
    [path addLineToPoint:CGPointMake(bottomPoint.x - widthStraight_2, bottomPoint.y)];
    if ((corners == UIRectCornerAllCorners) || (corners & UIRectCornerBottomLeft)) {
        [path addArcWithCenter:CGPointMake(bottomPoint.x - widthStraight_2, bottomPoint.y - maxRadius)
                        radius:maxRadius
                    startAngle:M_PI_2
                      endAngle:M_PI
                     clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(leftPoint.x, leftPoint.y + heightStraight_2)];
    }
    [path closePath];
    
    return path;
}

@end
