//
//  MGUMessages.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
#import "MGUMessagesController.h"

@interface MGUMessagesDelays : NSObject
@property (nonatomic, strong) NSMutableSet <MGUMessagesPresenter *>*presenters;
- (void)addPresenter:(MGUMessagesPresenter *)presenter;
- (BOOL)removePresenter:(MGUMessagesPresenter *)presenter;
- (void)removeIdentifier:(NSString *)identifier;
- (void)removeAll;
@end

@implementation MGUMessagesDelays
- (instancetype)init {
    self = [super init];
    if (self) {
        self->_presenters = [NSMutableSet set];
    }
    return self;
}


#pragma mark - Action
- (void)addPresenter:(MGUMessagesPresenter *)presenter {
    [self.presenters addObject:presenter];
}

- (void)removeIdentifier:(NSString *)identifier {
    NSArray *arr = [[self.presenters allObjects] mgrFilter:^BOOL(MGUMessagesPresenter *obj) {
        if ([obj.identifier isEqualToString:identifier] == NO) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    self.presenters = [NSMutableSet setWithArray:arr];
}

- (void)removeAll {
    [self.presenters removeAllObjects];
}

- (BOOL)removePresenter:(MGUMessagesPresenter *)presenter {
    if ([self.presenters containsObject:presenter] == NO) {
        return NO;
    }
    
    [self.presenters removeObject:presenter];
    return YES;
}
@end

@interface MGUMessagesController ()
@property (nonatomic, strong) dispatch_queue_t messageQueue;
@property (nonatomic, strong) NSMutableArray <MGUMessagesPresenter *>*queue;
@property (nonatomic, strong) MGUMessagesDelays *delays;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *>*counts; // Integer
@property (nonatomic, strong, nullable) MGUMessagesPresenter *current;
@property (nonatomic, weak, nullable) id autohideToken;
@end

@implementation MGUMessagesController

- (void)dealloc {
    [self hideCurrentAnimated:YES];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸
//! 한파일에 CommonInit 함수가 2개 있음.
static void CommonInit(MGUMessagesController *self) {
    self->_messageQueue = dispatch_queue_create("it.swiftkick.MGUMessages", DISPATCH_QUEUE_SERIAL);
    self->_queue = [NSMutableArray array];
    self->_delays = [MGUMessagesDelays new];
    self->_counts = [NSMutableDictionary dictionary];
    self->_pauseBetweenMessages = 0.5;
    self->_defaultConfig = [MGUMessagesConfig new];
}

#pragma mark - 세터 & 게터
- (void)setCurrent:(MGUMessagesPresenter *)current { // dequeueNext 메서드에서 호출된다.
    MGUMessagesPresenter *oldValue = _current;
    _current = current;
    if (oldValue != nil) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.pauseBetweenMessages * NSEC_PER_SEC));
        __weak __typeof(self) weakSelf = self;
        dispatch_after(delayTime, self.messageQueue, ^{
            [weakSelf dequeueNext];
        });
    }
}


#pragma mark - Action
- (void)hideAnimated:(BOOL)animated {
    dispatch_sync(self.messageQueue, ^{
        [self hideCurrentAnimated:animated];
    });
}

- (void)hideAll {
    dispatch_sync(self.messageQueue, ^{
        [self.queue removeAllObjects];
        [self.delays removeAll];
        [self.counts removeAllObjects];
        [self hideCurrentAnimated:YES];
    });
}

- (void)hideIdentifier:(NSString *)identifier {
    dispatch_sync(self.messageQueue, ^{
        if ([identifier isEqualToString:self.current.identifier] == YES) {
            [self hideCurrentAnimated:YES];
        }
        
        self.queue = [self.queue mgrFilter:^BOOL(MGUMessagesPresenter *obj) {
            if ([obj.identifier isEqualToString:identifier] == NO) {
                return YES;
            } else {
                return NO;
            }
        }].mutableCopy;
            
        [self.delays removeIdentifier:identifier];
        self.counts[identifier] = nil;
    });
}

- (void)hideCountedIdentifier:(NSString *)identifier {
    dispatch_sync(self.messageQueue, ^{
        NSNumber *number = self.counts[identifier];
        if (number != nil) {
            NSInteger count = [number integerValue];
            if (count < 2) {
                self.counts[identifier] = nil;
            } else {
                self.counts[identifier] = @(count - 1);
                return;
            }
        }
        
        if ([identifier isEqualToString:self.current.identifier] == YES) {
            [self hideCurrentAnimated:YES];
        }
        
        self.queue = [self.queue mgrFilter:^BOOL(MGUMessagesPresenter *obj) {
            if ([obj.identifier isEqualToString:identifier] == NO) {
                return YES;
            } else {
                return NO;
            }
        }].mutableCopy;
        [self.delays removeIdentifier:identifier];
    });
}

