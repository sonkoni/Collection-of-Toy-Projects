//
//  MGENoise.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGENoise.h"

static NSUInteger const kMGENoiseImageSize = 128;

static inline CGFloat *gradientComponentsForColors(MGEColor *color1, MGEColor *color2) {
    CGFloat *components = (CGFloat *)malloc(8*sizeof(CGFloat));
    const CGFloat *alternateBackgroundComponents = CGColorGetComponents([color1 CGColor]);
    if(CGColorGetNumberOfComponents([color1 CGColor]) == 2){
        components[0] = alternateBackgroundComponents[0];
        components[1] = alternateBackgroundComponents[0];
        components[2] = alternateBackgroundComponents[0];
        components[3] = alternateBackgroundComponents[1];
    }else{
        components[0] = alternateBackgroundComponents[0];
        components[1] = alternateBackgroundComponents[1];
        components[2] = alternateBackgroundComponents[2];
        components[3] = alternateBackgroundComponents[3];
    }

    const CGFloat *backgroundComponents = CGColorGetComponents([color2 CGColor]);
    if(CGColorGetNumberOfComponents([color2 CGColor]) == 2){
        components[4] = backgroundComponents[0];
        components[5] = backgroundComponents[0];
        components[6] = backgroundComponents[0];
        components[7] = backgroundComponents[1];
    }else{
        components[4] = backgroundComponents[0];
        components[5] = backgroundComponents[1];
        components[6] = backgroundComponents[2];
        components[7] = backgroundComponents[3];
    }
    return components;
}

void MGRDrawNoiseWithOpacityBlendMode(CGFloat opacity, CGBlendMode blendMode, CGContextRef context) {
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger scale = 1; // UIScreen.mainScreen.scale 를 쓰면 overHead 위험이 있다. 그냥 1로하자.
        NSUInteger pixelsWideth = kMGENoiseImageSize * scale;
        NSUInteger pixelsHigh = kMGENoiseImageSize * scale;
        NSUInteger size = pixelsWideth * pixelsHigh;
        char *bitmapData = (char *)malloc(size); // CGColorSpaceCreateDeviceGray를 사용하고, 알파도 단순 1이므로 char 로 충분.

        for(NSUInteger i = 0; i < size; ++i){
            bitmapData[i] = (char)(arc4random_uniform(256));
        }
        
        // uint8_t 8비트(1바이트) 크기의 부호 없는 정수형 변수 선언 unsigned char = uint8_t
        NSInteger bitsPerComponent = sizeof(uint8_t) * 8; // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현됨
        NSInteger bytesPerPixel = bitsPerComponent * 1 / 8; // 결과적으로 1을 반환한다.
        // 결과적으로 1이다.(1바이트) 한 픽셀은 RGBA통(RGB통 A=1고정)으로 이렇게 1바이트로 구성하겠다는 뜻.
        // 8로 나누는것(비트) 1를 곱하는 것(RGB통 A=1고정) 왜냐하면 그레이스케일로 알파 없이 하나의 값으로 결정됨.
        // 1을 곱하는 것은 grayscale 정보하나(1 바이트)만 포함하기 때문이고, 8을 나누는 것은 비트를 바이트로 고치기 위함이다.
        
        NSInteger bytesPerRow = bytesPerPixel * pixelsWideth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        CGContextRef bitmapContext = CGBitmapContextCreate(bitmapData,
                                                           pixelsWideth,
                                                           pixelsHigh,
                                                           bitsPerComponent,
                                                           bytesPerRow,
                                                           colorSpace,
                                                           (CGBitmapInfo)kCGImageAlphaNone);
        /** Color-Picker-for-iOS 에서는 CGImageCreate를 사용했다.
        CGImageRef CGImageCreate(size_t width,                   // width
                                 size_t height,                  // height
                                 size_t bitsPerComponent,        // 8
                                 size_t bitsPerPixel,            // 24
                                 size_t bytesPerRow,             // width * 3
                                 CGColorSpaceRef space,          // colorSpace
                                 CGBitmapInfo bitmapInfo,        // 0
                                 CGDataProviderRef provider,     // dataProvider
                                 const CGFloat *decode,          // NULL
                                 bool shouldInterpolate,         // NO
                                 CGColorRenderingIntent intent); // kCGRenderingIntentDefault
         */
        // CGContextSetInterpolationQuality(bitmapContext, kCGInterpolationNone);
        // CGContextSetShouldAntialias(bitmapContext, NO);    // 디폴트가 YES
        // CGContextSetAllowsAntialiasing(bitmapContext, NO); // 디폴트가 YES
        // CGContextSetRenderingIntent(bitmapContext, kCGRenderingIntentDefault);
        
        CGColorSpaceRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(bitmapData);
    });

    
    if (context == NULL) {
#if TARGET_OS_IPHONE
        context = UIGraphicsGetCurrentContext();
#else
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101400
        context = [NSGraphicsContext currentContext].CGContext;
#else
        if (@available(macOS 10.14, *)) {
            context = [NSGraphicsContext currentContext].CGContext;
        } else {
            context = [[NSGraphicsContext currentContext] graphicsPort];
        }
#endif
#endif
    }

    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, blendMode);

