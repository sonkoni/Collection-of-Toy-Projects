//
//  MGRXXX.m
//  MGRGradientProject
//
//  Created by Kwan Hyun Son on 2022/11/16.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGASystemPreferencesHelper.h"
@import BaseKit;
NSString *base = @"x-apple.systempreferences:";

@implementation NSWorkspace (SystemPreferences)
+ (void)mgrOpenSystemPreferencesWithID:(MGASystemPreferencesID)identifier {
    NSString *fullURLString = [NSString stringWithFormat:@"%@%@", base, identifier];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:fullURLString]]; // + fileURLWithPath: 사용금지
}

+ (void)mgrOpenSystemPreferencesWithFileURLStr:(MGASystemPreferencesFileURLStr)fileURLStr {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:fileURLStr]]; // + URLWithString: 사용금지
}
@end


@implementation NSAppleScript (SystemPreferences)
+ (void)mgrOpenPreferences:(MGASystemPreferencesScptName)scptName {
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSString *path = [[NSBundle mgrMacRes] pathForResource:[scptName stringByDeletingPathExtension]
                                                    ofType:@"scpt"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errorDict];
    returnDescriptor = [scriptObject executeAndReturnError:&errorDict];
    NSLog(@"에러가 있다면 알려주라.. %@", errorDict);
    if (returnDescriptor != NULL) {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType]) {
            // script returned an AppleScript result
            if (cAEList == [returnDescriptor descriptorType]) {
                 // result is a list of other descriptors
            } else {
                // coerce the result to the appropriate ObjC type
            }
        }
    } else {
        // no script result, handle error here
    }
}
@end


#pragma mark - DEPRECATED_ATTRIBUTE
void MGROpenPreferences(MGASystemPreferencesScptName scptName, void(^errorHandlerBlock)(void)) {
    //! 애플 샌드박싱 정책으로 인하여 바로 아래 주석처럼 URL을 호출해서는 안된다.
    //! XXX.entitlements 파일에서 App Sandbox NO로 하면 작동할테지만, 제대로된 해결 방법이 아니다.
    //! NSString *path = [[NSBundle mainBundle] pathForResource:@"ScreenSaverPref" ofType:@"scpt"];
    //! NSURL *url = [NSURL fileURLWithPath:path];
    //!
    //! 그래서 다음과 같이 해결한다.
    //! Explain1.jpg 처럼. Users/$USER/Library/Application Scripts/$PRODUCT_BUNDLE_IDENTIFIER 의 경로에 파일을 카피하고
    //! NSFileManager로 불러오면된다.
    NSError *error = nil;
    NSURL *scriptfileUrl = nil;
    @try {
        NSURL *destinationURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:&error];
        [error mgrMakeExceptionAndThrow];
        scriptfileUrl = [destinationURL URLByAppendingPathComponent:scptName];
        NSLog(@"Linking of scriptfile successful! 에러 객체 => %@", error);
        if (error != nil && errorHandlerBlock != nil) {
            errorHandlerBlock();
        }
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        scriptfileUrl = nil;
    }

    @try {
        //! NSUserScriptTask 가 NSUserAppleScriptTask 보다 더 가볍다. ∵ 수퍼 클래스이므로.
        NSUserScriptTask *task = [[NSUserScriptTask alloc] initWithURL:scriptfileUrl error:&error];
//        NSUserAppleScriptTask *task = [[NSUserAppleScriptTask alloc] initWithURL:scriptfileUrl error:&error]; // 이것도 가능.
        [error mgrMakeExceptionAndThrow];
        NSLog(@"Execution of AppleScript successful! 에러 객체 => %@", error);
        [task executeWithCompletionHandler:^(NSError *error) {
            NSLog(@"뭔일 있어? 에러 객체 => %@", error);
        }];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
//        scriptfileUrl = nil;
    }
}


