//
//  Assets.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-12
//  에셋 타입 정의
//  ----------------------------------------------------------------------
//

#ifndef Mulgrim_Assets_h
#define Mulgrim_Assets_h
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h> /* for CGFloat, CGMacro */

NS_ASSUME_NONNULL_BEGIN
typedef int MASHex NS_TYPED_ENUM;
static const MASHex MASHexOceanBlue50    = 0xFAFDFF;
static const MASHex MASHexOceanBlue100   = 0xEDF9FF;
static const MASHex MASHexOceanBlue200   = 0xAFDCF3;
static const MASHex MASHexOceanBlue300   = 0x70BEE6;
static const MASHex MASHexOceanBlue400   = 0x4AA1D3;
static const MASHex MASHexOceanBlue500   = 0x2384BF;
static const MASHex MASHexOceanBlue600   = 0x1667A0;
static const MASHex MASHexOceanBlue700   = 0x084A80;
static const MASHex MASHexOceanBlue800   = 0x07335A;
static const MASHex MASHexOceanBlue900   = 0x061C33;
static const MASHex MASHexOceanBlue950   = 0x04101F;
static const MASHex MASHexOceanBlueA300  = 0x1CA2E6;
static const MASHex MASHexOceanBlueA350  = 0x1A98D7;
static const MASHex MASHexOceanBlueA500  = 0x219BED;
static const MASHex MASHexOceanBlueA550  = 0x1A91E0;


typedef NSString * MASColor NS_TYPED_ENUM;
static MASColor const MASColorOceanBlue50       = @"OceanBlue50";
static MASColor const MASColorOceanBlue100      = @"OceanBlue100";
static MASColor const MASColorOceanBlue200      = @"OceanBlue200";
static MASColor const MASColorOceanBlue300      = @"OceanBlue300";
static MASColor const MASColorOceanBlue400      = @"OceanBlue400";
static MASColor const MASColorOceanBlue500      = @"OceanBlue500";
static MASColor const MASColorOceanBlue600      = @"OceanBlue600";
static MASColor const MASColorOceanBlue700      = @"OceanBlue700";
static MASColor const MASColorOceanBlue800      = @"OceanBlue800";
static MASColor const MASColorOceanBlue900      = @"OceanBlue900";
static MASColor const MASColorOceanBlue950      = @"OceanBlue950";
static MASColor const MASColorOceanBlueA300     = @"OceanBlueA300";
static MASColor const MASColorOceanBlueA350     = @"OceanBlueA350";
static MASColor const MASColorOceanBlueA500     = @"OceanBlueA500";
static MASColor const MASColorOceanBlueA550     = @"OceanBlueA550";


typedef NSString * MASImage NS_TYPED_ENUM;
static MASImage const MASImageLogo              = @"Logo";


typedef NSString * MASSymbol NS_TYPED_ENUM;


typedef NSString * MASSound NS_TYPED_ENUM;


// MASFontSize : 폰트 사이즈. 기본은 애플의 정의에 따르며 확장 시 Large/Medium/Small
// ----------------------------------------------------------------------
typedef CGFloat MASFontSize NS_TYPED_ENUM;
static const MASFontSize MASFontSizeLargeTitle      = 34.f;
static const MASFontSize MASFontSizeTitle1          = 28.f;
static const MASFontSize MASFontSizeTitle2          = 22.f;
static const MASFontSize MASFontSizeTitle3          = 20.f;
static const MASFontSize MASFontSizeheadline        = 17.f;
static const MASFontSize MASFontSizeBody            = 17.f;  // Default
static const MASFontSize MASFontSizeCallout         = 16.f;
static const MASFontSize MASFontSizeSubhead         = 15.f;
static const MASFontSize MASFontSizeFootnote        = 13.f;
static const MASFontSize MASFontSizeCaption1        = 12.f;
static const MASFontSize MASFontSizeCaption2        = 11.f;


// MASIconSize : 아이콘과 심볼. 4포인트 단위
// ----------------------------------------------------------------------
typedef CGFloat MASIconSize NS_TYPED_ENUM;
static const MASIconSize MASIconSizeXXLarge         = 40.f;
static const MASIconSize MASIconSizeXLarge          = 36.f;
static const MASIconSize MASIconSizeLarge           = 28.f;
static const MASIconSize MASIconSizeMedium          = 24.f;  // Default
static const MASIconSize MASIconSizeSmall           = 20.f;
static const MASIconSize MASIconSizeXSmall          = 16.f;
static const MASIconSize MASIconSizeTiny            = 12.f;


