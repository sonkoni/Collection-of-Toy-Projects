//
//  MGUSwipeExpanding.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeExpanding.h"
#import "MGUSwipeActionButton.h"

@implementation MGUSwipeScaleAndAlphaExpansion
- (instancetype)init {
    return [self initWithDuration:0.15 scale:0.8 interButtonDelay:0.1];
}

- (instancetype)initWithDuration:(CGFloat)duration scale:(CGFloat)scale interButtonDelay:(CGFloat)interButtonDelay {
    self = [super init];
    if (self) {
        _duration = duration;
        _scale = scale;
        _interButtonDelay = interButtonDelay;
    }
    return self;
}

- (MGUSwipeExpansionAnimationTimingParameters)animationTimingParameters:(NSArray <MGUSwipeActionButton *>* __unused)buttons
                                                           expanding:(BOOL)expanding {
    
    MGUSwipeExpansionAnimationTimingParameters timingParameters = MGUSwipeExpansionAnimationTimingParametersDefault;
    timingParameters.delay = (expanding == YES)? self.interButtonDelay : 0.0;
    return timingParameters;
}

- (void)actionButton:(MGUSwipeActionButton * __unused)button
           didChange:(BOOL)expanding
  otherActionButtons:(NSArray <MGUSwipeActionButton *>*)otherActionButtons {
    
    NSArray <MGUSwipeActionButton *>*buttons =
    (expanding == YES) ? otherActionButtons : [[otherActionButtons reverseObjectEnumerator] allObjects];
    
    [buttons enumerateObjectsUsingBlock:^(MGUSwipeActionButton *button, NSUInteger index, BOOL *stop) {
        NSTimeInterval delay = self.interButtonDelay * (CGFloat)(expanding ? index : index + 1);
        void (^animationsBlock)(void) = ^{
            button.transform = expanding ? CGAffineTransformMakeScale(self.scale, self.scale) : CGAffineTransformIdentity;
            button.alpha = expanding ? 0.0 : 1.0;
        };
        
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.duration
                                                              delay:delay
                                                            options:UIViewAnimationOptionCurveEaseInOut
                                                         animations:animationsBlock
                                                         completion:nil];
    }];
}

@end
