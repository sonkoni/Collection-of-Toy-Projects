//
//  MGRPub.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-07
//  ----------------------------------------------------------------------
//  값 전달 퍼블리셔. Thread-Safe 하다.
//

#define MGRPUB_DEBUG    0

#import <Foundation/Foundation.h>
#import <BaseKit/MGRProtocolType.h>
@class MGRPub, MGRPubToken;

NS_ASSUME_NONNULL_BEGIN
// 스트림 블락
typedef void (^MGRPubStreamBlock)(id _Nullable value);

// 프로토타입 블락
typedef MGRPubStreamBlock _Nonnull (^MGRPubPrototypeBlock)(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next);

// 큐 타입
typedef NS_ENUM(NSInteger, MGRPubQueue) {
    MGRPubQueueMain = 1,     // 메인큐
    MGRPubQueueHigh,         // 다급한 작업용
    MGRPubQueueLow,          // 여유있는 작업용
    MGRPubQueueBack          // 백그라운드 작업용
};

// 리시버 타입
@protocol MGRPubReceiving
- (dispatch_group_t _Nullable)group;    // 리시버의 line group 이며 finish 처리를 위해 심어진다.
- (dispatch_queue_t _Nullable)queue;    // 리시버의 line queue 이며 queueType 에 의해 결정된다.
- (void)setData:(id _Nullable)data;     // 센더가 리시버에 값을 넘긴다. 리시버는 자신의 stream 블락에 적절히 내린다.
- (void)setPub:(MGRPub * _Nullable)pub; // 리시버가 strong 으로 붙잡는 최종 센더이다. 리시버가 있으면 센더는 안 죽는다.
@end




// ----------------------------------------------------------------------
// Pub : 추상 클래스
// ----------------------------------------------------------------------
@interface MGRPub<__covariant ObjectType> : NSObject
+ (dispatch_queue_t)queue:(MGRPubQueue)queueType;
- (MGRPub * _Nullable)parent;
- (void)subscribe:(id<MGRPubReceiving>)listener;
- (void)unsubscribe:(id<MGRPubReceiving>)listener;
- (MGRPubQueue)queueType;
@end




// ----------------------------------------------------------------------
// Producer : 자료를 발송하는 지점
// ----------------------------------------------------------------------

// data 의 종류에 따라 Just 혹은 Fail 배출
//     [A]
//      └─ value/error - x
MGRPub * MGRPubOnce(id data);

// 단일값 배출 후 종료 : 성공값
//     [A]
//      └─ value - x
MGRPub * MGRPubJust(id value);
@interface MGRPub<ObjectType> (Just)
+ (MGRPub<ObjectType> *)just:(ObjectType)value;
@end

// 단일값 배출 후 종료 : 실패값
//     [A]
//      └─ error - x
MGRPub * MGRPubFail(NSError *error);
@interface MGRPub (Fail)
+ (MGRPub<NSError *> *)fail:(NSError *)error;
@end