- (NSInteger)countIdentifier:(NSString *)identifier {
    NSNumber *number = self.counts[identifier];
    if (number != nil) {
        return [number integerValue];
    } else {
        return 0;
    }
}

- (void)setCount:(NSInteger)count identifier:(NSString *)identifier {
    NSNumber *number = self.counts[identifier];
    if (number != nil) {
        self.counts[identifier] = @(count);
    }
}

- (void)queueAutoHide {
    //! strong 으로 잡으면 안되므로 이렇게 잡는 것이 옳다. self.current 를 직접잡으면 좆된다.
    MGUMessagesPresenter *current = self.current;
    if (current == nil) {
        return;
    }
    self.autohideToken = current;
    NSTimeInterval pauseDuration = current.pauseDuration;
    if (MGEFloatIsNull(pauseDuration) == NO) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pauseDuration * NSEC_PER_SEC));
        dispatch_after(delayTime, self.messageQueue, ^{
            // Make sure we've still got a green light to auto-hide.
            if (self.autohideToken == current) {
                [self internalHidePresenter:current];
            }
        });
    }
}

- (void)internalHidePresenter:(MGUMessagesPresenter *)presenter {
    if (self.current != nil) {
        [self hideCurrentAnimated:YES];
    } else {
        self.queue = [self.queue mgrFilter:^BOOL(MGUMessagesPresenter *obj) {
            if (obj != presenter) {
                return YES;
            } else {
                return NO;
            }
        }].mutableCopy;

        [self.delays removePresenter:presenter];
    }
}

- (void)hideCurrentAnimated:(BOOL)animated { // 디폴트 YES
    MGUMessagesPresenter *current = _current;
    if (current == nil || self.current.isHiding == YES) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    void (^actionBlock)(void) = ^{
        [current hideAnimated:animated completion:^(BOOL completed) {
            __strong __typeof(weakSelf) self = weakSelf;
            if (completed == YES) {
                dispatch_sync(self.messageQueue, ^{
                    if (self.current != current) {
                        return;
                    }
                    self.counts[current.identifier] = nil;
                    self.current = nil;
                });
            }
        }];
    };
    
    NSTimeInterval delay = current.delayHide;
    if (MGEFloatIsNull(delay) == YES) {
        delay = 0.0;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        actionBlock();
    });
}

#pragma mark -- Show
//! 결과적으로 모든 메서든 이것으로 show 이것을 거친다.
- (void)showPresenter:(MGUMessagesPresenter *)presenter {
    dispatch_sync(self.messageQueue, ^{
        [self enqueuePresenter:presenter];
    });
}

- (void)showConfig:(MGUMessagesConfig *)config view:(UIView *)view {
    MGUMessagesPresenter *presenter = [[MGUMessagesPresenter alloc] initWithConfig:config
                                                        view:view
                                                    delegate:self];
    [self showPresenter:presenter];
}

- (void)showConfig:(MGUMessagesConfig *)config viewProvider:(MGUMessagesViewProvider)viewProvider {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (viewProvider == nil) {
            NSCAssert(FALSE, @"빈 블락이 들어왔다.");
        } else {
            UIView *view = viewProvider();
            [self showConfig:config view:view];
        }
    });
}

- (void)showView:(UIView *)view {
    [self showConfig:self.defaultConfig view:view];
}

- (void)showViewProvider:(MGUMessagesViewProvider)viewProvider {
    [self showConfig:self.defaultConfig viewProvider:viewProvider];
}

- (BOOL)canBeExchanged {
    if (self.current != nil && self.current.isHiding == NO) {
        return YES;
    }
    return NO;
}

- (NSString *)currentIdentifier {
    return self.current.identifier;
}


#pragma mark - Private
//! Show를 하게 되면 프리젠터를 동반하여 이 메서드를 친다.
- (void)enqueuePresenter:(MGUMessagesPresenter *)presenter {
    if (presenter.config.ignoreDuplicates == YES) {
        NSNumber *number = self.counts[presenter.identifier];
        if (number != nil) {
            NSInteger num = [number integerValue];
            self.counts[presenter.identifier] = @(num + 1);
        } else {
            self.counts[presenter.identifier] = @(1); //  여기가 실행되네.
        }
        
        if ([self.current.identifier isEqualToString:presenter.identifier] && self.current.isHiding == NO) {
            return;
        }
        
        NSArray *arr = [self.queue mgrFilter:^BOOL(MGUMessagesPresenter *obj) {
            if ([obj.identifier isEqualToString:presenter.identifier] == YES) {
                return YES;
            } else {
                return NO;
            }
        }];
        
        if (arr.count > 0) {
            return;
        }
    }
    
    void (^doEnqueueBlock)(void) = ^{
        [self.queue addObject:presenter];
        [self dequeueNext];
    };
    

    NSTimeInterval delay = presenter.delayShow;
    if (MGEFloatIsNull(delay) == NO) { // 딜레이가 있다면.
        [self.delays addPresenter:presenter];
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), self.messageQueue, ^{
            // Don't enqueue if the view has been hidden during the delay window.
            __strong __typeof(weakSelf) self = weakSelf;
            if ([self.delays removePresenter:presenter] == NO) {
                return;
            }
            doEnqueueBlock();
        });
    } else {
        doEnqueueBlock(); // 보통 여기로 친다.
    }
}

