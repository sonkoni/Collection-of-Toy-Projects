//
//  NSNumberFormatter+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-19
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumberFormatter (Extension)

/*!
 * @abstract    boundaryValue 를 기준으로 작으면 maximumSignificantDigits 적용한다.
 * @discussion  같거나 크면 정수로 표현한다.(소숫점 첫 째자리에서 반올림). 작을 경우. 왼쪽에서부터 처음 0이 아닌 수를 integer 만큼 볼 수 있게 그 뒤에서 반올림한다. 애플이 사용하는 전략이다.
 */
- (void)mgrStrategyCurrentValue:(CGFloat)currentValue
                  boundaryValue:(CGFloat)boundaryValue
           maxSignificantDigits:(NSInteger)maximumSignificantDigits;

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-10-19 : 라이브러리 정리됨
*/
