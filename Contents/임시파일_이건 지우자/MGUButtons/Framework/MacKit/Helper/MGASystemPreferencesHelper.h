//
//  MGRXXX.h
//  MGRGradientProject
//
//  Created by Kwan Hyun Son on 2022/11/16.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SystemPreferencesID : 안되는 것도 존재한다.
typedef NSString * MGASystemPreferencesID NS_TYPED_EXTENSIBLE_ENUM;
extern MGASystemPreferencesID const notifications_id;
extern MGASystemPreferencesID const notifications_notifications_id;
extern MGASystemPreferencesID const notifications_focus_id;

extern MGASystemPreferencesID const security_id;
extern MGASystemPreferencesID const security_General_id;
extern MGASystemPreferencesID const security_FileVault_id;
extern MGASystemPreferencesID const security_Firewall_id;
extern MGASystemPreferencesID const security_Advanced_id;
extern MGASystemPreferencesID const security_Privacy_id;
extern MGASystemPreferencesID const security_Privacy_Accessibility_id;
extern MGASystemPreferencesID const security_Privacy_AllFiles_id;
extern MGASystemPreferencesID const security_Privacy_Advertising_id;
extern MGASystemPreferencesID const security_Privacy_Assistive_id;
extern MGASystemPreferencesID const security_Privacy_Automation_id;
extern MGASystemPreferencesID const security_Privacy_Calendars_id;
extern MGASystemPreferencesID const security_Privacy_Camera_id;
extern MGASystemPreferencesID const security_Privacy_Contacts_id;
extern MGASystemPreferencesID const security_Privacy_DiagnosticsSage_id;
extern MGASystemPreferencesID const security_Privacy_Facebook_id;
extern MGASystemPreferencesID const security_Privacy_LinkedIn_id;
extern MGASystemPreferencesID const security_Privacy_LocationServices_id;
extern MGASystemPreferencesID const security_Privacy_Microphone_id;
extern MGASystemPreferencesID const security_Privacy_Photos_id;
extern MGASystemPreferencesID const security_Privacy_Reminders_id;
extern MGASystemPreferencesID const security_Privacy_TencentWeibo_id;
extern MGASystemPreferencesID const security_Privacy_Twitter_id;
extern MGASystemPreferencesID const security_Privacy_Weibo_id;

extern MGASystemPreferencesID const sharing_id;
extern MGASystemPreferencesID const sharing_Screen_Sharing_id;
extern MGASystemPreferencesID const sharing_File_Sharing_id;
extern MGASystemPreferencesID const sharing_Printer_Sharing_id;
extern MGASystemPreferencesID const sharing_Remote_Login_id;
extern MGASystemPreferencesID const sharing_Remote_Management_id;
extern MGASystemPreferencesID const sharing_Remote_AppleEvents_id;
extern MGASystemPreferencesID const sharing_Internet_Sharing_id;
extern MGASystemPreferencesID const sharing_Bluetooth_Sharing_id;

extern MGASystemPreferencesID const softwareupdate_id;

extern MGASystemPreferencesID const speech_id;
extern MGASystemPreferencesID const speech_Dictation_id;
extern MGASystemPreferencesID const speech_Siri_id;

extern MGASystemPreferencesID const password_id;

extern MGASystemPreferencesID const universalaccess_id;
extern MGASystemPreferencesID const universalaccess_Display_id;
extern MGASystemPreferencesID const universalaccess_Zoom_id;
extern MGASystemPreferencesID const universalaccess_VoiceOver_id;
extern MGASystemPreferencesID const universalaccess_Descriptions_id;
extern MGASystemPreferencesID const universalaccess_Captions_id;
extern MGASystemPreferencesID const universalaccess_Audio_id;
extern MGASystemPreferencesID const universalaccess_Keyboard_id;
extern MGASystemPreferencesID const universalaccess_MouseTrackpad_id;
extern MGASystemPreferencesID const universalaccess_SwitchControl_id;
extern MGASystemPreferencesID const universalaccess_Dictation_id;

