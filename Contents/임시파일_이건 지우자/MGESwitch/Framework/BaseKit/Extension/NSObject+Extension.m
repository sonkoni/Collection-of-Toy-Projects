//
//  NSObject+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSObject+Extension.h"
#if DEBUG
// T@"NSDate",&,N,V_addedOn   ===>   T@"NSDate" 이렇게 컷팅해준다.
static const char * CuttingPropertyName(const char * attrs) {
    if (attrs == NULL) {
        return NULL;
    }
    static char buffer[256];
    const char * e = strchr(attrs, ',');
    if (e == NULL) {
        return NULL;
    }
    int len = (int)(e - attrs);
    memcpy(buffer, attrs, len);
    buffer[len] = '\0';
    return ( buffer );
}
// ----------------------------------------------------------------------
@implementation NSObject (DEBUG_Extension)
+ (NSString *)mgrGetAttributesFromPropertyVariableName:(NSString *)propertyVariableName {
    objc_property_t property = class_getProperty([self class], [propertyVariableName UTF8String]);
    if (property == NULL) {
        return nil;
    }
    const char * attrs = property_getAttributes(property);
    if (attrs == NULL) {
        return nil;
    }
    return [NSString stringWithCString:attrs
                              encoding:NSASCIIStringEncoding];
}
+ (NSString *)mgrGetPropertyNameFromPropertyVariableName:(NSString *)propertyVariableName {
    objc_property_t property = class_getProperty([self class], [propertyVariableName UTF8String]);
    if (property == NULL) {
        return nil;
    }
    const char * attrs = property_getAttributes(property);
    if (attrs == NULL) {
        return nil;
    }
    return [NSString stringWithCString:CuttingPropertyName(attrs) encoding:NSASCIIStringEncoding];
}
+ (BOOL)mgrHasPropertyVariableName:(NSString *)propertyVariableName {
    return (class_getProperty([self class], [propertyVariableName UTF8String]) != NULL);
}
+ (NSArray <NSString *>*)mgrPropertyVariableNames {
    unsigned int i, count = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    if (count == 0) {
        free(properties);
        return nil;
    }
    NSMutableArray <NSString *>*list = [NSMutableArray array];
    for (i = 0; i < count; i++ ) {
        [list addObject: [NSString stringWithUTF8String:property_getName(properties[i])]];
    }
    return [list copy];
}
@end
#endif  /* DEBUG */



@implementation NSObject (Extension)

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                          afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    return invocation;
}

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr
                          afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation setArgument:argumentPtr atIndex:2];
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    return invocation;
}

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr1
                     withArgumentPtr:(void *)argumentPtr2
                          afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation setArgument:argumentPtr1 atIndex:2];
    [invocation setArgument:argumentPtr2 atIndex:3];
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    return invocation;
}

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr1
                     withArgumentPtr:(void *)argumentPtr2
                     withArgumentPtr:(void *)argumentPtr3
                          afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation setArgument:argumentPtr1 atIndex:2];
    [invocation setArgument:argumentPtr2 atIndex:3];
    [invocation setArgument:argumentPtr3 atIndex:4];
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    return invocation;
}

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr1
                     withArgumentPtr:(void *)argumentPtr2
                     withArgumentPtr:(void *)argumentPtr3
                     withArgumentPtr:(void *)argumentPtr4
                          afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation setArgument:argumentPtr1 atIndex:2];
    [invocation setArgument:argumentPtr2 atIndex:3];
    [invocation setArgument:argumentPtr3 atIndex:4];
    [invocation setArgument:argumentPtr4 atIndex:5];
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
    return invocation;
}

@end

@implementation NSInvocation (CancelPreviousPerformRequest)
- (void)mgrCancelPreviousPerformRequest {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(invoke) object:nil];
}
@end
