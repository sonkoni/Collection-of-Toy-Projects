//
//  MGRResult.m
//  Created by Kiro on 2023/01/06.
//

#import "MGRResult.h"

@implementation MGRResult {
    id _data;
}
@dynamic state, value, error;
+ (instancetype)data:(id)data {
    return [[[self class] alloc] initWithData:data];
}
- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {_data = data;}
    return self;
}
- (MGRResultState)state {
    if (_data && ![_data isKindOfClass:[NSError class]]) {
        return MGRResultSuccess;
    }
    return MGRResultFailure;
}
- (id)value {
    if ([self state] == MGRResultSuccess) {return _data;}
    return nil;
}
- (NSError *)error {
    if ([self state] == MGRResultFailure) {
        return _data ? _data : [NSError errorWithDomain:@"Empty" code:0 userInfo:nil];
    }
    return nil;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _data];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p> %@", NSStringFromClass([self class]), self, _data];
}
#pragma mark - Equal
- (BOOL)isEqual:(id)item {
    if (item == self) {return YES;}
    if (![item isKindOfClass:[self class]] || !item) {return NO;}
    return [_data isEqual:((MGRResult *)item)->_data];
}
- (NSUInteger)hash {
    // NSUInteger half_bit_uint = CHAR_BIT * sizeof(NSUInteger) / 2;
    // return (NSUInteger)self ^ ([_data hash] << half_bit_uint | [_data hash] >> half_bit_uint);
    const NSUInteger prime = 31;
    return prime * [_data hash];
}
#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MGRResult *shallow = [[[self class] allocWithZone:zone] init];
    if (shallow) {
        shallow->_data = _data;
    }
    return shallow;
}
@end

// ----------------------------------------------------------------------
@implementation MGRResult (InState)
- (void)inSuccess:(void (NS_NOESCAPE ^)(id _Nonnull))successBlock {
    if ([self state] == MGRResultSuccess) {successBlock(_data);}
}
- (void)inFailure:(void (NS_NOESCAPE ^)(NSError * _Nonnull))failureBlock {
    if ([self state] == MGRResultFailure) {failureBlock(_data);}
}
- (void)inSuccess:(void (NS_NOESCAPE ^)(id _Nonnull))successBlock inFailure:(void (NS_NOESCAPE ^)(NSError * _Nonnull))failureBlock {
    if ([self state] == MGRResultSuccess) {successBlock(_data); return;}
    failureBlock(_data);
}
@end

// ----------------------------------------------------------------------
#import "MGRTagObject.h"
@implementation MGRResult (Mapper)
- (MGRTagObject *)tagObject {
    return [[MGRTagObject alloc] initWithTag:[self state] object:self->_data];
}
@end
