//
//  MGEImageHelper.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEImageHelper.h"
#import "MGEGeometryHelper.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h> // UTTypeURL
//#import <MobileCoreServices/MobileCoreServices.h> // kUTTypeURL
#import <Accelerate/Accelerate.h> // @import Accelerate;
#import <ImageIO/ImageIO.h>
#if TARGET_OS_IPHONE
#else
static CGSize _getPointSizeFromPixelSize(CGSize PixelSize) {
    return CGSizeMake(PixelSize.width / MGE_MAINSCREEN_SCALE , PixelSize.height / MGE_MAINSCREEN_SCALE);
}
#endif

static CGImagePropertyOrientation __MGECGImageOrientation(NSURL *url, CGImageSourceRef imageSource, NSData *imageData);
static CGSize __MGEPixelSize(NSURL *url, CGImageSourceRef imageSource, NSData *imageData);
static BOOL __MGEHasAlpha(NSURL *url, CGImageSourceRef imageSource, NSData *imageData);

#pragma mark - Resize UIKit AppKit
MGEImage *MGEResizedImage(NSURL *url, CGSize toSize) {
    MGEImage *image = [[MGEImage alloc] initWithContentsOfFile:url.path];
//    [image setScalesWhenResized:YES]; Mac Deprecated
    if (image == nil) { return nil; }
    CGRect frameRect = CGRectMake(0.0, 0.0, toSize.width, toSize.height);
    CGRect imageRect = (CGRect){CGPointZero, image.size};
    CGRect drawRect = MGERectByFittingRect(imageRect, frameRect); // Aspect Fit

#if TARGET_OS_IPHONE
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat preferredFormat];
    format.opaque = NO;
    format.scale = MGE_MAINSCREEN_SCALE;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:drawRect.size format:format];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        [image drawInRect:CGRectMake(0.0, 0.0, drawRect.size.width, drawRect.size.height)];
    }];
    
//    클래식한 방식이다. 이러한 방식이 있다는 것만 기억하자.
//    UIGraphicsBeginImageContextWithOptions(drawRect.size, NO, MGE_MAINSCREEN_SCALE);
//    [image drawInRect:CGRectMake(0.0, 0.0, drawRect.size.width, drawRect.size.height)];
//    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return result;
#else
    NSImage *newImage = [[NSImage alloc] initWithSize:drawRect.size];
    [newImage lockFocus];
//    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [image drawInRect:CGRectMake(0.0, 0.0, drawRect.size.width, drawRect.size.height)];
    [newImage unlockFocus];
    return newImage;

//  이렇게도 할 수는 있다. 그런데, 용량이 더 커버린다.
//    return [NSImage imageWithSize:drawRect.size flipped:NO
//                   drawingHandler:^BOOL(NSRect dstRect) {
//        [image drawInRect:CGRectMake(0.0, 0.0, drawRect.size.width, drawRect.size.height)];
//        return YES;
//    }];
#endif
}

#pragma mark - Resize ImageIO
MGEImage *MGEResizedImageImageIO(NSURL *url, CGSize toSize) {
    if (toSize.width < 1.0 || toSize.height < 1.0) {
        NSCAssert(FALSE, @"좆도 사이즈가 너무 작아.");
        return nil;
    }
    
    CGSize framePixelSize = CGSizeMake(toSize.width * MGE_MAINSCREEN_SCALE, toSize.height * MGE_MAINSCREEN_SCALE);
    NSInteger maxPixelSize = (NSInteger)(MAX(framePixelSize.width, framePixelSize.height));
    
    NSDictionary *imageSourceOptions =
    @{(id)kCGImageSourceShouldCache : (id)kCFBooleanFalse}; // kCFBooleanFalse kCFBooleanTrue
    
    CGSize imagePixelSize = CGSizeZero;
    CGImageSourceRef imageSource =
    CGImageSourceCreateWithURL((__bridge CFURLRef)url, (__bridge CFDictionaryRef)imageSourceOptions);
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    CFNumberRef width = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    CFNumberRef height = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    if (width && height) {
        CFNumberGetValue(width, kCFNumberCGFloatType, &imagePixelSize.width);
        CFNumberGetValue(height, kCFNumberCGFloatType, &imagePixelSize.height);
    }
    if (imageSource == NULL || properties == NULL || width == NULL || height == NULL) {
        if (imageSource != NULL) {CFRelease(imageSource);}
        if (properties != NULL) {CFRelease(properties);}
        return nil;
    }
    CFRelease(properties);
    
    NSMutableDictionary *options =
    @{(id)kCGImageSourceCreateThumbnailWithTransform : (id)kCFBooleanTrue,
      (id)kCGImageSourceCreateThumbnailFromImageAlways: (id)kCFBooleanTrue,
      (id)kCGImageSourceShouldCacheImmediately: (id)kCFBooleanTrue,
      (id)kCGImageSourceThumbnailMaxPixelSize : @(maxPixelSize)}.mutableCopy;
    
    /* Deprecated
    NSString *uti =
    (__bridge_transfer NSString*)UTTypeCreatePreferredIdentifierForTag((__bridge CFStringRef)UTTagClassFilenameExtension,
                                                                       (__bridge CFStringRef)url.pathExtension,
                                                                       (__bridge CFStringRef)UTTypeImage.identifier);
     */
    NSString *uti = [UTType typeWithFilenameExtension:url.pathExtension].identifier;

    if (uti != NULL) {
        options[(id)kCGImageSourceTypeIdentifierHint] = uti;
        if ([uti isEqualToString:UTTypeJPEG.identifier] ||
            [uti isEqualToString:UTTypeTIFF.identifier] ||
            [uti isEqualToString:UTTypePNG.identifier] ||
            [uti hasPrefix:@"public.heif"]) {
            CGFloat ratio = MIN(imagePixelSize.width / framePixelSize.width,
                                imagePixelSize.height / framePixelSize.height);
            // The value of this key must be an integer CFNumberRef (allowed values: 2, 4, and 8).
            if (ratio <= 2.0) {
                options[(id)kCGImageSourceSubsampleFactor] = @(2.0);
            } else if (ratio <= 4.0) {
                options[(id)kCGImageSourceSubsampleFactor] = @(4.0);
            } else {
                options[(id)kCGImageSourceSubsampleFactor] = @(8.0);
            }
        }
    }
    
    CGImageRef image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (CFDictionaryRef)options);
    CFRelease(imageSource);
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:(CGImageRef)CFAutorelease(image) scale:MGE_MAINSCREEN_SCALE orientation:UIImageOrientationUp];
#else
    CGSize finalSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    finalSize = _getPointSizeFromPixelSize(finalSize);
    return [[NSImage alloc] initWithCGImage:(CGImageRef)CFAutorelease(image) size:finalSize];
