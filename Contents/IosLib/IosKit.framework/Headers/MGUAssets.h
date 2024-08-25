//
//  MGUAssets.h
//  Created by Kiro on 2022/11/10.
//

#ifndef MGUAssets_h
#define MGUAssets_h
@import BaseKit;

// Color
static MARColor const MARColorTestColor     = @"TestColor";

// Image
static MARImage const MARImageTestCorn      = @"Corn";

// Symbol
static MARSymbol const MARSymbolTestPlay  = @"play.circle.fill";

// Space Size
static const MARSpaceSize MARSpaceSizeScrollEnd     = MARSpaceSizeXXLarge; // 스크롤이 발생하는 끝단 여백
static const MARSpaceSize MARSpaceSizeMinimalTouch  = 44.f;             // 최소 터치구역 크기(애플규정)

#endif /* MGUAssets_h */



#import <UIKit/UIKit.h>
@interface UIColor (Assets)
@property (class, nonatomic, readonly) UIColor *mgrTestColor;
@end

@interface UIImage (Assets)
@property (class, nonatomic, readonly) UIImage *mgrLogoImage;

@property (class, nonatomic, readonly) UIImage *mgrTestCornImage;
@property (class, nonatomic, readonly) UIImage *mgrTestPlaySymbol;
@end

@interface UIFont (Assets)
@end

//
//
/*
"_person.text.rectangle.fill"
UIColor(
    red: 75.0/255.0,
    green: 217.0/255.0,
    blue: 100.0/255.0,
    alpha: 1.0
)

-----------------------------------------

"_square.and.arrow.forward.square.fill"
"_person.fill.badge.minus"
"_bell.badge.square.fill"
UIColor(
    red: 255.0/255.0,
    green: 59.0/255.0,
    blue: 47.0/255.0,
    alpha: 1.0
)

-----------------------------------------

"_magnifyingglass.square.fill"
UIColor(
    red: 72.0/255.0,
    green: 72.0/255.0,
    blue: 74.0/255.0,
    alpha: 1.0
)

-----------------------------------------

"_house.square.fill"
UIColor(
    red: 251.0/255.0,
    green: 145.0/255.0,
    blue: 14.0/255.0,
    alpha: 1.0
)

-----------------------------------------

"_questionmark.square.fill"
UIColor(
    red: 2.0/255.0,
    green: 123.0/255.0,
    blue: 254.0/255.0,
    alpha: 1.0
)

-----------------------------------------

"_creditcard.square.fill"
UIColor(
    red: 142.0/255.0,
    green: 142.0/255.0,
    blue: 147.0/255.0,
    alpha: 1.0
)
*/
