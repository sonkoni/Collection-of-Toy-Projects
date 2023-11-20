//
//  MGRWeakObject.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-09
//  ----------------------------------------------------------------------
//  object weak 처리를 위한 래퍼
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRWeakObject<__covariant ObjectType> : NSObject <NSCopying>
@property (nonatomic, weak) ObjectType object;
+ (instancetype)object:(ObjectType _Nullable)object;
- (instancetype)initWithObject:(ObjectType _Nullable)object;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
