//
//  MGEDisplayLink.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEDisplayLink.h"
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#define MGR_UNI_DisplayLink NSTimer
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define MGR_UNI_DisplayLink CADisplayLink
#endif

@interface MGEDisplayLink ()
@property (nonatomic, strong, nullable) MGR_UNI_DisplayLink *displayLink;  // NSTimer 일때 Target을 weak로 잡자.
@property (nonatomic, assign) CGFloat displayLinkProgress; // 0.0 ~ 1.0
@property (nonatomic, assign) NSInteger totalFrames; // 총 몇 번때려야 최종까지 도착하는가.
@property (nonatomic, assign) CGFloat startProgress;
@property (nonatomic, assign) NSInteger delayFrames;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation MGEDisplayLink

+ (instancetype)displayLinkWithDuration:(CFTimeInterval)duration
                     easingFunctionType:(MGEEasingFunctionType)easingFunctionType
                          progressBlock:(void(^__nullable)(CGFloat progress))progressBlock
                        completionBlock:(void(^__nullable)(void))completionBlock {
    MGEDisplayLink *MGEDisplayLink = [[super alloc] init];
    if (self) {
        MGEDisplayLink.animationDuration = duration;
        MGEDisplayLink.easingFunctionType = easingFunctionType;
        MGEDisplayLink.progressBlock = progressBlock;
        MGEDisplayLink.completionBlock = completionBlock;
        MGEDisplayLink.delay = 0.0;
    }
    return MGEDisplayLink;
}

- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
#if DEBUG
    NSLog(@"MGEDisplayLink Dealloc");
#endif
}


#pragma mark - control
- (void)startAnimationWithStartProgress:(CGFloat)startProgress {
    [self startAnimationWithStartProgress:startProgress delay:self.delay];
}

- (void)startAnimationWithStartProgress:(CGFloat)startProgress delay:(CFTimeInterval)delay {
    [self invalidate];
    _startProgress = startProgress;
    NSInteger preferredFramesPerSecond = 60;
    _timeInterval = (1.0 / 60.0);
    self.delay = delay;
    self.delayFrames = (NSInteger)(self.delay * preferredFramesPerSecond);

#if TARGET_OS_OSX
    __weak __typeof(self)weakSelf = self;
    _displayLink = [NSTimer timerWithTimeInterval:self.timeInterval
                                            target:weakSelf
                                          selector:@selector(displayTick:)
                                          userInfo:nil
                                           repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.displayLink forMode:NSRunLoopCommonModes];
    // CommonModes해야 인터렉션 딜레이 방지가능.
//    self.displayLink.tolerance = 0.1; // 허용오차. 약간의 오차를 줘야지 프로그램이 메모리를 덜먹는다. 보통 0.1
#elif TARGET_OS_IPHONE
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayTick:)];
    self.displayLink.preferredFramesPerSecond = preferredFramesPerSecond;
    // 즉, ===> self.displayLink.duration == 1 / 60.0 이 된다.
//    self.displayLink.preferredFramesPerSecond = [UIScreen mainScreen].maximumFramesPerSecond; // 과한가?
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
#endif
}

- (void)displayTick:(MGR_UNI_DisplayLink *)displayLink {
    if (self.delayFrames != 0) {
        self.delayFrames = MAX(0, self.delayFrames - 1);
        return;
    }
    if (self.animationDuration == 0.0) {
        [self updateProgress:1.0];
        return;
    }
    if (self.totalFrames == 0) { // Total Frame Setting : 최초에 설정.
        self.totalFrames = (NSInteger)(ceil(self.animationDuration / self.timeInterval)); //  올림함수.
        self.displayLinkProgress = self.startProgress;
    } else {
        self.displayLinkProgress = self.displayLinkProgress + (1.0 / self.totalFrames);
        self.displayLinkProgress = MIN(1.0, MAX(0.0, self.displayLinkProgress));
        [self updateProgress:self.displayLinkProgress];
    }
}

- (void)updateProgress:(CGFloat)progress {
    if (self.displayLink == nil) {
        return;
    }
    if (self.progressBlock == nil) {
        NSAssert(FALSE, @"progressBlock이 nil인데, display link를 작동시켰다.");
    }

    if (progress == 1.0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.totalFrames = 0;
        self.progressBlock(1.0);
        if (self.completionBlock != nil) {
            self.completionBlock();
        }
    } else {
        progress = MGEEasingFunction(self.easingFunctionType, progress, 0.0, 1.0, 1.0);
        self.progressBlock(progress);
    }
}

- (void)invalidate {
    if (self.displayLink != nil) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        _totalFrames = 0; //! 반드시 0으로 설정해줘야한다. 재사용 시, 예전 거에 이어서 되버리면 안된다.
    }
}

@end

#undef MGR_UNI_DisplayLink


#pragma mark - MGEDisplayLinkGroup
@interface MGEDisplayLinkGroup ()
@property (nonatomic, strong, nullable) NSMutableArray <MGEDisplayLink *>*MGEDisplayLinks;
@end

