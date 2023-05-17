//
//  UIImage+ResizeColor.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIImage+ResizeColor.h"
#import "UIImage+Etc.h"

@implementation UIImage (ResizeColor)

- (UIImage *)mgrThumbnailImageWithSize:(CGSize)thumbnailSize cornerRadius:(CGFloat)cornerRadius {
    // Classic 스타일.
//    CGSize origImageSize = self.size;
//    // 섬네일 영역
//    CGRect newRect = CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);
//
//    // 같은 종횡비를 유지하기 위해 축척비를 계산한다.
//    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
//    // 섬네일 영역과 같은 크기로 투명 비트맵 컨텍스트를 만든다.
//    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
//
//    // 모서리가 둥근 베지어패스를 만든다.
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:cornerRadius];
//
//    // 모든 드로잉 클립을 이 라운드 영역에 만든다.
//    [path addClip];
//
//    // 이미지를 섬네일 영역의 중앙에 놓는다.
//    CGRect projectRect;
//    projectRect.size.width  = ratio * origImageSize.width;
//    projectRect.size.height = ratio * origImageSize.height;
//    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
//    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
//
//    // 이미지를 그 위치에 그린다.
//    [self drawInRect:projectRect];
//
//    // 이미지 컨텍스트로부터 해당 이미지를 얻어 thumbnail로 유지한다.
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // 이미지 컨텍스트 리소스를 정리한다.
//    UIGraphicsEndImageContext();
//    return smallImage;
    
    CGSize origImageSize = self.size;
    // 섬네일 영역
    CGRect newRect = CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);
    // 같은 종횡비를 유지하기 위해 축척비를 계산한다.
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:thumbnailSize];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext*_Nonnull myContext) {
        // 모서리가 둥근 베지어패스를 만든다.
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:cornerRadius];
        // 모든 드로잉 클립을 이 라운드 영역에 만든다.
        [path addClip];
        CGRect projectRect;
        projectRect.size.width  = ratio * origImageSize.width;
        projectRect.size.height = ratio * origImageSize.height;
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
        [self drawInRect:projectRect];
    }];
    return image;
}

- (UIImage *)mgrImageWithSize:(CGSize)newSize {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext*_Nonnull myContext) {
        [self drawInRect:(CGRect) {.origin = CGPointZero, .size = newSize}];
    }];
    return image;
}

- (UIImage *)mgrImageWithColor:(UIColor * _Nonnull)newColor {
    
    if (newColor == nil) {
        NSAssert(false, @"UIColor 객체는 nil이 되어서는 안된다.");
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //! iOS는 그림이 거꾸로 나온다.
    CGContextTranslateCTM(context, 0.0, self.size.height); // 좌표 번역:좌상의 중심 좌표축을 image와 함께 통째로 아래로.
    CGContextScaleCTM(context, 1.0, -1.0); // 뒤집는다.
//! 이렇게도 가능하다.
// CGContextTranslateCTM(context, self.size.width, self.size.height); // 좌표 번역: 좌상의 중심 좌표축을 image와 함께 통째로 우하로.
// CGContextRotateCTM(context, M_PI);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    
    [newColor setFill];
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)mgrImageWithCircularColor:(UIColor *)circularColor circularSize:(CGSize)circularSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rect = (CGRect){CGPointZero, circularSize};
    UIGraphicsBeginImageContextWithOptions(circularSize, NO, scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];

    [circularColor setFill];
    UIRectFill(rect);

    if (self != nil) {
        CGRect iconRect = CGRectMake((rect.size.width - self.size.width) / 2.0,
                                     (rect.size.height - self.size.height) / 2.0,
                                     self.size.width,
                                     self.size.height);

        [self drawInRect:iconRect blendMode:kCGBlendModeNormal alpha:1.0];
    }
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)mgrImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    CALayer *layer = [CALayer layer];
    layer.contentsScale = UIScreen.mainScreen.scale;
    layer.backgroundColor = color.CGColor;
    layer.cornerRadius = cornerRadius;
    layer.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, UIScreen.mainScreen.scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)mgrImageWithLayer:(CALayer *)layer cornerRadius:(CGFloat)cornerRadius {
    CGSize size = layer.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    layer.contentsScale = scale;
    UIGraphicsBeginImageContextWithOptions(size, layer.opaque, scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:cornerRadius];
    [path addClip];
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    //
    /* 효과는 동일
    CGSize size = layer.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    layer.contentsScale = scale;
    UIGraphicsBeginImageContextWithOptions(size, layer.opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh); // 보간품질. 여기서는 의미 없는 듯.
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:cornerRadius];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    */
    //
    /* 효과는 동일
    CGSize size = layer.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    layer.contentsScale = scale;
        
    UIGraphicsImageRendererFormat *rendererFormat = [UIGraphicsImageRendererFormat defaultFormat];
    rendererFormat.preferredRange = UIGraphicsImageRendererFormatRangeStandard; // 별 효과가 없는 듯.
    rendererFormat.scale = scale;
    rendererFormat.opaque = layer.opaque;
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:rendererFormat];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:cornerRadius];
        [path addClip];
        [layer renderInContext:UIGraphicsGetCurrentContext()];
    }];
    */
    //
    /* 효과는 동일
    CGSize size = layer.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    layer.contentsScale = scale;

    UIGraphicsImageRendererFormat *rendererFormat = [UIGraphicsImageRendererFormat defaultFormat];
    rendererFormat.preferredRange = UIGraphicsImageRendererFormatRangeStandard; // 별 효과가 없는 듯.
    rendererFormat.scale = scale;
    rendererFormat.opaque = layer.opaque;

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:rendererFormat];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:cornerRadius];
        CGContextAddPath(ctx, path.CGPath);
        CGContextClip(ctx);
        [layer renderInContext:ctx];
    }];
    */
}