// 단일값 배출 후 종료 : 미래 성공값/실패값. 종료 후 구독 시 마지막 값 준다.
//     [A]
//      └─ ─ ─ ─ value/error - x
// 주의: 결과를 보증하고 처리 시간이 길지 않은 미래값을 배출한다.
//      외부에서 토큰을 붙잡지 않아도 결과를 보증한다. 내부에서 토큰이 Strong 으로 잡힌다.
//      때문에 취소하고 싶으면 반환되는 토큰에 수동으로 cancel 해야 한다.
// 특별한 경우가 아니면 MGRFuture 클래스를 직접 이용하지 말고 MGRPubFuture 형식으로 사용하자.
// @data: 초기 이니셜라이징 값이 있을 수 있다. 하지만 setData: 통해 새 값이 들어오면 배출 후 종료한다.
// -emit: (!주의!)종료하지 않고 배출만 한다. 지속값 배출에 사용되므로, 완성 자료 배출은 setData: 를 이용하자.
typedef void (^MGRPubPromiseBlock)(id _Nullable value);
@interface MGRFuture<__covariant ObjectType> : MGRPub <ObjectType>
@property (nonatomic, nullable) id data;
+ (instancetype)data:(id)data;
- (instancetype)initWithData:(ObjectType)data;
- (void)emit:(id)value;
@end
MGRPub * MGRPubFuture(void (NS_NOESCAPE ^fulfill)(MGRPubPromiseBlock promise));
MGRPub * MGRPubFutureIn(MGRPubPromiseBlock _Nullable __strong * _Nonnull promise);
MGRPub * MGRPubOnFuture(MGRPubQueue queueType, void (NS_NOESCAPE ^fulfill)(MGRPubPromiseBlock promise));
@interface MGRPub<__covariant ObjectType> (Future)
// 직접 내부 블락에서 작업하여 promise 처리할 때
+ (MGRPub<ObjectType> *)future:(void (NS_NOESCAPE ^)(MGRPubPromiseBlock promise))fulfill;
// 외부 promise 블락을 심어서 핸들링할 때
+ (MGRPub<ObjectType> *)futureIn:(MGRPubPromiseBlock _Nullable __strong * _Nonnull)promise;
// 내부작업 큐 지정하여 내부 블락에서 promise 처리할 때
+ (MGRPub<ObjectType> *)on:(MGRPubQueue)queueType future:(void (NS_NOESCAPE ^)(MGRPubPromiseBlock promise))fulfill;
@end

// 단일값 배출 후 종료 : 배열을 순차적으로 쏟아붇는다.
//     [A]
//      └─ [0]-[1]-[2]-[3]-x
MGRPub * MGRPubSequence(NSArray *array);
@interface MGRPub<__covariant ObjectType> (Sequence)
typedef ObjectType _Nonnull (^MGRSeqRefineBlock)(NSUInteger idx, ObjectType value);
+ (MGRPub<ObjectType> *)sequence:(NSArray *)array;
+ (MGRPub<ObjectType> *)sequence:(NSArray *)array refine:(MGRSeqRefineBlock)refiner;
@end

// 여러 값을 Send 할 수 있다. 저장값 없음. 구독 다음 회차부터 값을 받는다.
// nil 이나 Error 를 전송하면 구독자이 끊긴다. 하지만 Pass 는 종료되지 않는다.
// 지속퍼블리셔로서, 리시버가 토큰을 저장하고 있을 때에만 다음 자료를 준다.
// 만약 토큰을 붙잡지 않아서 리시버가 dealloc 된다면 finish 를 때리지 않는다.
//     [A] - a - b - c - d ---
//           |   |   |   |
// Pass 는 자료를 저장하지 않는다. 구독 시 자료를 주지 않으며, 구독 다음에 Pass 가 자료를 받으면 그때 준다.
@interface MGRPubPass<__covariant ObjectType> : MGRPub <ObjectType>
- (void)send:(id _Nullable)data;
@end
@interface MGRPub<ObjectType> (Pass)
+ (MGRPubPass<ObjectType> *)pass;
@end

// 여러 값을 Send 할 수 있다. 저장값 있음. 구독 시점부터 값을 받는다.
// nil 이나 Error 를 전송하면 구독자이 끊긴다. 하지만 Post 는 종료되지 않는다.
// 지속퍼블리셔로서, 리시버가 토큰을 저장하고 있을 때에만 다음 자료를 준다.
// 만약 토큰을 붙잡지 않아서 리시버가 dealloc 된다면 finish 를 때리지 않는다.
//     [A] - a - b - c - d ---
//           |   |   |   |
// Post는 자료를 저장한다.
// - Post 는 이니셜 자료가 nil 일 경우 구독을 해도 첫 값을 주지 않는다.
// - send에 nil을 전송하면 data에 저장되지 않으며, 기존 구독자를 finish 하고 끊는다.
// - send에 err을 전송하면 data에 저장되며, 기존 구독자에게 error 를 보내고 끊는다.
@interface MGRPubPost<__covariant ObjectType> : MGRPub <ObjectType>
@property (nonatomic, readonly, nullable) id data;
- (instancetype)initWithData:(id)data;
- (void)send:(id _Nullable)data;
@end
@interface MGRPub<ObjectType> (Post)
+ (MGRPubPost<ObjectType> *)post;
+ (MGRPubPost<ObjectType> *)post:(id)data;
@end

