//
//  MGAAssets.h
//  Created by Kiro on 2022/11/10.
//

#ifndef MGAAssets_h
#define MGAAssets_h
@import BaseKit;

// Color
static MARColor const MARColorTestColor     = @"TestColor";

// Image
static MARImage const MARImageTestSunflower = @"Sunflower";

// Symbol
static MARSymbol const MARSymbolTestStop  = @"stop.circle.fill";

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
