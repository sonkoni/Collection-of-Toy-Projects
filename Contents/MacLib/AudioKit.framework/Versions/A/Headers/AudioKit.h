//
//  AudioKit.h
//  ----------------------------------------------------------------------
//  Prefix : MGO
//  사운드 관련 함수 제공
//  ----------------------------------------------------------------------
//  SoundClip 의 파일 중 프로젝트에 필요한 사운드만 IosRes/MacRes 번들에 담아서 쓴다.
//

#import <Foundation/Foundation.h>

//! Project version number for AudioKit.
FOUNDATION_EXPORT double AudioKitVersionNumber;

//! Project version string for AudioKit.
FOUNDATION_EXPORT const unsigned char AudioKitVersionString[];

//! Sound
#import <AudioKit/MGOSoundHelper.h>
#import <AudioKit/MGOSound.h>
