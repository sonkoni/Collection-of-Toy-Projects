//
//  MGENoise.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//
//  1. KGNoise : 이 프로젝트를 중심으로 만들었다. [David Keegan](https://github.com/kgn/KGNoise)
//  2. JMNoise : [Jason Morrissey](https://github.com/jasonmorrissey/JMNoise)

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

//! UIView 계열에서는 context NULL 이다. layer의 - drawInContext: 메서드에서 호출할 때는 그 인수를 넘겨준다.
extern void MGRDrawNoiseWithOpacityBlendMode(CGFloat opacity, CGBlendMode blendMode, CGContextRef _Nullable context);

#pragma mark - MGENoise Color
@interface MGEColor (MGENoise)
- (MGEColor *)mgrColorWithNoiseWithOpacity:(CGFloat)opacity; // 디폴트 BlendMode kCGBlendModeScreen
- (MGEColor *)mgrColorWithNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode;
@end


#pragma mark - MGENoise Image
@interface MGEImage (MGENoise)
- (MGEImage *)mgrImageWithNoiseOpacity:(CGFloat)opacity; // 디폴트 BlendMode kCGBlendModeScreen
- (MGEImage *)mgrImageWithNoiseOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode;
@end


#pragma mark - MGENoiseView

// 노이즈 레벨 프리셋
// ----------------------------------------------------------------------
typedef CGFloat     MGENoiseLevel;
static const MGENoiseLevel MGENoiseLevelLow   = 0.05;
static const MGENoiseLevel MGENoiseLevelLower = 0.02;
static const MGENoiseLevel MGENoiseLevelNone  = 0.0;


@interface MGENoiseView : MGEView
#if TARGET_OS_OSX
@property (strong, nonatomic) NSColor *backgroundColor;
#endif
@property (nonatomic) MGENoiseLevel noiseOpacity; // [0.0 ~ 1.0] 디폴트 0.1
@property (nonatomic) CGBlendMode noiseBlendMode; // 디폴트 BlendMode kCGBlendModeScreen
@end


#pragma mark - MGENoiseLinearGradientView
typedef NS_ENUM(NSUInteger, KGLinearGradientDirection){
    KGLinearGradientDirection0Degrees,   // Left to Right
    KGLinearGradientDirection90Degrees,  // Bottom to Top
    KGLinearGradientDirection180Degrees, // Right to Left
    KGLinearGradientDirection270Degrees  // Top to Bottom
};

@interface MGENoiseLinearGradientView : MGENoiseView
@property (strong, nonatomic) MGEColor *alternateBackgroundColor;
@property (nonatomic) KGLinearGradientDirection gradientDirection;
@end


#pragma mark - MGENoiseRadialGradientView

@interface MGENoiseRadialGradientView : MGENoiseView
@property (strong, nonatomic) MGEColor *alternateBackgroundColor;
@end

NS_ASSUME_NONNULL_END


//! CGBlendMode - typedef CF_ENUM (int32_t, CGBlendMode) { ... };
// https://developer.android.com/reference/android/graphics/BlendMode <- 그림으로 예시
// https://apprize.best/apple/drawing/10.html <- 그림으로 예시
/* Available in Mac OS X 10.4 & later. */
//kCGBlendModeNormal,       일반적. 일반적으로 덮어.
//kCGBlendModeMultiply,     곱셈. 각 채널의 밝기를 곱하는. 기본적으로 어두워진다.
//kCGBlendModeScreen,       스크린. 곱셈이지만 밝아진다. 검정은 무시된다.
//kCGBlendModeOverlay,      오버레이. 곱셈과 스크린의 조합.
//kCGBlendModeDarken,       어둡게. 어두운 색상을 결과 색상으로한다.
//kCGBlendModeLighten,      밝게. 밝은 색상을 결과 색상으로한다.
//kCGBlendModeColorDodge,   닷지 컬러. 검정은 무시된다. 기본적으로 밝아진다.
//kCGBlendModeColorBurn,    굽​​기 컬러. 흰색은 무시된다. 기본적으로 어두워진다.
//kCGBlendModeSoftLight,    소프트 라이트. 128 (50 %) 회색보다 밝은 경우 닷지, 어두운 경우 굽기.
//kCGBlendModeHardLight,    하드 라이트. 128 (50 %) 회색보다 밝은 경우 스크린, 어두운 경우 곱셈.

