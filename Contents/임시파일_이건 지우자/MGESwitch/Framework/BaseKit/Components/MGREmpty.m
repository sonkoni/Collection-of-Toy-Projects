//
//  MGREmpty.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGREmpty.h"

@implementation MGREmpty

/// 인스턴스 Never 반환
+ (instancetype)never {
    return [[self alloc] initWith:MGREmptyNever];
}

/// 인스턴스 Done 반환
+ (instancetype)done {
    return [[self alloc] initWith:MGREmptyDone];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (self != [MGREmpty class]) {
        NSAssert(NO, @"Subclassing MGREmpty not allowed.");
        return nil;
    }
    return [super allocWithZone:zone];
}

- (instancetype)init {
    return [self initWith:MGREmptyDone];
}

- (instancetype)initWith:(MGREmptyState)state {
    self = [super init];
    if (self) {
        _state = state;
    }
    return self;
}

- (NSString *)description {
    if (_state) {
        return [NSString stringWithFormat:@"<MGREmpty Done: %p>", self];
    }
    return [NSString stringWithFormat:@"<MGREmpty Never: %p>", self];
}

/// 상태에 대한 싱글톤 반환
- (id<MGREmptying>)null {
    if (_state) {
        return [MGRDone new];
    }
    return [MGRNever new];
}

- (MGREmpty *)empty {
    return [self copy];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    } else if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [(MGREmpty *)object state] == _state;
}

- (id)copyWithZone:(NSZone *)zone {
    MGREmpty *shallow = [[[self class] allocWithZone:zone] init];
    if (shallow) {
        shallow->_state = _state;
    }
    return shallow;
}

- (NSUInteger)hash {
    return (NSUInteger)self;
}
@end

// ----------------------------------------------------------------------

@implementation MGRNever
+ (MGRNever *)null {
    return [[MGRNever alloc] init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static MGRNever * _never = nil;
    static dispatch_once_t onceNeverToken;
    dispatch_once(&onceNeverToken, ^{
        _never = [super allocWithZone:zone];
    });
    return _never;
}
- (MGREmptyState)state {
    return NO;
}
- (MGREmpty *)empty {
    return [[MGREmpty alloc] initWith:NO];
}
- (BOOL)isEqual:(id)object {
    return object == self;
}
- (NSUInteger)hash {
    return 0;
}
@end

// ----------------------------------------------------------------------

@implementation MGRDone
+ (MGRDone *)null {
    return [[MGRDone alloc] init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static MGRDone * _done = nil;
    static dispatch_once_t onceDoneToken;
    dispatch_once(&onceDoneToken, ^{
        _done = [super allocWithZone:zone];
    });
    return _done;
}
- (MGREmptyState)state {
    return YES;
}
- (MGREmpty *)empty {
    return [[MGREmpty alloc] initWith:YES];
}
- (BOOL)isEqual:(id)object {
    return object == self;
}
- (NSUInteger)hash {
    return 0;
}
@end


// ----------------------------------------------------------------------

/// 다음의 경우 '비어있냐 YES' 로 판단한다.
/// @discussion - 객체가 nil 일 때
/// @discussion - NSNull 객체일 때
/// @discussion - MGREmptyType 객체일 때
/// @discussion - 일반 객체의 데이터 길이가 0일 때 (length 0)
/// @discussion - 일반 객체의 아이템 갯수가 0일 때 (count 0)
//BOOL MGREmptyIs(id _Nullable object) {
//    return (!object ||
//            object == [NSNull null] ||
//            [object conformsToProtocol:@protocol(MGREmptying)] ||
//            ([object respondsToSelector:@selector(length)] && ![(NSData *)object length]) ||
//            ([object respondsToSelector:@selector(count)] && ![(NSArray *)object count]));
//}


