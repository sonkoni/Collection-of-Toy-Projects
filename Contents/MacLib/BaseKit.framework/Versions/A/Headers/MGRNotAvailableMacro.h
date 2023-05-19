//
//  MGRNotAvailableMacro.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-11-08
//  ----------------------------------------------------------------------
//  애플에서 지원 안하는 notavailable 지원한다.
//

#ifndef MGRNotAvailableMacro_h
#define MGRNotAvailableMacro_h
#import <Foundation/Foundation.h>

// 그냥 이용 불가. 특정 메서드를 잠그는데, 메시지를 남길 수 있다.
// NS_UNAVAILABLE 은 단순히 잠그기만 한다.
//  + (instancetype)new MGR_UNAVAILABLE("new 메서드 이용불가.");
//
#define MGR_UNAVAILABLE(_cComment_)  __attribute__((unavailable(_cComment_)))


// 버전 처리 이용 불가.  다음 형태로 if 문 내부에서 사용한다.
//  if(MGR_NOT_AVAILABLE(iOS 13.0, *)) {
//      [self _legacy_hBWT:t iE:e];
//      return;
//  }
//
#define MGR_NOT_AVAILABLE(...)      @available(__VA_ARGS__)) { } else if(YES




#endif /* MGRNotAvailableMacro_h */


//  2021-11-08 : MGR_UNAVAILABLE 등록
//  2020-07-20 : MGR_NOT_AVAILABLE 등록
