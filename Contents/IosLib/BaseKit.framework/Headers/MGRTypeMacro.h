//
//  MGRTYPEMacro.h
//  BaseKit
//
//  Created by Kiro on 2023/01/16.
//

#ifndef MGRTypeMacro_h
#define MGRTypeMacro_h

// 타입에 컴마가 있을 때 UNPACK 한다
//   @property MGR_BIND(NSArray<NSString *> *, world);
//   @property MGR_BIND(MGRTYPE(NSDictionary<NSString *, NSString *> *), hello);
// 딕셔너리처럼 다중 제네릭으로 내부에 comma 가 들어가는 MGRTYPE 으로 한 번 싸준다.
#define MGRTYPE(...)     __VA_ARGS__

#endif /* MGRTypeMacro_h */


// 이렇게도 괄호로 언팩할 수 있게 매크로를 만들 수도 있다.
// 하지만 NSArray<NSString *> * 처럼 괄호가 필요없을 때에도 반드시 괄호를 써야 한다는 단점이 있다.
// #define UNPACK( ... ) __VA_ARGS__
// #define FOO( type, name ) UNPACK type name
//   @property (nonatomic) FOO((NSDictionary<NSString *, NSString *> *), koko);
//                              ================ 괄호필수 ===============