//! 안되는 것. - 예를 들어 2개만 해봤다. 아래 사이트에서 안되는 패널을 확인할 수 있다.
//! https://www.mbsplugins.de/archive/2020-04-05/MacOS_System_Preference_Links
/* 세부 앵커는 아래의 코드로 확인할 수 있다.
tell application "System Preferences"
    get the name of every anchor of pane id "com.apple.preference.sound"
end tell
// All Output ==> {"effects", "input", "output"}
 */
extern MGASystemPreferencesID const sound_id;
extern MGASystemPreferencesID const sound_effects_id;
extern MGASystemPreferencesID const sound_input_id;
extern MGASystemPreferencesID const sound_output_id;
extern MGASystemPreferencesID const desktopscreeneffect_id;
extern MGASystemPreferencesID const desktopscreeneffect_ScreenSaverPref_HotCorners_id;
extern MGASystemPreferencesID const desktopscreeneffect_DesktopPref_id;
extern MGASystemPreferencesID const desktopscreeneffect_ScreenSaverPref_id;


#pragma mark - File URL : 파일 URL로 대문 접근하기 : 대문까지만 가능함.
typedef NSString * MGASystemPreferencesFileURLStr NS_TYPED_EXTENSIBLE_ENUM;
extern MGASystemPreferencesFileURLStr const Accounts;
extern MGASystemPreferencesFileURLStr const Appearance;
extern MGASystemPreferencesFileURLStr const AppleIDPrefPane;
extern MGASystemPreferencesFileURLStr const Battery;
extern MGASystemPreferencesFileURLStr const Bluetooth;
extern MGASystemPreferencesFileURLStr const ClassKitPreferencePane;
extern MGASystemPreferencesFileURLStr const ClassroomSettings;
extern MGASystemPreferencesFileURLStr const DateAndTime;
extern MGASystemPreferencesFileURLStr const DesktopScreenEffectsPref;
extern MGASystemPreferencesFileURLStr const DigiHubDiscs;
extern MGASystemPreferencesFileURLStr const Displays;
extern MGASystemPreferencesFileURLStr const Dock;
extern MGASystemPreferencesFileURLStr const EnergySaver;
extern MGASystemPreferencesFileURLStr const EnergySaverPref;
extern MGASystemPreferencesFileURLStr const Expose;
extern MGASystemPreferencesFileURLStr const Extensions;
extern MGASystemPreferencesFileURLStr const FamilySharingPrefPane;
extern MGASystemPreferencesFileURLStr const FibreChannel;
extern MGASystemPreferencesFileURLStr const InternetAccounts;
extern MGASystemPreferencesFileURLStr const Keyboard;
extern MGASystemPreferencesFileURLStr const Mouse;
extern MGASystemPreferencesFileURLStr const Network;
extern MGASystemPreferencesFileURLStr const Notifications;
extern MGASystemPreferencesFileURLStr const Passwords;
extern MGASystemPreferencesFileURLStr const PrintAndFax;
extern MGASystemPreferencesFileURLStr const PrintAndScan;
extern MGASystemPreferencesFileURLStr const Profiles;
extern MGASystemPreferencesFileURLStr const ScreenTime;
extern MGASystemPreferencesFileURLStr const Security;
extern MGASystemPreferencesFileURLStr const SharingPref;
extern MGASystemPreferencesFileURLStr const SoftwareUpdate;
extern MGASystemPreferencesFileURLStr const Sound;
extern MGASystemPreferencesFileURLStr const Speech;
extern MGASystemPreferencesFileURLStr const Spotlight;
extern MGASystemPreferencesFileURLStr const StartupDisk;
extern MGASystemPreferencesFileURLStr const TimeMachine;
extern MGASystemPreferencesFileURLStr const TouchID;
extern MGASystemPreferencesFileURLStr const Trackpad;
extern MGASystemPreferencesFileURLStr const UniversalAccessPref;
extern MGASystemPreferencesFileURLStr const Wallet;


#pragma mark - Apple Script : 가장 수행능력이 뛰어나다
typedef NSString * MGASystemPreferencesScptName NS_TYPED_EXTENSIBLE_ENUM;
extern MGASystemPreferencesScptName const DesktopPref; // Desktop & Screen Saver
extern MGASystemPreferencesScptName const ScreenSaverPref; // Desktop & Screen Saver
extern MGASystemPreferencesScptName const ScreenSaverPref_HotCornersPref; // Desktop & Screen Saver
extern MGASystemPreferencesScptName const soundEffectsPref; // Sound
extern MGASystemPreferencesScptName const soundOutputPref; // Sound
extern MGASystemPreferencesScptName const soundInputPref; // Sound
extern MGASystemPreferencesScptName const notifications; // Notifications & Focus
extern MGASystemPreferencesScptName const notificationsFocus; // Notifications & Focus