// 여러 상태 전송. update 를 통해 객체를 받아 전송한다.
// 지속퍼블리셔로서, 리시버가 토큰을 저장하고 있을 때에만 다음 자료를 준다.
// 만약 토큰을 붙잡지 않아서 리시버가 dealloc 된다면 finish 를 때리지 않는다.
//     [A] - a - b - c - d ---
//           |   |   |   |
// 업데이트 블락으로 copy 된 객체를 인자로 준다.
// 작업해서 반환하면 업데이트 되고, nil 이면 업데이트 되지 않고 버린다.
// 업데이트 블락은 락이 걸리므로 단순 할당 작업이나 동일비교 작업 등 빠르게 처리되는 작업만 해라.
@interface MGRPubState<__covariant ObjectType> : MGRPub <ObjectType>
typedef ObjectType _Nullable (^MGRPubUpdateBlock)(ObjectType copied);
@property (nonatomic, readonly) ObjectType value;
+ (instancetype)state:(id<NSCopying>)data;
- (void)update:(NS_NOESCAPE MGRPubUpdateBlock)updateBlock;
@end


// 상위 퍼브를 집적시켜 하위 파이프로 분배한다.
//     [A] [B] [C]   a를 [A][B][C]에 연결, b를 [A][B][C]에 연결, c를 [A][B][C]에 연결
//      └───┼───┘    이렇게 하위에 상위를 각각 연결해주는 Cold 중개자이다.
//        [Hub]      단독으로는 안 쓰이고, merge 나 tie 등 다중 연결 파이프에서 사용한다.
//      ┌───┼───┐    - [A][B][C]하나라도 error 를 받으면 해당 라인이 종료한다.
//     [a] [b] [c]   - [A][B][C] 모두 완료되어야 해당 라인이 종료한다.
@interface MGRPubHub : MGRPub
- (instancetype)initWithPubs:(NSArray<MGRPub *> *)pubs;
- (void)setPrototype:(MGRPubStreamBlock (^)(NSUInteger count, NSArray *storage, MGRPubStreamBlock next))prototype;
@end




// ----------------------------------------------------------------------
// Receiver: 자료를 받는 지점
// ----------------------------------------------------------------------

// 리졸버 : 퍼브 내부의 퍼브를 풀어내는 스트림 블락 생산
MGRPubStreamBlock MGRPubResolver(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next);

// 허브 토큰 오브젝트 : 허브에 담기는 이중 자료구조
@interface MGRPubHubTokenObject<__covariant ObjectType> : NSObject <MGRCancellable>
@property (nonatomic, nullable) MGRPubToken *token;
@property (nonatomic, nullable) ObjectType object;
- (instancetype)initWith:(MGRPubToken *)token;
- (void)cancel; // token 만 제거하며 object 는 살린다.
@end

@interface MGRPubHubUnit<__covariant ObjectType> : NSObject
@property (nonatomic, weak) MGRPubToken *token;
@property (nonatomic) NSMutableArray<MGRPubHubTokenObject<ObjectType> *> *storage;
@end

// 공유 리시버: Share 파이프에서 사용하는 퍼브 겸용 토큰
@interface MGRPubShare : MGRPub <MGRPubReceiving>
@property (nonatomic, nullable) MGRPub *pub;
@property (nonatomic) MGRPubStreamBlock stream;
@property (nonatomic) dispatch_queue_t queue;
- (instancetype)initFrom:(MGRPub *)pub queue:(dispatch_queue_t)queue;
@end

