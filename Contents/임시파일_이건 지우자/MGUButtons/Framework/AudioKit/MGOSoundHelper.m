//
//  MGOSoundHelper.m
//

#import "MGOSoundHelper.h"

static BOOL _SoundIsOn = YES;

void MGOSoundEnroll(NSBundle  * _Nullable bundle, NSString *filename, SystemSoundID *soundIDPtr) {
    if (*soundIDPtr) {return;}
    bundle = bundle ? bundle : [NSBundle mainBundle];
    NSURL *clipURL = [[bundle resourceURL] URLByAppendingPathComponent:filename];
    NSCAssert([[NSFileManager defaultManager] fileExistsAtPath:clipURL.path], @"Sound File NotFound!");
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)clipURL, soundIDPtr);
}

void MGOSoundDispose(SystemSoundID *soundIDPtr) {
    if (!*soundIDPtr) {return;}
    AudioServicesDisposeSystemSoundID(*soundIDPtr);
    *soundIDPtr = 0;
}

void MGOSoundSetOn(BOOL isOn) {
    _SoundIsOn = isOn;
}

BOOL MGOSoundIsOn(void) {
    return _SoundIsOn;
}

// 재생
// 진동음의 경우 만약에 장치에서 진동을 사용할 수 없는 경우,
// AudioServicesPlayAlertSoundWithCompletion()은 진동 대신 소리를 재생하지만,
// AudioServicesPlaySystemSoundWithCompletion()는 재생하지 않는다.
// 따라서 경고의 의미로 사용하지 않는다면 PlaySystemSound 를 쓰라고 권고한다.
//
void MGOSoundSystemPlay(SystemSoundID soundID) {
    if (!_SoundIsOn || !soundID) {return;}
    AudioServicesPlaySystemSoundWithCompletion(soundID, nil);
    
}

void MGOSoundAlertPlay(SystemSoundID soundID) {
    if (!_SoundIsOn || !soundID) {return;}
    AudioServicesPlayAlertSoundWithCompletion(soundID, nil);
}