//! https://developer.apple.com/documentation/devicemanagement/systempreferences?language=objc
//!-------  Apple ID - 앵커 : {"com.apple.AppleMediaServicesUI.SpyglassPurchases", "AppleAccount", "iCloud"}
// com.apple.preferences.AppleIDPrefPane

//!-------  Family Sharing - 앵커 : {"iCloud"}
// com.apple.preferences.FamilySharingPrefPane

//!-------  General - 앵커 : {"Handoff", "Main"} - Main 만 쓰면 될듯.
// com.apple.preference.general

//!-------  Dock & Menu Bar - 앵커 : {"Bluetooth", "Siri", "WiFi", "Clock", "Battery", "ScreenMirroring", "Display", "FocusModes", "NowPlaying", "Sound", "Spotlight", "KeyboardBrightness", "Dock", "DoNotDisturb", "AirDrop", "AccessibilityShortcuts", "TimeMachine", "UserSwitcher"}
// com.apple.preference.dock

//!-------  Mission Control - 앵커 : {"Spaces", "Main"}
// com.apple.preference.expose

//!-------  Siri - 앵커 : {"Dictation", "Siri"} - Siri 만 쓰면 될듯.
// com.apple.preference.speech

//!-------  Spotlight - 앵커 : {"privacy", "searchResults"}
// com.apple.preference.spotlight

//!-------  Language & Region - 앵커 : {"Language", "Region", "Translation"}
// com.apple.Localization

//!-------  Internet Accounts - 앵커 : {"com.apple.account.Google", "com.apple.account.aol", "com.apple.account.126", "com.apple.account.163", "com.apple.account.qq", "com.apple.account.Exchange", "com.apple.account.Yahoo", "InternetAccounts"}
// com.apple.preferences.internetaccounts

//!-------  Users & Groups - 앵커 : {"mobilityPref", "loginOptionsPref", "startupItemsPref", "passwordPref"}
// com.apple.preferences.users

//!-------  Accessibility - 앵커 : {"Accessibility_Shortcut", "Seeing_Cursor", "Seeing_Zoom", "Keyboard", "Seeing_VoiceOver", "Virtual_Keyboard", "TextToSpeech", "Dwell", "Dictation", "Switch", "Siri", "Alternate_Pointer_Actions", "Full_Keyboard_Access", "Mouse", "Captioning", "Media_Descriptions", "Head_Pointer", "General", "Seeing_ColorFilters", "Seeing_Display", "Hearing"}
// com.apple.preference.universalaccess

//!-------  Screen Time - 앵커 : {"CommunicationLimit", "Requests", "DailyNotifications", "Options", "WeeklyUsage", "DailyPickups", "Downtime", "DailyUsage", "AlwaysAllowed", "ContentAndPrivacy", "WeeklyNotifications", "ViewUsageLimit", "WeeklyPickups"}
// com.apple.preference.screentime

//!-------  Extensions - 앵커 : {"Extensions"}
// com.apple.preferences.extensions

//!-------  Security & Privacy - 앵커 : {"Privacy_Microphone", "Privacy_Reminders", "Privacy_Calendars", "Firewall", "Privacy_Assistive", "Privacy_LocationServices", "Privacy_Contacts", "General", "Advanced", "Privacy_Accessibility", "Privacy_Camera", "Privacy_SystemServices", "FDE", "Privacy", "Privacy_AllFiles"}
// com.apple.preference.security

//!-------  Softwareupdate - 앵커 : {"SoftwareUpdate"}
// com.apple.preferences.softwareupdate

//!-------  Network - 앵커 : {"VPN", "PPP", "Bluetooth", "Advanced Ethernet", "DNS", "Advanced VPN", "WINS", "6to4", "Bond", "Ethernet", "WWAN", "Advanced Modem", "Proxies", "Advanced Wi-Fi", "Modem", "VLAN", "PPPoE", "TCP/IP", "802.1X", "FireWire", "VPN on Demand", "Wi-Fi"}
// com.apple.preference.network

