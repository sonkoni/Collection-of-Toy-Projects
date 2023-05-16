//
//  MGRResult.h
// ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-06
// ----------------------------------------------------------------------
//  성공/실패 타입을 가지고 있는 객체 래퍼
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MGRResultState) {
    MGRResultFailure    = 0,  //  data 가 nil 이거나 NSError 일 때
    MGRResultSuccess    = 1,  //  data 가 일반값일 때
};

NS_ASSUME_NONNULL_BEGIN
@interface MGRResult<__covariant SuccessType> : NSObject <NSCopying>
@property (nonatomic, readonly) MGRResultState state;
@property (nonatomic, readonly, nullable) SuccessType value;  // 성공타입이면 값을 반환. 만약 실패타입이면 nil 이다.
@property (nonatomic, readonly, nullable) NSError *error;     // 실패타입이면 에러 반환. 만약 성공타입이면 nil 이다.
+ (instancetype)data:(id _Nullable)data;
- (instancetype)initWithData:(id _Nullable)data;
@end

@interface MGRResult<__covariant SuccessType> (InState)
- (void)inSuccess:(void(NS_NOESCAPE ^)(SuccessType value))successBlock;          // 성공타입일 때에만 실행
- (void)inFailure:(void(NS_NOESCAPE ^)(NSError * _Nullable error))failureBlock;  // 실패티입일 때에만 실행. 실제 data 가 nil 이면 nil 을 준다.
- (void)inSuccess:(void(NS_NOESCAPE ^)(SuccessType value))successBlock inFailure:(void(NS_NOESCAPE ^)(NSError * _Nullable error))failureBlock;
@end

@class MGRTagObject;
@interface MGRResult (Mapper)
- (MGRTagObject *)tagObject;
@end
NS_ASSUME_NONNULL_END


/*  ----------------------------------------------------------------------
 *  2023-01-06      : 정리
 *  2021-05-13      : 생성
 *
 */
