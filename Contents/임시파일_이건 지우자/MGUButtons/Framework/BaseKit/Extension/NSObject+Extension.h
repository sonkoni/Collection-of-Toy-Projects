//
//  NSObject+Extension.h
//
//  Created by Kwan Hyun Son on 2022/07/06.
//
// https://github.com/AlanQuatermain/aqtoolkit/tree/master/Extensions
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5

#import <Foundation/Foundation.h>

#if DEBUG
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (Extension)
//! properties
//! Recipe 클래스, @property (nonatomic, strong, nullable) NSDate *addedOn;
//! NSLog(@"알려줘----> [%@]", [Recipe mgrGetAttributesFromPropertyVariableName:@"addedOn"]);
//! output  알려줘----> [T@"NSDate",&,N,V_addedOn]
+ (NSString * _Nullable)mgrGetAttributesFromPropertyVariableName:(NSString *)propertyVariableName;
//! NSLog(@"알려줘----> [%@]", [Recipe mgrGetAttributesFromPropertyVariableName:@"addedOn"]);
//! output  알려줘----> [T@"NSDate"]
+ (NSString * _Nullable)mgrGetPropertyNameFromPropertyVariableName:(NSString *)propertyVariableName;
+ (BOOL)mgrHasPropertyVariableName:(NSString *)propertyVariableName;
+ (NSArray <NSString *>* _Nullable)mgrPropertyVariableNames;
@end
NS_ASSUME_NONNULL_END
#endif  /* DEBUG */


