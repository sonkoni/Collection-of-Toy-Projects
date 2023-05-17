//
//  NSURL+Filename.h
//
//  Created by Kwan Hyun Son on 2020/11/14.
//
// https://stackoverflow.com/questions/35222425/get-favicon-co-from-wkwebview
// https://github.com/will-lumley/FaviconFinder/

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define MGR_UNI_COLOR NSColor
#define MGEImage NSImage
#define MGR_UNI_VIEW NSView
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define MGR_UNI_COLOR UIColor
#define MGEImage UIImage
#define MGR_UNI_VIEW UIView
#endif

@class UTType;

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Filename)

/// Hashed filename from remote url path
- (NSString * _Nullable)mgrFilename;

/**
 * @brief URL에 해당하는 객체가 몇 KB 바이트인지. 문자열로 반환한다.
 * @param countStyle 1000 bytes를 1 KB 로 할지 1024 bytes를 1 KB 로 할지의 결정. 보통 NSByteCountFormatterCountStyleFile를 쓰는듯.
 * @discussion ...
 * @remark ...
 * @code
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *url = [mainBundle URLForResource:@"sampeImage" withExtension:@"png"]; // Assets.xcassets에 넣지 않았을 때.
        NSString *byteCount = [url mgrByteCountWithCountStyle:NSByteCountFormatterCountStyleFile];
        NSLog(@"My Image Size ・ %@", byteCount);
 
        Output ==> My Image Size ・ 181 KB
 * @endcode
 * @return KB 바이트인지를 나타내는 문자열
*/
- (NSString * _Nullable)mgrByteCountWithCountStyle:(NSByteCountFormatterCountStyle)countStyle;

//! (주의) URL 접근 관련 샌드박싱 문제로 테스트 용도로만 사용할 것
//! NSURL *url = [NSURL URLWithString:@"https://www.youtube.com"];
//! UIImage *webFavIcon = [url mgrWebFavIcon];
//! 웹사이트의 대표 아이콘 이미지를 반환한다.
- (MGEImage * _Nullable)mgrWebFavIcon;


//! 애플 샘플코드에서 가져왔다. Navigating Hierarchical Data Using Outline and Split Views
//! https://developer.apple.com/documentation/appkit/cocoa_bindings/navigating_hierarchical_data_using_outline_and_split_views?language=objc
// Returns true if this URL is a file system container (packages aren't containers).
- (BOOL)mgrIsFolder;

// Returns true if this URL points to an image file.
- (BOOL)mgrIsImage;

// Returns UTType fileType.identifier를 해서 스트링을 사용할 수도 있다.
- (UTType * _Nullable)mgrFileType;

- (BOOL)mgrIsHidden;

#if TARGET_OS_OSX
- (NSImage * _Nullable)mgrIcon;
#endif

// Returns the human-visible localized name.
- (NSString *)mgrLocalizedName;

- (NSString *)mgrFileSizeString;

- (NSDate * _Nullable)mgrCreationDate;

- (NSDate * _Nullable)mgrModificationDate;

// Returns the localized kind string.
- (NSString *)mgrKind;
@end


@interface NSURL (FileLocation)
#if TARGET_OS_OSX
// Macintosh HD > System > Library > Desktop Pictures
+ (NSURL *)mgrDesktopPicturesFolder;
#endif

// AppSandBox/Documents
// 이 디렉토리는 마치 영구 저장소같이 사용할 수 있고, 아이클라우드 백업 시 자동으로 백업이 함께 된다.
// 보통은 사용자가 앱을 사용하면서 필요한 내용을 저장하거나 사용자가 생성한 데이터를 저장하게 된다.
// 사용자가 생성한 파일이 아니라 앱에서 이 디렉토리를 활용하게 되면 심사거부될 수 있다. 주의해야 한다.
// mac: file:///Users/_USER_/Library/Containers/_APP_BUNDLE_ID_/Data/Documents/
// ios: file:///...Devices.../_UUID_/data/Containers/Data/Application/_APP_UUID_/Documents/
+ (NSURL *)mgrAppDocumentsURL;

// AppSandBox/Library/Caches
// 이 디렉토리는 사용자가 선별(아이템 구매 또는 잡지 구매 같이)적으로 저장할 수 있고, 클라우드 백업 역시 선별적으로 가능하다.
// 보통은 추가 구매 콘텐츠나 웹 등에서 임시적으로 이미지, 동영상, pdf 등의 파일을 저장하기도 하고 기간을 두고 해제하기도 한다.
// mac: file:///Users/_USER_/Library/Containers/_APP_BUNDLE_ID_/Data/Library/Caches/
// ios: file:///...Devices.../_UUID_/data/Containers/Data/Application/_APP_UUID_/Library/Caches/
+ (NSURL *)mgrAppCachesURL;

// AppSandBox/Library/Application Support
// 이 디렉토리는 앱에서 자체적으로 필요한 파일을 저장하기 위해 사용한다.
// 보통 DB 파일이 저장된다. 코어데이터 파일은 반드시 이 디렉토리에 저장해야 한다.
// 이 디렉토리는 자동생성되지 않으므로, 호출 시 없으면 생성될 수 있게 옵션을 YES 로 두었다.
// mac: file:///Users/_USER_/Library/Containers/_APP_BUNDLE_ID_/Data/Library/Application%20Support/
// ios: file:///...Devices.../_UUID_/data/Containers/Data/Application/_APP_UUID_/Library/Application%20Support/
+ (NSURL *)mgrAppSupportURL;

// AppSandBox/tmp
// 이 디렉토리는 일시적으로 사용하게 되는 곳으로, 클라우드 백업과는 무관한 폴더다.
// 잠시 보여주기 위해서 저장한 파일이나 일회성으로 소비되는 리소스를 저장한다.
// mac: file:///var/folders/y1/w2ckp19x687413637gy6m0z80000gp/T/_APP_BUNDLE_ID_/
// ios: file:///...Devices.../_UUID_/data/Containers/Data/Application/_APP_UUID_/tmp/
+ (NSURL *)mgrAppTempURL;

@end

NS_ASSUME_NONNULL_END

#undef MGR_UNI_COLOR
#undef MGEImage
#undef MGR_UNI_VIEW
