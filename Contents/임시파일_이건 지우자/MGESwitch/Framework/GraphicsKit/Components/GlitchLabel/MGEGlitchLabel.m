//
//  MGEGlitchLabel.m
//
//  Created by Kwan Hyun Son on 2022/03/30.
//

#import "MGEGlitchLabel.h"
#import "MGEImageHelper.h"
@import BaseKit;

@interface MGEGlitchLabel ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger channel;   // 디폴트 0 (0 -> 1 -> 2 -> 0 -> 1 -> 2 -> 0 -> ...)
@property (nonatomic, assign) CGFloat amplitude;   // 디폴트 2.5
@property (nonatomic, assign) CGFloat phase;       // 디폴트 0.9
@property (nonatomic, assign) CGFloat phaseStep;   // 디폴트 0.05
@property (nonatomic, assign) CGFloat globalAlpha; // 디폴트 0.8
@end

@implementation MGEGlitchLabel

- (void)dealloc {
    [self finishAnimation];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}


#if TARGET_OS_IPHONE
- (void)drawTextInRect:(CGRect)rect {
    [self mgrDrawRect:rect];
}

#else
- (void)drawRect:(CGRect)dirtyRect {
    [self mgrDrawRect:dirtyRect];
}
#endif

- (void)mgrDrawRect:(CGRect)dirtyRect {
    if (self.glitchEnabled == NO) {
#if TARGET_OS_IPHONE
        [super drawTextInRect:dirtyRect]; return;
#else
        [super drawRect:dirtyRect]; return;
#endif
    }
    
    CGFloat x0 = self.amplitude * sin((M_PI * 2.0) * self.phase);
        
    if (MGRRandomFloat() >= self.glitchThreshold) { // 0.9
        x0 = x0 * self.glitchAmplitude;             // 10.0
    }

    CGFloat x1 = floor(self.bounds.origin.x);
    CGFloat x2 = x1 + x0;
    CGFloat x3 = x1 - x0;

    self.globalAlpha = MGRRandomFloatRange(self.alphaMin, 1.0);

    MGEImage *channelsImage;
    
    switch (self.channel) {
        case 0:  {
            channelsImage = [self getChannelsImage:x1 x2:x2 x3:x3];
            break;
        }
        case 1:  {
            channelsImage = [self getChannelsImage:x2 x2:x3 x3:x1];
            break;
        }
        case 2:  {
            channelsImage = [self getChannelsImage:x3 x2:x1 x3:x2];
            break;
        }
        default: {
            NSLog(@"ERROR");
            break;
        }
    }
    
    if (channelsImage != nil) {
        [channelsImage drawInRect:self.bounds];
        if (self.drawScanline == YES) {
            [[self getScanlineImage:channelsImage] drawInRect:self.bounds];
            if (MGRRandomFloatRange(0.0, 2.0) > 1.0) {
                [[self getScanlineImage:channelsImage] drawInRect:self.bounds];
            }
        }
    }

}


#pragma mark - 생성 & 소멸
static void CommonInit(MGEGlitchLabel *self) {
    self->_amplitudeMIN = 2.0;
    self->_amplitudeMAX = 3.0;
    
    self->_glitchAmplitude = 10.0;
    self->_glitchThreshold = 0.9;
    
    self->_alphaMin = 0.8;
    
    self->_glitchEnabled = YES;
    self->_drawScanline = YES;
#if TARGET_OS_IPHONE
    self->_blendMode = kCGBlendModeLighten;
#else
    self->_compositingOperation = NSCompositingOperationLighten;
#endif
    
//    kCGBlendModeMultiply,
//    kCGBlendModeScreen,
//    kCGBlendModeOverlay,
//    kCGBlendModeDarken,
//    kCGBlendModeLighten,
//    kCGBlendModeColorDodge,
//    kCGBlendModeColorBurn,
//    kCGBlendModeSoftLight,
//    kCGBlendModeHardLight,
//    kCGBlendModeDifference,
//    kCGBlendModeExclusion,
//    kCGBlendModeHue,
//    kCGBlendModeSaturation,
//    kCGBlendModeColor,
//    kCGBlendModeLuminosity,
//    kCGBlendModeClear,                  /* R = 0 */
//    kCGBlendModeCopy,                   /* R = S */
//    kCGBlendModeSourceIn,               /* R = S*Da */
//    kCGBlendModeSourceOut,              /* R = S*(1 - Da) */
//    kCGBlendModeSourceAtop,             /* R = S*Da + D*(1 - Sa) */
//    kCGBlendModeDestinationOver,        /* R = S*(1 - Da) + D */
//    kCGBlendModeDestinationIn,          /* R = D*Sa */
//    kCGBlendModeDestinationOut,         /* R = D*(1 - Sa) */
//    kCGBlendModeDestinationAtop,        /* R = S*(1 - Da) + D*Sa */
//    kCGBlendModeXOR,                    /* R = S*(1 - Da) + D*(1 - Sa) */
//    kCGBlendModePlusDarker,             /* R = MAX(0, (1 - D) + (1 - S)) */
//    kCGBlendModePlusLighter             /* R = MIN(1, S + D) */
    
    self->_channel = 0;
    self->_amplitude = 2.5;
    self->_phase = 0.9;
    self->_phaseStep = 0.05;
    self->_globalAlpha = 0.8;
    [self startAnimation];
}