#endif
}

#pragma mark - Resize CoreGraphics
// https://stackoverflow.com/questions/10544887/rotating-a-cgimage
MGEImage *MGEResizedImageCoreGraphics(NSURL *url, CGSize toSize) {
    if (toSize.width < 1.0 || toSize.height < 1.0) {
        NSCAssert(FALSE, @"좆도 사이즈가 너무 작아.");
        return nil;
    }
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    if (imageSource == nil) { return nil; }
    
    CGImagePropertyOrientation orientation = MGECGImageOrientationFromImageSource(imageSource);
    BOOL swapWidthHeight = MGESwapWidthHeightForCGImagePropertyOrientation(orientation);
    CGImageRef image = CGImageSourceCreateImageAtIndex((CGImageSourceRef)CFAutorelease(imageSource), 0, NULL);
    if (image == nil) { return nil; }
    
    CGColorSpaceRef space = CGImageGetColorSpace(image);
    CGColorSpaceRef colorSpace = CGColorSpaceRetain(space);
    if (colorSpace == nil) {
        colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    }
    
    CGRect frameRect = CGRectMake(0.0, 0.0, toSize.width, toSize.height);
    CGRect imageRect = CGRectMake(0.0, 0.0, CGImageGetWidth(image), CGImageGetHeight(image));
    if (swapWidthHeight == YES) {
        imageRect = CGRectMake(0.0, 0.0, imageRect.size.height, imageRect.size.width);
    }
    
    CGRect drawRect = MGERectByFittingRect(imageRect, frameRect); // Aspect Fit
    NSInteger pixelsWidth = (NSInteger)(drawRect.size.width * MGE_MAINSCREEN_SCALE);
    NSInteger pixelsHeight = (NSInteger)(drawRect.size.height * MGE_MAINSCREEN_SCALE);
    
    size_t bytesPerRow = 0;
    if (swapWidthHeight == NO) {
        bytesPerRow = CGImageGetBytesPerRow(image);
    } else {
//        NSUInteger const componentsPerPixel = 4;
//        NSUInteger const bytesPerComponent = sizeof(uint8_t);
//        NSUInteger const bytesPerPixel = bytesPerComponent * componentsPerPixel; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로
//        bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
        size_t bitsPerPixel = CGImageGetBitsPerPixel(image);
        size_t bitsPerRow = bitsPerPixel * pixelsWidth;
        bytesPerRow = bitsPerRow / CHAR_BIT;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 pixelsWidth,
                                                 pixelsHeight,
                                                 CGImageGetBitsPerComponent(image),
                                                 bytesPerRow,
                                                 (CGColorSpaceRef)CFAutorelease(colorSpace),
                                                 CGImageGetBitmapInfo(image));

    if (orientation == kCGImagePropertyOrientationDown) { // 3.OK
        CGContextRotateCTM(context, M_PI);
        CGContextTranslateCTM(context, -pixelsWidth, -pixelsHeight);
    } else if (orientation == kCGImagePropertyOrientationRight) {  // 6.OK
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -pixelsHeight, 0);
    } else if (orientation == kCGImagePropertyOrientationLeft) { // 8.OK
        CGContextRotateCTM(context, M_PI_2);
        CGContextTranslateCTM(context, 0, -pixelsWidth);
    } else if (orientation == kCGImagePropertyOrientationLeftMirrored) {  // 5.OK
        CGContextRotateCTM(context, M_PI_2);
        CGContextTranslateCTM(context, 0, -pixelsWidth);
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, -pixelsHeight, 0);
    } else if (orientation == kCGImagePropertyOrientationRightMirrored) { // 7.OK
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -pixelsHeight, 0);
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, -pixelsHeight, 0);
    } else if (orientation == kCGImagePropertyOrientationDownMirrored) { // 4.OK
        CGContextRotateCTM(context, M_PI);
        CGContextTranslateCTM(context, -pixelsWidth, -pixelsHeight);
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, -pixelsWidth, 0);
    } else if (orientation == kCGImagePropertyOrientationUpMirrored) { // 2.OK
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, -pixelsWidth, 0);
    } else { // 1. OK
        // kCGImagePropertyOrientationUp
    }
    
