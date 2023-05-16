//
//  MGRFidObject.m
//  BaseKit
//
//  Created by Kiro on 2023/01/06.
//

#import "MGRFidObject.h"

@implementation MGRFidObject
+ (instancetype)fid:(double)fid object:(id)object {
    return [[[self class] alloc] initWithFid:fid object:object];
}
- (instancetype)initWithFid:(double)fid object:(id)object {
    self = [super init];
    if (self) {
        _fid = fid;
        _object = object;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%.6f : %@", _fid, _object];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p> %.6f : %@", NSStringFromClass([self class]), self, _fid, _object];
}
#pragma mark - Equal
- (BOOL)isEqual:(id)item {
    if (item == self) {return YES;}
    if (![item isKindOfClass:[self class]] || !item) {return NO;}
    if (fabs(_fid - [(MGRFidObject *)item fid]) > FLT_EPSILON) {return NO;}
    return [_object isEqual:[(MGRFidObject *)item object]];
}
- (NSUInteger)hash {
    const NSUInteger prime = 31;
    return _fid + floor((_fid - floor(_fid)) * pow(10, FLT_DIG)) + prime + [_object hash];
}
#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MGRFidObject *shallow = [[[self class] allocWithZone:zone] init];
    if (shallow) {
        shallow->_fid = _fid;
        shallow->_object = _object;
    }
    return shallow;
}
@end



// ----------------------------------------------------------------------
#define DefaultFid      0.0
#define DefaultTo       1.0
@implementation MGRFidFuture {
    double _to;
}
@dynamic fid, object;
+ (instancetype)object:(id)object {
    return [[[self class] alloc] initWithFid:DefaultFid to:DefaultTo object:object];
}
+ (instancetype)fid:(double)fid to:(double)to object:(id)object {
    return [[[self class] alloc] initWithFid:fid to:to object:object];
}
- (instancetype)initWithFid:(double)fid to:(double)to object:(id)object {
    BOOL isGreaterEqual = ((to < fid) || (fabs(to - fid) <= FLT_EPSILON));
    MGRFidObject *data = [[MGRFidObject alloc] initWithFid:(isGreaterEqual ? to : fid) object:object];
    self = [super initWithData:data];
    if (self) {_to = to;}
    if (isGreaterEqual) {[super setData:data];}
    return self;
}
- (void)setFid:(double)fid {
    MGRFidObject *current = [super data];
    if (fabs(current.fid - fid) <= FLT_EPSILON) {return;}
    if ((_to < fid) || (fabs(_to - fid) <= FLT_EPSILON)) {
        [super setData:[[MGRFidObject alloc] initWithFid:_to object:current.object]];
    } else {
        [super emit:[[MGRFidObject alloc] initWithFid:fid object:current.object]];
    }
}
- (void)setObject:(id)object {
    [super setData:[[MGRFidObject alloc] initWithFid:_to object:object]];
}
- (double)fid {
    return [[super data] fid];
}
- (id)object {
    return [[super data] object];
}
@end
