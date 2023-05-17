//
//  UIBezierPath+TrigonometricFunctions.m
//  SineTEST
//
//  Created by Kwan Hyun Son on 2021/07/23.
//

#import "UIBezierPath+TrigonometricFunctions.h"

@implementation UIBezierPath (TrigonometricFunctions)

#pragma mark - 사인함수
+ (UIBezierPath *)mgrSinePathWithRectOrigin:(CGPoint)rectOrigin //! 사인함수가 쭉 그려질(몇 개가 그려질 지 모른다.) 얇고 긴 막대기 모양의 rect의 origin
                               oneCycleSize:(CGSize)oneCycleSize
                     parallelMovementDegree:(CGFloat)parallelMovementDegree
                                      count:(NSInteger)count {
    
    UIBezierPath *unitSinePath = [UIBezierPath bezierPath];
    
    //! 사인함수 하나의 주기당 그려질 사인함수의 크기.
    CGSize sinePathUnitSize = oneCycleSize; //! CGSizeMake(50.0, 25.0); 이면 높이가 +12.5 ~ -12.5
    
    //! parallel movement : 평행이동. 0 <= <360 (모든 경우의 수이다.) 90도 씩 4개정도 준비하면 될듯.
    for (NSInteger degree = 0; degree <= 360; degree = degree + 5) {
        CGFloat x = (degree / 360.0) * sinePathUnitSize.width;
        CGFloat y = -sin((degree - parallelMovementDegree) /180.0 * M_PI) * sinePathUnitSize.height/2.0; // iOS는 y축이 반대방향이다.
        if (degree == 0) {
            [unitSinePath moveToPoint:CGPointMake(x, y)];
        } else {
            [unitSinePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    [unitSinePath applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, rectOrigin.x, rectOrigin.y + sinePathUnitSize.height/2.0)];
    
    UIBezierPath *sumSinePath = [UIBezierPath bezierPath];
    UIBezierPath *temp = unitSinePath.copy;
    [sumSinePath appendPath:temp];
    
    if (count <= 1) {
        return sumSinePath;
    }
    
    for (NSInteger i = 1; i < count; i++) {
        temp = unitSinePath.copy;
        [temp applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, sinePathUnitSize.width * i, 0.0)];
        [sumSinePath appendPath:temp];
    }
    
    return sumSinePath;
}

+ (UIBezierPath *)mgrSinePathWithRectLeftCenter:(CGPoint)leftCenter
                                   oneCycleSize:(CGSize)oneCycleSize
                         parallelMovementDegree:(CGFloat)parallelMovementDegree
                                          count:(NSInteger)count {
    CGPoint rectOrigin = leftCenter;
    rectOrigin.y = rectOrigin.y - oneCycleSize.height / 2.0;
    return [UIBezierPath mgrSinePathWithRectOrigin:rectOrigin
                                      oneCycleSize:oneCycleSize
                            parallelMovementDegree:parallelMovementDegree
                                             count:count];
}

+ (UIBezierPath *)mgrSinePathWithRectLeftBottomPoint:(CGPoint)leftBottomPoint
                                        oneCycleSize:(CGSize)oneCycleSize
                              parallelMovementDegree:(CGFloat)parallelMovementDegree
                                               count:(NSInteger)count {
    
    CGPoint rectOrigin = leftBottomPoint;
    rectOrigin.y = rectOrigin.y - oneCycleSize.height;
    return [UIBezierPath mgrSinePathWithRectOrigin:rectOrigin
                                      oneCycleSize:oneCycleSize
                            parallelMovementDegree:parallelMovementDegree
                                             count:count];
}
@end
