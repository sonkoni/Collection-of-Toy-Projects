//
//  MGRKeyObject.m
//  Created by Kiro on 2022/12/09.
//

#import "MGRKeyObject.h"

@implementation MGRKeyObject
+ (instancetype)key:(id)key object:(id)object {
    return [[[self class] alloc] initWithKey:key object:object];
}
- (instancetype)initWithKey:(id)key object:(id)object {
    self = [super init];
    if (self) {
        _key = key;
        _object = object;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", _key, _object];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p> %@ : %@", NSStringFromClass([self class]), self, _key, _object];
}
#pragma mark - Equal
- (BOOL)isEqual:(id)item {
    if (item == self) {return YES;}
    if (![item isKindOfClass:[self class]] || !item) {return NO;}
    return ([_key isEqual:[(MGRKeyObject *)item key]] && [_object isEqual:[(MGRKeyObject *)item object]]);
}
- (NSUInteger)hash {
    const NSUInteger prime = 31;
    return prime * [_key hash] + [_object hash];
}
#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MGRKeyObject *shallow = [[[self class] allocWithZone:zone] init];
    if (shallow) {
        shallow->_key = _key;
        shallow->_object = _object;
    }
    return shallow;
}
@end



// ----------------------------------------------------------------------
#define DefaultKey      @(0)
#define DefaultTo       @(100)
@implementation MGRKeyFuture {
    id _to;
}
@dynamic key, object;
+ (instancetype)object:(id)object {
    return [[[self class] alloc] initWithKey:DefaultKey to:DefaultTo object:object];
}
+ (instancetype)key:(id)key to:(id)to object:(id)object {
    return [[[self class] alloc] initWithKey:key to:to object:object];
}
- (instancetype)initWithKey:(id)key to:(id)to object:(id)object {
    MGRKeyObject *data = [[MGRKeyObject alloc] initWithKey:key object:object];
    self = [super initWithData:data];
    if (self) {_to = to;}
    if ([key isEqual:to]) {[super setData:data];}
    return self;
}
- (void)setKey:(id)key {
    MGRKeyObject *current = [super data];
    if ([key isEqual:current.key]) {return;}
    if ([key isEqual:_to]) {
        [super setData:[[MGRKeyObject alloc] initWithKey:_to object:current.object]];
    } else {
        [super emit:[[MGRKeyObject alloc] initWithKey:key object:current.object]];
    }
}
- (void)setObject:(id)object {
    [super setData:[[MGRKeyObject alloc] initWithKey:_to object:object]];
}
- (id)key {
    return [[super data] key];
}
- (id)object {
    return [[super data] object];
}
@end