//!-------  Bluetooth - 앵커 : {"Main"}
// com.apple.preferences.Bluetooth

//!-------  Touch ID - 앵커 : {"TouchID"}
// com.apple.preferences.password

//!-------  Keyboard - 앵커 : {"InputSources", "shortcutsTab", "keyboardTab_ModifierKeys", "keyboardTab", "Text", "Dictation"}
// com.apple.preference.keyboard

//!-------  Trackpad - 앵커 : {"trackpadTab"}
// com.apple.preference.trackpad

//!-------  Mouse - 앵커 : {"mouseTab"}
// com.apple.preference.mouse

//!-------  Displays - 앵커 : {"displaysDisplayTab", "displaysNightShiftTab", "universalControlTab", "displaysArrangementTab", "displaysColorTab", "displaysGeometryTab"}
// com.apple.preference.displays

//!-------  Printers & Scanners - 앵커 : {"scan", "fax", "print", "share"}
// com.apple.preference.printfax

//!-------  Battery - 앵커 : {"schedule", "currentSource", "usage", "adapter", "battery", "ups"}
// com.apple.preference.battery

//!-------  Date & Time - 앵커 : {"DateTimePref", "TimeZonePref"}
// com.apple.preference.datetime

//!-------  Sharing - 앵커 : {"Internet", "Services_PersonalFileSharing", "Services_ARDService", "Services_DVDorCDSharing", "Services_WindowsSharing", "Services_AirPlayReceiver", "Services_RemoteLogin", "Main", "Services_PrinterSharing", "Services_ContentCaching", "Services_RemoteAppleEvent", "Services_ScreenSharing"}
// com.apple.preferences.sharing

//!-------  Time Machine - 앵커 : {"main"}
// com.apple.prefs.backup

//!-------  Startupdisk - 앵커 : {"StartupSearchGroup"}
// com.apple.preference.startupdisk


@interface NSWorkspace (SystemPreferences)
+ (void)mgrOpenSystemPreferencesWithID:(MGASystemPreferencesID)identifier; // 세부적으로 갈 수 있지만, 못가는 곳도 존재한다.
+ (void)mgrOpenSystemPreferencesWithFileURLStr:(MGASystemPreferencesFileURLStr)fileURLStr; // 모든 대문까지만 가능하다.
@end


/*
 entitlements에서 다음과 같이 설정해야할듯. Explain0.png 참고하자.
<key>com.apple.security.scripting-targets</key>
<dict>
    <key>com.apple.systempreferences</key>
    <array>
        <string>preferencepane.reveal</string>
    </array>
</dict>

Entitlements File                                   Dictionary
    com.apple.security.scripting-targets            Dictionary
        com.apple.systempreferences                 Array
            Item 0                                  String          preferencepane.reveal
    Apple Events                                    Boolean         YES
    App Sandbox                                     Boolean         YES

### XXX.scpt 파일의 Target도 설정하라.
*/
@interface NSAppleScript (SystemPreferences)

/*!
 * @abstract    Apple Script 파일을 통해 시스템 환경설정의 특정 영역으로 이동한다.
 * @discussion  entitlements 설정이 반드시 필요하다. 설명을 참고하라.
 */
+ (void)mgrOpenPreferences:(MGASystemPreferencesScptName)scptName;
@end


#pragma mark - DEPRECATED_ATTRIBUTE
//! 아래 함수 내가 잘못 만들었다. 샌드박스 적용안되며, 유저가 특정 폴더에 넣은것만 read 가능하다. 이것은 좀 더 고급기능이 들어간 앱에서 사용해야한다.
//! Macintosh HD > Users > kwanhyunson > Library > Application Scripts 폴더에 유저가 직접 넣었다는 가정하에 (Sandboxing을 벗어남) 했던, 방법 이었다.
//! apple script 이용. 됨(샌드박스도 적용 안됨.). set 은 승인을 요구하지만, reveal 까지는 무방하다.
void MGROpenPreferences(MGASystemPreferencesScptName scptName, void(^_Nullable errorHandlerBlock)(void)) DEPRECATED_ATTRIBUTE;

NS_ASSUME_NONNULL_END
