//
//  MGRTimer.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-03
// ----------------------------------------------------------------------
//  디스패치 타이머 래퍼
//    - 일시정지 상태로 만들어지며, resume 을 때려야 가동된다.
//

#import <BaseKit/MGRDispatchTimerHelper.h>

NS_ASSUME_NONNULL_BEGIN
@interface MGRTimer : NSObject
/// 타이머. 메인큐에서 작업.
+ (instancetype)timerInterval:(NSTimeInterval)dueTime work:(dispatch_block_t)workBlock;
/// 타이머. 지정큐에서 작업.
+ (instancetype)timerInterval:(NSTimeInterval)dueTime on:(dispatch_queue_t)queue work:(dispatch_block_t)workBlock;
/// 타이머. 지정큐에서 작업. max 가 0 이면 무한대.
+ (instancetype)timerStart:(NSTimeInterval)start interval:(NSTimeInterval)dueTime max:(NSUInteger)max on:(dispatch_queue_t)queue
                      work:(dispatch_block_t)workBlock started:(dispatch_block_t _Nullable)startedBlock canceled:(dispatch_block_t)canceledBlock;
/// 타이머. 절대시간 이후 실행. 지정큐에서 작업. max 가 0 이면 무한대.
+ (instancetype)timerStartWall:(NSTimeInterval)start interval:(NSTimeInterval)dueTime max:(NSUInteger)max on:(dispatch_queue_t)queue
                          work:(dispatch_block_t)workBlock started:(dispatch_block_t _Nullable)startedBlock canceled:(dispatch_block_t _Nullable)canceledBlock;
#if (TARGET_OS_OSX || TARGET_OS_IPHONE)
// 앱 라이프에 따라 앱 동작 일시중지/재개 반복
@property (nonatomic, assign) BOOL isSyncAppLife; // 기본값 NO. 만약 set 으로 YES 를 해버리면 setAppSyncToActive 로 설정됨.
- (void)setAppSyncToActive; // Sleep:WillResignActive, Wake:DidBecomeActive
- (void)setAppSyncToHide;   // Sleep:WillHide(DidEnterBackground), Wake:WillUnhide(WillEnterForeground)
- (void)setAppSyncToSleep:(NSNotificationName)sleepName wake:(NSNotificationName)wakeName;
#endif
@property (nonatomic, nullable) dispatch_source_t timerCore;
- (BOOL)isInitiated;    // 이니셜라이징 되어 한 번도 실행한 적이 없는지
- (BOOL)isRuning;       // 현재 진행상태인지
// 내부에서 체크하고 있기 때문에 사용할 때 상태를 체크하지 않고 바로 때려 써도 안전하다.
- (void)resume;  // 타이머 가동
- (void)pause;   // 타이머 일시정지   -> 그냥 일시정지.   다시 resume 할 수 있다.
- (void)cancel;  // 타이머 취소      -> 모든 리소스 제거. 다시 resume 할 수 없다.
// SyncAppLife : 잠자기와 깨어날 때 때려진다.
- (void)sleep NS_REQUIRES_SUPER;
- (void)wake NS_REQUIRES_SUPER;
@end
NS_ASSUME_NONNULL_END

/*  ----------------------------------------------------------------------
 *  2023-01-03      : timerCore 를 밖으로 빼고 재사용할 수 있도록 함
 *  2022-01-14      : SyncAppLife 로 변경. 다양성 확보.
 *  2022-01-08      : SyncAppActive 안정성 개선
 *  2022-01-03      : pause, resume, dealloc 안정성 개선
 *  2020-10-22      : 액티브 버그 수정
 *  2020-04-24      : 생성
 *
 */