//    NSLog(@"===> %@", DescriptionForCGImagePropertyOrientation(orientation));
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    if (swapWidthHeight == NO) {
        CGContextDrawImage(context, CGRectMake(0.0, 0.0, pixelsWidth, pixelsHeight), image);
    } else {
        CGContextDrawImage(context, CGRectMake(0.0, 0.0, pixelsHeight, pixelsWidth), image);
    }
    CGImageRef scaledImage = CGBitmapContextCreateImage(context);
    CFRelease(context);
    if (scaledImage == nil) {
#if TARGET_OS_IPHONE
        return [UIImage imageWithCGImage:(CGImageRef)CFAutorelease(image)
                                   scale:MGE_MAINSCREEN_SCALE
                             orientation:UIImageOrientationUp];
#else
        return [[NSImage alloc] initWithCGImage:(CGImageRef)CFAutorelease(image) size:CGSizeZero];
#endif
    }
    CFRelease(image);
    
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:(CGImageRef)CFAutorelease(scaledImage)
                               scale:MGE_MAINSCREEN_SCALE
                         orientation:UIImageOrientationUp];
#else
    CGSize finalSize = CGSizeMake(CGImageGetWidth(scaledImage), CGImageGetHeight(scaledImage));
    finalSize = _getPointSizeFromPixelSize(finalSize);
    return [[NSImage alloc] initWithCGImage:(CGImageRef)CFAutorelease(scaledImage) size:finalSize];
#endif
}

#pragma mark - Resize CoreImage
MGEImage *MGEResizedImageCoreImage(NSURL *url, CGSize toSize) {
    if (toSize.width < 1.0 || toSize.height < 1.0) {
        NSCAssert(FALSE, @"좆도 사이즈가 너무 작아.");
        return nil;
    }
    
    NSDictionary *imageSourceOptions =
    @{(id)kCGImageSourceShouldCache : (id)kCFBooleanFalse}; // kCFBooleanFalse kCFBooleanTrue
    
    CGSize imagePixelSize = CGSizeZero;
    CGImageSourceRef imageSource =
    CGImageSourceCreateWithURL((__bridge CFURLRef)url, (__bridge CFDictionaryRef)imageSourceOptions);
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    CGImagePropertyOrientation orientation = MGECGImageOrientationFromImageSource(imageSource); // 방향 체크
    BOOL swapWidthHeight = MGESwapWidthHeightForCGImagePropertyOrientation(orientation); // 가로 세로 길이가 바뀌는지 체크
    CFNumberRef width = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    CFNumberRef height = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    if (width && height) {
        CFNumberGetValue(width, kCFNumberCGFloatType, &imagePixelSize.width);
        CFNumberGetValue(height, kCFNumberCGFloatType, &imagePixelSize.height);
    }
    if (imageSource == NULL || properties == NULL || width == NULL || height == NULL) {
        if (imageSource != NULL) {CFRelease(imageSource);}
        if (properties != NULL) {CFRelease(properties);}
        return nil;
    }
    CFRelease(imageSource);
    CFRelease(properties);
    
    CGRect framePixelRect = CGRectMake(0.0, 0.0, toSize.width * MGE_MAINSCREEN_SCALE, toSize.height * MGE_MAINSCREEN_SCALE);
    CGRect imagePixelRect = CGRectMake(0.0, 0.0, imagePixelSize.width, imagePixelSize.height);
    CGRect destImgPixelRect = CGRectZero; // original image 방향을 바로 잡는다고 가정 시, 방향 정정 후 original image의 픽셀 rect
    if (swapWidthHeight == NO) {
        destImgPixelRect = imagePixelRect;
    } else {
        destImgPixelRect = CGRectMake(0.0, 0.0, imagePixelRect.size.height, imagePixelRect.size.width);
    }
    // 최종적으로 방향을 바로 잡는다고 가정 시, 방향 정정 후 그려져야할(반환될) image의 픽셀 rect
    CGRect destDrawPixelRect = MGERectByFittingRect(destImgPixelRect, framePixelRect);
    CGFloat scale =
        MAX(destDrawPixelRect.size.width, destDrawPixelRect.size.height) /
        (CGFloat)MAX(destImgPixelRect.size.width, destImgPixelRect.size.height);
//    CGFloat aspectRatio = imagePixelRect.size.width / imagePixelRect.size.height; // 짜부를 만든다.
    
    CIImage *ciImg = [[CIImage alloc] initWithContentsOfURL:url];
    if (ciImg == nil) { return nil; }
    
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setDefaults]; // mac 필수. ios 자동 - 길호 프로젝트에서 참고.
    if (filter != nil) {
        ciImg = [ciImg imageByApplyingCGOrientation:orientation]; // 적용해줘야한다.
        [filter setValue:ciImg forKey:kCIInputImageKey];
        [filter setValue:@(scale) forKey:kCIInputScaleKey];
//        [filter setValue:@(aspectRatio) forKey:kCIInputAspectRatioKey]; // 짜부를 만든다.
    }
    
    CIImage *outputCIImage = filter.outputImage;
    if (outputCIImage == nil) { return nil; }
    CIContext *sharedContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CGImageRef outputCGImage = [sharedContext createCGImage:outputCIImage fromRect:outputCIImage.extent];
    if (outputCGImage == nil) { return nil; }
    
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:(CGImageRef)CFAutorelease(outputCGImage) scale:MGE_MAINSCREEN_SCALE orientation:UIImageOrientationUp];
#else
    CGSize finalSize = CGSizeMake(CGImageGetWidth(outputCGImage), CGImageGetHeight(outputCGImage));
    finalSize = _getPointSizeFromPixelSize(finalSize);
    return [[NSImage alloc] initWithCGImage:(CGImageRef)CFAutorelease(outputCGImage) size:finalSize];
