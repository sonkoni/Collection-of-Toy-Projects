//
//  MGRWeakProxy.h
//  MGRPageControls
//
//  Created by Kwan Hyun Son on 2021/07/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGRWeakProxy
 @abstract      weak proxy 객체를 target으로 메서드를 보내면 weak proxy가 자신의 target에 메서드를 전달해준다.
 @discussion    메서들 나누어 나누어 받을 수 있을 것으로 사료된다.
 * @code
        self.displayLink = [CADisplayLink displayLinkWithTarget:[[WeakProxy alloc] initWithTarget:self] selector:@selector(updateFrame:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
 
        // updateFrame:에 대한 메서드는 self(MGRWeakProxy 가 아님.)가 구현한다.
 * @endcode
*/

@interface MGRWeakProxy : NSObject

@property (nonatomic, weak, nullable) id <NSObject>target;

- (instancetype)initWithTarget:(id <NSObject>)target;

@end

NS_ASSUME_NONNULL_END
