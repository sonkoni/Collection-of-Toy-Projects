//  NSImage+Etc.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-10
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (Etc)

//! id 형으로 해야 컴파일 경고 및 다양한 문제를 피해갈 수 있다.
/*
 CALayer *somelayer = [CALayer layer];
 somelayer.frame = ...
 somelayer.contents = [NSImage imageWithName:@"SomeImage"].mgrCGImage;
 
 CGImageRef imageRef = (__bridge CGImageRef)([channelsImage mgrCGImage]);
 */
- (id)mgrCGImage;

// - initWithCGImage:size: 가 NSImage 클래스에 존재하지만, 단순히 CGImage로 만들고 싶어서 내가 만들었다.
// https://soooprmx.com/nsimage와-cgimage-변환하는-법/
+ (instancetype)mgrImageWithCGImage:(CGImageRef)cgImage;

+ (instancetype)mgrImageWithCIImage:(CIImage *)ciImage;


/**
 * @brief 번들에서 해당하는 이미지를 가져온다.
 * @param name 이미지의 이름(string)
 * @param bundle 가져올 bundle. nil 이면 메인번들에서 호출한다.
 * @discussion + (nullable NSImage *)imageNamed:(NSImageName)name bundle:(nullable NSBundle *)bundle 해당하는 메서드가 없다.
 * @remark NSColor 객체는 + (NSColor *)colorNamed:(NSColorName)name bundle:(NSBundle *)bundle; 메서드가 존재한다. 따라서 NSColor 및 UIKit과의 일관성을 위해서 만들었다.
 * @code
        NSImage *image = [NSImage mgrImageNamed:@"myImage"
                                         bundle:[NSBundle bundleForClass:[MatrixScreenSaverView class]]];
 * @endcode
 * @return 번들에서 발견되 이미지를 반환한다.
*/
+ (nullable NSImage *)mgrImageNamed:(NSImageName)name bundle:(nullable NSBundle *)bundle;

/**
 * @brief UIImage의 메서드처럼, System
 * @param symbolName ...
 * @param description ...
 * @param configuration ...
 * @discussion ...
 * @remark 참고사이트 https://developer.apple.com/documentation/appkit/nsimagesymbolconfiguration    https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui
 * @code
        NSImageSymbolConfiguration *config = [NSImageSymbolConfiguration configurationWithTextStyle:NSFontTextStyleBody
                                                                                              scale:NSImageSymbolScaleLarge];
        NSArray <NSColor *>*paletteColors = @[[NSColor systemTealColor], [NSColor systemGrayColor]];
        NSImageSymbolConfiguration *paletteColorsConfig = [NSImageSymbolConfiguration configurationWithPaletteColors:paletteColors];
        config = [config configurationByApplyingConfiguration:paletteColorsConfig];
  
        NSImage *image = [NSImage mgrSystemSymbolName:@"highlighter"
                             accessibilityDescription:@"..."
                                    withConfiguration:config];
 * @endcode
 * @return NSImage 인스턴스 객체.
*/
+ (nullable instancetype)mgrSystemSymbolName:(NSString *)symbolName
                    accessibilityDescription:(nullable NSString *)description
                           withConfiguration:(nullable NSImageSymbolConfiguration *)configuration;


//! NSVisualEffectView의 maskImage로 사용할 이미지 뷰를 반환한다. NSVisualEffectView는 layer로 cornerRadius 효과 불가능. NSPopupButton의 MenuItem의 커스텀 뷰에서 셀렉션을 위한 비쥬얼 이팩트 뷰의 라디어스를 위해 사용했다.
+ (NSImage *)mgrMaskWithCornerRadius:(CGFloat)radius;


- (NSData * _Nullable)mgrPNGData;
- (NSData * _Nullable)mgrJPEGDataWithCompressionQuality:(CGFloat)compressionQuality; // 0.0 ~ 1.0
@end

NS_ASSUME_NONNULL_END

//
// https://stackoverflow.com/questions/32042385/nsvisualeffectview-with-rounded-corners
