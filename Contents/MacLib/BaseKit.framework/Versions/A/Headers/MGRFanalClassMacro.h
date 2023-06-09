//
//  MGRFanalClassMacro.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-20
//  ----------------------------------------------------------------------
//  파이널 클래스 : 상속 불가능하게 만들기

#ifndef MGRFanalClassMacro_h
#define MGRFanalClassMacro_h
#import <Foundation/Foundation.h>

#define MGR_FINAL_CLASS(CLASSNAME, ...)                                 \
CLASSNAME                                                               \
__VA_ARGS__;                                                            \
+ (instancetype)allocWithZone:(struct _NSZone *)zone {                  \
    NSCAssert(self == [CLASSNAME class], @"Subclassing not allowed");   \
    return [super allocWithZone:zone];                                  \
}


// 다음의 구현부가 있다고 할 때, 상속해서 접근할 경우 아래처럼 터지게 하면 된다.
// 이것을 매크로로 구현하면 다음처럼 사용할 수 있다. 다음 두 코드는 같다.
//    @implementation DTOHello
//    + (instancetype)allocWithZone:(struct _NSZone *)zone {
//        NSCAssert(self == [DTOHello class], @"Subclassing not allowed");
//        return [super allocWithZone:zone];
//    ... code ...
//    @end
//
//    @implementation MGR_FINAL_CLASS(DTOHello)
//    ... code ...
//    @end
//
//
// 만약 내부에 프라이빗 변수를 설정하고 싶으면 다음처럼 하면 된다. 다음 두 코드는 같다.
//    @implementation DTOHello {
//        id _value;
//    }
//    + (instancetype)allocWithZone:(struct _NSZone *)zone {
//        NSCAssert(self == [DTOHello class], @"Subclassing not allowed");
//        return [super allocWithZone:zone];
//    ... code ...
//    @end
//
//    @implementation MGR_FINAL_CLASS(DTOHello, {
//        id _value;
//    })
//    ... code ...
//    @end
//

#endif /* MGRFanalClassMacro_h */