- (UIImage *)mgrInvertAlphaWithSourceOutColor:(UIColor *)sourceOutColor cornerRadius:(CGFloat)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawAtPoint:CGPointZero];
    UIImage *image = [UIImage mgrImageWithColor:sourceOutColor size:self.size cornerRadius:cornerRadius];
    [image drawAtPoint:CGPointZero
             blendMode:kCGBlendModeSourceOut
                 alpha:1.0];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    //
    // https://stackoverflow.com/questions/30907448/how-to-cut-the-shape-of-a-logopng-image-from-another-image-programmatically-in
    // https://gist.github.com/codelynx/59fc49db3fd594ccfe3bfb1aab81c1c0
    //func masked(with image: UIImage, position: CGPoint? = nil, inverted: Bool = false) -> UIImage? {
    //    let position = position ??
    //        CGPoint(x: size.width.half - image.size.width.half,
    //                y: size.height.half - image.size.height.half)
    //    defer { UIGraphicsEndImageContext() }
    //    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    //    draw(at: .zero)
    //    image.draw(at: position, blendMode: inverted ? .destinationOut : .destinationIn, alpha: 1)
    //    return UIGraphicsGetImageFromCurrentImageContext()
    //}
}

// https://gist.github.com/codelynx/59fc49db3fd594ccfe3bfb1aab81c1c0
// 효과는 위와 동일하지만, 효율성이 떨어지는 듯.
//- (UIImage *)mgrInvertAlpha {
//    NSInteger pixelsWidth = (NSInteger)(self.size.width * self.scale); // w, h는 같게 주어진다.
//    NSInteger pixelsHeight = (NSInteger)(self.size.height * self.scale);
//    NSUInteger const componentsPerPixel = 4;
//    NSUInteger const bytesPerComponent = sizeof(uint8_t);
//
//    NSUInteger const bitsPerComponent = bytesPerComponent * CHAR_BIT;   // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현됨
//    NSUInteger const bytesPerPixel = bytesPerComponent * componentsPerPixel; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로 나누는것(비트) 4를 곱하는 것(RGBA)
////    NSUInteger const bitsPerPixel = bitsPerComponent * componentsPerPixel;
//    NSUInteger const bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
//
//    CGContextRef context = CGBitmapContextCreate(nil,
//                                                 pixelsWidth,
//                                                 pixelsHeight,
//                                                 bitsPerComponent,
//                                                 bytesPerRow,
//                                                 CGColorSpaceCreateDeviceRGB(),
//                                                 kCGImageAlphaPremultipliedLast);
//
//    CGImageRef cgImage = [self mgrCGImage]; // 그냥 CGImage를 쓰면 주변부 알파 값이 잘린다.
//    if (context != NULL && cgImage != NULL) {
//        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//        CGContextFillRect(context, CGRectMake(0.0, 0.0, pixelsWidth, pixelsHeight));
//        CGContextDrawImage(context, CGRectMake(0.0, 0.0, pixelsWidth, pixelsHeight), cgImage);
//
//        typedef struct __RGBA {
//            uint8_t r;
//            uint8_t g;
//            uint8_t b;
//            uint8_t a;
//        } RGBA;
//
//        uint8_t *ptr = CGBitmapContextGetData(context);
//        RGBA *imageData = (RGBA *)ptr;
//        int i = 0;
//        if (ptr != NULL) {
//            for (int y = 0; y < pixelsHeight; y++) {
//                for (int x = 0; x < pixelsWidth; x++) {
//                    RGBA rgba = imageData[i];
//                    imageData[i].a = 0xff - rgba.a;
//                    i++;
//                }
//            }
//            CGImageRef cgImage = CGBitmapContextCreateImage(context);
//            if (cgImage != NULL) {
//                return [UIImage imageWithCGImage:cgImage];
//            }
//        }
//    }
//    return nil;
//}

