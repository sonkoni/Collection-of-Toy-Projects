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


/**
 // https://stackoverflow.com/questions/19082082/converting-nsdata-to-nsurl-nil-string-parameter
 // Asset을 이용하여 등록하는 방법. 방법만 알아두고 사용은 하지말자. Asset에 해당하는 것을 가져와 요리하는 방법을 숙지하자.
- (void)enrollTinkSound {
    if (_keyPressDeleteSoundID != 0) { return; }
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSArray <NSString *>*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                     NSUserDomainMask, // iOS 에서는 인자가 항상 이 값
                                                                     YES); // iOS 에서는 인자가 항상 이 값
    NSString *documentsDirectory = paths.firstObject; // iOS에서는 배열 요소의 값이 항상 한 개.
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"key_press_delete.caf"];
    NSDataAsset *dataAsset = [[NSDataAsset alloc] initWithName:@"key_press_delete"];
    [defaultFileManager createFileAtPath:fullPath contents:dataAsset.data attributes:nil];
    
    if ([defaultFileManager fileExistsAtPath:fullPath] == YES) {
        NSURL *inFileURL = [NSURL fileURLWithPath:fullPath isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)inFileURL, &(_keyPressDeleteSoundID));
    } else {
        NSCAssert(FALSE, @"Sound File NotFound!");
    }
}

 // Asset을 이용하여 등록하는 방법. 방법만 알아두고 사용은 하지말자.
- (void)enrollTinkSound {
    if (_keyPressDeleteSoundID != 0) { return; }
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [defaultFileManager URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask].firstObject;
    documentsDirectory = [documentsDirectory URLByAppendingPathComponent:@"key_press_delete.caf"];
    NSString *fullPath = [documentsDirectory path];
    NSDataAsset *dataAsset = [[NSDataAsset alloc] initWithName:@"key_press_delete"];
    
    [defaultFileManager createFileAtPath:fullPath contents:dataAsset.data attributes:nil];
    if ([defaultFileManager fileExistsAtPath:fullPath] == YES) {
        NSURL *inFileURL = [NSURL fileURLWithPath:fullPath isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)inFileURL, &(_keyPressDeleteSoundID));
    } else {
        NSCAssert(FALSE, @"Sound File NotFound!");
    }
}
*/
