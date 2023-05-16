//
//  MGASoundStateListener.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGASoundStateListener.h"
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>

NSNotificationName const MGAHardwareVolumeChangeNotification = @"MGAHardwareVolumeChangeNotification";

@interface MGASoundStateListener ()
@property (nonatomic, assign) CGFloat volumeLevel;
@end

@implementation MGASoundStateListener

#pragma mark - 생성 & 소멸
- (void)dealloc {
    self->_hardwareVolumeDetecting = NO;
}

+ (instancetype)sharedSoundManager {
    static MGASoundStateListener *sharedObject = nil;
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startHardwareVolumeDetecting];
            });
        }
    }
}

- (void)startHardwareVolumeDetecting {
    _volumeLevel = [[self class] volume];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        while (TRUE) {
            if (self->_hardwareVolumeDetecting == NO) {
                break;
            }
            self.volumeLevel = [[self class] volume];
        }
    });
}

- (void)setVolumeLevel:(CGFloat)volumeLevel {
    if (_volumeLevel != volumeLevel) {
        NSMutableDictionary <NSKeyValueChangeKey, NSNumber *>*userInfo = [NSMutableDictionary dictionary];
        userInfo[NSKeyValueChangeOldKey] = @(_volumeLevel);
        userInfo[NSKeyValueChangeNewKey] = @(volumeLevel);
        [[NSNotificationCenter defaultCenter] postNotificationName:MGAHardwareVolumeChangeNotification
                                                            object:self
                                                          userInfo:userInfo];
        _volumeLevel = volumeLevel;
    }
}

+ (AudioObjectID)defaultOutputDeviceID {
    // get output device device
    AudioObjectID outputDeviceID = kAudioObjectUnknown;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mScope = kAudioObjectPropertyScopeGlobal;

    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 150000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 120000)
    propertyAOPA.mElement = kAudioObjectPropertyElementMain;
#else
    if (@available(macOS 12.0, iOS 15, *)) {
        propertyAOPA.mElement = kAudioObjectPropertyElementMain;
    } else {
        propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    }
#endif
    
    propertyAOPA.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
    if (!AudioObjectHasProperty(kAudioObjectSystemObject, &propertyAOPA)) {
        NSLog(@"Cannot find default output device!");
        return outputDeviceID;
    }
#else
    if (!AudioHardwareServiceHasProperty(kAudioObjectSystemObject, &propertyAOPA)) {
        NSLog(@"Cannot find default output device!");
        return outputDeviceID;
    }
#endif
    
    UInt32 propertySize = sizeof(AudioObjectID);

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
    status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAOPA, 0, NULL, &propertySize, &outputDeviceID);
#else
    status = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propertyAOPA, 0, NULL, &propertySize, &outputDeviceID);
#endif
    
    if(status) {
        NSLog(@"Cannot find default output device!");
    }
    return outputDeviceID;
}

+ (float)volume {
    Float32 outputVolume;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 150000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 120000)
    propertyAOPA.mElement = kAudioObjectPropertyElementMain;
#else
    if (@available(macOS 12.0, iOS 15, *)) {
        propertyAOPA.mElement = kAudioObjectPropertyElementMain;
    } else {
        propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    }
#endif
    propertyAOPA.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMainVolume;
    propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
    AudioObjectID outputDeviceID = [[self class] defaultOutputDeviceID];
    
    if (outputDeviceID == kAudioObjectUnknown) {
        NSLog(@"Unknown device");
        return 0.0;
    }
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
    if (!AudioObjectHasProperty(outputDeviceID, &propertyAOPA)) {
        NSLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return 0.0;
    }
#else
    if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
        NSLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return 0.0;
    }
#endif
    
    UInt32 propertySize = sizeof(Float32);
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
    status = AudioObjectGetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, &propertySize, &outputVolume);
#else
    status = AudioHardwareServiceGetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, &propertySize, &outputVolume);
#endif
    
    if (status) {
        NSLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return 0.0;
    }
    
    if (outputVolume < 0.0 || outputVolume > 1.0) return 0.0;
    
    return outputVolume;
}

+ (void)setSystemVolumeValue:(Float32)newVolume {
    if (newVolume < 0.0 || newVolume > 1.0) {
        NSLog(@"Requested volume out of range (%.2f)", newVolume);
        return;
    }
    
    UInt32 propertySize = 0;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 150000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 120000)
    propertyAOPA.mElement = kAudioObjectPropertyElementMain;
#else
    if (@available(macOS 12.0, iOS 15, *)) {
        propertyAOPA.mElement = kAudioObjectPropertyElementMain;
    } else {
        propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    }
#endif
    propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    if (newVolume < 0.001) {
        NSLog(@"Requested mute");
        propertyAOPA.mSelector = kAudioDevicePropertyMute;
    } else {
        NSLog(@"Requested volume %.2f", newVolume);
        propertyAOPA.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMainVolume;
    }
    AudioObjectID outputDeviceID = [[self class] defaultOutputDeviceID];
    if (outputDeviceID == kAudioObjectUnknown) {
        NSLog(@"Unknown device"); return;
    }
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
    if (!AudioObjectHasProperty(outputDeviceID, &propertyAOPA)) {
        NSLog(@"Device 0x%0x does not support volume control", outputDeviceID);
        return;
    }
#else
    if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
        NSLog(@"Device 0x%0x does not support volume control", outputDeviceID);
        return;
    }
#endif
    
    Boolean canSetVolume = NO;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
    status = AudioObjectIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetVolume);
#else
    status = AudioHardwareServiceIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetVolume);
#endif
    
    if (status || canSetVolume == NO) {
        NSLog(@"Device 0x%0x does not support volume control", outputDeviceID);
        return;
    }
    if (propertyAOPA.mSelector == kAudioDevicePropertyMute) {
        propertySize = sizeof(UInt32);
        UInt32 mute = 1;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
        status = AudioObjectSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &mute);
#else
        status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &mute);
#endif
    }
    else {
        propertySize = sizeof(Float32);
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
        status = AudioObjectSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &newVolume);
#else
        status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &newVolume);
#endif
        if (status) {
            NSLog(@"Unable to set volume for device 0x%0x", outputDeviceID);
        }
        // make sure we're not muted
        propertyAOPA.mSelector = kAudioDevicePropertyMute;
        propertySize = sizeof(UInt32);
        UInt32 mute = 0;
        

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100
        if (!AudioObjectHasProperty(outputDeviceID, &propertyAOPA)) {
            NSLog(@"Device 0x%0x does not support muting", outputDeviceID);
            return;
        }
        Boolean canSetMute = NO;
        status = AudioObjectIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetMute);
        if (status || !canSetMute) {
            NSLog(@"Device 0x%0x does not support muting", outputDeviceID);
            return;
        }
        status = AudioObjectSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &mute);
#else
        if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
            NSLog(@"Device 0x%0x does not support muting", outputDeviceID);
            return;
        }
        Boolean canSetMute = NO;
        status = AudioHardwareServiceIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetMute);
        if (status || !canSetMute) {
            NSLog(@"Device 0x%0x does not support muting", outputDeviceID);
            return;
        }
        status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, NULL, propertySize, &mute);
#endif
    }
    if (status) {
        NSLog(@"Unable to set volume for device 0x%0x", outputDeviceID);
    }
}

@end
