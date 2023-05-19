//
//  MGREnumType.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-20
//  ----------------------------------------------------------------------
//  기본 지원 타입 정의
//

#ifndef MGRSysType_h
#define MGRSysType_h
#import <Foundation/Foundation.h>

/// 자주 사용하는 NSNumber 타입
//                         Objc                           Swift
// ------------------------------------     -------------------------------------
//            .boolValue > BOOL               .boolValue > Bool
//         .integerValue > NSInteger           .intValue > Int (Int32/Int64)
// .unsignedIntegerValue > NSUInteger         .uintValue > UInt (UInt32/UInt64)
//           .floatValue > float/CGFloat     .floatValue > Float (Float32)
//          .doubleValue > double/CGFloat   .doubleValue > Double (Float64)
//
// ---------------------------------------------------- Create   32-bit    64-bit
typedef NSNumber *   MGRBool;   //            + numberWithBool:  _Bool     _Bool
typedef NSNumber *   MGRInt;    //         + numberWithInteger:  int32_t   int64_t
typedef NSNumber *   MGRUInt;   // + numberWithUnsignedInteger:  uint32_t  uint64_t
typedef NSNumber *   MGRFloat;  //           + numberWithFloat:  float     float
typedef NSNumber *   MGRDouble; //          + numberWithDouble:  double    double



/// 시스템 라이프 상태 이넘
//                [ iOS ]                          [ Mac ]
//  ------------------------------------------------------------------
//  DidActive  - applicationDidBecomeActive:     - applicationDidBecomeActive:
//  WillSleep  - applicationWillResignActive:    - applicationWillResignActive:
//  DidSleep   - applicationDidEnterBackground:  - applicationDidResignActive:
//  WillActive - applicationWillEnterForeground: - applicationWillBecomeActive:
//  == iOS는 씬델리게이트가 있으면 아래만 친다 ==
//  WillShow   - sceneWillEnterForeground:       - applicationWillUnhide:
//  DidShow    - sceneDidBecomeActive:           - applicationDidUnhide:
//  WillHide   - sceneWillResignActive:          - applicationWillHide:
//  DidHide    - sceneDidEnterBackground:        - applicationDidHide:
//  == iOS 의 sceneDidEnterBackground 는 갑자기 날리면 안칠 수 있다 ==
//
typedef NS_ENUM(NSInteger, MGRSysLife) {
    MGRSysLifeDidSleep      = 0,
    MGRSysLifeWillSleep,
    MGRSysLifeWillActive,
    MGRSysLifeDidActive,
    MGRSysLifeWillShow,
    MGRSysLifeDidShow,
    MGRSysLifeWillHide,
    MGRSysLifeDidHide
};

#endif /* MGRSysType_h */
