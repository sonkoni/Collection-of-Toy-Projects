//
//  MGAAssets.h
//  Created by Kiro on 2022/11/10.
//

#ifndef MGAAssets_h
#define MGAAssets_h
@import BaseKit;

// Color
static MASColor const MASColorTestColor     = @"TestColor";

// Image
static MASImage const MASImageTestSunflower = @"Sunflower";

// Symbol
static MASSymbol const MASSymbolTestStop  = @"stop.circle.fill";

#endif /* MGAAssets_h */



#import <AppKit/AppKit.h>
@interface NSColor (Assets)
@property (class, nonatomic, readonly) NSColor *mgrTestColor;
@end

@interface NSImage (Assets)
@property (class, nonatomic, readonly) NSImage *mgrLogoImage;

@property (class, nonatomic, readonly) NSImage *mgrTestSunflowerImage;
@property (class, nonatomic, readonly) NSImage *mgrTestStopSymbol;
@end

@interface NSFont (Assets)
@end
