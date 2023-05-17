//
//  NSImage+ResizeColor.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSImage+ResizeColor.h"
#import "NSImage+Etc.h"

@implementation NSImage (ResizeColor)

- (NSImage *)mgrThumbnailImageWithSize:(CGSize)thumbnailSize cornerRadius:(CGFloat)cornerRadius {
    // Classic 스타일.
    
    CGSize origImageSize = self.size;
    // 섬네일 영역
    CGRect newRect = CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);

    // 같은 종횡비를 유지하기 위해 축척비를 계산한다.
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    // 섬네일 영역과 같은 크기로 투명 비트맵 컨텍스트를 만든다.
    NSImage *image = [[NSImage alloc] initWithSize:newRect.size];
    [image lockFocus];

    // 모서리가 둥근 베지어패스를 만든다.
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect
                                                         xRadius:cornerRadius
                                                         yRadius:cornerRadius];
    // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    [path addClip];

    // 이미지를 섬네일 영역의 중앙에 놓는다.
    CGRect projectRect;
    projectRect.size.width  = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;

    // 이미지를 그 위치에 그린다.
    [self drawInRect:projectRect];

    // 이미지 컨텍스트로부터 해당 이미지를 얻어 thumbnail로 유지한다.
    [image unlockFocus];
    return image;
    //
    /* 신형 스타일
    CGSize origImageSize = self.size;
    // 섬네일 영역
    CGRect newRect = CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);
    // 같은 종횡비를 유지하기 위해 축척비를 계산한다.
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    return [NSImage imageWithSize:thumbnailSize flipped:NO
               drawingHandler:^BOOL(NSRect dstRect) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect
                                                             xRadius:cornerRadius
                                                             yRadius:cornerRadius];
        // 모든 드로잉 클립을 이 라운드 영역에 만든다.
        [path addClip];
        CGRect projectRect;
        projectRect.size.width  = ratio * origImageSize.width;
        projectRect.size.height = ratio * origImageSize.height;
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
        
        [self drawInRect:CGRectMake(0.0, 0.0, thumbnailSize.width, thumbnailSize.height)];
        return YES;
    }];
     */
}

- (NSImage *)mgrImageWithSize:(CGSize)newSize {
    if (self.isValid == NO) {
        return nil;
    }
    
//     uint8_t 8비트(1바이트) 크기의 부호 없는 정수형 변수 선언 unsigned char = uint8_t
    size_t bitsPerComponent = sizeof(uint8_t) * 8; // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현됨
    NSInteger bytesPerPixel = bitsPerComponent * 4 / 8; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로 나누는것(비트) 4를 곱하는 것(RGBA) NSCalibratedRGBColorSpace : Calibrated color space with red, green, blue, and alpha components. 4 가 아닌 3도 있을 수 있음.
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    NSInteger pixelsWideth = (NSInteger)(newSize.width  * scale);
    NSInteger pixelsHigh   = (NSInteger)(newSize.height * scale);
    NSInteger bytesPerRow = bytesPerPixel * pixelsWideth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    size_t bitsPerPixel = bytesPerPixel * bitsPerComponent;
//  여기서는  bitsPerComponent = bitsPerSample는 동일하다. 완전 동일한 것 같다. (하나의 색을 저장하는데 필요한 비트의 갯수)
//  여기서는  bytesPerPixel = samplesPerPixel는 동일하다. 완전 동일한지는 모르겠다. 필셀당 바이트 갯수, 픽셀당 색의 갯수
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                    pixelsWide:pixelsWideth
                                                                    pixelsHigh:pixelsHigh
                                                                 bitsPerSample:8
                                                               samplesPerPixel:4
                                                                      hasAlpha:YES
                                                                      isPlanar:NO
                                                                colorSpaceName:NSCalibratedRGBColorSpace
                                                                   bytesPerRow:bytesPerRow
                                                                  bitsPerPixel:bitsPerPixel]; // 32
    
    rep.size = newSize;
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    [self drawInRect:NSMakeRect(0, 0, newSize.width, newSize.height)
            fromRect:NSZeroRect
           operation:NSCompositingOperationCopy
            fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    NSImage *newImage = [[NSImage alloc] initWithSize:newSize];
    [newImage addRepresentation:rep];
    return newImage;
}

