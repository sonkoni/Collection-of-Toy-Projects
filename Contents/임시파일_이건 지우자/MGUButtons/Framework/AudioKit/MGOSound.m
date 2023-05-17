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
}
- (void)dealloc {
    MGOSoundDispose(&_tinkSoundID);
    MGOSoundDispose(&_tockSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MASSoundTink, &_tinkSoundID);
        MGOSoundEnroll(bundle, MASSoundTock, &_tockSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundTink {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _tinkSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundTock {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _tinkSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
@end



#pragma mark - 키보드 효과음
@implementation MGOSoundKeyboard {
    SystemSoundID _keyPressSoundID;
    SystemSoundID _keyDeleteSoundID;
    SystemSoundID _keyModifierSoundID;
}
- (void)dealloc {
    MGOSoundDispose(&_keyPressSoundID);
    MGOSoundDispose(&_keyDeleteSoundID);
    MGOSoundDispose(&_keyModifierSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MASSoundKeyPress, &_keyPressSoundID);
        MGOSoundEnroll(bundle, MASSoundKeyDelete, &_keyDeleteSoundID);
        MGOSoundEnroll(bundle, MASSoundKeyModifier, &_keyModifierSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundKeyPress {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _keyPressSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundKeyDelete {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _keyDeleteSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundKeyModifier {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _keyModifierSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
@end



#pragma mark - 피커 효과음
@implementation MGOSoundPicker {
    SystemSoundID _tickSoundID;
}
- (void)dealloc {
    MGOSoundDispose(&_tickSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MASSoundTick, &_tickSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundTick {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _tickSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
@end




#pragma mark - 줄자 효과음
@implementation MGOSoundRuler {
    SystemSoundID _rollingSoundID;
    SystemSoundID _tickHapticSoundID;
}
- (void)dealloc {
    MGOSoundDispose(&_rollingSoundID);
    MGOSoundDispose(&_tickHapticSoundID);
}
- (instancetype)initWithBundle:(NSBundle * _Nullable)bundle {
    self = [super initWithBundle:bundle];
    if (self) {
        MGOSoundEnroll(bundle, MASSoundRolling, &_rollingSoundID);
        MGOSoundEnroll(bundle, MASSoundTickHaptic, &_tickHapticSoundID);
    }
    return self;
}
- (MGRSoundPlayBlock)playSoundRolling {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _rollingSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
- (MGRSoundPlayBlock)playSoundTickHaptic {
    static MGRSoundPlayBlock _playBlock;
    if (_playBlock) {return _playBlock;}
    SystemSoundID soundID = _tickHapticSoundID;
    return _playBlock = ^{MGOSoundSystemPlay(soundID);};
}
@end
