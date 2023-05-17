//
//  NSBox+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSBox+Extension.h"

@implementation NSBox (Extension)

- (void)mgrBackgroundColor:(NSColor *_Nullable)backgroundColor
               borderColor:(NSColor *_Nullable)borderColor
               borderWidth:(CGFloat)borderWidth
              cornerRadius:(CGFloat)cornerRadius {
    self.titlePosition = NSNoTitle;
    self.boxType = NSBoxCustom;
    self.fillColor = backgroundColor;
    self.borderColor = borderColor;
    self.borderWidth = borderWidth;
    self.cornerRadius = cornerRadius;
}

@end
