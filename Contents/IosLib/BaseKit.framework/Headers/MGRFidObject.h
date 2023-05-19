//
//  MGRFidObject.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-05
//  ----------------------------------------------------------------------
//  Progress 나 Degree 등에서 활용할 수 있도록 double 값과 객체를 함께 담은 래퍼
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface MGRFidObject<__covariant ObjectType> : NSObject <NSCopying>
@property (nonatomic, readonly) double fid;
@property (nonatomic, readonly, nullable) ObjectType object;
+ (instancetype)fid:(double)fid object:(ObjectType _Nullable)object;
- (instancetype)initWithFid:(double)fid object:(ObjectType _Nullable)object;
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
// * fid 초기값 0.0 이다. to 이상의 값을 주면 최종값을 주고 종료한다.
// * to 초기값 1.0 이다. 초기화 단계에서 할당하며 수정할 수 없다.
@interface MGRFidFuture<__covariant ObjectType> : MGRFuturistic <MGRFidObject<ObjectType> *>
@property (nonatomic) double fid;
@property (nonatomic, nullable) ObjectType object;
+ (instancetype)object:(ObjectType _Nullable)object;
+ (instancetype)fid:(double)fid to:(double)to object:(ObjectType _Nullable)object;
- (instancetype)initWithFid:(double)fid to:(double)to object:(ObjectType _Nullable)object;
@end
NS_ASSUME_NONNULL_END
