//
//  MGUMorphingLabel+Fall.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 25/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabel+Fall.h"
#import "MGUMorphingLabelCharLimbo.h"
@import GraphicsKit;

@implementation MGUMorphingLabel (Fall)
- (void)FallLoad {
    
    MGRMorphingManipulateProgressClosure progressClosures = ^CGFloat(NSInteger index, CGFloat progress, BOOL isNewChar) {
        
        if (isNewChar == YES) {
            return MIN(1.0, MAX(0.0, progress - self.morphingCharacterDelay * (CGFloat)index / 1.7));
        }
        
        CGFloat j = (CGFloat)(round(sin((CGFloat)index) * 1.7));
        return MIN(1.0, MAX(0.0001, progress + self.morphingCharacterDelay * (CGFloat)j));
     };
    
    NSString *closureKey = [NSString stringWithFormat:@"Fall%@", MGRMorphingPhasesProgress];
    self.progressClosures[closureKey] = progressClosures;
    
    
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
    
    closureKey = [NSString stringWithFormat:@"Fall%@", MGRMorphingPhasesDisappear];
    self.effectClosures[closureKey] = effectClosures;
    
    
    MGUMorphingLabelEffectClosure effectClosuresX =
    ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        CGFloat currentFontSize =
            MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, 0.0, self.font.pointSize, 1.0);
        CGFloat yOffset = self.font.pointSize - currentFontSize;

        NSValue *rectValue = self.freshRects[index];
        CGRect newRect = [rectValue CGRectValue];
        newRect = CGRectOffset(newRect, 0.0, yOffset);

        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:newRect
                                                     alpha:(CGFloat)self.morphingProgress
                                                      size:currentFontSize
                                           drawingProgress:0.0];
    };

    closureKey = [NSString stringWithFormat:@"Fall%@", MGRMorphingPhasesAppear];
    self.effectClosures[closureKey] = effectClosuresX;
    
    MGRMorphingDrawingClosure drawingClosures =  ^BOOL (MGUMorphingLabelCharLimbo *limbo) {

        if (limbo.drawingProgress <= 0.0) {
            return NO;
        } else {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGRect charRect = limbo.rect;
            
            CGContextSaveGState(context); // 각각의 컨텍스트 저장
            CGFloat charCenterX = charRect.origin.x + (charRect.size.width / 2.0);
            CGFloat charBottomY = charRect.origin.y + charRect.size.height - self.font.pointSize / 6;
            UIColor *charColor  = self.textColor;
            
            // Fall down if drawingProgress is more than 50%
            if (limbo.drawingProgress > 0.5) {
                CGFloat ease =
                    MGEEasingFunction_C(MGEEasingFunctionTypeEaseInQuint,
                                        limbo.drawingProgress - 0.4,
                                        0.0,
                                        1.0,
                                        0.5);
                charBottomY += ease * 10.0;
                CGFloat fadeOutAlpha = MIN(1.0, MAX(0.0, limbo.drawingProgress * -2.0 + 2.0 + 0.01));
                charColor = [self.textColor colorWithAlphaComponent:fadeOutAlpha];
            }
            
            
            charRect = CGRectMake(charRect.size.width / -2.0, charRect.size.height * -1.0 + self.font.pointSize / 6,
                                  charRect.size.width, charRect.size.height);
            
            CGContextTranslateCTM(context, charCenterX, charBottomY);
            
            CGFloat angle = sin(limbo.rect.origin.x) > 0.5 ? 168.0 : -168.0;
            
            CGFloat rotation =
            MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutBack,
                                MIN(1.0, limbo.drawingProgress),
                                0.0,
                                1.0,
                                1.0) * angle;
            CGContextRotateCTM(context, rotation * M_PI / 180.0);
            
            NSString *s = limbo.character;

            NSMutableDictionary <NSAttributedStringKey, NSObject *>*attributes = @{
            NSForegroundColorAttributeName : charColor,
            NSFontAttributeName: [self.font fontWithSize:limbo.size]
            }.mutableCopy;
            
            [s drawInRect:charRect withAttributes:attributes];
            
            CGContextRestoreGState(context);
            
            return YES;
        }
    };
    
    closureKey = [NSString stringWithFormat:@"Fall%@", MGRMorphingPhasesDraw];
    self.drawingClosures[closureKey] = drawingClosures;
}
@end