- (NSImage *)mgrBestRepresentationForSize:(NSSize)size {
    NSArray <NSImageRep *>*representations = self.representations;
    if (representations == nil || [representations count] == 0) {
        return [self mgrImageWithSize:size];
    }

    NSImageRep *resultRep =
    [representations sortedArrayUsingComparator:^NSComparisonResult(NSImageRep *rep1, NSImageRep *rep2) {
        NSInteger repWidth1 = lround(rep1.size.width);
        NSInteger repWidth2 = lround(rep2.size.width);
        NSInteger repPixelWidth1 = rep1.pixelsWide;
        NSInteger repPixelWidth2 = rep2.pixelsWide;
        
        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        if (repWidth1 > repWidth2) {
            if (repWidth2 >= size.width) {
                return NSOrderedDescending;
            } else  {
                return NSOrderedAscending;
            }
        } else if (repWidth1 < repWidth2) {
            if (size.width <= repWidth1) {
                return NSOrderedAscending;
            } else  {
                return NSOrderedDescending;
            }
        } else { // ==
            NSInteger scale1 = (repPixelWidth1/repWidth1);
            NSInteger scale2 = (repPixelWidth2/repWidth2);
            if (ABS(scale1 - scale) == ABS(scale2 - scale)) {
                return NSOrderedSame;
            }
            if (ABS(scale1 - scale) < ABS(scale2 - scale)) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }
    }].firstObject;

    NSImage *result = [[NSImage alloc] initWithSize:size];
    [result lockFocus];
    [resultRep drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    [result unlockFocus];
    return result;
}

- (NSImage *)mgrImageWithCornerRadius:(CGFloat)cornerRadius {
    CGSize size = self.size;
    CGFloat maxRadius = MIN(size.width, size.height) / 2.0;
    cornerRadius = MIN(maxRadius, MAX(0.0, cornerRadius));
    
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size}
                                                         xRadius:cornerRadius
                                                         yRadius:cornerRadius];
    [path addClip];
    [self drawInRect:(CGRect){CGPointZero, size}];
    [image unlockFocus];
    return image;
}

- (NSImage *)mgrImageWithColor:(NSColor *_Nonnull)newColor {
    if (newColor == nil) {
        NSCAssert(FALSE, @"NSColor 객체는 nil이 되어서는 안된다.");
    }    
    [self lockFocus];
    [newColor setFill];
    NSRect srcSpacePortionRect = NSMakeRect(0.0, 0.0, self.size.width, self.size.width);
    NSRectFillUsingOperation(srcSpacePortionRect, NSCompositingOperationSourceAtop);
    [self unlockFocus];
    return self;
    //
    //  또 다른 방법.
//    if (newColor == nil) {
//        NSCAssert(FALSE, @"NSColor 객체는 nil이 되어서는 안된다.");
//    }
//
//    NSImage *newImage = [[NSImage alloc] initWithSize:self.size];
//    [newImage lockFocus];
//    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
//
//    CGContextSetBlendMode(context, kCGBlendModeNormal);
//
//    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
//    CGContextClipToMask(context, rect, (__bridge CGImageRef)[self mgrCGImage]);
//
//    [newColor setFill];
//    CGContextFillRect(context, rect);
//    [newImage unlockFocus];
//    return newImage;
}

- (NSImage *)mgrImageWithCircularColor:(NSColor *)circularColor circularSize:(CGSize)circularSize {
    CGRect rect = (CGRect){CGPointZero, circularSize};
    
    NSImage *image = [[NSImage alloc] initWithSize:circularSize];
    [image lockFocus];
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    [circularColor setFill];
    NSRectFill(rect);
    
    if (self != nil) {
        CGRect iconRect = CGRectMake((rect.size.width - self.size.width) / 2.0,
                                     (rect.size.height - self.size.height) / 2.0,
                                     self.size.width,
                                     self.size.height);
        [self drawInRect:iconRect
                fromRect:NSMakeRect(0.0, 0.0, self.size.width, self.size.height)
               operation:NSCompositingOperationSourceOver // http://zathras.de/blog-nscompositingoperation-at-a-glance.htm
                fraction:1.0];
    }
    
    [image unlockFocus];
    return image;
}

+ (NSImage *)mgrImageWithColor:(NSColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    CALayer *layer = [CALayer layer];
    layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    layer.backgroundColor = color.CGColor;
    layer.cornerRadius = cornerRadius;
    layer.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    [layer renderInContext:context];
    [image unlockFocus];
    return image;
}

