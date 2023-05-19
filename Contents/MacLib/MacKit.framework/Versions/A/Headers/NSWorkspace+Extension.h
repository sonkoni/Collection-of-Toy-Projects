//
//  NSWorkspace+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-22
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * MGRAppBundleIdentifier NS_TYPED_EXTENSIBLE_ENUM;
static MGRAppBundleIdentifier const MGRAppBundleIdentifierSafari = @"com.apple.safari";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierCalculator = @"com.apple.calculator";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierMail = @"com.apple.mail";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierNotes = @"com.apple.notes";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierTextEdit = @"com.apple.textedit";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierPhotos = @"com.apple.photos";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierMusic = @"com.apple.music";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierReminders = @"com.apple.reminders";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierFaceTime = @"com.apple.facetime";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierTerminal = @"com.apple.terminal";
static MGRAppBundleIdentifier const MGRAppBundleIdentifierPreview = @"com.apple.preview";

@interface NSWorkspace (Extension)

+ (void)mgrLaunchWithIdentifier:(MGRAppBundleIdentifier)identifier; // identifier에 해당하는 앱을 론치한다.

// Mac에 존재하는 특정 파일(폴더)를 파인더에서 연다.
// @"/System/Library/Desktop Pictures/Big Sur Graphic.heic"
+ (void)mgrLaunchFinderWithFilePath:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-09-22 : 라이브러리 정리됨
*/