// 일반 리시버: 퍼브 구독의 필수이며 스트림 리소스를 담고 있다.
@interface MGRPubToken : NSObject <MGRPubReceiving, MGRCancellable>
@property (nonatomic, nullable) dispatch_group_t group;
@property (nonatomic, nullable) MGRPub *pub;
@property (nonatomic) MGRPubStreamBlock stream;
@property (nonatomic) MGRPubQueue queueType;
@property (nonatomic, readonly) dispatch_queue_t queue;
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group;
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t)queue;
- (void)setData:(id _Nullable)data;
- (void)cancel;
@end

// 이너 리시버: 내부에서 연결되는 토큰
@interface MGRPubInnerToken : MGRPubToken
@property (nonatomic, weak) NSMutableSet *storage;
@end

// 허브 리시버: 허브 사용하는 토큰
@interface MGRPubHubToken : MGRPubToken
@property (nonatomic, weak) NSMutableArray<MGRPubHubTokenObject *> *storage;
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t _Nullable)queue at:(NSUInteger)idx;
@end

// 최종 사용자에게 제공되는 토큰
@interface MGRPubTicket : MGRPubToken
@property (nonatomic, weak) NSMutableSet *storage;
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group type:(MGRPubQueue)queueType;
- (void (^)(id _Nullable __strong * _Nullable))storeIn;
@end

// 이너퍼브 커넥터
@interface MGRPub<ObjectType> (Inner)
// 일반적 이너퍼브. nil/fail 일 때 종료, next 스트림으로 success/fail 만 넘긴다.
- (void)inner:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t _Nullable)queue storage:(NSMutableSet *)storage next:(MGRPubStreamBlock)next;
// 허브 이너퍼브. nil/fail 일 때 종료. process 스트림으로 nil/success/fail 모두 넘긴다.
// 해당 인덱스에 대한 종료 처리는 이미 하고 넘어가기 때문에 process 에서는 값 핸들링만 하면 된다.
- (void)inner:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t _Nullable)queue storage:(NSMutableArray *)storage at:(NSUInteger)idx process:(MGRPubStreamBlock)process;
@end



// 스트림 끝단: 이 지점에서 티켓이 만들어지며, 상위로 거슬러 올라가 파이프를 누적해 반환된다.
@interface MGRPub<ObjectType> (Sink)
typedef void (^MGRPubSuccessBlock)(ObjectType value);
typedef void (^MGRPubFailureBlock)(NSError *error);
typedef void (^MGRPubFinishBlock)(void);
// 내려받기. 성공값.
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success;
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success;
// 내려받기. 성공을 받으며 종료는 항상 메인큐에서 실행된다.
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success finish:(MGRPubFinishBlock)finish;
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success finish:(MGRPubFinishBlock)finish;
// 내려받기. 성공과 실패를 받는다.
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure;
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure;
// 내려받기. 성공을 받으며 실패와 종료도 받을 수 있다. 종료는 항상 메인큐에서 실행된다.
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure finish:(MGRPubFinishBlock)finish;
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure finish:(MGRPubFinishBlock)finish;
@end

// 스트림 끝단: 이 지점에서 티켓이 만들어지며, 상위로 거슬러 올라가 파이프를 누적해 반환된다.
@interface MGRPub<ObjectType> (Assign)
// 할당하기. 성공값. ticket을 cancel 하거나 owner 가 nil 이면 종료한다.
- (MGRPubTicket *)mainAssign:(id)owner keypath:(NSString *)keypath;
- (MGRPubTicket *)mainAssign:(id)owner keypath:(NSString *)keypath finish:(MGRPubFinishBlock)finish;;
- (MGRPubTicket *)mainAssign:(id)owner selector:(SEL)selector;
- (MGRPubTicket *)mainAssign:(id)owner selector:(SEL)selector finish:(MGRPubFinishBlock)finish;;
@end




// ----------------------------------------------------------------------
// Pipe: 자료를 연결하는 지점
// ----------------------------------------------------------------------

