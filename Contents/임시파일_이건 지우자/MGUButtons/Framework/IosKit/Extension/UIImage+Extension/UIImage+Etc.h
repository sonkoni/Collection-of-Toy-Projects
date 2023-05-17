//
//  UIImage+Etc.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-08-24
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

/*!
 @enum       MGRTabBarButtonAnimationType
 @abstract   ......
 @constant   MGRTabBarButtonAnimationTypeGravity     .....
 @constant   MGRTabBarButtonAnimationTypeScale   .....
 @constant   MGRTabBarButtonAnimationTypePerfect   .....
 */
typedef NS_ENUM(NSUInteger, MGUImageExtension) {
    MGUImageExtensionPNG = 1,
    MGUImageExtensionJPEG
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Etc)

//! 본 클래스에 CGImage를 뽑아 주는 image.CGImage 프라퍼티가 존재하지만, Transparency한 배경이 존재할 때, 제거하거 뽑아주는 문제가 존재하여 만들었다. Transparency한 부분까지 살려서 빼준다. 받는 쪽에서 해제 해야한다.
- (CGImageRef)newMgrCGImage;

//! 리시버의 이미지를 인 메모리 상태에서 임시적으로 저장하여 그 URL을 뱉어준다.
- (NSURL *)mgrTempURLWithFileName:(NSString *)fileName withExtension:(MGUImageExtension)extension;

// https://stackoverflow.com/questions/65726433/uiimage-upside-down-when-reconverted-from-string-stored-in-sqlite
- (NSData * _Nullable)mgrPngData;

// 퍼포먼스에 영향을 줄 수 있다.
- (BOOL)mgrIsEqualToImage:(UIImage *)object;

// Returns true if the image has an alpha layer
- (BOOL)mgrHasAlpha;

// NSBundle *bundle = [NSBundle bundleForClass:self.class];
//
// NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"bundleName" withExtension:@"bundle"];
// NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
//
// NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
// NSBundle *bundle = [NSBundle bundleWithPath:bundlePath]
+ (nullable instancetype)mgrImageWithBundle:(NSBundle * _Nullable)bundle // nil 이면 main 번들.
                                   fileName:(NSString * _Nullable)fileName
                                     ofType:(NSString * _Nullable)ext;
@end

NS_ASSUME_NONNULL_END
