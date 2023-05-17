//
//  MGAContentView.m
//
//  Created by Kwan Hyun Son on 2022/05/10.
//

#import "MGAContentView.h"

@implementation MGAContentView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (BOOL)canBecomeKeyView {
    return [NSApp isFullKeyboardAccessEnabled];
}

/** 포커스 링은 하지 않는 것이 좋다.
- (void)drawFocusRingMask { // 포커스 링의 바운더리를 잡아준다.
    CGFloat cornerRadius = self.bounds.size.height / 2.0;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:cornerRadius yRadius:cornerRadius];
    [[NSColor blackColor] set];
    [path fill];
}

- (NSRect)focusRingMaskBounds {
    return [self bounds];
}
*/

#pragma mark -- OVERRIDE - NSResponder - Responding to Mouse Events
- (BOOL)acceptsFirstResponder {
    return [NSApp isFullKeyboardAccessEnabled];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self.window makeFirstResponder:nil];
}

@end