// 파이프
@interface MGRPubPipe<__covariant ObjectType> : MGRPub
@property (nonatomic, nullable) MGRPub *parent;
@property (nonatomic) MGRPubPrototypeBlock prototype;
- (instancetype)initFrom:(MGRPub *)pub;
@end

// 파이프허브: 상위의 여러 라인과 하위 라인을 연결한다. merge, tie 등 멀티 리시브 계열 파이프에서 사용함.
@interface MGRPubPipeHub<__covariant ObjectType> : MGRPubPipe
- (instancetype)initFrom:(MGRPub *)pub NS_UNAVAILABLE;
@end

// 파이브라인: 라인 큐를 지정할 수 있다. line 파이프에서 사용함.
@interface MGRPubPipeLine<__covariant ObjectType> : MGRPubPipe
@property (nonatomic) MGRPubQueue queueType;
@end



// 상위 파이프를 집적시켜 여러 파이프로 분배한다.
//         [A]
//          │       받은 결과값을 하위에 공유한다.
//        [Hub]     모든 파이프가 Cold 형식으로 매번 호출되지만
//      ┌───┼───┐   쉐어는 Hot 형식으로 [B][C][D] 에게 같은 데이터를 공유한다.
//     [B] [C] [D]
@interface MGRPub<ObjectType> (Share)
- (MGRPub<ObjectType> *)share;
@end


// 라인의 큐를 지정한다.
//         [Producer]
//     ┌───────┴───────┐     ┐
//  [*line*]        [line]   ├ 라인 전체가 하나의 큐로 직렬화된다.
//   [Pipe]         [Pipe]   │ 마지막에 지정된 라인큐가 전체 라인큐가 된다.
//   [Pipe]        [*line*]  │ 라인큐를 하나도 지정하지 않으면
//     │               │     ┘ sender 의 쓰레드에서 처리되어 리시버가 메인큐로 받게 된다.
// [Receiver]      [Receiver]
@interface MGRPub<ObjectType> (Line)
- (MGRPub<ObjectType> *)line:(MGRPubQueue)type;
@end


// 받은 값을 특정 형태로 변환하여 다음 스트림으로 내린다.
//     [A]-- a -- b -- c -- d --
//           |    |    |    |
// map     [a'] [b'] [c'] [d']
@interface MGRPub<ObjectType> (Map)
typedef id _Nonnull (^MGRPubMapBlock)(ObjectType value);
typedef NSError * _Nonnull (^MGRPubMapErrorBlock)(NSError *error);
// 성공값을 입력받아 다른 성공실패값으로 변환하여 발행
- (MGRPub *)map:(MGRPubMapBlock)mapBlock;
// 실패값을 입력받아 다른 실패값으로 변환하여 발행(에러의 형태를 조정할 때 사용)
- (MGRPub<NSError *> *)mapError:(MGRPubMapErrorBlock)mapBlock;
@end


// 블락을 통과시켜 YES 이면 발행. NO 면 발행하지 않는다.
//     [A]-- a -- b -- c -- d --
//           |    |    |    |YES
// filter                  (d)
@interface MGRPub<ObjectType> (Filter)
typedef BOOL (^MGRPubFilterBlock)(ObjectType value);
- (MGRPub<ObjectType> *)filter:(MGRPubFilterBlock)filterBlock;
@end


// 특정 범위만 발행 후 종료한다.
//     [A]-- a -- b -- c --<d>fin
//           |    |    |      |
// atLast                    (d)
@interface MGRPub<ObjectType> (At)
// 첫 입력만 배출하고 종료하기
- (MGRPub<ObjectType> *)atFirst;
// 제일 마지막 값만 배출하고 종료하기
- (MGRPub<ObjectType> *)atLast;
@end


// 받은 갯수를 발행하고 종료한다.
//     [A]-- a -- b -- c -- d -- <e>fin
//           |    |    |    |      |
// count                          (5)
@interface MGRPub<ObjectType> (Count)
- (MGRPub<NSNumber *> *)count;
@end