- (UIImage *)mgrCropAlpha {
    CGFloat imageScale = self.scale;
    CGImageRef cgImage = self.CGImage;
    size_t pixelsWideth = (NSInteger)(self.size.width * imageScale);
    size_t pixelsHeight = (NSInteger)(self.size.height * imageScale);
//    NSInteger bufferSize = pixelsWideth * pixelsHeight * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger const componentsPerPixel = 4;
    size_t const bytesPerComponent = sizeof(uint8_t);
    size_t const bitsPerComponent = bytesPerComponent * CHAR_BIT; // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현됨 size_t bitsPerComponent = sizeof(uint8_t) * 8;
    size_t const bytesPerPixel = bytesPerComponent * componentsPerPixel; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로 나누는것(비트) 4를 곱하는 것(RGBA) size_t bytesPerPixel = bitsPerComponent * 4 / 8;
    __unused size_t const bitsPerPixel = bitsPerComponent * componentsPerPixel;
    size_t bytesPerRow = bytesPerPixel * pixelsWideth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 pixelsWideth,
                                                 pixelsHeight,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    
    uint8_t * ptr = CGBitmapContextGetData(context);
    if (context == NULL || ptr == NULL) {
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        return self;
    }
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, pixelsWideth, pixelsHeight), cgImage);
        
    size_t minX = pixelsWideth;
    size_t minY = pixelsHeight;
    NSInteger maxX = 0;
    NSInteger maxY = 0;
    
    for (int x = 0; x < pixelsWideth; x++) {
        for (int y = 0; y < pixelsHeight; y++) {
            size_t i = bytesPerRow * y + bytesPerPixel * x;
            CGFloat a = (CGFloat)(ptr[i + 3]) / 255.0;
            if(a > 0.0) {
                if (x < minX) { minX = x;};
                if (x > maxX) { maxX = x;};
                if (y < minY) { minY = y;};
                if (y > maxY) { maxY = y;};
            }
        }
    }
    
    CGRect rect = CGRectMake((CGFloat)minX, (CGFloat)minY, (CGFloat)(maxX-minX), (CGFloat)(maxY-minY));
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect(cgImage, rect);
    UIImage *result = [[UIImage alloc] initWithCGImage:croppedImage scale:imageScale orientation:self.imageOrientation];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(croppedImage);
    return result;
}


