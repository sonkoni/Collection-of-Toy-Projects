//
//  MGOSoundHelper.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-19
//  사운드클립 재생을 도와주는 간단한 편의함수
//  ----------------------------------------------------------------------
//
//

#ifndef MGOSoundHelper_h
#define MGOSoundHelper_h
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

NS_ASSUME_NONNULL_BEGIN

/// 음원파일을 등록. 번들명 nil은 메인번들.
void MGOSoundEnroll(NSBundle  * _Nullable bundle, NSString *filename, SystemSoundID *soundIDPtr);

/// 등록한 사운드 폐기. 객체에서 음원을 개별 등록했다면 dealloc 에서 처리해야 함.
void MGOSoundDispose(SystemSoundID * _Nonnull soundIDPtr);

/// 소리 On/Off. 기본값 YES.
void MGOSoundSetOn(BOOL isOn);

/// 소리 상태. 기본값 YES.
BOOL MGOSoundIsOn(void);

/// 등록한 30초 이하의 짧은 사운드 재생. 비동기적으로 실행됨.
void MGOSoundSystemPlay(SystemSoundID soundID);
void MGOSoundAlertPlay(SystemSoundID soundID);

NS_ASSUME_NONNULL_END

#endif /* MGOSoundHelper_h */