#pragma mark - SystemPreferencesID : 안되는 것도 존재한다.
MGASystemPreferencesID const notifications_id = @"com.apple.preference.notifications";
MGASystemPreferencesID const notifications_notifications_id = @"com.apple.preference.notifications?Notifications";
MGASystemPreferencesID const notifications_focus_id = @"com.apple.preference.notifications?Focus";
MGASystemPreferencesID const security_id = @"com.apple.preference.security";
MGASystemPreferencesID const security_General_id = @"com.apple.preference.security?General";
MGASystemPreferencesID const security_FileVault_id = @"com.apple.preference.security?FDE";
MGASystemPreferencesID const security_Firewall_id = @"com.apple.preference.security?Firewall";
MGASystemPreferencesID const security_Advanced_id = @"com.apple.preference.security?Advanced";
MGASystemPreferencesID const security_Privacy_id = @"com.apple.preference.security?Privacy";
MGASystemPreferencesID const security_Privacy_Accessibility_id = @"com.apple.preference.security?Privacy_Accessibility";
MGASystemPreferencesID const security_Privacy_AllFiles_id = @"com.apple.preference.security?Privacy_AllFiles";
MGASystemPreferencesID const security_Privacy_Advertising_id = @"com.apple.preference.security?Privacy_Advertising";
MGASystemPreferencesID const security_Privacy_Assistive_id = @"com.apple.preference.security?Privacy_Assistive";
MGASystemPreferencesID const security_Privacy_Automation_id = @"com.apple.preference.security?Privacy_Automation";
MGASystemPreferencesID const security_Privacy_Calendars_id = @"com.apple.preference.security?Privacy_Calendars";
MGASystemPreferencesID const security_Privacy_Camera_id = @"com.apple.preference.security?Privacy_Camera";
MGASystemPreferencesID const security_Privacy_Contacts_id = @"com.apple.preference.security?Privacy_Contacts";
MGASystemPreferencesID const security_Privacy_DiagnosticsSage_id = @"com.apple.preference.security?Privacy_Diagnostics";
MGASystemPreferencesID const security_Privacy_Facebook_id = @"com.apple.preference.security?Privacy_Facebook";
MGASystemPreferencesID const security_Privacy_LinkedIn_id = @"com.apple.preference.security?Privacy_LinkedIn";
MGASystemPreferencesID const security_Privacy_LocationServices_id = @"com.apple.preference.security?Privacy_LocationServices";
MGASystemPreferencesID const security_Privacy_Microphone_id = @"com.apple.preference.security?Privacy_Microphone";
MGASystemPreferencesID const security_Privacy_Photos_id = @"com.apple.preference.security?Privacy_Photos";
MGASystemPreferencesID const security_Privacy_Reminders_id = @"com.apple.preference.security?Privacy_Reminders";
MGASystemPreferencesID const security_Privacy_TencentWeibo_id = @"com.apple.preference.security?Privacy_TencentWeibo";
MGASystemPreferencesID const security_Privacy_Twitter_id = @"com.apple.preference.security?Privacy_Twitter";
MGASystemPreferencesID const security_Privacy_Weibo_id = @"com.apple.preference.security?Privacy_Weibo";
MGASystemPreferencesID const sharing_id = @"com.apple.preferences.sharing";
MGASystemPreferencesID const sharing_Screen_Sharing_id = @"com.apple.preferences.sharing?Services_ScreenSharing";
MGASystemPreferencesID const sharing_File_Sharing_id = @"com.apple.preferences.sharing?Services_PersonalFileSharing";
MGASystemPreferencesID const sharing_Printer_Sharing_id = @"com.apple.preferences.sharing?Services_PrinterSharing";
MGASystemPreferencesID const sharing_Remote_Login_id = @"com.apple.preferences.sharing?Services_RemoteLogin";
MGASystemPreferencesID const sharing_Remote_Management_id = @"com.apple.preferences.sharing?Services_ARDService";
MGASystemPreferencesID const sharing_Remote_AppleEvents_id = @"com.apple.preferences.sharing?Services_RemoteAppleEvent";
MGASystemPreferencesID const sharing_Internet_Sharing_id = @"com.apple.preferences.sharing?Internet";
MGASystemPreferencesID const sharing_Bluetooth_Sharing_id = @"com.apple.preferences.sharing?Services_BluetoothSharing";
MGASystemPreferencesID const softwareupdate_id = @"com.apple.preferences.softwareupdate";
MGASystemPreferencesID const speech_id = @"com.apple.preference.speech";
MGASystemPreferencesID const speech_Dictation_id = @"com.apple.preference.speech?Dictation";
MGASystemPreferencesID const speech_Siri_id = @"com.apple.preference.speech?Siri";
MGASystemPreferencesID const password_id = @"com.apple.preferences.password";
MGASystemPreferencesID const universalaccess_id = @"com.apple.preference.universalaccess";
MGASystemPreferencesID const universalaccess_Display_id = @"com.apple.preference.universalaccess?Seeing_Display";
MGASystemPreferencesID const universalaccess_Zoom_id = @"com.apple.preference.universalaccess?Seeing_Zoom";
MGASystemPreferencesID const universalaccess_VoiceOver_id = @"com.apple.preference.universalaccess?Seeing_VoiceOver";
MGASystemPreferencesID const universalaccess_Descriptions_id = @"com.apple.preference.universalaccess?Media_Descriptions";
MGASystemPreferencesID const universalaccess_Captions_id = @"com.apple.preference.universalaccess?Captioning";
MGASystemPreferencesID const universalaccess_Audio_id = @"com.apple.preference.universalaccess?Hearing";
MGASystemPreferencesID const universalaccess_Keyboard_id = @"com.apple.preference.universalaccess?Keyboard";
MGASystemPreferencesID const universalaccess_MouseTrackpad_id = @"com.apple.preference.universalaccess?Mouse";
MGASystemPreferencesID const universalaccess_SwitchControl_id = @"com.apple.preference.universalaccess?Switch";
MGASystemPreferencesID const universalaccess_Dictation_id = @"com.apple.preference.universalaccess?SpeakableItems";