#endif
}

#pragma mark - Resize VImage
// https://stackoverflow.com/questions/22745824/rotating-video-without-rotating-avcaptureconnection-and-in-the-middle-of-avasset/23899034#23899034
MGEImage *MGEResizedImageVImage(NSURL *url, CGSize toSize) {
    if (toSize.width < 1.0 || toSize.height < 1.0) {
        NSCAssert(FALSE, @"좆도 사이즈가 너무 작아.");
        return nil;
    }
    
    NSDictionary *imageSourceOptions =
    @{(id)kCGImageSourceShouldCache : (id)kCFBooleanFalse}; // kCFBooleanFalse kCFBooleanTrue
    
    CGSize imagePixelSize = CGSizeZero;
    // Decode the source image
    CGImageSourceRef imageSource =
    CGImageSourceCreateWithURL((__bridge CFURLRef)url, (__bridge CFDictionaryRef)imageSourceOptions);
    CGImagePropertyOrientation orientation = MGECGImageOrientationFromImageSource(imageSource); // 방향 체크
    BOOL swapWidthHeight = MGESwapWidthHeightForCGImagePropertyOrientation(orientation); // 가로 세로 길이가 바뀌는지 체크
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    CFNumberRef width = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    CFNumberRef height = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    if (width && height) {
        CFNumberGetValue(width, kCFNumberCGFloatType, &imagePixelSize.width);
        CFNumberGetValue(height, kCFNumberCGFloatType, &imagePixelSize.height);
    }
    if (imageSource == NULL || properties == NULL || width == NULL || height == NULL || image == nil) {
        if (imageSource != NULL) {CFRelease(imageSource);}
        if (properties != NULL) {CFRelease(properties);}
        if (image != NULL) {CFRelease(image);}
        return nil;
    }
    CFRelease(imageSource);
    CFRelease(properties);
    
    CGRect framePixelRect = CGRectMake(0.0, 0.0, toSize.width * MGE_MAINSCREEN_SCALE, toSize.height * MGE_MAINSCREEN_SCALE);
    CGRect imagePixelRect = CGRectMake(0.0, 0.0, imagePixelSize.width, imagePixelSize.height);
    CGRect destImgPixelRect = CGRectZero; // original image 방향을 바로 잡는다고 가정 시, 방향 정정 후 original image의 픽셀 rect
    if (swapWidthHeight == NO) {
        destImgPixelRect = imagePixelRect;
    } else {
        destImgPixelRect = CGRectMake(0.0, 0.0, imagePixelRect.size.height, imagePixelRect.size.width);
    }
    // 최종적으로 방향을 바로 잡는다고 가정 시, 방향 정정 후 그려져야할(반환될) image의 픽셀 rect
    CGRect destDrawPixelRect = MGERectByFittingRect(destImgPixelRect, framePixelRect);
    
    // image format 정의
    vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            .bitmapInfo = (CGBitmapInfo)(kCGImageAlphaFirst | kCGBitmapByteOrderDefault), // ARGB8888 에 해당한다.
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault
        //    For example, ARGB8888 is kCGImageAlphaFirst | kCGBitmapByteOrderDefault, and BGRA8888 is kCGImageAlphaFirst | kCGBitmapByteOrder32Little.
    };
    
    vImage_Error error = kvImageNoError;
    vImage_Buffer sourceBuffer = { 0 }; // Create and initialize the source buffer
    // defer { sourceBuffer.data.deallocate() } 원본 코드는 이런 코드였음.
    
    // 이미지가 담긴 소스 버퍼를 만든다.
    error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, NULL, image, (vImage_Flags)kvImageNoFlags);
    CFRelease(image);
    if (error != kvImageNoError) {
        if (sourceBuffer.data != NULL) { free(sourceBuffer.data); sourceBuffer.data = NULL; } return nil;
    }
    
    // 사이즈를 줄이자. Create and initizlize the destination buffer. 방향은 그대로 간다.
    vImage_Buffer destinationBuffer = {0};
    
    if (swapWidthHeight == NO) {
        error = vImageBuffer_Init(&destinationBuffer,
                                  (vImagePixelCount)destDrawPixelRect.size.height,
                                  (vImagePixelCount)destDrawPixelRect.size.width,
                                  format.bitsPerPixel,
                                  (vImage_Flags)kvImageNoFlags);
    } else {
        error = vImageBuffer_Init(&destinationBuffer,
                                  (vImagePixelCount)destDrawPixelRect.size.width,
                                  (vImagePixelCount)destDrawPixelRect.size.height,
                                  format.bitsPerPixel,
                                  (vImage_Flags)kvImageNoFlags);
    }
    if (error != kvImageNoError) {
        if (destinationBuffer.data != NULL) { free(destinationBuffer.data); destinationBuffer.data = NULL; }
        if (sourceBuffer.data != NULL) { free(sourceBuffer.data); sourceBuffer.data = NULL; }
        return nil;
    }

    error = vImageScale_ARGB8888(&sourceBuffer, &destinationBuffer, NULL, (vImage_Flags)kvImageNoFlags);
    if (sourceBuffer.data != NULL) { free(sourceBuffer.data); sourceBuffer.data = NULL; } // sourceBuffer 사용 끝.
    if (error != kvImageNoError) {
        if (destinationBuffer.data != NULL) { free(destinationBuffer.data); destinationBuffer.data = NULL; } return nil;
    } // 여기까지 사이즈가 줄어든 상태로 버퍼에 담았다.
    
    CGImageRef result = NULL;
    
    if (orientation == kCGImagePropertyOrientationUp) { // 방향 수정이 필요가 없는 경우.
        result = vImageCreateCGImageFromBuffer(&destinationBuffer, &format, nil, nil, kvImageNoFlags, &error);
        if (destinationBuffer.data != NULL) { free(destinationBuffer.data); destinationBuffer.data = NULL; }
        if (error != kvImageNoError) { CGImageRelease(result); return nil; }
    } else {  // 방향을 수정해야할 필요가 있을 경우에만 들어온다.
        vImage_Buffer rotationBuffer = {0};
        if (swapWidthHeight == NO) {
            error = vImageBuffer_Init(&rotationBuffer, destinationBuffer.height, destinationBuffer.width, format.bitsPerPixel, kvImageNoFlags);
        } else {
            error = vImageBuffer_Init(&rotationBuffer, destinationBuffer.width, destinationBuffer.height, format.bitsPerPixel, kvImageNoFlags);
        }
        if (error != kvImageNoError) {
            if (rotationBuffer.data != NULL) { free(rotationBuffer.data); rotationBuffer.data = NULL; }
            return nil;
        }
        const Pixel_8888 backgroundColor = {0,0,0,0};
        if (orientation == kCGImagePropertyOrientationRight) { // 6 번.
            error = vImageRotate_ARGB8888(&destinationBuffer, &rotationBuffer, NULL, -M_PI_2, backgroundColor, kvImageNoFlags);
        } else if (orientation == kCGImagePropertyOrientationLeft) { // 8 번.
            error = vImageRotate_ARGB8888(&destinationBuffer, &rotationBuffer, NULL, M_PI_2, backgroundColor, kvImageNoFlags);
        } else if (orientation == kCGImagePropertyOrientationDown) { // 3 번.
            error = vImageRotate_ARGB8888(&destinationBuffer, &rotationBuffer, NULL, M_PI, backgroundColor, kvImageNoFlags);
        } else if (orientation == kCGImagePropertyOrientationDownMirrored) { // 4.OK
            error = vImageRotate_ARGB8888(&destinationBuffer, &rotationBuffer, NULL, M_PI, backgroundColor, kvImageNoFlags);
            error = vImageHorizontalReflect_ARGB8888(&rotationBuffer, &rotationBuffer, (vImage_Flags)kvImageNoFlags);
        } else if (orientation == kCGImagePropertyOrientationLeftMirrored) { // 5.OK
            error = vImageRotate_ARGB8888(&destinationBuffer, &rotationBuffer, NULL, M_PI_2, backgroundColor, kvImageNoFlags);
            error = vImageVerticalReflect_ARGB8888(&rotationBuffer, &rotationBuffer, (vImage_Flags)kvImageNoFlags);
        } else if (orientation == kCGImagePropertyOrientationRightMirrored) { // 7.OK
            error = vImageRotate_ARGB8888(&destinationBuffer, &rotationBuffer, NULL, -M_PI_2, backgroundColor, kvImageNoFlags);
            error = vImageVerticalReflect_ARGB8888(&rotationBuffer, &rotationBuffer, kvImageNoFlags);
        } else if (orientation == kCGImagePropertyOrientationUpMirrored) { // 2.OK
            error = vImageHorizontalReflect_ARGB8888(&destinationBuffer, &rotationBuffer, kvImageNoFlags);
        }
        
        if (destinationBuffer.data != NULL) { free(destinationBuffer.data); destinationBuffer.data = NULL; }
        if (error != kvImageNoError) {
            if (rotationBuffer.data != NULL) { free(rotationBuffer.data); rotationBuffer.data = NULL; } return nil;
        }
        
        result = vImageCreateCGImageFromBuffer(&rotationBuffer, &format, nil, nil, kvImageNoFlags, &error);
        if (error != kvImageNoError) { CGImageRelease(result); return nil; }
    }
    
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:(CGImageRef)CFAutorelease(result) scale:MGE_MAINSCREEN_SCALE orientation:UIImageOrientationUp];
#else
    CGSize finalSize = CGSizeMake(CGImageGetWidth(result), CGImageGetHeight(result));
    finalSize = _getPointSizeFromPixelSize(finalSize);
    return [[NSImage alloc] initWithCGImage:(CGImageRef)CFAutorelease(result) size:finalSize];
