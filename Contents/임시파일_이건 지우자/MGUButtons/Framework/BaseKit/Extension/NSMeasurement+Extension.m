//
//  NSMeasurement+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSMeasurement+Extension.h"

@implementation NSMeasurement (Extension)


#pragma mark - Calculation
- (NSMeasurement *)mgrMultiplyByScalarValue:(CGFloat)doubleValue {
    return [[NSMeasurement alloc] initWithDoubleValue:(self.doubleValue * doubleValue) unit:self.unit];
}

- (NSMeasurement *)mgrDivideByScalarValue:(CGFloat)doubleValue {
    if (doubleValue == 0.0) {
        NSCAssert(FALSE, @"나눠지는 값은 0이될 수 없다. 수학적 불능.");
    }
    return [[NSMeasurement alloc] initWithDoubleValue:(self.doubleValue / doubleValue) unit:self.unit];
}

- (NSMeasurement *)mgrDivideScalarValueByMeasurement:(CGFloat)doubleValue {
    if (self.doubleValue == 0.0) {
        NSCAssert(FALSE, @"나눠지는 값은 0이될 수 없다. 수학적 불능.");
    }
    return [[NSMeasurement alloc] initWithDoubleValue:(doubleValue / self.doubleValue) unit:self.unit];
}


#pragma mark - Formatting a Measurement
- (NSString *)mgrFormatted:(MGRMeasurementFormatStyleUnitWidthType)unitWidthType {
    NSMeasurementFormatter *formatter = [NSMeasurementFormatter new];
    formatter.unitStyle = unitWidthType;
    return [formatter stringFromMeasurement:self];
}

- (NSString *)mgrFormattedEnergy:(MGRMeasurementFormatStyleUnitWidthType)unitWidthType
                           usage:(MGRMeasurementFormatUnitUsage)usage {
    NSMeasurementFormatter *formatter = [NSMeasurementFormatter new];
    formatter.unitStyle = unitWidthType;
    formatter.numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    if (usage == MGRMeasurementFormatUnitUsageNone ||
        usage == MGRMeasurementFormatUnitUsageGeneral) {
        formatter.unitOptions = NSMeasurementFormatterUnitOptionsProvidedUnit;
        NSMeasurement <NSUnitEnergy *>*measurement = [self measurementByConvertingToUnit:[NSUnitEnergy kilowattHours]];
        if (measurement.doubleValue >= 10.0) {
            formatter.numberFormatter.maximumFractionDigits = 0;
        } else {
            formatter.numberFormatter.usesSignificantDigits = YES;
            formatter.numberFormatter.maximumSignificantDigits = 2;
        }
        return [formatter stringFromMeasurement:measurement];
    } else if (usage == MGRMeasurementFormatUnitUsageAsProvided) {
        formatter.unitOptions = NSMeasurementFormatterUnitOptionsProvidedUnit;
        formatter.numberFormatter.maximumFractionDigits = 6;
        return [formatter stringFromMeasurement:self];
    } else if (usage == MGRMeasurementFormatUnitUsageFood ||
               usage == MGRMeasurementFormatUnitUsageWorkout) {
        NSMeasurementFormatter *formatter = [NSMeasurementFormatter new];
        formatter.unitStyle = unitWidthType;
        NSMeasurement <NSUnitEnergy *>*measurement = self;
        if (self.unit != [NSUnitEnergy kilocalories]) { // kilocalories가 기준이 된다. 이 영역에서는
            measurement = [self measurementByConvertingToUnit:[NSUnitEnergy kilocalories]];
        }
        if (measurement.doubleValue >= 10.0) {
            formatter.numberFormatter.maximumFractionDigits = 0;
        } else {
            formatter.numberFormatter.usesSignificantDigits = YES;
            formatter.numberFormatter.maximumSignificantDigits = 2;
        }
        return [formatter stringFromMeasurement:measurement];
    } else {
        NSCAssert(FALSE, @"유효한 usage 가 아니다.");
        return [formatter stringFromMeasurement:self];
    }
}


#pragma mark - Convenience Accessors
+ (NSMeasurement <NSUnitVolume *>*)mgrMeasurementWithCupsValue:(CGFloat)cupsValue {
    return [[NSMeasurement alloc] initWithDoubleValue:cupsValue unit:[NSUnitVolume cups]];
}
+ (NSMeasurement <NSUnitVolume *>*)mgrMeasurementWithTablespoons:(CGFloat)tablespoons {
    return [[NSMeasurement alloc] initWithDoubleValue:tablespoons unit:[NSUnitVolume tablespoons]];
}
+ (NSMeasurement <NSUnitMass *>*)mgrMeasurementWithGrams:(CGFloat)grams {
    return [[NSMeasurement alloc] initWithDoubleValue:grams unit:[NSUnitMass grams]];
}
@end
