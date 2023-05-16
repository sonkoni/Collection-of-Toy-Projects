//
//  MGRWeakObject.m
//  BaseKit
//
//  Created by Kiro on 2022/12/13.
//

#import "MGRWeakObject.h"

@implementation MGRWeakObject
+ (instancetype)object:(id)object {
    return [[[self class] alloc] initWithObject:object];
}
- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _object];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %p> %@", NSStringFromClass([self class]), self, _object];
}

#pragma mark - Equal
- (BOOL)isEqual:(id)item {
    if (item == self) {return YES;}
    if (![item isKindOfClass:[self class]] || !item) {return NO;}
    return [_object isEqual:[(MGRWeakObject *)item object]];
}
- (NSUInteger)hash {
    return [_object hash];
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(NSZone *)zone {
    MGRWeakObject *shallow = [[[self class] allocWithZone:zone] init];
    if (shallow) {
        shallow->_object = _object;
    }
    return shallow;
}
@end