#if TARGET_OS_IPHONE
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) {
        CGFloat scaleFactor = [[UIScreen mainScreen] scale];
        CGContextScaleCTM(context, 1.0/scaleFactor, 1.0/scaleFactor);
    }
#else
    if([[NSScreen mainScreen] respondsToSelector:@selector(backingScaleFactor)]){
        CGFloat scaleFactor = [[NSScreen mainScreen] backingScaleFactor];
        CGContextScaleCTM(context, 1.0/scaleFactor, 1.0/scaleFactor);
    }
#endif
    
    CGRect imageRect = {.size={(CGFloat)CGImageGetWidth(noiseImageRef), (CGFloat)CGImageGetHeight(noiseImageRef)}};
    
    //! 아래 세 줄은 내가 추가했다. 잘 했는지는 모르겠다.
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextSetShouldAntialias(context, NO);    // 디폴트가 YES
    CGContextSetAllowsAntialiasing(context, NO); // 디폴트가 YES
    
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
    //
    /**
    typedef CF_OPTIONS(uint32_t, CGBitmapInfo) {
        kCGBitmapAlphaInfoMask = 0x1F,
        kCGBitmapFloatInfoMask = 0xF00,
        kCGBitmapFloatComponents = (1 << 8),
        kCGBitmapByteOrderMask     = kCGImageByteOrderMask,
        kCGBitmapByteOrderDefault  = kCGImageByteOrderDefault,
        kCGBitmapByteOrder16Little = kCGImageByteOrder16Little,
        kCGBitmapByteOrder32Little = kCGImageByteOrder32Little,
        kCGBitmapByteOrder16Big    = kCGImageByteOrder16Big,
        kCGBitmapByteOrder32Big    = kCGImageByteOrder32Big
    } CG_AVAILABLE_STARTING(10.0, 2.0); **/
    
    /**
    typedef CF_ENUM(uint32_t, CGImageAlphaInfo) {
        kCGImageAlphaNone,               // For example, RGB.
        kCGImageAlphaPremultipliedLast,  // For example, premultiplied RGBA
        kCGImageAlphaPremultipliedFirst, // For example, premultiplied ARGB
        kCGImageAlphaLast,               // For example, non-premultiplied RGBA
        kCGImageAlphaFirst,              // For example, non-premultiplied ARGB
        kCGImageAlphaNoneSkipLast,       // For example, RBGX.
        kCGImageAlphaNoneSkipFirst,      // For example, XRGB.
        kCGImageAlphaOnly                // No color data, alpha data only
    };**/
    // kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little 이런식으로 사용가능.
}


#pragma mark - MGENoise Color
@implementation MGEColor (MGENoise)

- (MGEColor *)mgrColorWithNoiseWithOpacity:(CGFloat)opacity {
    return [self mgrColorWithNoiseWithOpacity:opacity andBlendMode:kCGBlendModeScreen];
}

- (MGEColor *)mgrColorWithNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode {
    CGRect rect = {.size = {kMGENoiseImageSize, kMGENoiseImageSize}};
#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f); // (size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self setFill];
    CGContextFillRect(context, rect);
    MGRDrawNoiseWithOpacityBlendMode(opacity, blendMode, NULL);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
#else
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    [self setFill]; CGContextFillRect(context, rect);
    MGRDrawNoiseWithOpacityBlendMode(opacity, blendMode, NULL);
    [image unlockFocus];
    return [NSColor colorWithPatternImage:image];
#endif
}

@end


#pragma mark - MGENoise Image
@implementation MGEImage (MGENoise)
- (MGEImage *)mgrImageWithNoiseOpacity:(CGFloat)opacity {
    return [self mgrImageWithNoiseOpacity:opacity andBlendMode:kCGBlendModeScreen];
}

- (MGEImage *)mgrImageWithNoiseOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode {
#if TARGET_OS_IPHONE
    CGRect rect = {.size=self.size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawAtPoint:CGPointZero];
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -CGRectGetHeight(rect));
    CGContextClipToMask(context, rect, [self CGImage]);

    MGRDrawNoiseWithOpacityBlendMode(opacity, blendMode, NULL);

    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
#else
    CGRect rect = {.size=self.size};
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    [self drawAtPoint:CGPointZero fromRect:CGRectZero operation:NSCompositingOperationSourceOver fraction:1];
    CGContextClipToMask(context, rect, [self CGImageForProposedRect:NULL context:[NSGraphicsContext currentContext] hints:nil]);
    MGRDrawNoiseWithOpacityBlendMode(opacity, blendMode, NULL);
//    [MGENoise drawNoiseWithOpacity:opacity andBlendMode:blendMode];
    CGContextRestoreGState(context);
    [image unlockFocus];
    return image;
#endif
}
@end


#pragma mark - MGENoiseView
@implementation MGENoiseView
    
#if TARGET_OS_IPHONE
- (instancetype)initWithFrame:(CGRect)frameRect{
#else
- (instancetype)initWithFrame:(NSRect)frameRect{
#endif
    if((self = [super initWithFrame:frameRect])) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        [self setup];
    }
    return self;
}