/** shadow Image **/
- (UIImage *)mgrImageWithShadowBlurSize:(CGFloat)blurSize
                           shadowOffset:(CGSize)shadowOffset
                            shadowColor:(UIColor *)shadowColor
                          shadowOpacity:(CGFloat)shadowOpacity {
    CGFloat scale = [UIScreen mainScreen].scale;
    shadowOpacity = MIN(1.0, MAX(shadowOpacity, 0.0));
    shadowColor = [shadowColor colorWithAlphaComponent:shadowOpacity];
    
    // 그림자로 인해, 최종적으로 더 넓어진 size
    CGSize expandedSize = CGSizeMake(self.size.width + (blurSize * 2.0), self.size.height + (blurSize * 2.0));
    CGFloat shadowExtend = MAX(ABS(shadowOffset.width), ABS(shadowOffset.height)) * 2.0;
    expandedSize = CGSizeMake(expandedSize.width + shadowExtend, expandedSize.height + shadowExtend);
    
    // uint8_t 8비트(1바이트) 크기의 부호 없는 정수형 변수 선언 unsigned char = uint8_t
    NSUInteger const componentsPerPixel = 4;
    size_t const bytesPerComponent = sizeof(uint8_t);
    size_t const bitsPerComponent = bytesPerComponent * CHAR_BIT; // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현됨 size_t bitsPerComponent = sizeof(uint8_t) * 8;
    size_t const bytesPerPixel = bytesPerComponent * componentsPerPixel; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로 나누는것(비트) 4를 곱하는 것(RGBA) size_t bytesPerPixel = bitsPerComponent * 4 / 8;
    NSInteger pixelsWidth = (NSInteger)(expandedSize.width  * scale);
    NSInteger pixelsHeight = (NSInteger)(expandedSize.height * scale);
    NSInteger bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    __unused size_t bitsPerPixel = bitsPerComponent * componentsPerPixel;
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL,
                                                       pixelsWidth,
                                                       pixelsHeight,
                                                       bitsPerComponent,
                                                       bytesPerRow,
                                                       colourSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    CGContextSetInterpolationQuality(shadowContext, kCGInterpolationHigh);
    
    shadowOffset = CGSizeMake(shadowOffset.width * scale, shadowOffset.height * scale);
    blurSize = blurSize *scale;
    CGContextSetShadowWithColor(shadowContext, shadowOffset, blurSize, shadowColor.CGColor);

    CGSize entirePixelsSize = CGSizeMake(expandedSize.width * scale, expandedSize.height * scale);
    CGSize drawPixelsSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    CGPoint drawImageOrigin = CGPointMake((entirePixelsSize.width - drawPixelsSize.width)/2.0, (entirePixelsSize.height - drawPixelsSize.height)/2.0);
    CGRect drawImageRect = (CGRect){drawImageOrigin, (CGSize)(drawPixelsSize)};
    CGImageRef newCGImg = [self newMgrCGImage];
    CGContextDrawImage(shadowContext, drawImageRect, newCGImg);

    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(shadowedCGImage);
    CGImageRelease(newCGImg);
    return shadowedImage;
}

//! 위와 효과는 동일하다. 다른 방식.
- (UIImage *)mgrAddingShadowBlur:(CGFloat)blur shadowColor:(UIColor *)shadowColor offset:(CGSize)offset {
    CGSize size = self.size;
    //! 여기에 들어가는 사이즈가 이미지 사이즈가 된다.
    CGSize expandedSize = CGSizeMake(size.width + (blur*2.0), size.height + (blur*2.0));
    CGFloat shadowExtend = MAX(ABS(offset.width), ABS(offset.height)) * 2.0;
    expandedSize = CGSizeMake(expandedSize.width + shadowExtend, expandedSize.height + shadowExtend);
    
    CGPoint drawImageOrigin = CGPointMake((expandedSize.width - size.width)/2.0, (expandedSize.height - size.height)/2.0);
    CGRect drawImageRect = (CGRect){drawImageOrigin, (CGSize)(size)};
    
    UIGraphicsBeginImageContextWithOptions(expandedSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, offset, blur, shadowColor.CGColor);
    [self drawInRect:drawImageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)mgrSliderKnobWithSize:(CGFloat)size blurSize:(CGFloat)blurSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat length = (size > 0.0)? size : 28.0;
    
    CALayer *layer = [CALayer layer];
    layer.contentsScale = scale; // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    layer.rasterizationScale = scale; // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    layer.shouldRasterize = YES;
    layer.backgroundColor = UIColor.whiteColor.CGColor;
    layer.borderColor = [UIColor.blackColor colorWithAlphaComponent:0.25].CGColor;
    layer.borderWidth = 0.5;
    layer.cornerRadius = length / 2.0;
    layer.frame = CGRectMake(0.0, 0.0, length, length);
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image mgrImageWithShadowBlurSize:blurSize
                                shadowOffset:CGSizeMake(0.0, -blurSize/2.0)
                                 shadowColor:UIColor.blackColor
                               shadowOpacity:0.25];
}

