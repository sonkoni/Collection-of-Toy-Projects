//
//  MGUMorphingLabel+Anvil.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 25/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabel+Anvil.h"
#import "MGUMorphingLabelCharLimbo.h"
#import "MGUMorphingLabelEmitter.h"
@import GraphicsKit;

@implementation MGUMorphingLabel (Anvil)
- (void)AnvilLoad {
    
    MGRMorphingStartClosure startClosures = ^void (void) {
        [self.emitterView removeAllEmitters];
        
        if (self.freshRects.count <= 0) {
            return;
        }
        
        NSValue *rectValue = self.freshRects[(NSUInteger)self.freshRects.count / 2];
        CGRect centerRect = [rectValue CGRectValue];
        
        [self.emitterView createEmitter:@"leftSmoke"
                           particleName:@"MGUMorphingLabelSmoke"
                               duration:0.6
                       configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            
            layer.emitterSize = CGSizeMake(1.0, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x,
                                                centerRect.origin.y + centerRect.size.height / 1.3);
            
            layer.renderMode = kCAEmitterLayerUnordered;
            cell.emissionLongitude = M_PI / 2.0f;
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 130.0;
            cell.birthRate = 60.0;
            cell.velocity = (CGFloat)(80 + arc4random_uniform(60));
            cell.velocityRange = 100;
            cell.yAcceleration = -40;
            cell.xAcceleration = 70;
            cell.emissionLongitude = (-M_PI / 2.0);
            cell.emissionRange = M_PI / 4.0f / 5.0;
            cell.lifetime = self.morphingDuration * 2.0;
            cell.spin = 10;
            cell.alphaSpeed = -0.5 / self.morphingDuration;
        }];

        [self.emitterView createEmitter:@"rightSmoke"
                           particleName:@"MGUMorphingLabelSmoke"
                               duration:0.6
                       configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            
            layer.emitterSize = CGSizeMake(1.0, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x,
                                                centerRect.origin.y + centerRect.size.height / 1.3);
            
            layer.renderMode = kCAEmitterLayerUnordered;
            cell.emissionLongitude = M_PI / 2.0f;
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 130.0;
            cell.birthRate = 60.0;
            cell.velocity = (CGFloat)(80 + arc4random_uniform(60));
            cell.velocityRange = 100;
            cell.yAcceleration = -40;
            cell.xAcceleration = -70;
            cell.emissionLongitude = (M_PI / 2.0);
            cell.emissionRange = -M_PI / 4.0f / 5.0;
            cell.lifetime = self.morphingDuration * 2.0;
            cell.spin = 10;
            cell.alphaSpeed = -0.5 / self.morphingDuration;
        }];
        
        [self.emitterView createEmitter:@"leftFragments"
                           particleName:@"MGUMorphingLabelFragment"
                               duration:0.6
                       configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            
            layer.emitterSize = CGSizeMake(self.font.pointSize, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x,
                                                centerRect.origin.y + centerRect.size.height / 1.3);
            
            
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 40.0;
            cell.color = self.textColor.CGColor;
            cell.birthRate = 60;
            cell.velocity = 350;
            cell.yAcceleration = 0;
            cell.xAcceleration = (CGFloat)(10 * arc4random_uniform(10));
            cell.emissionLongitude = (-M_PI / 2.0);
            cell.emissionRange = M_PI / 4.0f / 5.0;
            cell.alphaSpeed = -2;
            cell.lifetime = self.morphingDuration;
        }];
        
        [self.emitterView createEmitter:@"rightFragments"
                           particleName:@"MGUMorphingLabelFragment"
                               duration:0.6
                       configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            
            layer.emitterSize = CGSizeMake(self.font.pointSize, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x,
                                                centerRect.origin.y + centerRect.size.height / 1.3);
            
            
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 40.0;
            cell.color = self.textColor.CGColor;
            cell.birthRate = 60;
            cell.velocity = 350;
            cell.yAcceleration = 0;
            cell.xAcceleration = (CGFloat)(-10 * arc4random_uniform(10));
            cell.emissionLongitude = (M_PI / 2.0);
            cell.emissionRange = -M_PI / 4.0f / 5.0;
            cell.alphaSpeed = -2;
            cell.lifetime = self.morphingDuration;
        }];
            
        [self.emitterView createEmitter:@"fragments"
                           particleName:@"MGUMorphingLabelFragment"
                               duration:0.6
                       configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            
            layer.emitterSize = CGSizeMake(self.font.pointSize, 1.0);
            layer.emitterPosition = CGPointMake(centerRect.origin.x,
                                                centerRect.origin.y + centerRect.size.height / 1.3);
            
            
            cell.scale = self.font.pointSize / 90.0;
            cell.scaleSpeed = self.font.pointSize / 40.0;
            cell.color = self.textColor.CGColor;
            cell.birthRate = 60;
            cell.velocity = 250;
            cell.velocityRange = (CGFloat)(arc4random_uniform(20) + 30);
            cell.yAcceleration = 500;
            cell.emissionLongitude = 0;
            cell.emissionRange = M_PI / 2.0;
            cell.alphaSpeed = -1;
            cell.lifetime = self.morphingDuration;
        }];
    };
    
    NSString *closureKey = [NSString stringWithFormat:@"Anvil%@", MGRMorphingPhasesStart];
    self.startClosures[closureKey] = startClosures;
        
    
    MGRMorphingManipulateProgressClosure progressClosures = ^CGFloat(NSInteger index, CGFloat progress, BOOL isNewChar) {
        
        if (isNewChar == NO) {
            return MIN(1.0, MAX(0.0, progress));
        }
        
        CGFloat j = (CGFloat)(sin((CGFloat)index) * 1.7);
        return MIN(1.0, MAX(0.0001, progress + self.morphingCharacterDelay * (CGFloat)j));
     };
    
    closureKey = [NSString stringWithFormat:@"Anvil%@", MGRMorphingPhasesProgress];
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
    
    closureKey = [NSString stringWithFormat:@"Anvil%@", MGRMorphingPhasesDisappear];
    self.effectClosures[closureKey] = effectClosures;
    
    
    effectClosures = ^MGUMorphingLabelCharLimbo * _Nullable (NSString *character, NSInteger index, CGFloat progress) {
        
        NSValue *rectValue = self.freshRects[index];
        CGRect rect = [rectValue CGRectValue];
        
        if (progress < 1.0) {
            CGFloat easingValue =
                MGEEasingFunction_C(MGEEasingFunctionTypeEaseOutBounce, progress, 0.0, 1.0, 1.0);
            rect.origin.y = rect.origin.y * easingValue;
        }
        
        if (progress > self.morphingDuration * 0.5) {
            CGFloat end = self.morphingDuration * 0.55;
            
            MGUMorphingLabelEmitter *emitter = [self.emitterView createEmitter:@"fragments"
                               particleName:@"MGUMorphingLabelFragment"
                                   duration:0.6
                           configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            }];
            
            emitter = [emitter update:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                if (progress > end) {
                    layer.birthRate = 0;
                }
            }];
            
            [emitter play];
            
            
            emitter = [self.emitterView createEmitter:@"leftFragments"
                               particleName:@"MGUMorphingLabelFragment"
                                   duration:0.6
                           configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            }];
            
            emitter = [emitter update:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                if (progress > end) {
                    layer.birthRate = 0;
                }
            }];
            
            [emitter play];
            
            emitter = [self.emitterView createEmitter:@"rightFragments"
                               particleName:@"MGUMorphingLabelFragment"
                                   duration:0.6
                           configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            }];
            
            emitter = [emitter update:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                if (progress > end) {
                    layer.birthRate = 0;
                }
            }];
            
            [emitter play];
        }
        
        if (progress > self.morphingDuration * 0.63) {
            CGFloat end = self.morphingDuration * 0.7;
            
            MGUMorphingLabelEmitter *emitter = [self.emitterView createEmitter:@"leftSmoke"
                               particleName:@"MGUMorphingLabelSmoke"
                                   duration:0.6
                           configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            }];
            
            emitter = [emitter update:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                if (progress > end) {
                    layer.birthRate = 0;
                }
            }];
            
            [emitter play];
            
            emitter = [self.emitterView createEmitter:@"rightSmoke"
                               particleName:@"MGUMorphingLabelSmoke"
                                   duration:0.6
                           configureClosure:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
            }];
            
            emitter = [emitter update:^(CAEmitterLayer * _Nonnull layer, CAEmitterCell * _Nonnull cell) {
                if (progress > end) {
                    layer.birthRate = 0;
                }
            }];
            
            [emitter play];
        }
        
        
        return [[MGUMorphingLabelCharLimbo alloc] initWithCharacter:character
                                                      rect:rect
                                                     alpha:(CGFloat)self.morphingProgress
                                                      size:self.font.pointSize
                                           drawingProgress:(CGFloat)progress];
    };
    
    closureKey = [NSString stringWithFormat:@"Anvil%@", MGRMorphingPhasesAppear];
    self.effectClosures[closureKey] = effectClosures;
}
@end
