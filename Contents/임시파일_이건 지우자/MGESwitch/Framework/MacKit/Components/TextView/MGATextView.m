//
//  MGATextView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGATextView.h"

@implementation MGATextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (NSSize)intrinsicContentSize {
    NSTextContainer *textContainer = [self textContainer];
    NSLayoutManager *layoutManager = [self layoutManager];
    [layoutManager ensureLayoutForTextContainer:textContainer];
    return [layoutManager usedRectForTextContainer:textContainer].size;
}

- (void)didChangeText {
    [super didChangeText];
    [self invalidateIntrinsicContentSize];
}

@end