/** image 의 중심에서의 일정 부분의 rect는 유지한채 다른 부분을 늘려서 이미지를 늘린다. **/
- (UIImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio // 원본의 가로의 길이를 1.0로 보았을 때, 얼마만큼을 보존할 것인가 보존 데이터는 센터를 중심
                               preserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio // 원본 가로 크기에서 몇배만큼 늘릴 것인가. 1.0 이상
                                stretchHeightRatio:(CGFloat)stretchHeightRatio {
    
    if (stretchWidthRatio < 1.0 || stretchHeightRatio < 1.0) {
        NSCAssert(FALSE, @"이 메서드는 늘리는 것만 허용한다. 줄이는 것은 허용하지 않는다.");
    }
    
    UIImage *result = self;
    if (stretchWidthRatio > 1.0) { // 1.0 이면 건드릴 필요가 없다.
        CGFloat newWidth = self.size.width * stretchWidthRatio;
        CGFloat step = (newWidth - self.size.width) / 2.0;
        CGFloat firstWidth = self.size.width + step;
        CGFloat secondWidth = newWidth; // self.size.width + step + step; 과 동일하다.
        CGSize firstSize = CGSizeMake(firstWidth, self.size.height);
        CGSize secondSize = CGSizeMake(secondWidth, self.size.height);
        CGFloat firstPreserveEdgeInset = self.size.width - ((self.size.width - (self.size.width * preserveWidthRatio)) / 2.0);
        UIEdgeInsets firstEdgeInsets = UIEdgeInsetsMake(0.0, firstPreserveEdgeInset , 0.0, 0.0);
        CGFloat secondPreserveEdgeInset = firstWidth - ((self.size.width - (self.size.width * preserveWidthRatio)) / 2.0);
        UIEdgeInsets secondEdgeInsets = UIEdgeInsetsMake(0.0, 0.0 , 0.0, secondPreserveEdgeInset);
        
        UIGraphicsBeginImageContextWithOptions(firstSize, NO, self.scale);
        result = [result resizableImageWithCapInsets:firstEdgeInsets resizingMode:UIImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, firstSize.width, firstSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(secondSize, NO, self.scale);
        result = [result resizableImageWithCapInsets:secondEdgeInsets resizingMode:UIImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, secondSize.width, secondSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (stretchHeightRatio > 1.0) { // 1.0 이면 건드릴 필요가 없다.
        CGFloat newHeight = self.size.height * stretchHeightRatio;
        CGFloat step = (newHeight - self.size.height) / 2.0;
        CGFloat firstHeight = self.size.height + step;
        CGFloat secondHeight = newHeight; // self.size.width + step + step; 과 동일하다.
        CGSize firstSize = CGSizeMake(result.size.width, firstHeight);
        CGSize secondSize = CGSizeMake(result.size.width, secondHeight);
        CGFloat firstPreserveEdgeInset = self.size.height - ((self.size.height - (self.size.height * preserveHeightRatio)) / 2.0);
        UIEdgeInsets firstEdgeInsets = UIEdgeInsetsMake(firstPreserveEdgeInset, 0.0 , 0.0, 0.0);
        CGFloat secondPreserveEdgeInset = firstHeight - ((self.size.height - (self.size.height * preserveHeightRatio)) / 2.0);
        UIEdgeInsets secondEdgeInsets = UIEdgeInsetsMake(0.0, 0.0 , secondPreserveEdgeInset, 0.0);
        
        UIGraphicsBeginImageContextWithOptions(firstSize, NO, self.scale);
        result = [result resizableImageWithCapInsets:firstEdgeInsets resizingMode:UIImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, firstSize.width, firstSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(secondSize, NO, self.scale);
        result = [result resizableImageWithCapInsets:secondEdgeInsets resizingMode:UIImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, secondSize.width, secondSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return result;
}

- (UIImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio {
    return [self mgrStretchSideWidthPreserveWidthRatio:preserveWidthRatio
                                   preserveHeightRatio:1.0
                                     stretchWidthRatio:stretchWidthRatio
                                    stretchHeightRatio:1.0];
}

- (UIImage *)mgrStretchSideWidthPreserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchHeightRatio:(CGFloat)stretchHeightRatio {
    return [self mgrStretchSideWidthPreserveWidthRatio:1.0
                                   preserveHeightRatio:preserveHeightRatio
                                     stretchWidthRatio:1.0
                                    stretchHeightRatio:stretchHeightRatio];
}

@end
