//
//  MGRNotOverrideMacro.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-05-01
//  ----------------------------------------------------------------------
//  수퍼의 메서드를 호출할 수는 있지만 재정의를 금지시킨다.
//      원형클래스.h
//          - (void)hello MGR_NOT_OVERRIDE;
//      파생클래스.m
//          - (void)hello {...}  --->> 재정의 금지했으므로 컴파일 에러가 뜬다.
//

#ifndef MGRNotOverrideMacro_h
#define MGRNotOverrideMacro_h
#import <Foundation/Foundation.h>

#define MGR_NOT_OVERRIDE      __attribute__((objc_direct))

#endif /* MGRNotOverrideMacro_h */
