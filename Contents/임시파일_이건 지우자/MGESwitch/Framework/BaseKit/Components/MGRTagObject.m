//
//  MGRTagObject.m
//  Created by Kiro on 2022/12/09.
//

#import "MGRTagObject.h"

@implementation MGRTagObject
+ (instancetype)tag:(NSInteger)tag object:(id)object {
    return [[[self class] alloc] initWithTag:tag object:object];
}
- (instancetype)initWithTag:(NSInteger)tag object:(id)object {
    self = [super init];
    if (self) {
        _tag = tag;
        _object = object;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%ld : %@", _tag, _object];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p> %ld : %@", NSStringFromClass([self class]), self, _tag, _object];
}
#pragma mark - Equal
- (BOOL)isEqual:(id)item {
    if (item == self) {return YES;}
    if (![item isKindOfClass:[self class]] || !item) {return NO;}
    if (_tag != [(MGRTagObject *)item tag]) {return NO;}
    return [_object isEqual:[(MGRTagObject *)item object]];
}
- (NSUInteger)hash {
    const NSUInteger prime = 31;
    return prime * _tag + [_object hash];
}
#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MGRTagObject *shallow = [[[self class] allocWithZone:zone] init];
    if (shallow) {
        shallow->_tag = _tag;
        shallow->_object = _object;
    }
    return shallow;
}
@end



// ----------------------------------------------------------------------
#define DefaultTag      0
#define DefaultTo       100
@implementation MGRTagFuture {
    NSInteger _to;
}
@dynamic tag, object;
+ (instancetype)object:(id)object {
    return [[[self class] alloc] initWithTag:DefaultTag to:DefaultTo object:object];
}
+ (instancetype)tag:(NSInteger)tag to:(NSInteger)to object:(id)object {
    return [[[self class] alloc] initWithTag:tag to:to object:object];
}
- (instancetype)initWithTag:(NSInteger)tag to:(NSInteger)to object:(id)object {
    MGRTagObject *data = [[MGRTagObject alloc] initWithTag:tag object:object];
    self = [super initWithData:data];
    if (self) {_to = to;}
    if (to == tag) {[super setData:data];}
    return self;
}
- (void)setTag:(NSInteger)tag {
    MGRTagObject *current = [super data];
    if (tag == current.tag) {return;}
    if (_to == tag) {
        [super setData:[[MGRTagObject alloc] initWithTag:_to object:current.object]];
    } else {
        [super emit:[[MGRTagObject alloc] initWithTag:tag object:current.object]];
    }
}
- (void)setObject:(id)object {
    [super setData:[[MGRTagObject alloc] initWithTag:_to object:object]];
}
- (NSInteger)tag {
    return [[super data] tag];
}
- (id)object {
    return [[super data] object];
}
@end
