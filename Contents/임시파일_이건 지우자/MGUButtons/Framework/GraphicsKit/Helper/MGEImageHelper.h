//
//  MGEImageHelper.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-08-27
//  ----------------------------------------------------------------------
//

#ifndef MGEImageHelper_h
#define MGEImageHelper_h
#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Resize Algorithm : Asepect Fit으로 한다.
MGEImage * _Nullable MGEResizedImage(NSURL *url, CGSize toSize); // 탑급으로 빠르다.
MGEImage * _Nullable MGEResizedImageImageIO(NSURL *url, CGSize toSize); // 탑급으로 빠르다. <- 이거 추천.
MGEImage * _Nullable MGEResizedImageCoreGraphics(NSURL *url, CGSize toSize); // 적당하다.
MGEImage * _Nullable MGEResizedImageCoreImage(NSURL *url, CGSize toSize); // 제일 느리다.
MGEImage * _Nullable MGEResizedImageVImage(NSURL *url, CGSize toSize); // 두 번째로 느리다.

MGEImage * _Nullable MGEResizedImageDataImageIO(NSData *imageData, CGSize toSize); // data로도 쓸 수 있게 하나 만들었다.
 
#pragma mark - Create : 단순 생성.
CGImageRef _Nullable MGECGImageCreateWithData(NSData *data); // 메모리를 해제해야한다. 컨벤션 이름 규칙 지킴. imageIO 사용함.

CGImagePropertyOrientation MGECGImageOrientationFromImageURL(NSURL *url);
CGImagePropertyOrientation MGECGImageOrientationFromImageSource(CGImageSourceRef imageSource);
CGImagePropertyOrientation MGECGImageOrientationFromImageData(NSData *imageData);
#if TARGET_OS_IPHONE
UIImageOrientation MGEUIImageOrientationFromImageURL(NSURL *url);
UIImageOrientation MGEUIImageOrientationFromImageSource(CGImageSourceRef imageSource);
UIImageOrientation MGEUIImageOrientationFromImageData(NSData *imageData);
#endif

// 픽셀 사이즈로 반환형은 NSInteger로 해석하라.
CGSize MGEPixelSizeFromImageURL(NSURL *url);
CGSize MGEPixelSizeFromImageSource(CGImageSourceRef imageSource);
CGSize MGEPixelSizeFromImageData(NSData *imageData);

BOOL MGEHasAlphaFromImageURL(NSURL *url);
BOOL MGEHasAlphaFromImageSource(CGImageSourceRef imageSource);
BOOL MGEHasAlphaFromImageData(NSData *imageData);
BOOL MGEHasAlphaFromCGImage(CGImageRef cgImage);

//! Simple Helper Function
BOOL MGESwapWidthHeightForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation);
NSString *DescriptionForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation);

#if TARGET_OS_IPHONE
// http://sylvana.net/jpegcrop/exif_orientation.html
// https://developer.apple.com/documentation/imageio/cgimagepropertyorientation?language=objc
UIImageOrientation UIImageOrientationForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation);
CGImagePropertyOrientation CGImagePropertyOrientationForUIImageOrientation(UIImageOrientation uiOrientation);
#endif

// 단순히 UIImage, NSImage -> CGImageRef
CGImageRef _Nullable MGECGImageGetImage(MGEImage *image);
// CFAutorelease된 결과 값을 반환한다. 저장하려면. CGImageRetain(...)

/*!
 * @abstract    반사된 이미지를 만든다. upside down 이미지를 만들어낸다.
 * @discussion  fraction 은 gradient의 clear color 시작점을 의미한다.
 *              alpha 값은 View(또는 layer)에서 처리한다.
 * @note        fraction 0.0 이면 일반적인 모습, 1.0 이면 하나도 안보임.
 * @see         Reflection_koni 프로젝트에서 애플의 알고리즘을 참고했다.
 *              UIKit, AppKit 전용은 MGUReflectionView, MGAReflectionView을 참고하라.
 */
CGImageRef _Nullable MGECreateReflectImageFromOriginalImage(CGImageRef originalImage, CGFloat fraction);

NS_ASSUME_NONNULL_END
#endif /* MGEImageHelper_h */
/* ----------------------------------------------------------------------
 
 * 2022-08-27 : 만들었다.
 */