// 거부하다가 어느 조건 이후로 계속 수락한다.
//    [A]-- a -- b -- c -- d -- e
//          |    |    |    |    |
// drop:2            (c)  (d)  (e)
@interface MGRPub<ObjectType> (Drop)
// 첫 값만 무시하고 이후 계속 받기
- (MGRPub<ObjectType> *)dropFirst;
// count 까지 무시한 이후 계속 받기
- (MGRPub<ObjectType> *)drop:(NSUInteger)count;
@end


// 수락하다가 어느 조건에서 계속 거부한다.
//     [A]-- a -- b -- c -- d -- e
//           |    |    |    |    |
// take:3   (a)  (b)  (c)
@interface MGRPub<ObjectType> (Take)
// 첫 값만 취하고 종료하기
- (MGRPub<ObjectType> *)takeFirst;
// count 까지만 취하고 종료하기
- (MGRPub<ObjectType> *)take:(NSUInteger)count;
@end


// 지정된 시간만큼 기다렸다가 처리한다
//     [A] -- a --- b --- c -- d -- e
//            └──┐  └──┐  └──┐
// delay:3    ...(a)...(b)...(c)
@interface MGRPub<ObjectType> (Delay)
// 입력 이벤트 이후 지정된 시긴만큼 늦췄다가 모두 차례로 발행한다.
- (MGRPub<ObjectType> *)delay:(NSTimeInterval)interval;
// 입력 이벤트 이후 지정된 시간만큼 기다렸다가 다른 입력이 없으면 배출한다.
- (MGRPub<ObjectType> *)debounce:(NSTimeInterval)interval;
// 입력 이벤트 이후 지정된 시간동안 늦췄다가 시간 내의 다른 이벤트 값은 무시하고 첫 이벤트 값만 배출한다.
- (MGRPub<ObjectType> *)throttle:(NSTimeInterval)interval;
@end


// 퍼블리셔들을 묶어 함께 발행한다. 각 이벤트마다 발행된다..
//    [A]-- a --------b--------c----d---
//    [B]-------1---------2-------------
//          |   |     |   |    |    |
//         (a) (1)   (b) (2)  (c)  (d)
@interface MGRPub<ObjectType> (Merge)
+ (MGRPub *)merge:(NSArray<MGRPub *> *)pubs;
- (MGRPub *)merge:(NSArray<MGRPub *> *)pubs;
@end


// 퍼블리셔들을 묶어 함께 각 이벤트마다 Late 로 발행한다.
// 여기서 a 이벤트는 발행되지 않는다. 짝이 안 맞으므로.
//    [A]-- a --------------------b---
//    [B]------- 2 ----- 3 -----------
//               |       |        |
//             (a,2)   (a,3)    (b,3)
@interface MGRPub<ObjectType> (Tie)
+ (MGRPub<NSArray *> *)tie:(NSArray<MGRPub *> *)pubs;
- (MGRPub<NSArray *> *)tie:(NSArray<MGRPub *> *)pubs;
@end


// 퍼블리셔들 결과들을 짝에 맞춰 순서대로 묶어 발행한다.
// 여기서 a 이벤트는 발행되지 않는다. 왜냐면 A와 B의 인덱스 짝이 안 맞으므로.
// 여기서 1 이벤트는 발행된다. 왜냐면 A와 B의 인덱스 짝이 맞으므로.
//    [A]----a----b----------c-------d--
//    [B]------1-----2---3-------4-----
//             |     |       |       |
//           (a,1) (b,2)   (c,3)   (d,4)
// 이 파이프는 짝이 안 맞을 경우 한쪽에 데이터가 엄청 쌓일 염려가 있으므로 좀 위험하다.
// 가능하면 take 와 함께 사용하여 받을 데이터 갯수를 정하길 권장한다.
@interface MGRPub<ObjectType> (Zip)
+ (MGRPub<NSArray *> *)zip:(NSArray<MGRPub *> *)pubs;
- (MGRPub<NSArray *> *)zip:(NSArray<MGRPub *> *)pubs;
@end

NS_ASSUME_NONNULL_END
