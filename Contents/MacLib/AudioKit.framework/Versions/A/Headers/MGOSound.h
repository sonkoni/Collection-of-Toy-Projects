//
//  MGOSound.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-19
//  사운드 재생. defaultSound, keyBoardSound 등처럼 기본 제공 사운드 클래스가 아닐 경우
//  MGOSound 를 각 프로젝트에서 알맞게 서브클래싱하여 동일한 방법으로 구현한다.
//  ----------------------------------------------------------------------
//
//      =========[ Dependancy  ]=======================
//      @(nonatomic) MGOSoundDefault sound;
//                   ════╤════════════════
//  ┌─────── .soundTink ─┘
//  │
//  │   =========[ View/Control ]=======================
//  │   뷰/컨트롤 등에서 사운드를 사용하기 위해서는 주입받아야 한다.
//  └─▶ @(nonatomic, nullable) MGRSoundPlayBlock actionSound;
//      - (IBAction)action:(id)sender {
//          if (_actionSound){_actionSound();}
//      }
//

#import <Foundation/Foundation.h>
@import BaseKit;
@class MGOSoundDefault, MGOSoundKeyboard, MGOSoundPicker, MGOSoundRuler;

NS_ASSUME_NONNULL_BEGIN

// 사운드 재생 컨테이너 추상 클래스
@interface MGOSound : NSObject
@property (class, nonatomic) BOOL soundON;  // 기본값 YES.
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle;
// IosRes/MacRes 번들 기준으로 사운드 객체 생산
@property (class, nonatomic, readonly) MGOSoundDefault *defaultSound;
@property (class, nonatomic, readonly) MGOSoundKeyboard *keyBoardSound;
@property (class, nonatomic, readonly) MGOSoundPicker *pickerSound;
@property (class, nonatomic, readonly) MGOSoundRuler *rulerSound;
@end


// 일반 효과음
static MARSound const MARSoundTink          = @"sound_tink.caf";
static MARSound const MARSoundTock          = @"sound_tock.caf";
@interface MGOSoundDefault : MGOSound
@property (nonatomic, readonly) MGRSoundPlayBlock playSoundTink;
@property (nonatomic, readonly) MGRSoundPlayBlock playSoundTock;
@end


// 키보드 효과음
static MARSound const MARSoundKeyPress      = @"sound_key_press_click.caf";
static MARSound const MARSoundKeyDelete     = @"sound_key_press_delete.caf";
static MARSound const MARSoundKeyModifier   = @"sound_key_press_modifier.caf";
@interface MGOSoundKeyboard : MGOSound
@property (nonatomic, readonly) MGRSoundPlayBlock playSoundKeyPress;
@property (nonatomic, readonly) MGRSoundPlayBlock playSoundKeyDelete;
@property (nonatomic, readonly) MGRSoundPlayBlock playSoundKeyModifier;
@end


// 피커 효과음
static MARSound const MARSoundTick          = @"sound_wheels_of_time.caf";
@interface MGOSoundPicker : MGOSound
@property (nonatomic, readonly) MGRSoundPlayBlock playSoundTick;
@end


// 줄자 효과음
static MARSound const MARSoundRolling       = @"WorkoutResumedAutoDetect.caf";
static MARSound const MARSoundTickHaptic    = @"WorkoutSelect_Haptic.caf";
@interface MGOSoundRuler : MGOSound
- (MGRSoundPlayBlock)playSoundRolling;
- (MGRSoundPlayBlock)playSoundTickHaptic;
@end


NS_ASSUME_NONNULL_END
