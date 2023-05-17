//
//  UIBezierPath+TrigonometricFunctions.h
//
//  Created by Kwan Hyun Son on 2021/07/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (TrigonometricFunctions)


/**
 * @brief rectOrigin 에서 시작된 가로로 긴 사각형 안에 sine 함수를 늘어뜨려 그린다.
 * @param rectOrigin 사인함수가 그려질 긴 사각형의 origin에 해당한다.
 * @param oneCycleSize 사인함수의 한 사이클이 만들어 내는 사각형의 사이즈
 * @param parallelMovementDegree x축으로 평행이동할 각의 양. 일반적인 표준 사인함수에서 각(도:degree)로 생각하자.
 * @param count 몇개의 사인함수를 이어 붙일 것인가
 * @discussion 이 함수를 통해서 사인함수를 만들어보자.
 * @code
     UIBezierPath *result = [UIBezierPath mgrSinePathWithRectOrigin:CGPointMake(0.0, 150.0 - 12.5)
                                                       oneCycleSize:CGSizeMake(50.0, 25.0)
                                             parallelMovementDegree:0.0
                                                              count:10];
 * @endcode
 * @return 한 사이클로 이루어진 사인함수를 count개 오른쪽으로 붙인 사인함수를 반환한다.
*/
+ (UIBezierPath *)mgrSinePathWithRectOrigin:(CGPoint)rectOrigin
                               oneCycleSize:(CGSize)oneCycleSize
                     parallelMovementDegree:(CGFloat)parallelMovementDegree
                                      count:(NSInteger)count;


/**
 * @brief leftCenter 에서 시작된 가로로 긴 사각형 안에 sine 함수를 늘어뜨려 그린다. 위의 함수를 좀 더 편리하게 만들었다.
 * @param leftCenter 사인함수가 그려질 긴 사각형의 leftCenter에 해당한다.
 * @param oneCycleSize 사인함수의 한 사이클이 만들어 내는 사각형의 사이즈
 * @param parallelMovementDegree x축으로 평행이동할 각의 양. 일반적인 표준 사인함수에서 각(도:degree)로 생각하자.
 * @param count 몇개의 사인함수를 이어 붙일 것인가
 * @discussion 이 함수를 통해서 사인함수를 만들어보자.
 * @code
     UIBezierPath *result = [UIBezierPath mgrSinePathWithRectOrigin:CGPointMake(0.0, 150.0 - 12.5)
                                                       oneCycleSize:CGSizeMake(50.0, 25.0)
                                             parallelMovementDegree:0.0
                                                              count:10];
 * @endcode
 * @return 한 사이클로 이루어진 사인함수를 count개 오른쪽으로 붙인 사인함수를 반환한다.
*/
+ (UIBezierPath *)mgrSinePathWithRectLeftCenter:(CGPoint)leftCenter
                                   oneCycleSize:(CGSize)oneCycleSize
                         parallelMovementDegree:(CGFloat)parallelMovementDegree
                                          count:(NSInteger)count;


/**
 * @brief leftBottomPoint 에서 시작된 가로로 긴 사각형 안에 sine 함수를 늘어뜨려 그린다. 위의 함수를 좀 더 편리하게 만들었다.
 * @param leftBottomPoint 사인함수가 그려질 긴 사각형의 leftBottomPoint에 해당한다.
 * @param oneCycleSize 사인함수의 한 사이클이 만들어 내는 사각형의 사이즈
 * @param parallelMovementDegree x축으로 평행이동할 각의 양. 일반적인 표준 사인함수에서 각(도:degree)로 생각하자.
 * @param count 몇개의 사인함수를 이어 붙일 것인가
 * @discussion 이 함수를 통해서 사인함수를 만들어보자.
 * @code
     UIBezierPath *result = [UIBezierPath mgrSinePathWithRectOrigin:CGPointMake(0.0, 150.0 - 12.5)
                                                       oneCycleSize:CGSizeMake(50.0, 25.0)
                                             parallelMovementDegree:0.0
                                                              count:10];
 * @endcode
 * @return 한 사이클로 이루어진 사인함수를 count개 오른쪽으로 붙인 사인함수를 반환한다.
*/
+ (UIBezierPath *)mgrSinePathWithRectLeftBottomPoint:(CGPoint)leftBottomPoint
                                        oneCycleSize:(CGSize)oneCycleSize
                              parallelMovementDegree:(CGFloat)parallelMovementDegree
                                               count:(NSInteger)count;
                           


@end

NS_ASSUME_NONNULL_END
