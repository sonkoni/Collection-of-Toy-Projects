//
//  MGEGradientGenerator.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEGradientGenerator.h"
#import "MGEAvailability.h"

#pragma mark - typedef : ARGB 구조체

typedef struct __ARGB {
    uint8_t a;
    uint8_t r;
    uint8_t g;
    uint8_t b;
    //
    // const uint8_t a; 로 사용하고 싶은데 컴파일러 에러가 뜬다. XCode 업데이트 후 에러가 뜨는데, 버그일듯하다.
    // - (CGImageRef)image 메서드 내부의 data[i] = c; 부분에서 Cannot assign to lvalue with const-qualified data member 'a' 메시지가 뜬다.
} ARGB;

ARGB ARGBInit(void);
ARGB ARGBInitWithCGColor(CGColorRef color);
ARGB ARGBinterpolate(ARGB color1, ARGB color2,  CGFloat interpolationAmount);
uint8_t lerp(CGFloat interpolationAmount, uint8_t colorComponent1, uint8_t colorComponent2);

ARGB ARGBInit(){
    return (ARGB){.a = 0xff, .r = 0x0, .g = 0x0 , .b = 0x0};
}

ARGB ARGBInitWithCGColor(CGColorRef color){
    ARGB argb = ARGBInit();
    CGFloat *rgbaComponents = (CGFloat *)CGColorGetComponents(color);
    for (int i = 0; i < 3; i++) { // 알파는 뽑지 않겠다. 0, 1, 2까지만 사용.
        rgbaComponents[i] = MIN(MAX(rgbaComponents[i], 0.0), 1.0);
    }
    
    switch (CGColorGetNumberOfComponents(color)) {
        case 2:  {
            argb.r = (uint8_t)(rgbaComponents[0] * 0xff);
            argb.g = (uint8_t)(rgbaComponents[0] * 0xff);
            argb.b = (uint8_t)(rgbaComponents[0] * 0xff);
            break;
        }
        case 4:  {
            argb.r = (uint8_t)(rgbaComponents[0] * 0xff); // 255를 곱하는 것이다. 0xff = 255(십진수.)이다.
            argb.g = (uint8_t)(rgbaComponents[1] * 0xff);
            argb.b = (uint8_t)(rgbaComponents[2] * 0xff);
            break;
        }
        default:
            break;
    }
    return argb;
}

/// LERP : Linear interpolation between two points or rotations (두 점 또는 회전 사이의 선형 보간)
ARGB ARGBinterpolate(ARGB color1, ARGB color2,  CGFloat interpolationAmount) {
    uint8_t red   = lerp(interpolationAmount, color1.r, color2.r);
    uint8_t green = lerp(interpolationAmount, color1.g, color2.g);
    uint8_t blue  = lerp(interpolationAmount, color1.b, color2.b);
    
    ARGB argb = ARGBInit();
    argb.r = red;
    argb.g = green;
    argb.b = blue;
    
    return argb;
}

uint8_t lerp(CGFloat interpolationAmount, uint8_t colorComponent1, uint8_t colorComponent2) {
    uint8_t result = (uint8_t)(
                               (CGFloat)colorComponent1 +
                               (MIN(MAX(interpolationAmount, 0.0), 1.0) * ((CGFloat)colorComponent2 - (CGFloat)colorComponent1))
                               );
    return result;
}


#pragma mark - GradientGenerator

@interface MGEGradientGenerator ()
@property (nonatomic, nullable) CGImageRef generatedImage;
@end

@implementation MGEGradientGenerator

- (instancetype)init {
    self = [super init];
    if (self) {
        _scale = MGE_MAINSCREEN_SCALE; // 그대로 쓰면 심하게 버벅댄다. 앱에서는 1.0이 되게 될 것이다.
        _size  = CGSizeZero;
    }
    return self;
}


#pragma mark - 세터 & 게터
- (void)setEdgeAngle:(CGFloat)edgeAngle {
    if(_edgeAngle != edgeAngle) {
        _edgeAngle = edgeAngle;
        [self reset];
    }
}

- (void)setScale:(CGFloat)scale {
    if(_scale != scale) {
        _scale = scale;
        [self reset];
    }
}

- (void)setSize:(CGSize)size {
    if( CGSizeEqualToSize(_size, size) == NO) {
        _size = size;
        [self reset];
    }
}

- (void)setStartColor:(CGColorRef)startColor {
    if (CGColorEqualToColor(_startColor, startColor) == NO) {
        _startColor = startColor;
        [self reset];
    }
}

- (void)setEndColor:(CGColorRef)endColor {
    if (CGColorEqualToColor(_endColor, endColor) == NO) {
        _endColor = endColor;
        [self reset];
    }
}

