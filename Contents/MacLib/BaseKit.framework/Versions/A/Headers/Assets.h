//
//  Assets.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-12
//  에셋 타입 정의
//  ----------------------------------------------------------------------
//  * NS_ENUM           : Used for simple enumeration
//  * NS_CLOSED_ENUM    : Simple enumerations that do not change enumerators (@frozen)
//  * NS_OPTIONS        : For enumeration of optional types
//  * NS_TYPED_ENUM     : Used for enumeration of type constants
//  * NS_TYPED_EXTENSIBLE_ENUM: For extensible enumeration of type constants
//
//  NS_STRING_ENUM/NS_EXTENSIBLE_STRING_ENUM and using NS_TYPED_ENUM/NS_TYPED_EXTENSIBLE_ENUM instead.
//

#ifndef Mulgrim_Assets_h
#define Mulgrim_Assets_h
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h> /* for CGFloat, CGMacro */

NS_ASSUME_NONNULL_BEGIN
typedef int MARHex NS_TYPED_ENUM;
static const MARHex MARHexOceanBlue50    = 0xFAFDFF;
static const MARHex MARHexOceanBlue100   = 0xEDF9FF;
static const MARHex MARHexOceanBlue200   = 0xAFDCF3;
static const MARHex MARHexOceanBlue300   = 0x70BEE6;
static const MARHex MARHexOceanBlue400   = 0x4AA1D3;
static const MARHex MARHexOceanBlue500   = 0x2384BF;
static const MARHex MARHexOceanBlue600   = 0x1667A0;
static const MARHex MARHexOceanBlue700   = 0x084A80;
static const MARHex MARHexOceanBlue800   = 0x07335A;
static const MARHex MARHexOceanBlue900   = 0x061C33;
static const MARHex MARHexOceanBlue950   = 0x04101F;
static const MARHex MARHexOceanBlueA300  = 0x1CA2E6;
static const MARHex MARHexOceanBlueA350  = 0x1A98D7;
static const MARHex MARHexOceanBlueA500  = 0x219BED;
static const MARHex MARHexOceanBlueA550  = 0x1A91E0;


typedef NSString * MARColor NS_TYPED_ENUM;
static MARColor const MARColorOceanBlue50       = @"OceanBlue50";
static MARColor const MARColorOceanBlue100      = @"OceanBlue100";
static MARColor const MARColorOceanBlue200      = @"OceanBlue200";
static MARColor const MARColorOceanBlue300      = @"OceanBlue300";
static MARColor const MARColorOceanBlue400      = @"OceanBlue400";
static MARColor const MARColorOceanBlue500      = @"OceanBlue500";
static MARColor const MARColorOceanBlue600      = @"OceanBlue600";
static MARColor const MARColorOceanBlue700      = @"OceanBlue700";
static MARColor const MARColorOceanBlue800      = @"OceanBlue800";
static MARColor const MARColorOceanBlue900      = @"OceanBlue900";
static MARColor const MARColorOceanBlue950      = @"OceanBlue950";
static MARColor const MARColorOceanBlueA300     = @"OceanBlueA300";
static MARColor const MARColorOceanBlueA350     = @"OceanBlueA350";
static MARColor const MARColorOceanBlueA500     = @"OceanBlueA500";
static MARColor const MARColorOceanBlueA550     = @"OceanBlueA550";


typedef NSString * MARImage NS_TYPED_ENUM;
static MARImage const MARImageLogo              = @"Logo";


typedef NSString * MARSymbol NS_TYPED_ENUM;


typedef NSString * MARSound NS_TYPED_ENUM;


// MARFontSize : 폰트 사이즈. 기본은 애플의 정의에 따르며 확장 시 Large/Medium/Small
// ----------------------------------------------------------------------
typedef CGFloat MARFontSize NS_TYPED_ENUM;
static const MARFontSize MARFontSizeLargeTitle      = 34.f;
static const MARFontSize MARFontSizeTitle1          = 28.f;
static const MARFontSize MARFontSizeTitle2          = 22.f;
static const MARFontSize MARFontSizeTitle3          = 20.f;
static const MARFontSize MARFontSizeheadline        = 17.f;
static const MARFontSize MARFontSizeBody            = 17.f;  // Default
static const MARFontSize MARFontSizeCallout         = 16.f;
static const MARFontSize MARFontSizeSubhead         = 15.f;
static const MARFontSize MARFontSizeFootnote        = 13.f;
static const MARFontSize MARFontSizeCaption1        = 12.f;
static const MARFontSize MARFontSizeCaption2        = 11.f;


