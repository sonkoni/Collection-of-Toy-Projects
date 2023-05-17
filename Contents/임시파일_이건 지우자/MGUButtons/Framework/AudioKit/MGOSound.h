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
//  └─▶ @(nonatomic, weak) MGRSoundPlayBlock actionSound;
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
+ (MGOSoundDefault *)defaultSound;
+ (MGOSoundKeyboard *)keyBoardSound;
+ (MGOSoundPicker *)pickerSound;
+ (MGOSoundRuler *)rulerSound;
@end


// 일반 효과음
static MASSound const MASSoundTink          = @"sound_tink.caf";
static MASSound const MASSoundTock          = @"sound_tock.caf";
@interface MGOSoundDefault : MGOSound
- (MGRSoundPlayBlock)playSoundTink;
- (MGRSoundPlayBlock)playSoundTock;
@end


// 키보드 효과음
static MASSound const MASSoundKeyPress      = @"sound_key_press_click.caf";
static MASSound const MASSoundKeyDelete     = @"sound_key_press_delete.caf";
static MASSound const MASSoundKeyModifier   = @"sound_key_press_modifier.caf";
@interface MGOSoundKeyboard : MGOSound
- (MGRSoundPlayBlock)playSoundKeyPress;
- (MGRSoundPlayBlock)playSoundKeyDelete;
- (MGRSoundPlayBlock)playSoundKeyModifier;
@end


// 피커 효과음
static MASSound const MASSoundTick          = @"sound_wheels_of_time.caf";
@interface MGOSoundPicker : MGOSound
- (MGRSoundPlayBlock)playSoundTick;
@end


// 줄자 효과음
static MASSound const MASSoundRolling       = @"WorkoutResumedAutoDetect.caf";
static MASSound const MASSoundTickHaptic    = @"WorkoutSelect_Haptic.caf";
@interface MGOSoundRuler : MGOSound
- (MGRSoundPlayBlock)playSoundRolling;
- (MGRSoundPlayBlock)playSoundTickHaptic;
@end


NS_ASSUME_NONNULL_END