- (void)dequeueNext {
    if (self.current != nil || self.queue.count <= 0) {
        return;
    } else {
    }

    MGUMessagesPresenter *current = [self.queue mgrRemovedObjectAtIndex:0];
    self.current = current;
    // Set `autohideToken` before the animation starts in case
    // the dismiss gesture begins before we've queued the autohide
    // block on animation completion.
    self.autohideToken = current;
    current.showDate = CACurrentMediaTime();
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            NSError *error; // 여러번의 try catch를 이용할 경우 위로 빼줘도 괜찮다.
            [current showCompletion:^(BOOL completed) {
                __strong __typeof(weakSelf) self = weakSelf;
                if (completed == NO) {
                    dispatch_sync(self.messageQueue, ^{
                        [self internalHidePresenter:current];
                    });
                    return;
                }
                
                if (current == self.autohideToken) {
                    [self queueAutoHide];
                }
            } error:&error];
            
            [error mgrMakeExceptionAndThrow];
        } @catch(NSException *excpt) {
            [excpt mgrDescription];
            dispatch_sync(self.messageQueue, ^{
                self.current = nil;
            });
        }
    });
}


#pragma mark - Accessing messages
- (UIView *)currentView {
    __block UIView *view;
    dispatch_sync(self.messageQueue, ^{
        view = self.current.view;
    });
    return view;
}

- (UIView *)currentViewWithIdentifier:(NSString *)identifier {
    __block UIView *view;
    dispatch_sync(self.messageQueue, ^{
        if (self.current != nil && [self.current.identifier isEqualToString:identifier] == YES) {
            view = self.current.view;
        }
    });
    
    return view;
}

- (UIView *)queuedViewWithIdentifier:(NSString *)identifier {
    __block UIView *view;
    dispatch_sync(self.messageQueue, ^{
        __block MGUMessagesPresenter *queued;
        [self.queue enumerateObjectsUsingBlock:^(MGUMessagesPresenter *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.identifier isEqualToString:identifier] == YES) {
                queued = obj;
                *stop = YES;
            }
        }];
        if (queued != nil) {
            view = queued.view;
        }
    });
    
    return view;
}

- (UIView * _Nullable)currentOrQueuedWithIdentifier:(NSString *)identifier {
    UIView *view = [self currentViewWithIdentifier:identifier];
    if (view != nil) {
        return view;
    } else {
        return [self queuedViewWithIdentifier:identifier];
    }
}


#pragma mark - <MGUMessagesPresenterDelegate>
- (void)hideAnimator:(id <MGUMessagesAnimator>)animator {
    dispatch_sync(self.messageQueue, ^{
        MGUMessagesPresenter *presenter = [self presenterForAnimator:animator];
        if (presenter != nil) {
            [self internalHidePresenter:presenter];
        }
    });
    
}

- (void)panStartedAnimator:(id <MGUMessagesAnimator>)animator {
    self.autohideToken = nil;
}

- (void)panEndedAnimator:(id <MGUMessagesAnimator>)animator {
    [self queueAutoHide];
}

- (void)hidePresenter:(MGUMessagesPresenter *)presenter {
    dispatch_sync(self.messageQueue, ^{
        [self internalHidePresenter:presenter];
    });
}

- (MGUMessagesPresenter * _Nullable)presenterForAnimator:(id <MGUMessagesAnimator>)animator {
    if (self.current != nil && animator == self.current.animator) {
        return self.current;
    }
    return [self.queue mgrFilter:^BOOL(MGUMessagesPresenter *obj) {
        if (obj.animator == animator) {
            return YES;
        } else {
            return NO;
        }
    }].firstObject;
}


#pragma mark - Static APIs
+ (instancetype)sharedInstance {
    static MGUMessagesController *sharedInstance = nil;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        sharedInstance =  [[self alloc] init];
    });

    return sharedInstance;
}

@end