+ (NSImage *)mgrImageWithLayer:(CALayer *)layer cornerRadius:(CGFloat)cornerRadius {
    CGSize size = layer.bounds.size;
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    layer.contentsScale = scale;
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} xRadius:cornerRadius yRadius:cornerRadius];
    [path addClip];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    [layer renderInContext:context];
    [image unlockFocus];
    return image;
    //
    /* 효과는 동일
    CGSize size = layer.bounds.size;
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    layer.contentsScale = scale;
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh); // 보간품질. 여기서는 의미 없는 듯.
    CGPathRef path = CGPathCreateWithRoundedRect((CGRect){CGPointZero, size}, cornerRadius, cornerRadius, NULL);
    CGContextAddPath(context, path);
    CGContextClip(context);
    [layer renderInContext:context];
    [image unlockFocus];
    return image;
    */
}

/** shadow Image **/
- (NSImage *)mgrImageWithShadowBlurSize:(CGFloat)blurSize
                           shadowOffset:(CGSize)shadowOffset
                            shadowColor:(NSColor *)shadowColor
                          shadowOpacity:(CGFloat)shadowOpacity {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    shadowOpacity = MIN(1.0, MAX(shadowOpacity, 0.0));
    shadowColor = [shadowColor colorWithAlphaComponent:shadowOpacity];
    
    // 그림자로 인해, 최종적으로 더 넓어진 size
    CGSize expandedSize = CGSizeMake(self.size.width + (blurSize * 2.0), self.size.height + (blurSize * 2.0));
    CGFloat shadowExtend = MAX(ABS(shadowOffset.width), ABS(shadowOffset.height)) * 2.0;
    expandedSize = CGSizeMake(expandedSize.width + shadowExtend, expandedSize.height + shadowExtend);
    
    // uint8_t 8비트(1바이트) 크기의 부호 없는 정수형 변수 선언 unsigned char = uint8_t
    size_t bitsPerComponent = sizeof(uint8_t) * 8;   // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현됨
    NSInteger bytesPerPixel = bitsPerComponent * 4 / 8; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로 나누는것(비트) 4를 곱하는
    NSInteger pixelsWidth = (NSInteger)(expandedSize.width  * scale);
    NSInteger pixelsHeight = (NSInteger)(expandedSize.height * scale);
    NSInteger bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    __unused size_t bitsPerPixel = bytesPerPixel * bitsPerComponent;
    
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

    CGContextDrawImage(shadowContext, drawImageRect, (CGImageRef)[self mgrCGImage]);

    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    // self.size를 쓰면 늘어난 shadow 포함 넓이를 인식못한다.
    NSImage * shadowedImage = [[NSImage alloc] initWithCGImage:shadowedCGImage size:expandedSize];
    
    CGImageRelease(shadowedCGImage);
    return shadowedImage;
}

