//
//  MGRDispatchTimer.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
// ----------------------------------------------------------------------
//  VERSION_DATE    2020-10-08
// ----------------------------------------------------------------------
//

#ifndef MGRDispatchTimerHelper_h
#define MGRDispatchTimerHelper_h
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>   /* for CGFloat, CGMacro */

// 옵션 구조체
typedef struct MGRDispatchTimerConfig {
    NSTimeInterval start;       // 리줌 이후 시작까지 인터벌
    BOOL isStartWall;           // 시작시간을 절대시간으로 잡을 것인지 여부
    NSTimeInterval interval;    // 타이머가 반복해서 때릴 인터벌
    NSUInteger max;             // 타이머가 때릴 횟수. 0 이면 무한대.
} MGRDispatchTimerConfig;

// 옵션 구조체 제로
static MGRDispatchTimerConfig const MGRDispatchTimerConfigZero = {0,};

// 옵션 구조체 만들기
CG_INLINE MGRDispatchTimerConfig MGRDispatchTimerConfigMake(NSTimeInterval start, BOOL isStartWall, NSTimeInterval interval, NSUInteger max) {
    MGRDispatchTimerConfig cStruct = {start, isStartWall, interval, max};
    return cStruct;
}

NS_ASSUME_NONNULL_BEGIN

/// 디스패치 타이머 만들기
/// @discussion 리줌을 때려줘야 시작된다.
/// @discussion 모든 블락은 지정 queue 에서 동작한다.
/// @discussion (옵션) startedBlock 과 canceledBlock 은 1회만 동작한다.
/// @code
/// dispatch_resume(_timer);            // 리줌.
/// dispatch_suspend(_timer);           // 일시정지. 상태정보는 사용객체가 알아서.
/// dispatch_source_cancel(_timer);     // 취소.
/// dispatch_source_testcancel(_timer); // 0 이면 살아있음. Non-zero if canceled and zero if not canceled.
/// @endcode
dispatch_source_t
MGRDispatchTimerCreate(MGRDispatchTimerConfig config, dispatch_queue_t queue, dispatch_block_t workBlock, dispatch_block_t _Nullable startedBlock, dispatch_block_t _Nullable canceledBlock);

NS_ASSUME_NONNULL_END

#endif /* MGRDispatchTimer_h */