//kCGBlendModeDifference,   차이의 절대 값. 레이어의 상하 관계없이 색의 차이를 가지고 간다. 동일한 색상의 경우는 결과 검은 색입니다.검정은 무시된다.
//kCGBlendModeExclusion,    제외. 검정은 무시된다.
//kCGBlendModeHue,          색상. 레이어 1의 밝기와 채도, 레이어 2의 색상으로 합성.
//kCGBlendModeSaturation,   채도. 레이어 1의 밝기 · 색상, 레이어 2 채도 합성.
//kCGBlendModeColor,        컬러. 레이어 1의 밝기, 레이어 2의 색조와 채도 합성.
//kCGBlendModeLuminosity,   밝기. 칼라 역.

/* Available in Mac OS X 10.5 & later. R, S, and D are, respectively,
   premultiplied result, source, and destination colors with alpha; Ra,
   Sa, and Da are the alpha components of these colors.

   The Porter-Duff "source over" mode is called `kCGBlendModeNormal':
     R = S + D*(1 - Sa)

   Note that the Porter-Duff "XOR" mode is only titularly related to the
   classical bitmap XOR operation (which is unsupported by
   CoreGraphics). */

//kCGBlendModeClear,                  /* R = 0 */
//kCGBlendModeCopy,                   /* R = S */
//kCGBlendModeSourceIn,               /* R = S*Da */
//kCGBlendModeSourceOut,              /* R = S*(1 - Da) */

//kCGBlendModeSourceAtop,             /* R = S*Da + D*(1 - Sa) */
//kCGBlendModeDestinationOver,        /* R = S*(1 - Da) + D */
//kCGBlendModeDestinationIn,          /* R = D*Sa */
//kCGBlendModeDestinationOut,         /* R = D*(1 - Sa) */
//kCGBlendModeDestinationAtop,        /* R = S*(1 - Da) + D*Sa */
//kCGBlendModeXOR,                    /* R = S*(1 - Da) + D*(1 - Sa) */
//kCGBlendModePlusDarker,             /* R = MAX(0, (1 - D) + (1 - S)) */
//kCGBlendModePlusLighter             /* R = MIN(1, S + D) */


// https://helpx.adobe.com/kr/photoshop/using/blending-modes.html 한국어
// https://helpx.adobe.com/photoshop/using/blending-modes.html 영어
//표준(kCGBlendModeNormal) - 각 픽셀을 편집하거나 페인트하여 결과 색상으로 만듭니다. 이 모드가 기본 모드입니다. 비트맵이나 인덱스 색상 이미지로 작업하는 경우에는 [표준] 모드를 한계값이라고 합니다.
//디졸브 -각 픽셀을 편집하거나 페인트하여 결과 색상으로 만듭니다. 그러나 결과 색상은 픽셀 위치의 불투명도에 따라 임의로 픽셀을 기본 색상이나 혼합 색상으로 대체한 색상입니다.
//배경 - 레이어의 투명한 부분만 편집하거나 페인팅합니다. 이 모드는 [투명 픽셀 잠그기] 옵션을 선택하지 않은 레이어에만 작용하며 아세테이트지에서 투명 영역의 뒷면에 페인트하는 것과 유사한 효과를 냅니다.
//지우기(kCGBlendModeClear) -각 픽셀을 편집하거나 페인트하여 투명하게 만듭니다. 이 모드는 [모양] 도구(칠 영역 을 선택한 경우), [페인트 통] 도구 , [브러시] 도구 , [연필] 도구 , [칠] 명령 및 [획] 명령에 사용할 수 있습니다. 이 모드는 [투명 픽셀 잠그기] 옵션을 선택하지 않은 레이어에서만 사용할 수 있습니다.

//어둡게 하기(kCGBlendModeDarken) - 각 채널의 색상 정보를 보고 기본 색상이나 혼합 색상 중 더 어두운 색상을 결과 색상으로 선택합니다. 혼합 색상보다 밝은 픽셀은 대체되고 혼합 색상보다 어두운 픽셀은 변경되지 않습니다.

//곱하기(kCGBlendModeMultiply) - 각 채널의 색상 정보를 보고 기본 색상과 혼합 색상을 곱합니다. 결과 색상은 항상 더 어두운 색상이 됩니다. 어느 색상이든 검정색을 곱하면 검정색이 되고, 어느 색상이든 흰색을 곱하면 색상에 변화가 없습니다. 검정색이나 흰색 이외의 다른 색상으로 페인트하면 페인팅 도구로 계속 획을 그릴수록 점점 더 어두운 색상이 됩니다. 이 모드는 이미지에 여러 개의 마킹펜으로 그리는 것과 유사한 효과를 냅니다.

