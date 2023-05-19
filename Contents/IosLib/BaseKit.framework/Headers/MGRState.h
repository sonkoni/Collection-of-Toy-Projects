//
//  MGRState.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-02-15
//  ----------------------------------------------------------------------
//  성태 전달 퍼블리셔. Thread-Safe 하다.
//  일반 MGRPubPost 로도 상태 전달이 충분하지만, update 가 불편해서 전체를 새로 조직했다.
//  상태 컨테이터로부터 내려받은 state 객체에 대해 .value 로 값을 넣으면 중앙 상태가 업데이트 된다.
//

#import <BaseKit/MGRPub.h>
#import <BaseKit/MGRKeyObject.h>

@class MGRStatus;

NS_ASSUME_NONNULL_BEGIN
/// 상태 클라이언트 개별: 호스트의 다이나믹 프로퍼티 1개를 래핑.
//  - 밸류 게터 =>  id value = state.value;
//  - 밸류 세터 =>  state.value = 값
@interface MGRState<__covariant ObjectType> : MGRPub <ObjectType>
@property (nonatomic) ObjectType value;
- (instancetype)initFromKeyed:(MGRKeyObject<NSString*,MGRStatus*> *)keyed;
@end

/// 상태 클라이언트 그룹: 여러 개의 개별 상태를 래핑. (배열 자료순 == 이니셜 상태순)
//  배열 형 세터게터 및 서브스크립팅 지원
//  - 밸류 게터 =>  id value = states[인덱스];
//  - 밸류 세터 =>  states[인덱스] = 값;
@interface MGRStates : MGRPub <NSArray *>
@property (nonatomic) NSArray *value;
+ (instancetype)states:(NSArray<MGRState*> *)states;
- (MGRState *)state:(NSUInteger)idx; // 새 상태객체 반환
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (id)objectAtIndex:(NSUInteger)index;
- (void)setObject:(id)anObject atIndex:(NSUInteger)index;
@end

/// 상태 호스트: 다이나믹 프로퍼티를 제공하는 상태 컨테이너. 상태 객체를 반환한다.
//  딕셔너리 형 세터게터 및 서브스크립팅 지원
@interface MGRStatus : MGRPub <NSDictionary *>
@property (nonatomic) NSDictionary *value;
- (MGRState *)state:(NSString *)key; // 새 상태객체 반환
- (nullable id)objectForKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)setObject:(nullable id)obj forKeyedSubscript:(NSString *)key;
- (nullable id)objectForKeyedSubscript:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
