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
@end