//색상 번(kCGBlendModeColorBurn) - 각 채널의 색상 정보를 보고 두 채널 사이의 대비를 증가시켜서 기본 색상을 어둡게 하여 혼합 색상을 반영합니다. 흰색과 혼합하면 색상 변화가 없습니다.
//선형 번 -각 채널의 색상 정보를 보고 명도를 감소시켜서 기본 색상을 어둡게 하여 혼합 색상을 반영합니다. 흰색과 혼합하면 색상 변화가 없습니다.
//밝게 하기(kCGBlendModeLighten) - 각 채널의 색상 정보를 보고 기본 색상이나 혼합 색상 중 더 밝은 색상을 결과 색상으로 선택합니다. 혼합 색상보다 어두운 픽셀은 대체되고 혼합 색상보다 밝은 픽셀은 변경되지 않습니다.
//스크린(kCGBlendModeScreen) - 각 채널의 색상 정보를 보고 혼합 색상과 기본 색상의 반전색을 곱합니다. 결과 색상은 항상 더 밝은 색상이 됩니다. 검정색으로 스크린하면 색상에 변화가 없고, 흰색으로 스크린하면 흰색이 됩니다. 이 모드는 여러 장의 사진 슬라이드를 서로 포개서 투영하는 것과 유사한 효과를 냅니다.

//색상 닷지(kCGBlendModeColorDodge) - 각 채널의 색상 정보를 보고 두 채널 사이의 대비를 감소시켜서 기본 색상을 밝게 하여 혼합 색상을 반영합니다. 검정색과 혼합하면 색상 변화가 없습니다.

//선형 닷지(추가) - 각 채널의 색상 정보를 보고 명도를 증가시켜서 기본 색상을 밝게 하여 혼합 색상을 반영합니다. 검정색과 혼합하면 색상 변화가 없습니다.
//오버레이(kCGBlendModeOverlay) - 기본 색상에 따라 색상을 곱하거나 스크린합니다. 패턴이나 색상은 기본 색상의 밝은 영역과 어두운 영역을 보존하면서 기존 픽셀 위에 겹칩니다. 기본 색상은 대체되지 않고 혼합 색상과 섞여 원래 색상의 밝기와 농도를 반영합니다.
//소프트 라이트(kCGBlendModeSoftLight) -혼합 색상에 따라 색상을 어둡게 하거나 밝게 하여 이미지에 확산된 집중 조명을 비추는 것과 유사한 효과를 냅니다. 혼합 색상(광원)이 50% 회색보다 밝으면 이미지는 닷지한 것처럼 밝아지고, 혼합 색상이 50% 회색보다 더 어두우면 이미지는 번한 것처럼 어두워집니다. 순수한 검정색이나 흰색으로 칠하면 더 밝거나 더 어두운 영역이 뚜렷이 나타나지만 순수한 검정이나 흰색이 되지는 않습니다.

// 하드 라이트(kCGBlendModeHardLight) - 혼합 색상에 따라 색상을 곱하거나 스크린합니다. 이미지에 강한 집중 조명을 비추는 것과 유사한 효과를 냅니다. 혼합 색상(광원)이 50% 회색보다 밝으면 이미지는 스크린한 것처럼 밝아집니다. 이 모드는 이미지에 밝은 영역을 추가하는 데 유용합니다. 혼합 색상이 50% 회색보다 어두우면 이미지는 곱한 것처럼 어두워집니다. 이 모드는 이미지에 어두운 영역을 추가하는 데 유용합니다. 순수한 검정색이나 흰색으로 페인트하면 순수한 검정색이나 흰색이 됩니다.

