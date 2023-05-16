//
//  NSObject+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-24
//  ----------------------------------------------------------------------
//
// https://github.com/AlanQuatermain/aqtoolkit/tree/master/Extensions
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5

#import <Foundation/Foundation.h>

#if DEBUG
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (DEBUG_Extension)
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


// https://gist.github.com/majie1993/6646ff67ca53d671d618 : non_objective-c_object_perfomselector
// https://stackoverflow.com/questions/7075620/objective-c-how-to-call-performselector-with-a-bool-typed-parameter

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)

/*
 *    NSObject 클래스에 정의된 Perform 메서드 계열이 스칼라 인수를 제대로 받지 못하는 성질로 인해서 스칼라든 아니든 모두 다
 *    수용할 수 있는 메서드를 만들었다. 취소는 NSInvocation의 Extension 메서드 mgrCancelPreviousPerformRequest를 이용하라.
 *
 *.   argumentPtr은 SEL에 들어갈 인수의 주소 포인터를 넣어야한다.
 *    - (void)keke:(BOOL)isOK; 라면
 *    BOOL isOK = YES;
 *    &isOK 를 넣어야한다.
 *
 *    - (void)keke:(NSString *)str; 라면
 *    NSString *str = @"hihihi";
 *    &str 를 넣어야한다.
 
 #import "ViewController.h"
 #import "NSObject+Extension.h"
 @interface ViewController ()
 @property (nonatomic, strong) NSInvocation *invocation;
 @end
 @implementation ViewController
 - (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
     NSString *str = @"ASDASDFASD";
     BOOL isOK = YES;
     _invocation = [self mgrPerformSelector:@selector(myTest:isOK:)
                            withArgumentPtr:&str
                            withArgumentPtr:&isOK
                                 afterDelay:1.8];
     NSLog(@"------");
 }

 - (void)myTest:(NSString *)str isOK:(BOOL)isOK {
     NSLog(@"---> %@, %d", str, isOK);
 }

 - (IBAction)buttonClicked:(UIButton *)sender {
     NSLog(@"버튼 클릭!!!");
     if (self.invocation != nil) {
         [self.invocation mgrCancelPreviousPerformRequest];
         self.invocation = nil;
     }
 }
 @end
 
 // Output
 2022-11-24 11:11:58.338831+0900 JustTEST[90046:2785994] ------
 2022-11-24 11:12:00.139899+0900 JustTEST[90046:2785994] ---> ASDASDFASD, 1
 *
 */
- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                          afterDelay:(NSTimeInterval)delay;

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr
                          afterDelay:(NSTimeInterval)delay;

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr1
                     withArgumentPtr:(void *)argumentPtr2
                          afterDelay:(NSTimeInterval)delay;

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr1
                     withArgumentPtr:(void *)argumentPtr2
                     withArgumentPtr:(void *)argumentPtr3
                          afterDelay:(NSTimeInterval)delay;

- (NSInvocation *)mgrPerformSelector:(SEL)aSelector
                     withArgumentPtr:(void *)argumentPtr1
                     withArgumentPtr:(void *)argumentPtr2
                     withArgumentPtr:(void *)argumentPtr3
                     withArgumentPtr:(void *)argumentPtr4
                          afterDelay:(NSTimeInterval)delay;
@end

@interface NSInvocation (CancelPreviousPerformRequest)
// 위에서 반환된 invocation 객체에 때려야한다.
- (void)mgrCancelPreviousPerformRequest;
@end
NS_ASSUME_NONNULL_END

/* NSObject에는 다음과 같은 예약 및 그 예약을 취소할 수 있는 메서드가 존재한다.
 * 문제는 인수로 스칼라를 인식하지 못한다.
 * 그리고 취소할 때, 예약시 보낸 인수와 같은 인수를 보내야한다. isEqual: 이 YES이면 같음. 둘 다 nil이면 같은 것으로 인식한다.
 
    - (void)kiki:(NSString *)str {
        NSLog(@"===> %@", str);
    }
 
    // 예약.
    [self performSelector:@selector(kiki:) withObject:@"ABCD" afterDelay:2.8];
 
    // 취소.
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(kiki:)
                                               object:@"ABCD"];
 */
