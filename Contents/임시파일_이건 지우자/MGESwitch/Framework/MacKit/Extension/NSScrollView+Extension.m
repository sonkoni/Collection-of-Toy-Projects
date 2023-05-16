//
//  NSScrollView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSScrollView+Extension.h"

@implementation NSScrollView (Extension)

- (CGSize)mgrContentSize {
    if (self.documentView != nil) {
        return self.documentView.frame.size;
    } else {
        return CGSizeZero;
    }
}

- (void)setMgrContentSize:(CGSize)mgrContentSize {
    if (self.documentView != nil) {
        [self.documentView setFrameSize:mgrContentSize];
    }
}

- (CGPoint)mgrContentOffset {
    if (self.contentView != nil) {
        return self.contentView.bounds.origin;
    } else {
        return CGPointZero;
    }
    //
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/Scrolling.html#//apple_ref/doc/uid/TP40003463-SW2
}

- (void)setMgrContentOffset:(CGPoint)mgrContentOffset {
    if (self.contentView != nil) {
        [self.contentView scrollToPoint:mgrContentOffset];
        [self reflectScrolledClipView:self.contentView];
    }
    //
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/Scrolling.html#//apple_ref/doc/uid/TP40003463-SW2
}

- (CGPoint)mgrMaxOffset {
    CGFloat maxOffsetX = MAX(0.0, self.mgrContentSize.width - self.frame.size.width);
    CGFloat maxOffsetY = MAX(0.0, self.mgrContentSize.height - self.frame.size.height);
    return CGPointMake(maxOffsetX, maxOffsetY);
}

- (CGRect)clipViewBounds {
    return self.contentView.bounds;
}

- (void)setClipViewBounds:(CGRect)clipViewBounds {
    self.contentView.bounds = clipViewBounds;
    [self.contentView scrollToPoint:clipViewBounds.origin];
    [self reflectScrolledClipView:self.contentView];
}

- (void)setContentOffset:(CGPoint)contentOffset
                animated:(BOOL)animated
              completion:(void(^)(void))completion {
    if (animated == NO) {
        // 이게 더 정확한듯.
        [self.contentView scrollToPoint:contentOffset];
        // [self.contentView setBoundsOrigin:contentOffset];
        [self reflectScrolledClipView:self.contentView];
        if (completion) {
            completion();
        }
        return;
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.2;
        context.allowsImplicitAnimation = YES;
        // 이게 더 정확한듯.
        [self.contentView.animator scrollToPoint:contentOffset];
        // [self.contentView.animator setBoundsOrigin:contentOffset];
        [self reflectScrolledClipView:self.contentView];
    } completionHandler:^{
        if (completion) {
            completion();
        }
    }];
}

@end
