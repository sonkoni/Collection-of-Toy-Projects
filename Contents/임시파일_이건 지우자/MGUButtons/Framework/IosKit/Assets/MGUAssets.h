//
//  MGUAssets.h
//  Created by Kiro on 2022/11/10.
//

#ifndef MGUAssets_h
#define MGUAssets_h
@import BaseKit;

// Color
static MASColor const MASColorTestColor     = @"TestColor";

// Image
static MASImage const MASImageTestCorn      = @"Corn";

// Symbol
static MASSymbol const MASSymbolTestPlay  = @"play.circle.fill";

// Space Size
static const MASSpaceSize MASSpaceSizeScrollEnd     = MASSpaceSizeXXLarge; // 스크롤이 발생하는 끝단 여백
static const MASSpaceSize MASSpaceSizeMinimalTouch  = 44.f;             // 최소 터치구역 크기(애플규정)

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
