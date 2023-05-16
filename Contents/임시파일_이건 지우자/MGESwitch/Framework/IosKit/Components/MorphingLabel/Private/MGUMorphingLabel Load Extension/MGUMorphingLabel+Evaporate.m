//
//  MGUMorphingLabel+Evaporate.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 25/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabel+Evaporate.h"
#import "MGUMorphingLabelCharLimbo.h"
@import GraphicsKit;

@implementation MGUMorphingLabel (Evaporate)

- (void)EvaporateLoad {

     MGRMorphingManipulateProgressClosure progressClosures = ^CGFloat(NSInteger index, CGFloat progress, BOOL isNewChar) {
         //! NSInteger 로 해야한다. NSUInteger 로하면 버그가 발생한다.
         NSInteger j = (NSInteger)(round(cos((CGFloat)index) * 1.2));
         
         CGFloat delay = isNewChar ? self.morphingCharacterDelay * -1.0 : self.morphingCharacterDelay;
         return MIN(1.0, MAX(0.0, self.morphingProgress + delay * (CGFloat)j));
     };
    
    NSString *closureKey = [NSString stringWithFormat:@"Evaporate%@", MGRMorphingPhasesProgress];
    self.progressClosures[closureKey] = progressClosures;
    
    MGUMorphingLabelEffectClosure effectClosures =
    ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        CGFloat newProgress =
            MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, 0.0, 1.0, 1.0);
        
        CGFloat yOffset = -0.8 * self.font.pointSize * newProgress;
        NSValue *rectValue = self.previousRects[index];
        CGRect currentRect = [rectValue CGRectValue];
        currentRect = CGRectOffset(currentRect, 0.0, yOffset);
        CGFloat currentAlpha = 1.0 - newProgress;
        
        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:currentRect
                                                     alpha:currentAlpha
                                                      size:self.font.pointSize
                                           drawingProgress:0.0];
    };
    
    closureKey = [NSString stringWithFormat:@"Evaporate%@", MGRMorphingPhasesDisappear];
    self.effectClosures[closureKey] = effectClosures;

    MGUMorphingLabelEffectClosure effectClosuresX =
    ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        CGFloat newProgress =
            1.0 - MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutQuint, progress, 0.0, 1.0, 1.0);
        CGFloat yOffset = self.font.pointSize * newProgress * 1.2;

        NSValue *rectValue = self.freshRects[index];
        CGRect newRect = [rectValue CGRectValue];
        newRect = CGRectOffset(newRect, 0.0, yOffset);

        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:newRect
                                                     alpha:(CGFloat)self.morphingProgress
                                                      size:self.font.pointSize
                                           drawingProgress:0.0];
    };

    closureKey = [NSString stringWithFormat:@"Evaporate%@", MGRMorphingPhasesAppear];
    self.effectClosures[closureKey] = effectClosuresX;

}

@end