#endif
}

MGEImage *MGEResizedImageDataImageIO(NSData *imageData, CGSize toSize) {
    if (toSize.width < 1.0 || toSize.height < 1.0) {
        NSCAssert(FALSE, @"좆도 사이즈가 너무 작아.");
        return nil;
    }
    
    CGSize framePixelSize = CGSizeMake(toSize.width * MGE_MAINSCREEN_SCALE, toSize.height * MGE_MAINSCREEN_SCALE);
    NSInteger maxPixelSize = (NSInteger)(MAX(framePixelSize.width, framePixelSize.height));
    
    NSDictionary *imageSourceOptions =
    @{(id)kCGImageSourceShouldCache : (id)kCFBooleanFalse}; // kCFBooleanFalse kCFBooleanTrue
    CGSize imagePixelSize = CGSizeZero;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData,
                                                               (__bridge CFDictionaryRef)imageSourceOptions);
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    
    
    CFNumberRef width = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    CFNumberRef height = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    if (width && height) {
        CFNumberGetValue(width, kCFNumberCGFloatType, &imagePixelSize.width);
        CFNumberGetValue(height, kCFNumberCGFloatType, &imagePixelSize.height);
    }
    if (imageSource == NULL || properties == NULL || width == NULL || height == NULL) {
        if (imageSource != NULL) {CFRelease(imageSource);}
        if (properties != NULL) {CFRelease(properties);}
        return nil;
    }
    CFRelease(properties);
    
    NSMutableDictionary *options =
    @{(id)kCGImageSourceCreateThumbnailWithTransform : (id)kCFBooleanTrue,
      (id)kCGImageSourceCreateThumbnailFromImageAlways: (id)kCFBooleanTrue,
      (id)kCGImageSourceShouldCacheImmediately: (id)kCFBooleanTrue,
      (id)kCGImageSourceThumbnailMaxPixelSize : @(maxPixelSize)}.mutableCopy;
    
    CGImageRef image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (CFDictionaryRef)options);
    CFRelease(imageSource);
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:(CGImageRef)CFAutorelease(image) scale:MGE_MAINSCREEN_SCALE orientation:UIImageOrientationUp];
#else
    CGSize finalSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    finalSize = _getPointSizeFromPixelSize(finalSize);
    return [[NSImage alloc] initWithCGImage:(CGImageRef)CFAutorelease(image) size:finalSize];
