//
//  MGUSoundStateListener.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//
// https://github.com/jpsim/JPSVolumeButtonHandler

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 디텍팅하고 싶다면. hardwareVolumeDetecting 를 YES로 설정하라.
extern NSNotificationName const MGUHardwareVolumeChangeNotification;

/*!
 @class         MGUSoundStateListener
 @abstract      우선은 아이폰 하드웨어 볼륨을 사용자가 눌러서 변화가 있을 때, 감지하여 노티피케이션을 던져줄 수 있는 클래스이다.
 @discussion    iOS 전용으로 만들었다. Mac OS에서는 사용하지 말자.
*/
@interface MGUSoundStateListener : NSObject

/*!
 @property      hardwareVolumeDetecting
 @abstract      이 프라퍼티를 YES로 설정하면 MGUHardwareVolumeChangeNotification 을 받을 수 있다. 디폴트는 NO이다.
 @discussion    언제든지 NO로 설정하면 노티피케이션이 발동되지 않을 것이다.
 @code
      _soundManager = [MGUSoundStateListener sharedSoundManager];
      self.soundManager.hardwareVolumeDetecting = YES;
 
      __weak __typeof(self) weakSelf = self;
      NSNotificationCenter *nc =[NSNotificationCenter defaultCenter];
 
      _hardwareVolumeChangeObserver = [nc addObserverForName:MGUHardwareVolumeChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
          [weakSelf.sound testSoundStop];
          NSDictionary <NSKeyValueChangeKey, NSNumber *> *dictionary = note.userInfo;
          NSNumber *oldOutputVolume = dictionary[NSKeyValueChangeOldKey];
          NSNumber *newOutputVolume = dictionary[NSKeyValueChangeNewKey];
          NSLog(@"oldOutputVolume: %f, newOutputVolume: %f",[oldOutputVolume floatValue], [newOutputVolume floatValue]);
      }];
 
      // 지울 때는 아래와 같이
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc removeObserver:_hardwareVolumeChangeObserver name:MGUHardwareVolumeChangeNotification object:nil];
 @endcode
*/
@property (nonatomic, assign, getter = isHardwareVolumeDetecting) BOOL hardwareVolumeDetecting; // 디폴트 NO.

+ (instancetype)sharedSoundManager;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
