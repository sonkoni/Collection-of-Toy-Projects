//
//  MGOSound.m
//

#import "MGOSound.h"
#import "MGOSoundHelper.h"

static NSBundle * DefaultBundle(void) {
#if TARGET_OS_OSX
    return NSBundle.mgrMacRes;
#elif TARGET_OS_IPHONE
    return NSBundle.mgrIosRes;
#endif
}

@implementation MGOSound
+ (void)setSoundON:(BOOL)soundON {
    MGOSoundSetOn(soundON);
}
+ (BOOL)soundON {
    return MGOSoundIsOn();
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    return [super init];
}
+ (MGOSoundDefault *)defaultSound {
    return [[MGOSoundDefault alloc] initWithBundle:DefaultBundle()];
}
+ (MGOSoundKeyboard *)keyBoardSound {
    return [[MGOSoundKeyboard alloc] initWithBundle:DefaultBundle()];
}
+ (MGOSoundPicker *)pickerSound {
    return [[MGOSoundPicker alloc] initWithBundle:DefaultBundle()];
}
+ (MGOSoundRuler *)rulerSound {
    return [[MGOSoundRuler alloc] initWithBundle:DefaultBundle()];
}
@end



#pragma mark - 기본 효과음
@implementation MGOSoundDefault {
    SystemSoundID _tinkSoundID;
    SystemSoundID _tockSoundID;
    MGRSoundPlayBlock _playSoundTink;
    MGRSoundPlayBlock _playSoundTock;
}
- (void)dealloc {
    MGOSoundDispose(&_tinkSoundID);
    MGOSoundDispose(&_tockSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MARSoundTink, &_tinkSoundID);
        MGOSoundEnroll(bundle, MARSoundTock, &_tockSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundTink {
    if (_playSoundTink) {return _playSoundTink;}
    SystemSoundID soundID = _tinkSoundID;
    return _playSoundTink = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundTock {
    if (_playSoundTock) {return _playSoundTock;}
    SystemSoundID soundID = _tockSoundID;
    return _playSoundTock = ^{MGOSoundSystemPlay(soundID);};
}
@end



#pragma mark - 키보드 효과음
@implementation MGOSoundKeyboard {
    SystemSoundID _keyPressSoundID;
    SystemSoundID _keyDeleteSoundID;
    SystemSoundID _keyModifierSoundID;
    MGRSoundPlayBlock _playSoundKeyPress;
    MGRSoundPlayBlock _playSoundKeyDelete;
    MGRSoundPlayBlock _playSoundKeyModifier;
}
- (void)dealloc {
    MGOSoundDispose(&_keyPressSoundID);
    MGOSoundDispose(&_keyDeleteSoundID);
    MGOSoundDispose(&_keyModifierSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MARSoundKeyPress, &_keyPressSoundID);
        MGOSoundEnroll(bundle, MARSoundKeyDelete, &_keyDeleteSoundID);
        MGOSoundEnroll(bundle, MARSoundKeyModifier, &_keyModifierSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundKeyPress {
    if (_playSoundKeyPress) {return _playSoundKeyPress;}
    SystemSoundID soundID = _keyPressSoundID;
    return _playSoundKeyPress = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundKeyDelete {
    if (_playSoundKeyDelete) {return _playSoundKeyDelete;}
    SystemSoundID soundID = _keyDeleteSoundID;
    return _playSoundKeyDelete = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundKeyModifier {
    if (_playSoundKeyModifier) {return _playSoundKeyModifier;}
    SystemSoundID soundID = _keyModifierSoundID;
    return _playSoundKeyModifier = ^{MGOSoundSystemPlay(soundID);};
}
@end



#pragma mark - 피커 효과음
@implementation MGOSoundPicker {
    SystemSoundID _tickSoundID;
    MGRSoundPlayBlock _playSoundTick;
}
- (void)dealloc {
    MGOSoundDispose(&_tickSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MARSoundTick, &_tickSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundTick {
    if (_playSoundTick) {return _playSoundTick;}
    SystemSoundID soundID = _tickSoundID;
    return _playSoundTick = ^{MGOSoundSystemPlay(soundID);};
}
@end




#pragma mark - 줄자 효과음
@implementation MGOSoundRuler {
    SystemSoundID _rollingSoundID;
    SystemSoundID _tickHapticSoundID;
    MGRSoundPlayBlock _playSoundRolling;
    MGRSoundPlayBlock _playSoundTickHaptic;
}
- (void)dealloc {
    MGOSoundDispose(&_rollingSoundID);
    MGOSoundDispose(&_tickHapticSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MARSoundRolling, &_rollingSoundID);
        MGOSoundEnroll(bundle, MARSoundTickHaptic, &_tickHapticSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundRolling {
    if (_playSoundRolling) {return _playSoundRolling;}
    SystemSoundID soundID = _rollingSoundID;
    return _playSoundRolling = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundTickHaptic {
    if (_playSoundTickHaptic) {return _playSoundTickHaptic;}
    SystemSoundID soundID = _tickHapticSoundID;
    return _playSoundTickHaptic = ^{MGOSoundSystemPlay(soundID);};
}
@end
