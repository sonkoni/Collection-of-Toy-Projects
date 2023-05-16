//
//  UIVisualEffectView+MGRExtension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIVisualEffectView+Extension.h"

@implementation UIVisualEffectView (Extension)

+ (instancetype)mgrBlurViewWithBlurEffectStyle:(UIBlurEffectStyle)style {
    return [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
}

+ (instancetype)mgrBlurVibrancyViewWithBlurEffectStyle:(UIBlurEffectStyle)style {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [blurView.contentView addSubview:vibrancyView];
    vibrancyView.frame = blurView.contentView.bounds;
    vibrancyView.translatesAutoresizingMaskIntoConstraints = YES;
    [vibrancyView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    return blurView;
}

+ (instancetype)mgrBlurVibrancyViewWithBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                                   vibrancyEffectStyle:(UIVibrancyEffectStyle)vibrancyEffectStyle {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect style:vibrancyEffectStyle];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [blurView.contentView addSubview:vibrancyView];
    vibrancyView.frame = blurView.contentView.bounds;
    vibrancyView.translatesAutoresizingMaskIntoConstraints = YES;
    [vibrancyView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    return blurView;
}

- (void)mgrAddSubview:(UIView *)view pinEdges:(BOOL)pinEdges {
    if ([self.effect isKindOfClass:[UIBlurEffect class]] == NO) {
        NSAssert(FALSE, @"본 메서드의 리시버는 블러뷰이다.");
    }
    
    UIVisualEffectView *vibrancyView = self.contentView.subviews.firstObject;
    if (vibrancyView != nil &&
        [vibrancyView isKindOfClass:[UIVisualEffectView class]] &&
        [vibrancyView.effect isKindOfClass:[UIVibrancyEffect class]]) {
        [vibrancyView.contentView addSubview:view];
    } else {
        [self.contentView addSubview:view];
    }
    
    if (pinEdges == YES) {
        view.frame = view.superview.bounds;
        view.translatesAutoresizingMaskIntoConstraints = YES;
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
}

@end
