//
//  UIBezierPath+Pipe.h
//  PipeBezierTEST
//
//  Created by Kwan Hyun Son on 2021/01/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (Pipe)

/**
 * @brief startPoint 에서 endPoint로 파이프 path(⎣ 또는 ⎦ 또는 ⎡ 또는 ⎤)를 그려 반환한다.
 * @param startPoint 시작점.
 * @param endPoint 종료점.
 * @param isUpStyle 두 가지의 선택 가능성 중에서 윗 쪽에 선이 그어지는 것으로 선택할지의 여부.
 * @param radius 굽혀지는 곳에서 사용할 radius
 * @discussion radius를 적절하게 조절해주면 된다.
 * @code
    UIBezierPath *path1 = [UIBezierPath mgrPipePathWithStartPoint:CGPointMake(0.0, 50.0)
                                                         EndPoint:CGPointMake(50.0, 70.0)
                                                          upStyle:YES radius:10.0];
    // ⎤ 형태
 
    UIBezierPath *path1 = [UIBezierPath mgrPipePathWithStartPoint:CGPointMake(50.0, 150.0)
                                                         EndPoint:CGPointMake(200.0, 180.0)
                                                          upStyle:NO radius:10.0];
    // ⎣ 형태
 * @endcode
 * @return 반환 값은 ⎣ 또는 ⎦ 또는 ⎡ 또는 ⎤ 에 해당한느 path를 반환한다.
*/
+ (UIBezierPath *)mgrPipePathWithStartPoint:(CGPoint)startPoint
                                   EndPoint:(CGPoint)endPoint
                                    upStyle:(BOOL)isUpStyle
                                     radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