// 작동하지 않는 것.
MGASystemPreferencesID const sound_id = @"com.apple.preference.sound";
MGASystemPreferencesID const sound_effects_id = @"com.apple.preference.sound?effects";
MGASystemPreferencesID const sound_input_id = @"com.apple.preference.sound?input";
MGASystemPreferencesID const sound_output_id = @"com.apple.preference.sound?output";
MGASystemPreferencesID const desktopscreeneffect_id = @"com.apple.preference.desktopscreeneffect";
MGASystemPreferencesID const desktopscreeneffect_ScreenSaverPref_HotCorners_id = @"com.apple.preference.desktopscreeneffect?ScreenSaverPref_HotCorners";
MGASystemPreferencesID const desktopscreeneffect_DesktopPref_id = @"com.apple.preference.desktopscreeneffect?DesktopPref";
MGASystemPreferencesID const desktopscreeneffect_ScreenSaverPref_id = @"com.apple.preference.desktopscreeneffect?ScreenSaverPref";


#pragma mark - File URL : 파일 URL로 대문 접근하기 : 대문까지만 가능함.
MGASystemPreferencesFileURLStr const Accounts = @"/System/Library/PreferencePanes/Accounts.prefPane";
MGASystemPreferencesFileURLStr const Appearance = @"/System/Library/PreferencePanes/Appearance.prefPane";
MGASystemPreferencesFileURLStr const AppleIDPrefPane = @"/System/Library/PreferencePanes/AppleIDPrefPane.prefPane";
MGASystemPreferencesFileURLStr const Battery = @"/System/Library/PreferencePanes/Battery.prefPane";
MGASystemPreferencesFileURLStr const Bluetooth = @"/System/Library/PreferencePanes/Bluetooth.prefPane";
MGASystemPreferencesFileURLStr const ClassKitPreferencePane = @"/System/Library/PreferencePanes/ClassKitPreferencePane.prefPane";
MGASystemPreferencesFileURLStr const ClassroomSettings = @"/System/Library/PreferencePanes/ClassroomSettings.prefPane";
MGASystemPreferencesFileURLStr const DateAndTime = @"/System/Library/PreferencePanes/DateAndTime.prefPane";
MGASystemPreferencesFileURLStr const DesktopScreenEffectsPref = @"/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane";
MGASystemPreferencesFileURLStr const DigiHubDiscs = @"/System/Library/PreferencePanes/DigiHubDiscs.prefPane";
MGASystemPreferencesFileURLStr const Displays = @"/System/Library/PreferencePanes/Displays.prefPane";
MGASystemPreferencesFileURLStr const Dock = @"/System/Library/PreferencePanes/Dock.prefPane";
MGASystemPreferencesFileURLStr const EnergySaver = @"/System/Library/PreferencePanes/EnergySaver.prefPane";
MGASystemPreferencesFileURLStr const EnergySaverPref = @"/System/Library/PreferencePanes/EnergySaverPref.prefPane";
MGASystemPreferencesFileURLStr const Expose = @"/System/Library/PreferencePanes/Expose.prefPane";
MGASystemPreferencesFileURLStr const Extensions = @"/System/Library/PreferencePanes/Extensions.prefPane";
MGASystemPreferencesFileURLStr const FamilySharingPrefPane = @"/System/Library/PreferencePanes/FamilySharingPrefPane.prefPane";
MGASystemPreferencesFileURLStr const FibreChannel = @"/System/Library/PreferencePanes/FibreChannel.prefPane";
MGASystemPreferencesFileURLStr const InternetAccounts = @"/System/Library/PreferencePanes/InternetAccounts.prefPane";
MGASystemPreferencesFileURLStr const Keyboard = @"/System/Library/PreferencePanes/Keyboard.prefPane";
MGASystemPreferencesFileURLStr const Mouse = @"/System/Library/PreferencePanes/Mouse.prefPane";
MGASystemPreferencesFileURLStr const Network = @"/System/Library/PreferencePanes/Network.prefPane";
MGASystemPreferencesFileURLStr const Notifications = @"/System/Library/PreferencePanes/Notifications.prefPane";
MGASystemPreferencesFileURLStr const Passwords = @"/System/Library/PreferencePanes/Passwords.prefPane";
MGASystemPreferencesFileURLStr const PrintAndFax = @"/System/Library/PreferencePanes/PrintAndFax.prefPane";
MGASystemPreferencesFileURLStr const PrintAndScan = @"/System/Library/PreferencePanes/PrintAndScan.prefPane";
MGASystemPreferencesFileURLStr const Profiles = @"/System/Library/PreferencePanes/Profiles.prefPane";
MGASystemPreferencesFileURLStr const ScreenTime = @"/System/Library/PreferencePanes/ScreenTime.prefPane";
MGASystemPreferencesFileURLStr const Security = @"/System/Library/PreferencePanes/Security.prefPane";
MGASystemPreferencesFileURLStr const SharingPref = @"/System/Library/PreferencePanes/SharingPref.prefPane";
MGASystemPreferencesFileURLStr const SoftwareUpdate = @"/System/Library/PreferencePanes/SoftwareUpdate.prefPane";
MGASystemPreferencesFileURLStr const Sound = @"/System/Library/PreferencePanes/Sound.prefPane";
MGASystemPreferencesFileURLStr const Speech = @"/System/Library/PreferencePanes/Speech.prefPane";
MGASystemPreferencesFileURLStr const Spotlight = @"/System/Library/PreferencePanes/Spotlight.prefPane";
MGASystemPreferencesFileURLStr const StartupDisk = @"/System/Library/PreferencePanes/StartupDisk.prefPane";
MGASystemPreferencesFileURLStr const TimeMachine = @"/System/Library/PreferencePanes/TimeMachine.prefPane";
MGASystemPreferencesFileURLStr const TouchID = @"/System/Library/PreferencePanes/TouchID.prefPane";
MGASystemPreferencesFileURLStr const Trackpad = @"/System/Library/PreferencePanes/Trackpad.prefPane";
MGASystemPreferencesFileURLStr const UniversalAccessPref = @"/System/Library/PreferencePanes/UniversalAccessPref.prefPane";
MGASystemPreferencesFileURLStr const Wallet = @"/System/Library/PreferencePanes/Wallet.prefPane";


#pragma mark - Apple Script : 가장 수행능력이 뛰어나다
MGASystemPreferencesScptName const DesktopPref = @"DesktopPref.scpt";
MGASystemPreferencesScptName const ScreenSaverPref = @"ScreenSaverPref.scpt";
MGASystemPreferencesScptName const ScreenSaverPref_HotCornersPref = @"ScreenSaverPref_HotCornersPref.scpt";
MGASystemPreferencesScptName const soundEffectsPref = @"soundEffectsPref.scpt";
MGASystemPreferencesScptName const soundOutputPref = @"soundOutputPref.scpt";
MGASystemPreferencesScptName const soundInputPref = @"soundInputPref.scpt";
MGASystemPreferencesScptName const notifications = @"notifications.scpt";
MGASystemPreferencesScptName const notificationsFocus = @"notificationsFocus.scpt";