//선명한 라이트 - 혼합 색상에 따라 대비를 증가 또는 감소시켜 색상을 번하거나 닷지합니다. 혼합 색상(광원)이 50% 회색보다 밝으면 대비를 감소시켜 이미지를 밝게 하고, 혼합 색상이 50% 회색보다 어두우면 대비를 증가시켜 이미지를 어둡게 합니다.
//선형 라이트 - 혼합 색상에 따라 명도를 증가 또는 감소시켜 색상을 번하거나 닷지합니다. 혼합 색상(광원)이 50% 회색보다 밝으면 명도를 증가시켜 이미지를 밝게 하고, 혼합 색상이 50% 회색보다 어두우면 명도를 감소시켜 이미지를 어둡게 합니다.
//핀 라이트 - 혼합 색상에 따라 색상을 대체합니다. 혼합 색상(광원)이 50% 회색보다 밝으면 혼합 색상보다 어두운 픽셀은 대체되고 혼합 색상보다 밝은 색상은 변화가 없습니다. 혼합 색상이 50% 회색보다 어두우면 혼합 색상보다 밝은 픽셀은 대체되고 혼합 색상보다 어두운 색상은 변화가 없습니다. 이 모드는 이미지에 특수 효과를 추가하는 데 유용합니다.
//하드 혼합 - 혼합 색상의 빨강, 녹색, 파랑 채널 값을 기본 색상의 RGB 값에 추가합니다. 채널의 결과 합계가 255 이상이면 255 값을 받고 255 미만이면 0 값을 받습니다. 따라서 모든 혼합 픽셀의 빨강, 녹색, 파랑 채널 값은 0 또는 255입니다. 그러면 모든 픽셀이 기본 가색(빨강, 녹색 또는 파랑), 흰색 또는 검정으로 변경됩니다.

//참고 사항 : CMYK 이미지의 경우 [하드 혼합]을 선택하면 모든 픽셀이 기본 감색(녹청, 노랑 또는 마젠타), 흰색 또는 검정으로 변경됩니다. 최대 색상 값은 100입니다.

//차이(kCGBlendModeDifference) - 각 채널의 색상 정보를 보고 기본 색상과 혼합 색상 중 명도 값이 더 큰 색상에서 다른 색상을 뺍니다. 흰색과 혼합하면 기본 색상 값이 반전되고 검정색과 혼합하면 색상 변화가 없습니다.
//제외(kCGBlendModeExclusion) - [차이(kCGBlendModeDifference)] 모드와 유사하지만 대비가 더 낮은 효과를 냅니다. 흰색과 혼합하면 기본 색상 값이 반전되고, 검정색과 혼합하면 색상 변화가 없습니다.
//빼기 - 각 채널의 색상 정보를 보고 기본 색상에서 혼합 색상을 뺍니다. 8비트 및 16비트 이미지에서는 결과로 산출된 음수 값이 0으로 클리핑됩니다.
//나누기 - 각 채널의 색상 정보를 보고 기본 색상에서 혼합 색상을 나눕니다.
//색조(kCGBlendModeHue) - 기본 색상의 광도와 채도 및 혼합 색상의 색조로 결과 색상을 만듭니다.
//[채도(kCGBlendModeSaturation)] -기본 색상의 광도와 색조 및 혼합 색상의 채도로 결과 색상을 만듭니다. 이 모드를 사용하여 채도가 0인 영역(회색)을 페인트하면 색상 변화가 일어나지 않습니다.
//[색상(kCGBlendModeColor)] -기본 색상의 광도 및 혼합 색상의 색조와 채도로 결과 색상을 만듭니다. 이 모드는 이미지의 회색 레벨을 유지하며 단색 이미지에 색상을 칠하고 컬러 이미지에 색조를 적용하는 데 유용합니다.
//광도(kCGBlendModeLuminosity) - 기본 색상의 색조와 채도 및 혼합 색상의 광도로 결과 색상을 만듭니다. 이 모드는 [색상] 모드의 반대 효과를 냅니다.
//밝은 색상(kCGBlendModePlusLighter) - 혼합 색상과 기본 색상에 대한 모든 채널 값의 총합을 비교하고 더 높은 값의 색상을 표시합니다. [밝은 색상]은 제3의 새로운 색상을 생성하지 않으며, 결과 색상을 만들기 위해 기본 색상과 혼합 색상 중 가장 높은 채널 값을 선택하기 때문에 [밝게 하기] 혼합으로 만들어질 수 있습니다.
// 어두운 색상(kCGBlendModePlusDarker) - 혼합 색상과 기본 색상에 대한 모든 채널 값의 총합을 비교하고 더 낮은 값의 색상을 표시합니다. [어두운 색상]은 제3의 새로운 색상을 생성하지 않으며, 결과 색상을 만들기 위해 기본 색상과 혼합 색상 중 가장 낮은 채널 값을 선택하기 때문에 [어둡게 하기] 혼합으로 만들어질 수 있습니다.
