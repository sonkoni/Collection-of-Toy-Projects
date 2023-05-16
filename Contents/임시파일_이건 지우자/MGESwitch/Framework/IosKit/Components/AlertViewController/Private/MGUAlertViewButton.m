//
//  MGUAlertViewButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertViewButton.h"

@implementation MGUAlertViewButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    return [super buttonWithType:UIButtonTypeSystem]; // self의 initWithFrame:을 호출한다!!
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 퍼포먼스를 향상 시킨다. 주의점도 존재함 - 위키 : Api:Core Animation/CALayer/shouldRasterize
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self invalidateIntrinsicContentSize]; // intrinsicContentSize 호출하여 auto layout을 갱신한다.
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self updateButtonAppearance];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray <UIGestureRecognizer *>*gestureRecognizers = touch.gestureRecognizers;
    for (UIPanGestureRecognizer *gestureRecognizer in gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
            event.type == UIEventTypeTouches) { // 취소의 원인이 다른 터치라는 뜻.
            UIView *gestureRecognizerView = gestureRecognizer.view;
            CGRect relativeRect = [self convertRect:self.bounds toView:gestureRecognizerView];
            if (CGRectContainsRect(gestureRecognizerView.bounds, relativeRect) == YES) {
                return;
            }
        }
    }
    
    [super touchesCancelled:touches withEvent:event];
}

- (void)updateButtonAppearance {
    if (self.isEnabled == NO) {
        self.backgroundColor = nil;
    } else {
        if (self.isHighlighted || self.isSelected) {
            self.backgroundColor = self.highlightedButtonBackgroundColor;
        } else {
            self.backgroundColor = nil;
        }
    }
}

- (CGSize)intrinsicContentSize {
    if (self.hidden == YES) {
        return CGSizeZero;
    }

    return CGSizeMake([super intrinsicContentSize].width + 12.0f, 44.0f);
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

@end
