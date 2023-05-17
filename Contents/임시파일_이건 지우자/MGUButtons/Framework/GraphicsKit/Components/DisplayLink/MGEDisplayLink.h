//
//  MGEDisplayLink.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-17
//  ----------------------------------------------------------------------


#pragma mark - CADisplayLink 는 서브클래싱이 금지되어있다.

#import <QuartzCore/QuartzCore.h>
#import <GraphicsKit/MGEEasingHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGEDisplayLink : NSObject

@property (nonatomic, assign) CFTimeInterval animationDuration;
@property (nonatomic, assign) MGEEasingFunctionType easingFunctionType;
@property (nonatomic, copy, nullable) void (^progressBlock)(CGFloat progress); // 초기화 이후에도 설정할 수 있므르로.
@property (nonatomic, copy, nullable) void (^completionBlock)(void); // 초기화 이후에도 설정할 수 있므르로.
@property (nonatomic, assign) CFTimeInterval delay;

+ (instancetype)displayLinkWithDuration:(CFTimeInterval)duration
                     easingFunctionType:(MGEEasingFunctionType)easingFunctionType
                          progressBlock:(void(^__nullable)(CGFloat progress))progressBlock
                        completionBlock:(void(^__nullable)(void))completionBlock;

//! 0.5 로 하면 애니메이션 중간부분부터 실행되며, 초기화 단계에서 입력되었던 duration은 반으로 줄어들게된다.
- (void)startAnimationWithStartProgress:(CGFloat)startProgress;
- (void)startAnimationWithStartProgress:(CGFloat)startProgress delay:(CFTimeInterval)delay;
- (void)invalidate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


#pragma mark - MGEDisplayLinkGroup
@interface MGEDisplayLinkGroup : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>*animationDurations; // CFTimeInterval
@property (nonatomic, strong) NSArray <NSNumber *>*delays; // CFTimeInterval
@property (nonatomic, strong) NSArray <NSNumber *>*easingFunctionTypes; // NSInteger, MGEEasingFunctionType
@property (nonatomic, strong) NSArray <void(^)(CGFloat progress)>*progressBlocks;
@property (nonatomic, copy, nullable) void (^completionBlock)(void); // 초기화 이후에도 설정할 수 있므르로.

/**
 * @brief 오직 이것 하나로 초기화한다.
 * @param durations duration 배열. progressBlocks의 갯수와 동일하게 넣어줘야한다.
 * @param delays delay 배열. progressBlocks의 갯수와 동일하게 넣어주지 않으면 자동으로 동일하게 만들어준다.
 * @param easingFunctionTypes easing function type 배열. progressBlocks의 갯수와 동일하게 넣어주지 않으면 자동으로 동일하게 만들어준다.
 * @param progressBlocks progress block 배열
 * @param completionBlock completion handler block
 * @discussion MGEDisplayLink 를 연결하여 연속적으로 발동하게 만든 객체이다.
 * @remark - 기존의 MGEDisplayLink의 start progress 조정은 할 수 없게 되어있다. 무조건 0.0 에서 시작.
 * @code
    void (^progressBlock1)(CGFloat progress) = ^(CGFloat progress) {
        ...
    };
    void (^progressBlock2)(CGFloat progress) = ^(CGFloat progress) {
        ...
    };
    void (^completionBlock)(void) = ^{
        ...
    };
 
    self.displayLinkGroup =
    [MGEDisplayLinkGroup linkGroupWithDurations:@[@(0.3), @(0.3)]
                                         delays:@[@(0.0), @(0.3)]
                            easingFunctionTypes:@[@(MGEEasingFunctionTypeEaseInBack), @(MGEEasingFunctionTypeEaseInBack)]
                                 progressBlocks:@[progressBlock1, progressBlock2]
                                completionBlock:completionBlock];

    [self.displayLinkGroup startAnimation];
 * @endcode
 * @return 주어진 MGEDisplayLinkGroup 인스턴스를 반환한다.
*/
+ (instancetype)linkGroupWithDurations:(NSArray <NSNumber *>*)durations // CFTimeInterval
                                delays:(NSArray <NSNumber *>*)delays // CFTimeInterval
                   easingFunctionTypes:(NSArray <NSNumber *>*)easingFunctionTypes // NSInteger, MGEEasingFunctionType
                        progressBlocks:(NSArray <void(^)(CGFloat progress)>*)progressBlocks
                       completionBlock:(void(^__nullable)(void))completionBlock;

- (void)startAnimation;
- (void)invalidate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-10-17 : TARGET_OS_OSX 도 가능하게 만들었음.
 * 2021-04-20 : MGEDisplayLinkGroup 추가
 * 2021-04-17 : Delay 기능 추가
 */
