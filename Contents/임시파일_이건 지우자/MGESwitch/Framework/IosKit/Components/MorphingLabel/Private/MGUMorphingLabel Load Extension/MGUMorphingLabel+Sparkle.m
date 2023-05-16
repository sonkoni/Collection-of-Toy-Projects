//
//  MGUMorphingLabel+Sparkle.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 25/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabel+Sparkle.h"
#import "MGUMorphingLabelCharLimbo.h"
#import "MGUMorphingLabelEmitter.h"

@implementation MGUMorphingLabel (Sparkle)
- (void)SparkleLoad {
    
    MGRMorphingStartClosure startClosures = ^void (void) {
        [self.emitterView removeAllEmitters];
    };
    
    NSString *closureKey = [NSString stringWithFormat:@"Sparkle%@", MGRMorphingPhasesStart];
    self.startClosures[closureKey] = startClosures;
    
    MGRMorphingManipulateProgressClosure progressClosures = ^CGFloat(NSInteger index, CGFloat progress, BOOL isNewChar) {
        
        if (isNewChar == NO) {
            return MIN(1.0, MAX(0.0, progress));
        }
        
        CGFloat j = (CGFloat)(round(sin((CGFloat)index) * 1.5));
        return MIN(1.0, MAX(0.0001, progress + self.morphingCharacterDelay * (CGFloat)j));
     };
    
    closureKey = [NSString stringWithFormat:@"Sparkle%@", MGRMorphingPhasesProgress];
    self.progressClosures[closureKey] = progressClosures;
        
    MGUMorphingLabelEffectClosure effectClosures = ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        NSValue *rectValue = self.previousRects[index];
        CGRect currentRect = [rectValue CGRectValue];
        
        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:currentRect
                                                     alpha:1.0 - progress
                                                      size:self.font.pointSize
                                           drawingProgress:0.0];
    };
    
    closureKey = [NSString stringWithFormat:@"Sparkle%@", MGRMorphingPhasesDisappear];
    self.effectClosures[closureKey] = effectClosures;
    
    effectClosures = ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        
        if ([character isEqualToString:@" "] == NO) {
            
            NSValue *rectValue = self.freshRects[index];
            CGRect rect = [rectValue CGRectValue];
        
            CGPoint emitterPosition = CGPointMake(rect.origin.x + rect.size.width / 2.0,
                                                  (CGFloat)progress * rect.size.height * 0.9 + rect.origin.y);
            

            MGUMorphingLabelEmitter *emitter = [self.emitterView createEmitter:[NSString stringWithFormat:@"c%ld", (long)index]
                               particleName:@"MGUMorphingLabelSparkle"
                                   duration:self.morphingDuration
                           configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                
                layer.emitterSize = CGSizeMake(rect.size.width, 1.0);
                layer.renderMode = kCAEmitterLayerUnordered;
                cell.emissionLongitude = M_PI / 2.0f;
                cell.scale = self.font.pointSize / 300.0;
                cell.scaleSpeed = self.font.pointSize / 300.0 * -1.5;
                cell.color = self.textColor.CGColor;
                cell.birthRate = self.font.pointSize * (arc4random_uniform(7) + 3);
            }];
            
            emitter = [emitter update:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                layer.emitterPosition = emitterPosition;
            }];
            
            [emitter play];
        }
        
        NSValue *rectValue = self.freshRects[index];
        CGRect rect = [rectValue CGRectValue];
        
        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:rect
                                                     alpha:(CGFloat)self.morphingProgress
                                                      size:self.font.pointSize
                                           drawingProgress:(CGFloat)progress];
    };
    
    closureKey = [NSString stringWithFormat:@"Sparkle%@", MGRMorphingPhasesAppear];
    self.effectClosures[closureKey] = effectClosures;
    
    MGRMorphingDrawingClosure drawingClosures =  ^BOOL (MGUMorphingLabelCharLimbo *limbo) {
        if (limbo.drawingProgress > 0.0) {
            
            NSArray *arr = [self maskedImageForCharLimbo:limbo withProgress:limbo.drawingProgress];
            
            UIImage *charImage = arr.firstObject;
            NSValue *rectValue = arr.lastObject;
            CGRect rect = [rectValue CGRectValue];
            
            [charImage drawInRect:rect];
            return YES;
            
        } else {
            return NO;
        }
    };
    
    closureKey = [NSString stringWithFormat:@"Sparkle%@", MGRMorphingPhasesDraw];
    self.drawingClosures[closureKey] = drawingClosures;
        

    
    MGRMorphingSkipFramesClosure skipFramesClosures =  ^NSInteger (void) {
        return 1;
    };
    
    closureKey = [NSString stringWithFormat:@"Sparkle%@", MGRMorphingPhasesSkipFrames];
    self.skipFramesClosures[closureKey] = skipFramesClosures;
}

//! private (UIImage, CGRect)
- (NSArray *)maskedImageForCharLimbo:(MGUMorphingLabelCharLimbo *)charLimbo withProgress:(CGFloat)progress {
    
    CGFloat maskedHeight = charLimbo.rect.size.height * MAX(0.01, progress);
    
    CGSize maskedSize = CGSizeMake(charLimbo.rect.size.width, maskedHeight);
    
    UIGraphicsBeginImageContextWithOptions(maskedSize, NO, UIScreen.mainScreen.scale);
    
    CGRect rect = CGRectMake(0.0, 0.0, charLimbo.rect.size.width, maskedHeight);
    
    NSDictionary <NSAttributedStringKey, NSObject *>*attrs = @{
    NSForegroundColorAttributeName : self.textColor,
    NSFontAttributeName: self.font };
    
    [charLimbo.character drawInRect:rect withAttributes:attrs];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); // 하나의 이미지로 받아오기
    if (newImage == nil) {
        return @[UIImage.new, [NSValue valueWithCGRect:CGRectZero]];
    }
    
    UIGraphicsEndImageContext();
    
    CGRect newRect = CGRectMake(charLimbo.rect.origin.x, charLimbo.rect.origin.y,
                                charLimbo.rect.size.width, maskedHeight);
    return @[newImage, [NSValue valueWithCGRect:newRect]];
}
@end