#endif

}


#pragma mark - Create : 단순 생성.
CGImageRef MGECGImageCreateWithData(NSData *data) {
    CGImageRef result = NULL;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (imageSource != NULL) {
        NSDictionary *options =
        @{(id)kCGImageSourceCreateThumbnailWithTransform : (id)kCFBooleanTrue,
          (id)kCGImageSourceCreateThumbnailFromImageAlways: (id)kCFBooleanTrue};
        // kCGImageSourceThumbnailMaxPixelSize 을 정하지 않았으므로 다운 샘플링되지 않는다.
        // kCGImageSourceCreateThumbnailFromImageIfAbsent 을 정하지 않았으므로 만약에 가지고 있을 수 있는 섬내일 이미지에서 가져오지 않는다.
        result = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (CFDictionaryRef)options);
        CFRelease(imageSource);
    }
    return result;
}


#pragma mark - Helper
CGImagePropertyOrientation MGECGImageOrientationFromImageURL(NSURL *url) {
    return __MGECGImageOrientation(url, NULL, nil);
}
CGImagePropertyOrientation MGECGImageOrientationFromImageSource(CGImageSourceRef imageSource) {
    return __MGECGImageOrientation(nil, imageSource, nil);
}
CGImagePropertyOrientation MGECGImageOrientationFromImageData(NSData *imageData) {
    return __MGECGImageOrientation(nil, NULL, imageData);
}
#if TARGET_OS_IPHONE
UIImageOrientation MGEUIImageOrientationFromImageURL(NSURL *url) {
    return UIImageOrientationForCGImagePropertyOrientation(MGECGImageOrientationFromImageURL(url));
}
UIImageOrientation MGEUIImageOrientationFromImageSource(CGImageSourceRef imageSource) {
    return UIImageOrientationForCGImagePropertyOrientation(MGECGImageOrientationFromImageSource(imageSource));
}
UIImageOrientation MGEUIImageOrientationFromImageData(NSData *imageData) {
    return UIImageOrientationForCGImagePropertyOrientation(MGECGImageOrientationFromImageData(imageData));
}
#endif

CGSize MGEPixelSizeFromImageURL(NSURL *url) {
    return __MGEPixelSize(url, NULL, nil);
}
CGSize MGEPixelSizeFromImageSource(CGImageSourceRef imageSource) {
    return __MGEPixelSize(nil, imageSource, nil);
}
CGSize MGEPixelSizeFromImageData(NSData *imageData) {
    return __MGEPixelSize(nil, NULL, imageData);
}

