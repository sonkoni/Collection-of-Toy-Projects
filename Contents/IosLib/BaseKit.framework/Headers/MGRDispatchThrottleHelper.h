//
//  MGRDispatchThrottleHelper.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
// ----------------------------------------------------------------------
//  VERSION_DATE    2023-02-01
// ----------------------------------------------------------------------
//  메인큐에서 쓰로틀을 구현한다. 백쓰레드 작업이라면 MGRPub 를 이용하는 것이 좋다.

#ifndef MGRDispatchThrottleHelper_h
#define MGRDispatchThrottleHelper_h
#import <Foundation/Foundation.h>

typedef void (^MGRDispatchThrottleBlock)(NSTimeInterval interval, dispatch_block_t next);
MGRDispatchThrottleBlock MGRDispatchThrottleMake(void);

#endif /* MGRDispatchThrottleHelper_h */


/*
 * 2023-02-01 : 대부분 메인쓰레드 동작일 것으므로 큐를 제거한다.
 * 2021-12-27
 */

// + 시리얼에서 작동하는 것을 가정했다. 그래서 내부에 락이 없다.
//   만약 쓰레드를 지정할 경우 쓰로틍의 경우 입출력은 모두 쓰레드 경쟁을 하게 된다. 따라서 입출력이 시리얼이어야 한다.
//   범용으로 쓰기 위해 내부에 락을 설치하는 것도 고려해봤지만, 그럴 바에는 MGRPub 를 이용하는 것이 좋다.
//   MGRPub 에서 이 코드를 떼어낸 이유가, 간단히 단품으로 사용하기 위한 것이니까.
//