#pragma mark - 컨트롤
- (void)tick:(NSTimer *)timer {
    self.phase = self.phase + self.phaseStep; // 5% 씩.
    if (self.phase > 1.0) {
        self.phase = 0.0;
        self.channel = (self.channel == 2) ? 0 : self.channel + 1; // 디폴트 0 (0 -> 1 -> 2 -> 0 -> 1 -> 2 -> 0 -> ...)
        self.amplitude = MGRRandomFloatRange(self.amplitudeMIN, self.amplitudeMAX);
    }
#if TARGET_OS_IPHONE
    [self setNeedsDisplay];
#else
    self.needsDisplay = YES; // setNeedsDisplay' is deprecated: - Set the needsDisplay property to YES instead
    [self setNeedsDisplayInRect:self.bounds];  // 이걸 추가로 써줘야하나???
//    [self displayIfNeeded]; // 이걸 추가로 써줘야하나???
#endif
}

- (void)startAnimation {
    if (_timer != nil) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    // + scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:
    _timer = [NSTimer timerWithTimeInterval:1/30.0
                                     target:weakSelf
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes]; // <- NSRunLoopCommonModes 해야 인터렉션 딜레이 방지할 수 있다. NSDefaultRunLoopMode
    self.timer.tolerance = 0.1; // 허용오차. 약간의 오차를 줘야지 프로그램이 메모리를 덜먹는다. 보통 0.1
    
}