// MASSpaceSize : 여백공간. 4부터 64까지 공비가 2인 등비수열. 필요하면 값을 더해서 사용.
// ----------------------------------------------------------------------
typedef CGFloat MASSpaceSize NS_TYPED_ENUM;
static const MASSpaceSize MASSpaceSizeXXLarge       = 64.f;
static const MASSpaceSize MASSpaceSizeLarge         = 32.f;
static const MASSpaceSize MASSpaceSizeMedium        = 16.f;  // Default
static const MASSpaceSize MASSpaceSizeSmall         = 8.f;
static const MASSpaceSize MASSpaceSizeTiny          = 4.f;
static const MASSpaceSize MASSpaceSizeNone          = 0.f;


// MASRadius : 코너 라디우스. 상대적/절대적 크기 결정은 각 컨트롤러에서 함.
// ----------------------------------------------------------------------
typedef CGFloat MASRadius NS_TYPED_ENUM;
static const MASRadius MASRadiusLevel50             = 50.f;
static const MASRadius MASRadiusLevel48             = 48.f;
static const MASRadius MASRadiusLevel44             = 44.f;
static const MASRadius MASRadiusLevel40             = 40.f;
static const MASRadius MASRadiusLevel36             = 36.f;
static const MASRadius MASRadiusLevel32             = 32.f;
static const MASRadius MASRadiusLevel28             = 28.f;
static const MASRadius MASRadiusLevel24             = 24.f;
static const MASRadius MASRadiusLevel20             = 20.f;
static const MASRadius MASRadiusLevel16             = 16.f;
static const MASRadius MASRadiusLevel12             = 12.f;
static const MASRadius MASRadiusLevel8              = 8.f;
static const MASRadius MASRadiusLevel4              = 4.f;
static const MASRadius MASRadiusNone                = 0.f;


// MASAlpha : Transparent 부터 Opaque 까지 Level 단위 4배수.
// ----------------------------------------------------------------------
typedef CGFloat MASAlpha NS_TYPED_ENUM;
static const MASAlpha MASAlphaOpaque                = 1.f;
static const MASAlpha MASAlphaLevel98               = 0.98f;
static const MASAlpha MASAlphaLevel94               = 0.94f;
static const MASAlpha MASAlphaLevel90               = 0.90f;
static const MASAlpha MASAlphaLevel86               = 0.86f;
static const MASAlpha MASAlphaLevel82               = 0.82f;
static const MASAlpha MASAlphaLevel78               = 0.78f;
static const MASAlpha MASAlphaLevel74               = 0.74f;
static const MASAlpha MASAlphaLevel70               = 0.70f;
static const MASAlpha MASAlphaLevel66               = 0.66f;
static const MASAlpha MASAlphaLevel62               = 0.62f;
static const MASAlpha MASAlphaLevel58               = 0.58f;
static const MASAlpha MASAlphaLevel54               = 0.54f;
static const MASAlpha MASAlphaLevel50               = 0.50f;
static const MASAlpha MASAlphaLevel48               = 0.48f;
static const MASAlpha MASAlphaLevel44               = 0.44f;
static const MASAlpha MASAlphaLevel40               = 0.40f;
static const MASAlpha MASAlphaLevel36               = 0.36f;
static const MASAlpha MASAlphaLevel32               = 0.32f;
static const MASAlpha MASAlphaLevel28               = 0.28f;
static const MASAlpha MASAlphaLevel24               = 0.24f;
static const MASAlpha MASAlphaLevel20               = 0.20f;
static const MASAlpha MASAlphaLevel16               = 0.16f;
static const MASAlpha MASAlphaLevel12               = 0.12f;
static const MASAlpha MASAlphaLevel8                = 0.08f;
static const MASAlpha MASAlphaLevel4                = 0.04f;
static const MASAlpha MASAlphaTransparent           = 0.f;


// MASLineWidth : 선 두께
// ----------------------------------------------------------------------
typedef CGFloat MASLineWidth NS_TYPED_ENUM;
static const MASLineWidth MASLineWidthHeavy         = 3.f;
static const MASLineWidth MASLineWidthBold          = 2.5f;
static const MASLineWidth MASLineWidthMedium        = 2.f;
static const MASLineWidth MASLineWidthRegular       = 1.5f;
static const MASLineWidth MASLineWidthLight         = 1.0f;
static const MASLineWidth MASLineWidthThin          = 0.5f;


NS_ASSUME_NONNULL_END
#endif /* Mulgrim_Assets_h */