- (CGImageRef)image {
    if (self.generatedImage != nil) {
        return self.generatedImage;
    }
    
    NSInteger pixelsWidth = (NSInteger)(self.size.width  * self.scale); // w, h는 같게 주어진다.
    NSInteger pixelsHeight = (NSInteger)(self.size.height * self.scale);
    ARGB data[pixelsWidth * pixelsHeight];
    int i = 0;
    
    for (int y = 0; y < pixelsHeight; y++) {
        for (int x = 0; x < pixelsWidth; x++) {
            ARGB c = [self pixelDataForGradientAt:CGPointMake(x, y)
                                             size:CGSizeMake(pixelsWidth, pixelsHeight)];
            data[i] = c;
            i++;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); // 릴리즈 때문에 변수로 잡아야한다.
    NSUInteger const componentsPerPixel = 4;
    size_t const bytesPerComponent = sizeof(uint8_t);
    size_t const bitsPerComponent = bytesPerComponent * CHAR_BIT; // 8이다.(8비트 = 1바이트) 채널당 비트수. 2의 8승 즉 한 채널당 (RGBA 각각) 256 단계로 표현
    size_t const bytesPerPixel = bytesPerComponent * componentsPerPixel; // 4이다.(4바이트) 한 픽셀은 RGBA 이렇게 4바이트로 구성하겠음. 8로 나누는것(비트) 4를 곱하는 것(RGBA) size_t bytesPerPixel = bitsPerComponent * 4 / 8;
    __unused size_t const bitsPerPixel = bitsPerComponent * componentsPerPixel;
    size_t bytesPerRow = bytesPerPixel * pixelsWidth; // 이미지 한 줄당 바이트수. 0을 넣으면 자동계산됨
    CGContextRef context = CGBitmapContextCreate(data,
                                                 pixelsWidth,
                                                 pixelsHeight,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst); // 색공간에서 ARGB 로 한 픽셀을 구성하겠음.(알파가 제일먼저.)
    
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
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextSetShouldAntialias(context, NO);    // 디폴트가 YES
    CGContextSetAllowsAntialiasing(context, NO); // 디폴트가 YES
    // CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    
    CGImageRef img = CGBitmapContextCreateImage(context);
    self.generatedImage = img;
    CGImageRetain(self.generatedImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(img);
    
    return self.generatedImage; // return (CGImageRef)CFAutorelease(img);
    
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


#pragma mark - 지원 메서드

//! uint8_t (=unsigned char)에 해당하는 NSNumber 인스턴스를 담고 있는 4개 짜리 배열을 반환한다. alpha는 상수
- (ARGB)pixelDataForGradientAt:(CGPoint)point
                          size:(CGSize)size {
    
    CGPoint centerPoint = CGPointMake(size.width / 2.0, size.height / 2.0);
    point = CGPointMake(point.x - centerPoint.x, point.y - centerPoint.y);  // centerPoint를 (0, 0) 했을 때 좌표 값이다.
    CGFloat degree = atan2(point.y, point.x) * (180.0 / M_PI) - 90.0; // 단위를 ˚(도)로 치환하고 12시 방향이 0˚로 바꾼다.
    if (degree < 0.0) {
        degree = degree + 360.0; // 음수를 없앤다.
    }
    degree = degree / 360.0; // 단위를 12시 방향에서 반시계방향으로 한 바퀴 돌릴 때 [0.0, 1.0]이 되게한다.
    degree = 1.0 - degree;   // 시계방향으로 바꾼다.
    if (degree == 1.0) {
        degree = 0.0; // 1.0을 없애고 0.0으로 만든다.
    } // <- 여기까지 12를 0.0으로 하고 시계방향으로 돌면 1.0까지 만드는 코드이다.
    
    CGFloat edgeDegree = self.edgeAngle * 1.5;
    edgeDegree = edgeDegree / (M_PI * 2.0); // [0.0, 6.28...] => [0.0, 1.0]
    CGFloat splitDegree = 1.0 - edgeDegree;
    CGFloat startColorDegree = edgeDegree;
    CGFloat endColorDegree = 1.0 - (3.0 * edgeDegree);
    
//    CGFloat splitDegree = self.edgeAngle * 1.5;
//    splitDegree = splitDegree / (M_PI * 2.0); // [0.0, 6.28...] => [0.0, 1.0]
//    CGFloat startColorDegree = splitDegree * 2.0;
//    CGFloat endColorDegree = splitDegree * 2.0;
//    splitDegree = 1.0 - splitDegree;
    
    if (degree <= startColorDegree || degree >= splitDegree) { // 12시 방향을 0도를 기준으로 왼쪽으로 12.5도 오른쪽으로 45를 start 색으로 칠한다.
        return ARGBInitWithCGColor(self.startColor); // start color가 맞다.
    } else if (degree >= endColorDegree && degree < splitDegree) {
        return ARGBInitWithCGColor(self.endColor); // end color가 맞다. // 블루 칼라
    } else {
        CGFloat a = degree - startColorDegree;
        CGFloat b = endColorDegree - degree;
        
        return ARGBinterpolate(ARGBInitWithCGColor(self.startColor),
                               ARGBInitWithCGColor(self.endColor),
                               a / (a + b));
    }
}

- (void)reset {
    CGImageRef oldImg = _generatedImage;
    CGImageRelease(oldImg);
    self.generatedImage = nil;
}

@end