BOOL MGEHasAlphaFromImageURL(NSURL *url) {
    return __MGEHasAlpha(url, NULL, nil);
}
BOOL MGEHasAlphaFromImageSource(CGImageSourceRef imageSource) {
    return __MGEHasAlpha(nil, imageSource, nil);
}
BOOL MGEHasAlphaFromImageData(NSData *imageData) {
    return __MGEHasAlpha(nil, NULL, imageData);
}
BOOL MGEHasAlphaFromCGImage(CGImageRef cgImage) {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(cgImage);
    return (alpha == kCGImageAlphaFirst || /* For example, non-premultiplied ARGB */
            alpha == kCGImageAlphaLast || /* For example, non-premultiplied RGBA */
            alpha == kCGImageAlphaPremultipliedFirst || /* For example, premultiplied ARGB */
            alpha == kCGImageAlphaPremultipliedLast ||  /* For example, premultiplied RGBA */
            alpha == kCGImageAlphaOnly); /* No color data, alpha data only */
}


#pragma mark - Simple Helper Function
BOOL MGESwapWidthHeightForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation) {
    if (cgOrientation == kCGImagePropertyOrientationUp ||
        cgOrientation == kCGImagePropertyOrientationDown ||
        cgOrientation == kCGImagePropertyOrientationUpMirrored ||
        cgOrientation == kCGImagePropertyOrientationDownMirrored) {
        return NO;
    } else {
        return YES;
    }
}

NSString *DescriptionForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation) {
    switch (cgOrientation) {
        case kCGImagePropertyOrientationUp: return @"kCGImagePropertyOrientationUp";
        case kCGImagePropertyOrientationDown: return @"kCGImagePropertyOrientationDown";
        case kCGImagePropertyOrientationLeft: return @"kCGImagePropertyOrientationLeft";
        case kCGImagePropertyOrientationRight: return @"kCGImagePropertyOrientationRight";
        case kCGImagePropertyOrientationUpMirrored: return @"kCGImagePropertyOrientationUpMirrored";
        case kCGImagePropertyOrientationDownMirrored: return @"kCGImagePropertyOrientationDownMirrored";
        case kCGImagePropertyOrientationLeftMirrored: return @"kCGImagePropertyOrientationLeftMirrored";
        case kCGImagePropertyOrientationRightMirrored: return @"kCGImagePropertyOrientationRightMirrored";
    }
}

#if TARGET_OS_IPHONE
UIImageOrientation UIImageOrientationForCGImagePropertyOrientation(CGImagePropertyOrientation cgOrientation) {
    switch (cgOrientation) {
        case kCGImagePropertyOrientationUp: return UIImageOrientationUp;
        case kCGImagePropertyOrientationDown: return UIImageOrientationDown;
        case kCGImagePropertyOrientationLeft: return UIImageOrientationLeft;
        case kCGImagePropertyOrientationRight: return UIImageOrientationRight;
        case kCGImagePropertyOrientationUpMirrored: return UIImageOrientationUpMirrored;
        case kCGImagePropertyOrientationDownMirrored: return UIImageOrientationDownMirrored;
        case kCGImagePropertyOrientationLeftMirrored: return UIImageOrientationLeftMirrored;
        case kCGImagePropertyOrientationRightMirrored: return UIImageOrientationRightMirrored;
    }
}
CGImagePropertyOrientation CGImagePropertyOrientationForUIImageOrientation(UIImageOrientation uiOrientation) {
    switch (uiOrientation) {
        case UIImageOrientationUp: return kCGImagePropertyOrientationUp;
        case UIImageOrientationDown: return kCGImagePropertyOrientationDown;
        case UIImageOrientationLeft: return kCGImagePropertyOrientationLeft;
        case UIImageOrientationRight: return kCGImagePropertyOrientationRight;
        case UIImageOrientationUpMirrored: return kCGImagePropertyOrientationUpMirrored;
        case UIImageOrientationDownMirrored: return kCGImagePropertyOrientationDownMirrored;
        case UIImageOrientationLeftMirrored: return kCGImagePropertyOrientationLeftMirrored;
        case UIImageOrientationRightMirrored: return kCGImagePropertyOrientationRightMirrored;
    }
}
#endif


#pragma mark - Private
//! 셋 중에 하나만 넣는 것이다.
CGImagePropertyOrientation __MGECGImageOrientation(NSURL *url, CGImageSourceRef imageSource, NSData *imageData) {
    CGImagePropertyOrientation result = kCGImagePropertyOrientationUp;
    CFDictionaryRef properties = NULL;
    if (url != nil) {
        CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
        if (source == NULL) { return result; }
        properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CFRelease(source);
    } else if (imageSource != nil) {
        properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
//        CFRelease(imageSource); 여기서 만든 것이 아니기 때문에 해제하면 안된다.
    } else if (imageData != nil) {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        if (source == NULL) { return result; }
        properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CFRelease(source);
    } else {
        return result;
    }
    if (properties == NULL) { return result; }
    CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
    CFRelease(properties);
    if (val != NULL) {
        int exifOrientation;
        CFNumberGetValue(val, kCFNumberIntType, &exifOrientation);
        result = exifOrientation;
    }
    return result;
}

