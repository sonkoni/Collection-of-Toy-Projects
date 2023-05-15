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

//! NSLog(@"알려줘----> [%@]", [Recipe mgrGetPropertyNameFromPropertyVariableName:@"addedOn"]);
//! output  알려줘----> [T@"NSDate"]
+ (NSString * _Nullable)mgrGetPropertyNameFromPropertyVariableName:(NSString *)propertyVariableName;
+ (BOOL)mgrHasPropertyVariableName:(NSString *)propertyVariableName;
+ (NSArray <NSString *>* _Nullable)mgrPropertyVariableNames;
@end
NS_ASSUME_NONNULL_END
#endif  /* DEBUG */


// https://gist.github.com/majie1993/6646ff67ca53d671d618 : non_objective-c_object_perfomselector
// https://stackoverflow.com/questions/7075620/objective-c-how-to-call-performselector-with-a-bool-typed-parameter
// https://swiftpackageindex.com/mhdhejazi/Dynamic#user-content-how-to-use : 더 다양한 방식이 있다.
//
NS_ASSUME_NONNULL_BEGIN

#pragma mark - IMP 및 반환값을 사용하는 방식이 아래 주석에 따로 설명되어있다. 스위프트 예제도 있다. 확인하기 바란다.
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

/**
 - (IBAction)buttonClicked:(UIButton *)sender {
     if (self.invocation != nil) {
         [self.invocation mgrCancelPreviousPerformRequest];
         NSLog(@"닐이 아니다. %@", self.invocation);
     } else {
         NSLog(@"닐이다.");
     }
     
     void (^voidBlock)(void) = ^{
         // 니가 하고 싶은 것.
     };

     self.invocation = [NSObject mgrPerformBlock:&voidBlock afterDelay:1.2];
 }
 */
+ (NSInvocation *)mgrPerformBlock:(dispatch_block_t _Nonnull * _Nonnull)voidBlockPtr
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

#pragma mark - 수동구현. NSInvocation, IMP, 반환값을 사용하는 방식.
/**
*   NSInvocation에서 반환값을 받으려면 retainArguments를 해야한다.
*   performSelector 계열은 한계(인수 갯수 제한, 스칼라 못받음)가 너무 많아서 IMP 또는 NSInvocation을 사용하면 될 듯.
 
 
    _person = [Person new];
    NSString *firstName = @"Koni";
    NSString *lastName = @"Son";

//! NSInvocation 사용하기
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL selector = @selector(myPrivateMethod:firstName:); // 또는 NSSelectorFromString(@"myPrivateMethod:firstName:");
    if ([self.person respondsToSelector:selector] == YES) {
        NSMethodSignature *signature = [[self.person class] instanceMethodSignatureForSelector:selector];
        _invocation = [NSInvocation invocationWithMethodSignature:signature];
        [self.invocation retainArguments]; // 반환값을 받으려면 이렇게 해야 Release 되지 않는다.
        _invocation.target = self.person;
        _invocation.selector = selector;
        [_invocation setArgument:&firstName atIndex:2];
        [_invocation setArgument:&lastName atIndex:3];
        [_invocation invoke];
        [self.invocation getReturnValue:&(_result)];
        NSLog(@"=====> %@", _result);
    } else {
        NSLog(@"없네");
    }
#pragma clang diagnostic pop


//! IMP(함수포인터) 사용하기
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL selector = @selector(myPrivateMethod:firstName:); // 또는 NSSelectorFromString(@"myPrivateMethod:firstName:");
    if ([self.person respondsToSelector:selector] == YES) {
        IMP methodIMP = [[self.person class] instanceMethodForSelector:selector];
        NSString * (*cFunction)(id, SEL, NSString *, NSString *) = (NSString * (*)(id, SEL, NSString *, NSString *))methodIMP;
        self.result = cFunction(self.person, selector, firstName, lastName);
        NSLog(@"=====> %@", self.result);
    } else {
        NSLog(@"없네");
    }
    //
    // 반환형이 NSString *아니라 없으면 void를 사용하면된다.
#pragma clang diagnostic pop
 */


#pragma mark - 스위프트
/**
*   스위프트에서는 NSInvocation을 사용할 수 없다.
*   다음과 같은 Objective-C의 private 메서드를 사용할 수 있다.
*   위키 `Api:Swift/Attribute @convention` 를 참고하자. 블락에 대한 사용법도 나와있다.
 
@interface Toolbar : NSObject
// 이 메서드가 감춰져있다고 가정하자.
// - (NSString *)titleForItem:(NSString *)item withTag:(NSString *)tag;
@end


//!  Using methodForSelector() with @convention(c)
 typealias titleForItemMethod = @convention(c) (NSObject, Selector, NSString, NSString) -> NSString
 let selector = NSSelectorFromString("titleForItem:withTag:") // Selector(("titleForItem:withTag:")) 이것도 가능
 if toolbar.responds(to: selector) {
     let methodIMP = toolbar.method(for: selector)
     let method = unsafeBitCast(methodIMP, to: titleForItemMethod.self)
     let result = method(toolbar, selector, "foo", "bar")
 }

//!  Using performSelector()
 let selector = NSSelectorFromString("titleForItem:withTag:") // Selector(("titleForItem:withTag:")) 이것도 가능
 if toolbar.responds(to: selector) {
     if let result = toolbar.perform(selector, with: "foo", with: "bar")?.takeUnretainedValue() as? String {
         print("----> \(result)")
     }
     //
     // Unretained Value 이므로 변수로 바로 붙여서 써야한다.
     // 아래와 같이 변수로 받아서 사용하면 Release 되버린다.
     // let unmanaged = toolbar.perform(selector, with: "foo", with: "bar")
     // let result = unmanaged?.takeUnretainedValue() as? String
 }
 */
