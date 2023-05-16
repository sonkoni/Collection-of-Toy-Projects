//
//  MGUKeyboardStateListener.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//
// https://danilovdev.blogspot.com/2018/02/ios-swift-check-if-keyboard-is-visible.html

#import "MGUKeyboardStateListener.h"

@interface MGUKeyboardStateListener ()
@property (nonatomic, assign, readwrite) BOOL isVisible;
@property (nonatomic, assign) BOOL active;
@end

@implementation MGUKeyboardStateListener

#pragma mark - 생성 & 소멸
+ (instancetype)sharedKeyboardStateListener {
    static MGUKeyboardStateListener *sharedListener = nil;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        sharedListener =  [[self alloc] initPrivate];
    });
    
    return sharedListener;
}

// 진짜 초기화 메서드, 최초 1회만 호출될 것이다.
- (instancetype)initPrivate {
    self = [super init];
    if(self) {
        _isVisible = NO;
        _active = NO;
    }
    return self;
}


#pragma mark - Action
- (void)start {
    if (self.active == YES) {
        return;
    }
    self.active = YES;
    __weak __typeof(self) weakSelf = self;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:UIKeyboardWillShowNotification // 키보드가 올라올 때
                    object:nil
                     queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.isVisible = YES;
    }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification // 빨리 정리하는게 여기에서는 더 보기 좋다.
                        object:nil
                     queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.isVisible = NO;
    }];
}

- (void)stop {
    if (self.active == NO) {
        return;
    }
    self.active = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }

@end