// MARIconSize : 아이콘과 심볼. 4포인트 단위
// ----------------------------------------------------------------------
typedef CGFloat MARIconSize NS_TYPED_ENUM;
static const MARIconSize MARIconSizeXXLarge         = 40.f;
static const MARIconSize MARIconSizeXLarge          = 36.f;
static const MARIconSize MARIconSizeLarge           = 28.f;
static const MARIconSize MARIconSizeMedium          = 24.f;  // Default
static const MARIconSize MARIconSizeSmall           = 20.f;
static const MARIconSize MARIconSizeXSmall          = 16.f;
static const MARIconSize MARIconSizeTiny            = 12.f;


// MARSpaceSize : 여백공간. 4부터 64까지 공비가 2인 등비수열. 필요하면 값을 더해서 사용.
// ----------------------------------------------------------------------
typedef CGFloat MARSpaceSize NS_TYPED_ENUM;
static const MARSpaceSize MARSpaceSizeXXLarge       = 64.f;
static const MARSpaceSize MARSpaceSizeLarge         = 32.f;
static const MARSpaceSize MARSpaceSizeMedium        = 16.f;  // Default
static const MARSpaceSize MARSpaceSizeSmall         = 8.f;
static const MARSpaceSize MARSpaceSizeTiny          = 4.f;
static const MARSpaceSize MARSpaceSizeNone          = 0.f;


// MARRadius : 코너 라디우스. 상대적/절대적 크기 결정은 각 컨트롤러에서 함.
// ----------------------------------------------------------------------
typedef CGFloat MARRadius NS_TYPED_ENUM;
static const MARRadius MARRadiusLevel50             = 50.f;
static const MARRadius MARRadiusLevel48             = 48.f;
static const MARRadius MARRadiusLevel44             = 44.f;
static const MARRadius MARRadiusLevel40             = 40.f;
static const MARRadius MARRadiusLevel36             = 36.f;
static const MARRadius MARRadiusLevel32             = 32.f;
static const MARRadius MARRadiusLevel28             = 28.f;
static const MARRadius MARRadiusLevel24             = 24.f;
static const MARRadius MARRadiusLevel20             = 20.f;
static const MARRadius MARRadiusLevel16             = 16.f;
static const MARRadius MARRadiusLevel12             = 12.f;
static const MARRadius MARRadiusLevel8              = 8.f;
static const MARRadius MARRadiusLevel4              = 4.f;
static const MARRadius MARRadiusNone                = 0.f;


// MARAlpha : Transparent 부터 Opaque 까지 Level 단위 4배수.
// ----------------------------------------------------------------------
typedef CGFloat MARAlpha NS_TYPED_ENUM;
static const MARAlpha MARAlphaOpaque                = 1.f;
static const MARAlpha MARAlphaLevel98               = 0.98f;
static const MARAlpha MARAlphaLevel94               = 0.94f;
static const MARAlpha MARAlphaLevel90               = 0.90f;
static const MARAlpha MARAlphaLevel86               = 0.86f;
static const MARAlpha MARAlphaLevel82               = 0.82f;
static const MARAlpha MARAlphaLevel78               = 0.78f;
static const MARAlpha MARAlphaLevel74               = 0.74f;
static const MARAlpha MARAlphaLevel70               = 0.70f;
static const MARAlpha MARAlphaLevel66               = 0.66f;
static const MARAlpha MARAlphaLevel62               = 0.62f;
static const MARAlpha MARAlphaLevel58               = 0.58f;
static const MARAlpha MARAlphaLevel54               = 0.54f;
static const MARAlpha MARAlphaLevel50               = 0.50f;
static const MARAlpha MARAlphaLevel48               = 0.48f;
static const MARAlpha MARAlphaLevel44               = 0.44f;
static const MARAlpha MARAlphaLevel40               = 0.40f;
static const MARAlpha MARAlphaLevel36               = 0.36f;
static const MARAlpha MARAlphaLevel32               = 0.32f;
static const MARAlpha MARAlphaLevel28               = 0.28f;
static const MARAlpha MARAlphaLevel24               = 0.24f;
static const MARAlpha MARAlphaLevel20               = 0.20f;
static const MARAlpha MARAlphaLevel16               = 0.16f;
static const MARAlpha MARAlphaLevel12               = 0.12f;
static const MARAlpha MARAlphaLevel8                = 0.08f;
static const MARAlpha MARAlphaLevel4                = 0.04f;
static const MARAlpha MARAlphaTransparent           = 0.f;


// MARLineWidth : 선 두께
// ----------------------------------------------------------------------
typedef CGFloat MARLineWidth NS_TYPED_ENUM;
static const MARLineWidth MARLineWidthHeavy         = 3.f;
static const MARLineWidth MARLineWidthBold          = 2.5f;
static const MARLineWidth MARLineWidthMedium        = 2.f;
static const MARLineWidth MARLineWidthRegular       = 1.5f;
static const MARLineWidth MARLineWidthLight         = 1.0f;
static const MARLineWidth MARLineWidthThin          = 0.5f;


NS_ASSUME_NONNULL_END
#endif /* Mulgrim_Assets_h */
