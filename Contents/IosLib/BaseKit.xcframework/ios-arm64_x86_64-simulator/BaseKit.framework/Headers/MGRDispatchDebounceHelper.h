//
//  MGRDispatchDebounceHelper.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
// ----------------------------------------------------------------------
//  VERSION_DATE    2023-02-01
// ----------------------------------------------------------------------
//  메인큐에서 디바운스를 구현한다. 백쓰레드 작업이라면 MGRPub 를 이용하는 것이 좋다.

#ifndef MGRDispatchDebounceHelper_h
#define MGRDispatchDebounceHelper_h
#import <Foundation/Foundation.h>

typedef void (^MGRDispatchDebounceBlock)(NSTimeInterval interval, dispatch_block_t next);
MGRDispatchDebounceBlock MGRDispatchDebounceMake(void);

#endif /* MGRDispatchDebounceHelper_h */


/*
 * 2023-02-01 : 대부분 메인쓰레드 동작일 것으므로 큐를 제거한다.
 * 2021-12-27
 */

// + 시리얼에서 작동하는 것을 가정했다. 그래서 내부에 락이 없다.
//   만약 쓰레드를 지정할 경우 디바운스의 경우 출력은 안전하지만 입력은 쓰레드 경쟁을 하게 된다. 따라서 입력이 시리얼이어야 한다.
//   범용으로 쓰기 위해 내부에 락을 설치하는 것도 고려해봤지만, 그럴 바에는 MGRPub 를 이용하는 것이 좋다.
//   MGRPub 에서 이 코드를 떼어낸 이유가, 간단히 단품으로 사용하기 위한 것이니까.
//
