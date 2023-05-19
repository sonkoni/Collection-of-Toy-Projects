//
//  MGRKeyObject.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-09
//  ----------------------------------------------------------------------
//  딕셔너리의 key:value 에 대응한다.
//  보통 해당 값에 대한 딕셔너리 키에 해당하는 객체를 함께 넘길 때 사용한다.
//  키는 identifier 나 UUID 처럼 유니크한 값을 가져야 한다.
//  object 가 nullable 로 선언되어 있지만, 기본적으로 있어야 하며, 특별한 경우에만 nil 을 전달한다.
//  즉, 제거의 의미로 object 에 nil 이 전달할 수 있다.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface MGRKeyObject<__covariant KeyType, __covariant ObjectType> : NSObject <NSCopying>
@property (nonatomic, readonly) KeyType key;
@property (nonatomic, readonly, nullable) ObjectType object;
+ (instancetype)key:(KeyType)key object:(ObjectType _Nullable)object;
- (instancetype)initWithKey:(KeyType)key object:(ObjectType _Nullable)object;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END


#import <BaseKit/MGRPub.h>
NS_ASSUME_NONNULL_BEGIN
// 작업 시간이 오래 걸리지 않고 확실하게 결과가 보증되는 원거리 미래값
// --------------------------------------------------------
//           MGRKeyFuture     MGRTagFuture     MGRFidFuture
// --------------------------------------------------------
// 완료       setObject:       setObject:       setObject:
// 배출       setKey:          setTag:          setFid:
// 기본범위    @(0) ~ @(100)    0 ~ 100          0.0 ~ 1.0
// 완료조건    isEqual          ==               <= EPSILON
//           to 완전일치값      to 완전일치값       to 이상의 값
// --------------------------------------------------------
// * key 초기값 @(0) 이다. to 와 isEqual 비교를 통해 동일하면 최종값을 주고 종료한다.
// * to 초기값 @(100) 이다. 초기화 단계에서 할당하며 수정할 수 없다.
@interface MGRKeyFuture<__covariant KeyType, __covariant ObjectType> : MGRFuturistic <MGRKeyObject<KeyType, ObjectType> *>
@property (nonatomic) KeyType key;
@property (nonatomic, nullable) ObjectType object;
+ (instancetype)object:(ObjectType _Nullable)object;
+ (instancetype)key:(KeyType)key to:(KeyType)to object:(ObjectType _Nullable)object;
- (instancetype)initWithKey:(KeyType)key to:(KeyType)to object:(ObjectType _Nullable)object;
@end
NS_ASSUME_NONNULL_END
