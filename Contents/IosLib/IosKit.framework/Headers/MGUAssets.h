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
