//
//  NSMeasurement+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-18
//  ----------------------------------------------------------------------
//
//
// https://goshdarnformatstyle.com/measurement-style/
// https://ampersandsoftworks.com/posts/measurements-and-their-formatting/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGRMeasurementFormatStyleUnitWidthType
 @abstract   swift의 편의 함수 때문에 만들었다. 실제로는 NSMeasurementFormatter의 프라퍼티와 일대일 대응한다.
 @constant   MGRMeasurementFormatStyleUnitWidthTypeAbbreviated ....
 @constant   MGRMeasurementFormatStyleUnitWidthTypeNarrow .....
 @constant   MGRMeasurementFormatStyleUnitWidthTypeWide .....
 */
typedef NS_ENUM(NSInteger, MGRMeasurementFormatStyleUnitWidthType) {
    MGRMeasurementFormatStyleUnitWidthTypeAbbreviated = NSFormattingUnitStyleMedium,
    MGRMeasurementFormatStyleUnitWidthTypeNarrow = NSFormattingUnitStyleShort,
    MGRMeasurementFormatStyleUnitWidthTypeWide = NSFormattingUnitStyleLong
};

CF_INLINE NSFormattingUnitStyle MGRMeasurementFormatStyleConvert(MGRMeasurementFormatStyleUnitWidthType type) {
    if (type == MGRMeasurementFormatStyleUnitWidthTypeAbbreviated) { return NSFormattingUnitStyleMedium;
    } else if (type == MGRMeasurementFormatStyleUnitWidthTypeNarrow) { return NSFormattingUnitStyleShort;
    } else if (type == MGRMeasurementFormatStyleUnitWidthTypeWide) { return NSFormattingUnitStyleLong;
    } else { NSCAssert(FALSE, @"예상치 못한 값 등장"); return NSFormattingUnitStyleLong;
    }
}

// print(recommendedCalories.formatted(.measurement(width: .wide, usage: .asProvided))) usage: 에 대응한다.
// MeasurementFormatUnitUsage 스위프트. 에 해당한다.
// obj-c 와 일대일 매칭이 안된다. obj-c는 NS_OPTIONS 이지만 swift 방식과는 맞지 않아서 그냥 Enum으로 만들었다.
typedef NS_ENUM(NSUInteger, MGRMeasurementFormatUnitUsage) {
    MGRMeasurementFormatUnitUsageNone = 0,
    MGRMeasurementFormatUnitUsageAsProvided = NSMeasurementFormatterUnitOptionsProvidedUnit,
    MGRMeasurementFormatUnitUsageGeneral    = 100, // 대응이 안될 수 있다.
    
    // Selecting a Format for an Energy Measurement : 정확히 매칭이 안될 수 있다.
    MGRMeasurementFormatUnitUsageFood    = 101,
    MGRMeasurementFormatUnitUsageWorkout = 102,

    //Selecting a Format for a Length Measurement : 정확히 매칭이 안될 수 있다.
    MGRMeasurementFormatUnitUsagePerson   = 103,
    MGRMeasurementFormatUnitUsagePersonHeight = 104,
    MGRMeasurementFormatUnitUsageRoad = 105,
    
    //Selecting a Format for a Mass Measurement : 정확히 매칭이 안될 수 있다.
    MGRMeasurementFormatUnitUsagePersonWeight = 106,
    
    //Selecting a Format for a Temperature Measurement : 정확히 매칭이 안될 수 있다.
    MGRMeasurementFormatUnitUsageTemperaturePerson   = 107, // NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit
    MGRMeasurementFormatUnitUsageTemperatureWeather   = 108 // NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit
};


@interface NSMeasurement<ObjectType> (Extension)

#pragma mark - Calculation
// 자신과 동일한 타입의 제네릭이다. 스위프트와 동일하게 작동할 수 있게 만들었다.
// 스위프트에 정의된 static func * (lhs: Measurement<UnitType>, rhs: Double) -> Measurement<UnitType>
- (NSMeasurement <ObjectType>*)mgrMultiplyByScalarValue:(CGFloat)doubleValue;

// 나눠지는 값이 스칼라이다. 스위프트와 동일하게 작동할 수 있게 만들었다.
- (NSMeasurement <ObjectType>*)mgrDivideByScalarValue:(CGFloat)doubleValue;

//! 주의하라. 나눠지는 값(분모)은 self.doubleValue이다. 스위프트와 동일하게 작동할 수 있게 만들었다.
- (NSMeasurement <ObjectType>*)mgrDivideScalarValueByMeasurement:(CGFloat)doubleValue;


#pragma mark - Formatting a Measurement
/*
 swfit
let temperatureMeasurement = Measurement<UnitTemperature>(value: 100, unit: .fahrenheit)
temperatureMeasurement.formatted(.measurement(width: .wide)) // 100 degrees Fahrenheit
temperatureMeasurement.formatted(.measurement(width: .abbreviated)) // 100°F
temperatureMeasurement.formatted(.measurement(width: .narrow)) // 100°
 
 obj - c
 NSMeasurement *temperatureMeasurement = [[NSMeasurement alloc] initWithDoubleValue:100.0
                                                                               unit:[NSUnitTemperature fahrenheit]];
 NSString *result1 = [temperatureMeasurement mgrFormatted:MGRMeasurementFormatStyleUnitWidthTypeWide];
 NSString *result2 = [temperatureMeasurement mgrFormatted:MGRMeasurementFormatStyleUnitWidthTypeAbbreviated];
 NSString *result3 = [temperatureMeasurement mgrFormatted:MGRMeasurementFormatStyleUnitWidthTypeNarrow];
 NSLog(@"result1 => %@", result1); // result1 => 100 degrees Fahrenheit
 NSLog(@"result2 => %@", result2); // result2 => 100°F
 NSLog(@"result3 => %@", result3); // result3 => 100°
*/
- (NSString *)mgrFormatted:(MGRMeasurementFormatStyleUnitWidthType)unitWidthType;

//! NSUnitEnergy 전용. asProvided를 제외하고 표현 값이 10을 기준으로 정수로 보여줄지, maximumSignificantDigits = 2 로 할지로 결정된다.
// let recommendedCalories = Measurement(value: 20.0, unit: UnitEnergy.kilowattHours)
// print(recommendedCalories.formatted(.measurement(width: .wide))) // 20 kilowatt-hours
// print(recommendedCalories.formatted(.measurement(width: .wide, usage: .general))) // 20 kilowatt-hours
// print(recommendedCalories.formatted(.measurement(width: .wide, usage: .asProvided))) // 20 kilowatt-hours
// print(recommendedCalories.formatted(.measurement(width: .wide, usage: .food))) // 17,208 Calories
// print(recommendedCalories.formatted(.measurement(width: .wide, usage: .workout))) // 17,208 Calories
- (NSString *)mgrFormattedEnergy:(MGRMeasurementFormatStyleUnitWidthType)unitWidthType
                           usage:(MGRMeasurementFormatUnitUsage)usage;


#pragma mark - Convenience Accessors
+ (NSMeasurement <NSUnitVolume *>*)mgrMeasurementWithCupsValue:(CGFloat)cupsValue;
+ (NSMeasurement <NSUnitVolume *>*)mgrMeasurementWithTablespoons:(CGFloat)tablespoons;
+ (NSMeasurement <NSUnitMass *>*)mgrMeasurementWithGrams:(CGFloat)grams;
@end

NS_ASSUME_NONNULL_END
