//
//  MGUMorphingLabel+Pixelate.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 25/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabel+Pixelate.h"
#import "MGUMorphingLabelCharLimbo.h"
@import GraphicsKit;

@implementation MGUMorphingLabel (Pixelate)
- (void)PixelateLoad {
    
    MGUMorphingLabelEffectClosure effectClosures =
    ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        NSValue *rectValue = self.previousRects[index];
        CGRect currentRect = [rectValue CGRectValue];
        
        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:currentRect
                                                     alpha:1.0 - progress
                                                      size:self.font.pointSize
                                           drawingProgress:progress];
    };
    
    NSString *closureKey = [NSString stringWithFormat:@"Pixelate%@", MGRMorphingPhasesDisappear];
    self.effectClosures[closureKey] = effectClosures;
   
    MGUMorphingLabelEffectClosure effectClosuresX =
       ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
    
           NSValue *rectValue = self.freshRects[index];
           CGRect newRect = [rectValue CGRectValue];

           return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                         rect:newRect
                                                        alpha:progress
                                                         size:self.font.pointSize
                                              drawingProgress:1.0 - progress];
       };

       closureKey = [NSString stringWithFormat:@"Pixelate%@", MGRMorphingPhasesAppear];
       self.effectClosures[closureKey] = effectClosuresX;
    
    
    MGRMorphingDrawingClosure drawingClosures =  ^BOOL (MGUMorphingLabelCharLimbo *limbo) {
        if (limbo.drawingProgress > 0.0) {
            UIImage *charImage = [self pixelateImageForCharLimbo:limbo withBlurRadius:limbo.drawingProgress * 6.0];
            [charImage drawInRect:limbo.rect];
            return YES;
        } else {
            return NO;
        }
    };
    
    closureKey = [NSString stringWithFormat:@"Pixelate%@", MGRMorphingPhasesDraw];
    self.drawingClosures[closureKey] = drawingClosures;
    
    
    
}

//! private
- (UIImage *)pixelateImageForCharLimbo:(MGUMorphingLabelCharLimbo *)charLimbo withBlurRadius:(CGFloat)blurRadius {
    
    CGFloat scale = MIN(UIScreen.mainScreen.scale, 1.0 / blurRadius);
    
    UIGraphicsBeginImageContextWithOptions(charLimbo.rect.size, NO, scale);
    CGFloat fadeOutAlpha = MIN(1.0, MAX(0.0, charLimbo.drawingProgress * -2.0 + 2.0 + 0.01));
    
    CGRect rect = CGRectMake(0.0, 0.0, charLimbo.rect.size.width, charLimbo.rect.size.height);
    
    NSDictionary <NSAttributedStringKey, NSObject *>*attrs = @{
    NSForegroundColorAttributeName : [self.textColor colorWithAlphaComponent:fadeOutAlpha],
                NSFontAttributeName: self.font };
    
    [charLimbo.character drawInRect:rect
                     withAttributes:attrs];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
