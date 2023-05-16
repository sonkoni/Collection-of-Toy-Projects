//
//  NSNumberFormatter+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSNumberFormatter+Extension.h"

@implementation NSNumberFormatter (Extension)

- (void)mgrStrategyCurrentValue:(CGFloat)currentValue
                  boundaryValue:(CGFloat)boundaryValue
           maxSignificantDigits:(NSInteger)maximumSignificantDigits {
    self.roundingMode = NSNumberFormatterRoundHalfUp;
    if (currentValue >= boundaryValue) {
        self.maximumFractionDigits = 0; // boundaryValue 크면 정수로 표현( 소숫점 첫 째자리에서 반올림)
    } else {
        self.usesSignificantDigits = YES;
        self.maximumSignificantDigits = maximumSignificantDigits; // 작으면 앞 쪽 중요한 숫자만 integer 만큼 보여준다. 그 뒤에서 반올림한다.
    }
}
@end
