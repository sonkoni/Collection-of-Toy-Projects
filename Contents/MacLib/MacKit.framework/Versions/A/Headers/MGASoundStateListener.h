//
//  MGASoundStateListener.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/9147133/detect-when-the-system-volume-changes-on-mac
// http://www.cocoadev.com/index.pl?SoundVolume
// https://codeberg.org/sr-rolando/AudioZen/src/branch/master/Volume.m
// https://www.jianshu.com/p/0f826ace892b
// https://github.com/mabi99/NSSound_SystemVolumeExtension

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 디텍팅하고 싶다면. hardwareVolumeDetecting 를 YES로 설정하라.
extern NSNotificationName const MGAHardwareVolumeChangeNotification;

/*!
 @class         MGASoundStateListener
 @abstract      볼륨을 사용자가 눌러서 변화가 있을 때, 감지하여 노티피케이션을 던져줄 수 있는 클래스이다.
 @discussion    macOS 전용으로 만들었다.
*/
@interface MGASoundStateListener : NSObject

/*!
 @property      hardwareVolumeDetecting
 @abstract      이 프라퍼티를 YES로 설정하면 MGUHardwareVolumeChangeNotification 을 받을 수 있다. 디폴트는 NO이다.
 @discussion    언제든지 NO로 설정하면 노티피케이션이 발동되지 않을 것이다.
 @code
      _listener = [MGUSoundStateListener sharedSoundManager];
      self.listener.hardwareVolumeDetecting = YES;
 
      __weak __typeof(self) weakSelf = self;
      NSNotificationCenter *nc =[NSNotificationCenter defaultCenter];
 
      _hardwareVolumeChangeObserver = [nc addObserverForName:MGAHardwareVolumeChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
          [weakSelf.sound testSoundStop];
          NSDictionary <NSKeyValueChangeKey, NSNumber *> *dictionary = note.userInfo;
          NSNumber *oldOutputVolume = dictionary[NSKeyValueChangeOldKey];
          NSNumber *newOutputVolume = dictionary[NSKeyValueChangeNewKey];
          NSLog(@"oldOutputVolume: %f, newOutputVolume: %f",[oldOutputVolume floatValue], [newOutputVolume floatValue]);
      }];
 
      // nil 시킬 때에는 hardwareVolumeDetecting을 반드시 NO로 설정해야한다.
      self.listener.hardwareVolumeDetecting = NO;
      self.listener = nil;
 
      // 지울 때는 아래와 같이
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc removeObserver:_hardwareVolumeChangeObserver name:MGAHardwareVolumeChangeNotification object:nil];
 @endcode
*/
@property (nonatomic, assign, getter = isHardwareVolumeDetecting) BOOL hardwareVolumeDetecting; // 디폴트 NO.

+ (instancetype)sharedSoundManager; // single tone으로 사용하지 않아도 된다.

+ (float)volume;
+ (void)setSystemVolumeValue:(Float32)newVolume; // modal 로 알려주지는 않는다.
@end

NS_ASSUME_NONNULL_END
