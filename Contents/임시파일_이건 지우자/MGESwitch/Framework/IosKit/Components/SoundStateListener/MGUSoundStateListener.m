//
//  MGUSoundStateListener.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSoundStateListener.h"
#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

static void *MGUSoundStateListenerKVOContext;
NSNotificationName const MGUHardwareVolumeChangeNotification = @"MGUHardwareVolumeChangeNotification";
static NSString * const outputVolume = @"outputVolume"; // AVAudioSession 프라퍼티

@interface MGUSoundStateListener ()
@property (nonatomic, strong) id <NSObject>appWillResignActiveObserver;
@property (nonatomic, strong) id <NSObject>appDidBecomeActiveObserver;
@property (nonatomic, strong) id <NSObject>audioSessionInterruptionObserver;
@end

@implementation MGUSoundStateListener

#pragma mark - 생성 & 소멸
- (void)dealloc {
    [self finishHardwareVolumeDetecting];
}

+ (instancetype)sharedSoundManager {
    static MGUSoundStateListener *sharedObject = nil;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] initPrivate];
    });
    return sharedObject;
}
- (instancetype)initPrivate {
    self = [super init];
    if(self) {
        _hardwareVolumeDetecting = NO;
    }
    return self;
}

#pragma mark - Hardware Volume Detecting
- (void)setHardwareVolumeDetecting:(BOOL)hardwareVolumeDetecting {
    if (_hardwareVolumeDetecting != hardwareVolumeDetecting) {
        _hardwareVolumeDetecting = hardwareVolumeDetecting;
        if (hardwareVolumeDetecting == YES) {
            [self startHardwareVolumeDetecting];
        } else {
            [self finishHardwareVolumeDetecting];
        }
    }
}

//! NSObject 클래스에 정의된 메서드
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if(context != &MGUSoundStateListenerKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    } else {
        if ([keyPath isEqualToString:outputVolume]) {
//        NSLog(@"이전값: %@, 새로운 값:%@", [change objectForKey:NSKeyValueChangeOldKey], [change objectForKey:NSKeyValueChangeNewKey]);
            [[NSNotificationCenter defaultCenter] postNotificationName:MGUHardwareVolumeChangeNotification
                                                                object:self
                                                              userInfo:change];
        }
    }
}

//! 하드웨어 볼륨 디텍팅
// https://developer.apple.com/documentation/avfaudio/avaudiosession/1616533-outputvolume?language=objc : 애플 정식문서 (Key-Value-Observing)
// https://stackoverflow.com/questions/37123598/how-to-stop-avaudiosession-from-deactivating
// 꼼수 노티피케이션 이름 @"AVSystemController_SystemVolumeDidChangeNotification"(iOS 15미만은 작동) => @"SystemVolumeDidChange"(iOS 15이상)
- (void)startHardwareVolumeDetecting {
    // AVAudioSessionCategoryOptionDuckOthers 옵션은 다른 소리를 작게 만들지만, 내 자신이 디액티브되지 않으면, 회복되지 않는다.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers // 다른 소리를 영구적으로 줄어지 않으려면
                        error:NULL];
    [audioSession setActive:YES error:nil];
    
    //! Key - Value - Observing
    [audioSession addObserver:self
                   forKeyPath:outputVolume
                      options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew)
                      context:&MGUSoundStateListenerKVOContext];
    
    //! NSNotification - Observing
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    _appWillResignActiveObserver = [nc addObserverForName:UIApplicationWillResignActiveNotification
                                               object:nil
                                                queue:[NSOperationQueue mainQueue]
                                           usingBlock:^(NSNotification * _Nonnull note) {
        //        NSLog(@"UIApplicationWillResignActiveNotification");
    }];

    _appDidBecomeActiveObserver = [nc addObserverForName:UIApplicationDidBecomeActiveNotification
                                                object:nil
                                                 queue:[NSOperationQueue mainQueue]
                                            usingBlock:^(NSNotification * _Nonnull note) {
            [audioSession setActive:YES error:nil];
//        NSLog(@"UIApplicationDidBecomeActiveNotification");
    }];

    _audioSessionInterruptionObserver = [nc addObserverForName:AVAudioSessionInterruptionNotification
                                                        object:[AVAudioSession sharedInstance]
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *notification) {
        if (notification == nil) {
            return;
        }
        NSNumber *interruptionType = notification.userInfo[AVAudioSessionInterruptionTypeKey];
        NSNumber *interruptionOption = notification.userInfo[AVAudioSessionInterruptionOptionKey];
        switch (interruptionType.unsignedIntegerValue) {
            case AVAudioSessionInterruptionTypeBegan:{
                // • Audio has stopped, already inactive
                // • Change state of UI, etc., to reflect non-playing state
//                NSLog(@"AVAudioSessionInterruptionTypeBegan");
            } break;
            case AVAudioSessionInterruptionTypeEnded:{
                // • Make session active
                // • Update user interface
                // • AVAudioSessionInterruptionOptionShouldResume option
//                NSLog(@"AVAudioSessionInterruptionTypeEnded");
                [audioSession setActive:YES error:nil];
                if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                    // Here you should continue playback.
                }
            } break;
            default:
                break;
        }
    }];
}

- (void)finishHardwareVolumeDetecting {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:NULL];
    [audioSession removeObserver:self forKeyPath:outputVolume context:&MGUSoundStateListenerKVOContext];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:_appWillResignActiveObserver name:UIApplicationWillResignActiveNotification object:nil];
    [nc removeObserver:_appDidBecomeActiveObserver name:UIApplicationDidBecomeActiveNotification object:nil];
    [nc removeObserver:_audioSessionInterruptionObserver
                  name:AVAudioSessionInterruptionNotification
                object:[AVAudioSession sharedInstance]];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)init {
    NSCAssert(FALSE, @"- init 사용금지.");
    return nil;
}

+ (instancetype)new {
    NSCAssert(FALSE, @"+ new 사용금지.");
    return nil;
}

@end