//! 셋 중에 하나만 넣는 것이다.
CGSize __MGEPixelSize(NSURL *url, CGImageSourceRef imageSource, NSData *imageData) {
    CGSize pixelSize = CGSizeZero; // 형을 NSInteger로 잡고 싶지만 딱히 없어서 이걸로 잡았다.
    CFDictionaryRef properties = NULL;
    if (url != nil) {
        CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
        if (source == NULL) { return pixelSize; }
        properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CFRelease(source);
    } else if (imageSource != nil) {
        properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
//        CFRelease(imageSource); 여기서 만든 것이 아니기 때문에 해제하면 안된다.
    } else if (imageData != nil) {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        if (source == NULL) { return pixelSize; }
        properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CFRelease(source);
    } else {
        return pixelSize;
    }
    if (properties == NULL) { return pixelSize; }
    
    CFNumberRef width = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    CFNumberRef height = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    CFRelease(properties);
    if (width && height) {
        CFNumberGetValue(width, kCFNumberCGFloatType, &pixelSize.width); // kCFNumberNSIntegerType
        CFNumberGetValue(height, kCFNumberCGFloatType, &pixelSize.height); // kCFNumberNSIntegerType
    }
    return pixelSize;
}

//! 셋 중에 하나만 넣는 것이다.
BOOL __MGEHasAlpha(NSURL *url, CGImageSourceRef imageSource, NSData *imageData) {
    BOOL result = NO;
    CFDictionaryRef properties = NULL;
    if (url != nil) {
        CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
        if (source == NULL) { return result; }
        properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CFRelease(source);
    } else if (imageSource != nil) {
        properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
//        CFRelease(imageSource); 여기서 만든 것이 아니기 때문에 해제하면 안된다.
    } else if (imageData != nil) {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        if (source == NULL) { return result; }
        properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CFRelease(source);
    } else {
        return result;
    }
    if (properties == NULL) { return result; }
    result = CFDictionaryGetValue(properties, kCGImagePropertyHasAlpha) == kCFBooleanTrue;
    CFRelease(properties);
    return result;
}



CGImageRef MGECGImageGetImage(MGEImage *myImage) {
#if TARGET_OS_IPHONE
    return myImage.CGImage;
#else
    NSSize size = [myImage size];
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    return [myImage CGImageForProposedRect:&rect context:[NSGraphicsContext currentContext] hints:NULL];
#endif
}


// fraction 0.0 이면 일반적, 1.0 이면 하나도 안보임.
CGImageRef _MGECreateGradientImage(CGImageRef originalImage, CGFloat fraction) {
    fraction = MIN(MAX(0.0, fraction), 1.0);
    size_t pixelsWidth = CGImageGetWidth(originalImage);
    size_t pixelsHeight = CGImageGetHeight(originalImage);
    
    NSUInteger const componentsPerPixel = 2; // (alpha value, grayscale value) 2개.
    NSUInteger const bytesPerComponent = sizeof(uint8_t);
    size_t const bitsPerComponent = bytesPerComponent * CHAR_BIT;
    NSUInteger const bytesPerPixel = bytesPerComponent * componentsPerPixel;
    size_t const bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray(); // mask로 사용될 gradient
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL,
                                                               1.0, // 1 픽셀을 늘리겠다.
                                                               pixelsHeight,
                                                               bitsPerComponent,
                                                               bytesPerRow, // 0 이면 자동계산
                                                               colorSpace,
                                                               kCGImageAlphaNone);
    CGFloat colors[] = {0.0, 1.0,  // start Color  (alpha value, grayscale value)
                        0.0, 1.0,  // middle Color (alpha value, grayscale value)
                        1.0, 1.0}; // end Color    (alpha value, grayscale value)
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat gradientLocations[3] = {0.0, fraction, 1.0};
    size_t gradientLocationsCount = 3;
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                          colors,
                                                                          gradientLocations,
                                                                          gradientLocationsCount);
    CGContextDrawLinearGradient(gradientBitmapContext,
                                grayScaleGradient,
                                CGPointZero, // startPoint
                                CGPointMake(0, pixelsHeight), // endPoint
                                kCGGradientDrawsAfterEndLocation);
    CGImageRef result = CGBitmapContextCreateImage(gradientBitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(grayScaleGradient);
    CGContextRelease(gradientBitmapContext);
    return result;
}

CGImageRef MGECreateReflectImageFromOriginalImage(CGImageRef originalImage, CGFloat fraction) {
    size_t pixelsWidth = CGImageGetWidth(originalImage);
    size_t pixelsHeight = CGImageGetHeight(originalImage);
    CGRect pixelsRect = CGRectMake(0.0, 0.0, pixelsWidth, pixelsHeight);
    if (pixelsHeight == 0) {
        return NULL;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger const componentsPerPixel = 4;
    NSUInteger const bytesPerComponent = sizeof(uint8_t);
    size_t const bitsPerComponent = bytesPerComponent * CHAR_BIT;
    NSUInteger const bytesPerPixel = bytesPerComponent * componentsPerPixel;
    size_t const bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 pixelsWidth,
                                                 pixelsHeight,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef gradientMaskImage = _MGECreateGradientImage(originalImage, fraction);
    CGContextClipToMask(context, pixelsRect, gradientMaskImage);
    CGContextTranslateCTM(context, 0.0, pixelsHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, pixelsRect, originalImage);
    CGImageRef result = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(gradientMaskImage);
    CGContextRelease(context);
    return result;
}
