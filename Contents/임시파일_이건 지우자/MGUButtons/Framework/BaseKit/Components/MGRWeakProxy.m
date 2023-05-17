//
//  MGRWeakProxy.m
//  MGRPageControls
//
//  Created by Kwan Hyun Son on 2021/07/29.
//

#import "MGRWeakProxy.h"

@implementation MGRWeakProxy

- (instancetype)initWithTarget:(id <NSObject>)target {
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (self.target == nil) {
        return [super respondsToSelector:aSelector];
    }
    
    return [self.target respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end