- (void)finishAnimation {
    if (_timer == nil) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - get Image (Channels, Scanline)
- (MGEImage *)getChannelsImage:(CGFloat)x1 x2:(CGFloat)x2 x3:(CGFloat)x3 {
    MGEImage *redImage = [self getImageWithColor:[MGEColor redColor]];
    MGEImage *greenImage = [self getImageWithColor:[MGEColor greenColor]];
    MGEImage *blueImage = [self getImageWithColor:[MGEColor blueColor]];

#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
#else
    MGEImage *channelsImage = [[MGEImage alloc] initWithSize:self.bounds.size];
    [channelsImage lockFocus];
#endif

    CGRect rect1 = {CGPointMake(self.bounds.origin.x + x1, self.bounds.origin.y), self.bounds.size};
    CGRect rect2 = {CGPointMake(self.bounds.origin.x + x2, self.bounds.origin.y), self.bounds.size};
    CGRect rect3 = {CGPointMake(self.bounds.origin.x + x3, self.bounds.origin.y), self.bounds.size};
    
#if TARGET_OS_IPHONE
    [redImage drawInRect:rect1 blendMode:self.blendMode alpha:self.globalAlpha];
    [greenImage drawInRect:rect2 blendMode:self.blendMode alpha:self.globalAlpha];
    [blueImage drawInRect:rect3 blendMode:self.blendMode alpha:self.globalAlpha];
    UIImage * channelsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 여기까지는 풀사이즈.
#else
    [redImage drawInRect:rect1 fromRect:NSZeroRect operation:self.compositingOperation fraction:self.globalAlpha];
    [greenImage drawInRect:rect2 fromRect:NSZeroRect operation:self.compositingOperation fraction:self.globalAlpha];
    [blueImage drawInRect:rect3 fromRect:NSZeroRect operation:self.compositingOperation fraction:self.globalAlpha];
    [channelsImage unlockFocus];
#endif
    return channelsImage;
}
    
- (MGEImage * _Nullable)getScanlineImage:(MGEImage *)channelsImage {
#if TARGET_OS_IPHONE
    CGImageRef imageRef = channelsImage.CGImage;
#else
    CGImageRef imageRef = MGECGImageGetImage(channelsImage);
#endif
    if (imageRef == nil) {
        return nil;
    }
    CGFloat y = MGRRandomFloatRange(0.0, self.bounds.size.height);
    CGFloat y2 = MGRRandomFloatRange(0.0, self.bounds.size.height);
    
#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
    MGEImage *scanlineImage = [[MGEImage alloc] initWithSize:self.bounds.size];
    [scanlineImage lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
#endif
    
    // Get pixels
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(provider);
    
    // Get pixels with rect
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    size_t components  = CGImageGetBitsPerPixel(imageRef) / CGImageGetBitsPerComponent(imageRef);
    //! CGImageGetBytesPerRow(imageRef) 가로로 한 줄당 몇개의 바이트가 존재하는가 3424(이미지 크기에 따라 다르다.)
    //! CGImageGetBitsPerPixel(imageRef) 필셀당 비트 수 : 32 비트(= 4 바이트)
    //! CGImageGetBitsPerComponent(imageRef) 각 요소가 갖는 비트 수 (8 비트)
    //! size_t components : 4 개
    
    __unused size_t start = bytesPerRow * CGRectGetMinY(self.bounds) + components * CGRectGetMinX(self.bounds);    // (좌상)
    size_t end = bytesPerRow * (CGRectGetMaxY(self.bounds) - 1) + components * CGRectGetMaxX(self.bounds);// (우하)
    
    if (CFDataGetLength(dataRef) < (CFIndex)end) {
        CFRelease(dataRef);
        return nil;
    }
    
//    NSData *data = (__bridge_transfer NSData *)dataRef;
//    const UInt8 *bytePointer = (const UInt8 *)data.bytes;
    const UInt8 *bytePointer = CFDataGetBytePtr(dataRef);
    
    //! 특정 라인으로 제한.
    start = bytesPerRow * y + components * CGRectGetMinX(self.bounds);
    end   = bytesPerRow * y + components * CGRectGetMaxX(self.bounds);

    size_t length = end - start;
    size_t unit = length / (NSInteger)(self.bounds.size.width);
    //! unit - 4
    
    for (NSInteger col = 0; col < (NSInteger)(self.bounds.size.width); col++) {
        NSInteger index = start + (unit * col);
        
        UInt8 alpha = bytePointer[index];
        UInt8 red = bytePointer[index+1];
        UInt8 green = bytePointer[index+2];
        UInt8 blue = bytePointer[index+3];
        
        CGContextSetRGBFillColor(context, (CGFloat)(red / 255.0),
                                          (CGFloat)(green / 255.0),
                                          (CGFloat)(blue / 255.0),
                                          (CGFloat)(alpha / 255.0));
        
        CGContextFillRect(context, CGRectMake((CGFloat)col, y2, 1.0, 0.5));
    }
    
#if TARGET_OS_IPHONE
    UIImage * scanlineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 여기까지는 풀사이즈.
#else
    [scanlineImage unlockFocus];
#endif
    CFRelease(dataRef);
    return scanlineImage;
}

    
#pragma mark - get Image (red, green, blue)
- (MGEImage *)getImageWithColor:(MGEColor *)color {
#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
    NSDictionary <NSAttributedStringKey, id>*attributes =
        @{ NSFontAttributeName            : [self.font fontWithSize:self.font.pointSize],
           NSForegroundColorAttributeName : color };
    [self.text drawInRect:self.bounds withAttributes:attributes];
    UIImage * colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // 여기까지는 풀사이즈.
#else
    MGEImage *colorImage = [[MGEImage alloc] initWithSize:self.bounds.size];
    [colorImage lockFocus];
    NSDictionary <NSAttributedStringKey, id>*attributes =
        @{ NSFontAttributeName            : [self.font fontWithSize:self.font.pointSize],
            NSForegroundColorAttributeName : color };
    [self.stringValue drawInRect:self.bounds withAttributes:attributes];
    [colorImage unlockFocus];
#endif
    return colorImage;

}

@end
//
//    [NSGraphicsContext currentContextDrawingToScreen]
//- (NSArray<UIColor *> *)sd_colorsWithRect:(CGRect)rect {
//    if (!self) {
//        return nil;
//    }
//    CGImageRef imageRef = self.CGImage;
//    if (!imageRef) {
//        return nil;
//    }
//
//    // Check rect
//    CGFloat width = CGImageGetWidth(imageRef);
//    CGFloat height = CGImageGetHeight(imageRef);
//    if (CGRectGetWidth(rect) <= 0 || CGRectGetHeight(rect) <= 0 || CGRectGetMinX(rect) < 0 || CGRectGetMinY(rect) < 0 || CGRectGetMaxX(rect) > width || CGRectGetMaxY(rect) > height) {
//        return nil;
//    }
//
//    // Get pixels
//    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
//    if (!provider) {
//        return nil;
//    }
//    CFDataRef data = CGDataProviderCopyData(provider);
//    if (!data) {
//        return nil;
//    }
//
//    // Get pixels with rect
//    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
//    size_t components = CGImageGetBitsPerPixel(imageRef) / CGImageGetBitsPerComponent(imageRef);
//
//    size_t start = bytesPerRow * CGRectGetMinY(rect) + components * CGRectGetMinX(rect);
//    size_t end = bytesPerRow * (CGRectGetMaxY(rect) - 1) + components * CGRectGetMaxX(rect);
//    if (CFDataGetLength(data) < (CFIndex)end) {
//        CFRelease(data);
//        return nil;
//    }
//
//    const UInt8 *pixels = CFDataGetBytePtr(data);
//    size_t row = CGRectGetMinY(rect);
//    size_t col = CGRectGetMaxX(rect);
//
//    // Convert to color
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
//    NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:CGRectGetWidth(rect) * CGRectGetHeight(rect)];
//    for (size_t index = start; index < end; index += 4) {
//        if (index >= row * bytesPerRow + col * components) {
//            // Index beyond the end of current row, go next row
//            row++;
//            index = row * bytesPerRow + CGRectGetMinX(rect) * components;
//            index -= 4;
//            continue;
//        }
//        Pixel_8888 pixel = {pixels[index], pixels[index+1], pixels[index+2], pixels[index+3]};
//        UIColor *color = SDGetColorFromPixel(pixel, bitmapInfo);
//        [colors addObject:color];
//    }
//    CFRelease(data);
//
//    return [colors copy];
//}