//! 위와 효과는 동일하다. 다른 방식.
- (NSImage *)mgrAddingShadowBlur:(CGFloat)blur shadowColor:(NSColor *)shadowColor offset:(CGSize)offset {
    CGSize size = self.size;
    //! 여기에 들어가는 사이즈가 이미지 사이즈가 된다.
    CGSize expandedSize = CGSizeMake(size.width + (blur*2.0), size.height + (blur*2.0));
    CGFloat shadowExtend = MAX(ABS(offset.width), ABS(offset.height)) * 2.0;
    expandedSize = CGSizeMake(expandedSize.width + shadowExtend, expandedSize.height + shadowExtend);
    
    CGPoint drawImageOrigin = CGPointMake((expandedSize.width - size.width)/2.0, (expandedSize.height - size.height)/2.0);
    CGRect drawImageRect = (CGRect){drawImageOrigin, (CGSize)(size)};
    
    NSImage *image = [[NSImage alloc] initWithSize:expandedSize];
    [image lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGContextSetShadowWithColor(context, offset, blur, shadowColor.CGColor);
    [self drawInRect:drawImageRect];
    [image unlockFocus];
    return image;
}

/** image 의 중심에서의 일정 부분의 rect는 유지한채 다른 부분을 늘려서 이미지를 늘린다. **/
- (NSImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio // 원본 가로를 1.0로 볼 때, 얼마 보존할 것인지 보존양은 센터 기준
                               preserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio // 원본 가로 크기에서 몇배만큼 늘릴 것인가. 1.0 이상
                                stretchHeightRatio:(CGFloat)stretchHeightRatio {
    
    if (stretchWidthRatio < 1.0 || stretchHeightRatio < 1.0) {
        NSCAssert(FALSE, @"이 메서드는 늘리는 것만 허용한다. 줄이는 것은 허용하지 않는다.");
    }
    
    NSImage *result = self;
    if (stretchWidthRatio > 1.0) { // 1.0 이면 건드릴 필요가 없다.
        CGFloat newWidth = self.size.width * stretchWidthRatio;
        CGFloat step = (newWidth - self.size.width) / 2.0;
        CGFloat firstWidth = self.size.width + step;
        CGFloat secondWidth = newWidth; // self.size.width + step + step; 과 동일하다.
        CGSize firstSize = CGSizeMake(firstWidth, self.size.height);
        CGSize secondSize = CGSizeMake(secondWidth, self.size.height);
        CGFloat firstPreserveEdgeInset = self.size.width - ((self.size.width - (self.size.width * preserveWidthRatio)) / 2.0);
        NSEdgeInsets firstEdgeInsets = NSEdgeInsetsMake(0.0, firstPreserveEdgeInset , 0.0, 0.0);
        CGFloat secondPreserveEdgeInset = firstWidth - ((self.size.width - (self.size.width * preserveWidthRatio)) / 2.0);
        NSEdgeInsets secondEdgeInsets = NSEdgeInsetsMake(0.0, 0.0 , 0.0, secondPreserveEdgeInset);
        
        NSImage *image = [[NSImage alloc] initWithSize:firstSize];
        [image lockFocus];
        [result setCapInsets:firstEdgeInsets];
        [result setResizingMode:NSImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, firstSize.width, firstSize.height)];
        [image unlockFocus];
        result = image;
        
        image = [[NSImage alloc] initWithSize:secondSize];
        [image lockFocus];
        [result setCapInsets:secondEdgeInsets];
        [result setResizingMode:NSImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, secondSize.width, secondSize.height)];
        [image unlockFocus];
        result = image;
    }
    
    if (stretchHeightRatio > 1.0) { // 1.0 이면 건드릴 필요가 없다.
        CGFloat newHeight = self.size.height * stretchHeightRatio;
        CGFloat step = (newHeight - self.size.height) / 2.0;
        CGFloat firstHeight = self.size.height + step;
        CGFloat secondHeight = newHeight; // self.size.width + step + step; 과 동일하다.
        CGSize firstSize = CGSizeMake(result.size.width, firstHeight);
        CGSize secondSize = CGSizeMake(result.size.width, secondHeight);
        CGFloat firstPreserveEdgeInset = self.size.height - ((self.size.height - (self.size.height * preserveHeightRatio)) / 2.0);
        NSEdgeInsets firstEdgeInsets = NSEdgeInsetsMake(firstPreserveEdgeInset, 0.0 , 0.0, 0.0);
        CGFloat secondPreserveEdgeInset = firstHeight - ((self.size.height - (self.size.height * preserveHeightRatio)) / 2.0);
        NSEdgeInsets secondEdgeInsets = NSEdgeInsetsMake(0.0, 0.0 , secondPreserveEdgeInset, 0.0);
        
        NSImage *image = [[NSImage alloc] initWithSize:firstSize];
        [image lockFocus];
        [result setCapInsets:firstEdgeInsets];
        [result setResizingMode:NSImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, firstSize.width, firstSize.height)];
        [image unlockFocus];
        result = image;
        
        image = [[NSImage alloc] initWithSize:secondSize];
        [image lockFocus];
        [result setCapInsets:secondEdgeInsets];
        [result setResizingMode:NSImageResizingModeStretch];
        [result drawInRect:CGRectMake(0, 0, secondSize.width, secondSize.height)];
        [image unlockFocus];
        result = image;
    }
    return result;
}

// convenience
- (NSImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio {
    return [self mgrStretchSideWidthPreserveWidthRatio:preserveWidthRatio
                                   preserveHeightRatio:1.0
                                     stretchWidthRatio:stretchWidthRatio
                                    stretchHeightRatio:1.0];
}

// convenience
- (NSImage *)mgrStretchSideWidthPreserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchHeightRatio:(CGFloat)stretchHeightRatio {
    return [self mgrStretchSideWidthPreserveWidthRatio:1.0
                                   preserveHeightRatio:preserveHeightRatio
                                     stretchWidthRatio:1.0
                                    stretchHeightRatio:stretchHeightRatio];
}

@end
