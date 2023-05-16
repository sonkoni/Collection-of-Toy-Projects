//
//  MGACarouselScrollViewDeceleratingController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>
@class MGACarouselScrollView;

NS_ASSUME_NONNULL_BEGIN

@interface MGACarouselScrollViewDeceleratingController : NSObject

@property (nonatomic, weak) MGACarouselScrollView *scrollView;
@property (nonatomic, assign) CGFloat startVelocity; // 음수는 양수로 바꿔서 계산하겠다.
@property (nonatomic, assign, readonly) CGFloat distance;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

@property (nonatomic, assign) CGFloat targetDistance; // 조정된. 양수만 넣자.
@property (nonatomic, assign, readonly) NSTimeInterval targetDuration;
@property (nonatomic, assign) BOOL overFlow; // overFlow 하게된다.

@property (nonatomic, copy, nullable) void (^completionBlock)(void); // 중간에 날라가면, 그냥 무시한다.

- (void)beginScrollWithStartOffset:(CGPoint)startOffset endOffset:(CGPoint)endOffset;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
