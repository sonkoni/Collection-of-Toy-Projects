//
//  MGRDisplayLink.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGRDisplayLink.h"

@interface MGRDisplayLink ()
@property (nonatomic, strong, nullable) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat displayLinkProgress; // 0.0 ~ 1.0
@property (nonatomic, assign) NSInteger totalFrames; // 총 몇 번때려야 최종까지 도착하는가.
@property (nonatomic, assign) CGFloat startProgress;
@property (nonatomic, assign) NSInteger delayFrames;
@end

@implementation MGRDisplayLink

+ (instancetype)displayLinkWithDuration:(CFTimeInterval)duration
                     easingFunctionType:(MGREasingFunctionType)easingFunctionType
                          progressBlock:(void(^__nullable)(CGFloat progress))progressBlock
                        completionBlock:(void(^__nullable)(void))completionBlock {
    MGRDisplayLink *mgrDisplayLink = [[super alloc] init];
    if (self) {
        mgrDisplayLink.animationDuration = duration;
        mgrDisplayLink.easingFunctionType = easingFunctionType;
        mgrDisplayLink.progressBlock = progressBlock;
        mgrDisplayLink.completionBlock = completionBlock;
        mgrDisplayLink.delay = 0.0;
    }
    return mgrDisplayLink;
}

- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
}


#pragma mark - control
- (void)startAnimationWithStartProgress:(CGFloat)startProgress {
    [self startAnimationWithStartProgress:startProgress delay:self.delay];
}

- (void)startAnimationWithStartProgress:(CGFloat)startProgress delay:(CFTimeInterval)delay {
    [self invalidate];
    
    _startProgress = startProgress;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayTick:)];
    self.displayLink.preferredFramesPerSecond = 60; //! 즉, ===> self.displayLink.duration == 1 / 60.0 이 된다.
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.delay = delay;
    self.delayFrames = (NSInteger)(self.delay * self.displayLink.preferredFramesPerSecond);
}

- (void)displayTick:(CADisplayLink *)displayLink {
    if (self.totalFrames == 0) { // Total Frame Setting : 최초에 설정.
        self.totalFrames = (NSInteger)(ceil(self.animationDuration / self.displayLink.duration)); //  올림함수.
        self.displayLinkProgress = self.startProgress;
    } else {
        if (self.delayFrames != 0) {
            self.delayFrames = MAX(0, self.delayFrames - 1);
            return;
        }
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
        progress = MGREasingFunction(self.easingFunctionType, progress, 0.0, 1.0, 1.0);
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


#pragma mark - MGRDisplayLinkGroup
@interface MGRDisplayLinkGroup ()
@property (nonatomic, strong, nullable) NSMutableArray <MGRDisplayLink *>*mgrDisplayLinks;
@end

@implementation MGRDisplayLinkGroup

- (void)dealloc {
    [self invalidate];
}


#pragma mark - 생성 & 소멸
+ (instancetype)linkGroupWithDurations:(NSArray <NSNumber *>*)durations // CFTimeInterval
                                delays:(NSArray <NSNumber *>*)delays // CFTimeInterval
                   easingFunctionTypes:(NSArray <NSNumber *>*)easingFunctionTypes // NSInteger, MGREasingFunctionType
                        progressBlocks:(NSArray <void(^)(CGFloat progress)>*)progressBlocks
                       completionBlock:(void(^__nullable)(void))completionBlock {
    MGRDisplayLinkGroup *mgrDisplayLinkGroup = [[super alloc] init];
    if (self) {
        mgrDisplayLinkGroup.animationDurations = durations;
        mgrDisplayLinkGroup.delays = delays;
        mgrDisplayLinkGroup.easingFunctionTypes = easingFunctionTypes;
        mgrDisplayLinkGroup.progressBlocks = progressBlocks;
        mgrDisplayLinkGroup.completionBlock = completionBlock;
    }
    return mgrDisplayLinkGroup;
}

- (void)setupEasingFunctionTypes { // 하나만 넣어서 공통적인 easing 함수를 사용할 때.
    NSInteger progressBlocksCount = self.progressBlocks.count;
    NSInteger easingFunctionTypesCount = self.easingFunctionTypes.count;
    if (progressBlocksCount != easingFunctionTypesCount) {
        if (easingFunctionTypesCount == 0) {
            NSMutableArray <NSNumber *>*easingFunctionTypes = [NSMutableArray arrayWithCapacity:progressBlocksCount];
            for (NSInteger i = 0; i < progressBlocksCount; i++) {
                [easingFunctionTypes addObject:@(MGREasingFunctionTypeEaseLinear)];
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
    
    _mgrDisplayLinks = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        CFTimeInterval duration = [self.animationDurations[i] doubleValue];
        MGREasingFunctionType easingFunctionType = [self.easingFunctionTypes[i] integerValue];
        void (^progressBlock)(CGFloat progress) = self.progressBlocks[i];
        MGRDisplayLink *link = [MGRDisplayLink displayLinkWithDuration:duration
                                                    easingFunctionType:easingFunctionType
                                                         progressBlock:progressBlock
                                                       completionBlock:nil];
        link.delay = [self.delays[i] doubleValue];
        [self.mgrDisplayLinks addObject:link];
    }
    
    __weak __typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < count; i++) {
        MGRDisplayLink *link = weakSelf.mgrDisplayLinks[i];
        
        if (i == count - 1) {
            link.completionBlock = weakSelf.completionBlock;
        } else {
            __weak MGRDisplayLink *weakNextLink = self.mgrDisplayLinks[i+1];
            link.completionBlock = ^{
                [weakNextLink startAnimationWithStartProgress:0.0];
            };
        }
    }
    
    MGRDisplayLink *link = self.mgrDisplayLinks.firstObject;
    [link startAnimationWithStartProgress:0.0];
}

- (void)invalidate {
    for (MGRDisplayLink *link in self.mgrDisplayLinks) {
        [link invalidate];
    }
}

@end
