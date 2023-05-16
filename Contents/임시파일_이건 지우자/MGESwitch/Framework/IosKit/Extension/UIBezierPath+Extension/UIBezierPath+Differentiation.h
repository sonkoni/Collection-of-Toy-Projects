//
//  UIBezierPath+Differentiation.h
//  BezierMorph
//
//  Created by Kwan Hyun Son on 2020/11/28.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef float MGEPathSegmentPointsAccuracy NS_TYPED_EXTENSIBLE_ENUM; // High 이면 퀄리티 높지만, overHead 우려됨.
static const MGEPathSegmentPointsAccuracy MGEPathSegmentPointsAccuracyHigh API_AVAILABLE(ios(13.0)) = 2.0;
static const MGEPathSegmentPointsAccuracy MGEPathSegmentPointsAccuracyDefault API_AVAILABLE(ios(13.0)) = 1.0;
static const MGEPathSegmentPointsAccuracy MGEPathSegmentPointsAccuracyLow API_AVAILABLE(ios(13.0)) = 0.5;

@interface UIBezierPath (Differentiation) // 미분.

/**
 * @brief 리시버(UIBezierPath 인스턴스)를 주어진 accuracy 단위로 분해하여 CGPoint(NSValue) 배열을 반환한다.
 * @param accuracy 정확도를 의미하는 float 값으로 1포인트 단위로 하려면 MGEPathSegmentPointsAccuracyDefault를쓰자.
 * @discussion MGEPathSegmentPointsAccuracyDefault( = 1.0) 이면 퍼포먼스나 퀄리티 측면에서 사용하기 적당하다.
 * @code
    NSMutableArray <NSValue *>*segmentPoints =
    [bezierPath mgrSegmentPointsWithAccuracy:MGEPathSegmentPointsAccuracyDefault];
 * @endcode
 * @return 반환 값은 CGPoint를 랩핑한 NSValue 객체를 element로 갖는 NSMutableArray 객체를 반환한다.
*/
- (NSMutableArray <NSValue *>*)mgrSegmentPointsWithAccuracy:(MGEPathSegmentPointsAccuracy)accuracy;


#pragma mark - DEBUG
/**
 * @brief self (UIBezierPath) 객체를 MGEPathElementRef 분해하여 다시 재조립하는 메서드이다.
 * @discussion self (UIBezierPath) 객체를 MGEPathElementRef 분해하여 다시 재조립하는 메서드이다.
 * @code
    UIBezierPath *newPath = [originalPath mgrReconstructOriginalUIBezierPath];
 * @endcode
 * @return 반환 값은 self 를 분해하여 만든 잘게 쪼개 만든 MGEPathElementRef 배열을 다시 UIBezierPath 로 만든 것. 원본과 모양을 대조해보면된다.
*/
- (UIBezierPath *)mgrReconstructOriginalUIBezierPath;
@end

NS_ASSUME_NONNULL_END