- (void)setup{
#if TARGET_OS_IPHONE
    if(!self.backgroundColor){
        self.backgroundColor = [UIColor grayColor];
    }
    self.contentMode = UIViewContentModeRedraw;
#else
    if(!self.backgroundColor) {
        self.backgroundColor = [NSColor grayColor];
    }
#endif
    self.noiseOpacity = 0.1;
    self.noiseBlendMode = kCGBlendModeScreen;
}
    
#if TARGET_OS_IPHONE
#else
- (void)setBackgroundColor:(NSColor *)backgroundColor{
    if(_backgroundColor != backgroundColor){
        _backgroundColor = backgroundColor;
        [self setNeedsDisplay:YES];
    }
}
#endif

- (void)setNoiseOpacity:(CGFloat)noiseOpacity{
    if(_noiseOpacity != noiseOpacity){
        _noiseOpacity = noiseOpacity;
#if TARGET_OS_IPHONE
        [self setNeedsDisplay];
#else
        [self setNeedsDisplay:YES];
#endif
    }
}
    
- (void)setNoiseBlendMode:(CGBlendMode)noiseBlendMode{
    if(_noiseBlendMode != noiseBlendMode){
        _noiseBlendMode = noiseBlendMode;
#if TARGET_OS_IPHONE
        [self setNeedsDisplay];
#else
        [self setNeedsDisplay:YES];
#endif
    }
}

#if TARGET_OS_IPHONE
- (void)drawRect:(CGRect)dirtyRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
- (void)drawRect:(NSRect)dirtyRect{
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    [self.backgroundColor setFill];
    CGContextFillRect(context, self.bounds);
    MGRDrawNoiseWithOpacityBlendMode(self.noiseOpacity, self.noiseBlendMode, NULL);
}
    
@end

#pragma mark - MGENoiseLinearGradientView

@implementation MGENoiseLinearGradientView
    
- (void)setup{
    [super setup];
    self.gradientDirection = KGLinearGradientDirection270Degrees;
}

#if TARGET_OS_IPHONE
- (void)setAlternateBackgroundColor:(UIColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay];
    }
}
#else
- (void)setAlternateBackgroundColor:(NSColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay:YES];
    }
}
#endif
    
#if TARGET_OS_IPHONE
- (void)drawRect:(CGRect)dirtyRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
- (void)drawRect:(NSRect)dirtyRect{
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    // if we don't have an alternate color draw solid
    if(self.alternateBackgroundColor == nil){
        [super drawRect:dirtyRect];
        return;
    }
    
    CGRect bounds = self.bounds;
    CGContextSaveGState(context);
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat *components = gradientComponentsForColors(self.alternateBackgroundColor, self.backgroundColor);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, NULL, 2);
    CGColorSpaceRelease(baseSpace);
    baseSpace = NULL;
    CGPoint startPoint;
    CGPoint endPoint;
    switch (self.gradientDirection) {
        case KGLinearGradientDirection0Degrees:
            startPoint = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
            endPoint = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
            break;
        case KGLinearGradientDirection90Degrees:
            startPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
            endPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
            break;
        case KGLinearGradientDirection180Degrees:
            startPoint = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
            endPoint = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
            break;
        case KGLinearGradientDirection270Degrees:
        default:
            startPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
            endPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    gradient = NULL;
    CGContextRestoreGState(context);
    free(components);
    
    MGRDrawNoiseWithOpacityBlendMode(self.noiseOpacity, self.noiseBlendMode, NULL);
}
    
@end

#pragma mark - MGENoiseRadialGradientView

@implementation MGENoiseRadialGradientView
#if TARGET_OS_IPHONE
- (void)setAlternateBackgroundColor:(UIColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay];
    }
}
#else
- (void)setAlternateBackgroundColor:(NSColor *)alternateBackgroundColor{
    if(_alternateBackgroundColor != alternateBackgroundColor){
        _alternateBackgroundColor = alternateBackgroundColor;
        [self setNeedsDisplay:YES];
    }
}
#endif

#if TARGET_OS_IPHONE
- (void)drawRect:(CGRect)dirtyRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
- (void)drawRect:(NSRect)dirtyRect{
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    // if we don't have an alternate color draw solid
    if(self.alternateBackgroundColor == nil){
        [super drawRect:dirtyRect];
        return;
    }
    
    CGRect bounds = self.bounds;
    CGContextSaveGState(context);
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat *components = gradientComponentsForColors(self.alternateBackgroundColor, self.backgroundColor);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(bounds)), round(CGRectGetMidY(bounds)));
    CGFloat gradRadius = sqrt(pow((CGRectGetHeight(bounds)/2), 2) + pow((CGRectGetWidth(bounds)/2), 2));
    CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    gradient = NULL;
    CGContextRestoreGState(context);
    free(components);
    
    MGRDrawNoiseWithOpacityBlendMode(self.noiseOpacity, self.noiseBlendMode, NULL);
}
    
@end