@implementation MGEDisplayLinkGroup

- (void)dealloc {
    [self invalidate];
}


#pragma mark - 생성 & 소멸
+ (instancetype)linkGroupWithDurations:(NSArray <NSNumber *>*)durations // CFTimeInterval
                                delays:(NSArray <NSNumber *>*)delays // CFTimeInterval
                   easingFunctionTypes:(NSArray <NSNumber *>*)easingFunctionTypes // NSInteger, MGEEasingFunctionType
                        progressBlocks:(NSArray <void(^)(CGFloat progress)>*)progressBlocks
                       completionBlock:(void(^__nullable)(void))completionBlock {
    MGEDisplayLinkGroup *MGEDisplayLinkGroup = [[super alloc] init];
    if (self) {
        MGEDisplayLinkGroup.animationDurations = durations;
        MGEDisplayLinkGroup.delays = delays;
        MGEDisplayLinkGroup.easingFunctionTypes = easingFunctionTypes;
        MGEDisplayLinkGroup.progressBlocks = progressBlocks;
        MGEDisplayLinkGroup.completionBlock = completionBlock;
    }
    return MGEDisplayLinkGroup;
}

- (void)setupEasingFunctionTypes { // 하나만 넣어서 공통적인 easing 함수를 사용할 때.
    NSInteger progressBlocksCount = self.progressBlocks.count;
    NSInteger easingFunctionTypesCount = self.easingFunctionTypes.count;
    if (progressBlocksCount != easingFunctionTypesCount) {
        if (easingFunctionTypesCount == 0) {
            NSMutableArray <NSNumber *>*easingFunctionTypes = [NSMutableArray arrayWithCapacity:progressBlocksCount];
            for (NSInteger i = 0; i < progressBlocksCount; i++) {
                [easingFunctionTypes addObject:@(MGEEasingFunctionTypeEaseLinear)];
            }
            self.easingFunctionTypes = easingFunctionTypes.copy;
        } else {
            NSMutableArray <NSNumber *>*easingFunctionTypes = self.easingFunctionTypes.mutableCopy;
            for (NSInteger i = easingFunctionTypesCount; i < progressBlocksCount; i++) {
                [easingFunctionTypes addObject:self.easingFunctionTypes.lastObject];
            }
            self.easingFunctionTypes = easingFunctionTypes.copy;
        }
    }
}

- (void)setupDelays { // 하나만 넣어서 공통적인 easing 함수를 사용할 때.
    NSInteger progressBlocksCount = self.progressBlocks.count;
    NSInteger delaysCount = self.delays.count;
    if (progressBlocksCount != delaysCount) {
        if (delaysCount == 0) {
            NSMutableArray <NSNumber *>*delays = [NSMutableArray arrayWithCapacity:progressBlocksCount];
            for (NSInteger i = 0; i < progressBlocksCount; i++) {
                [delays addObject:@(0.0)];
            }
            self.delays = delays.copy;
        } else {
            NSMutableArray <NSNumber *>*delays = self.delays.mutableCopy;
            for (NSInteger i = delaysCount; i < progressBlocksCount; i++) {
                [delays addObject:self.delays.lastObject];
            }
            self.delays = delays.copy;
        }
    }
}


#pragma mark - 컨트롤
- (void)startAnimation {
    NSInteger count = self.progressBlocks.count;
    if (count < 0) {
        NSAssert(FALSE, @"progressBlocks의 갯수가 음수이다.");
    } else if (count == 0) {
        NSLog(@"progressBlocks 갯수가 없다.");
        return;
    }
    
    [self setupEasingFunctionTypes];
    [self setupDelays];
    
    _MGEDisplayLinks = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        CFTimeInterval duration = [self.animationDurations[i] doubleValue];
        MGEEasingFunctionType easingFunctionType = [self.easingFunctionTypes[i] integerValue];
        void (^progressBlock)(CGFloat progress) = self.progressBlocks[i];
        MGEDisplayLink *link = [MGEDisplayLink displayLinkWithDuration:duration
                                                    easingFunctionType:easingFunctionType
                                                         progressBlock:progressBlock
                                                       completionBlock:nil];
        link.delay = [self.delays[i] doubleValue];
        [self.MGEDisplayLinks addObject:link];
    }
    
    __weak __typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < count; i++) {
        MGEDisplayLink *link = weakSelf.MGEDisplayLinks[i];
        
        if (i == count - 1) {
            link.completionBlock = weakSelf.completionBlock;
        } else {
            __weak MGEDisplayLink *weakNextLink = self.MGEDisplayLinks[i+1];
            link.completionBlock = ^{
                [weakNextLink startAnimationWithStartProgress:0.0];
            };
        }
    }
    
    MGEDisplayLink *link = self.MGEDisplayLinks.firstObject;
    [link startAnimationWithStartProgress:0.0];
}

- (void)invalidate {
    for (MGEDisplayLink *link in self.MGEDisplayLinks) {
        [link invalidate];
    }
}

@end

