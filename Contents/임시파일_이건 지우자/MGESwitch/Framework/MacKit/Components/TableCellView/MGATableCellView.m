//
//  MGATableCellView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGATableCellView.h"

@interface MGATableCellView ()
@property (nonatomic, assign) BOOL mouseInside;
@property (nonatomic, strong) NSTrackingArea *trackingArea; // lazy
@end

@implementation MGATableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if ([self.trackingAreas containsObject:self.trackingArea] == NO) {
        [self addTrackingArea:self.trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)event {
    self.mouseInside = NO;
}


#pragma mark - 세터 & 게터
- (NSTrackingArea *)trackingArea {
    if (_trackingArea == nil) {
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                         options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited
                                                           owner:self
                                                        userInfo:nil];
    }
    return _trackingArea;
}

#pragma mark - 세터 & 게터
- (void)setMouseInside:(BOOL)mouseInside {
    if (_mouseInside != mouseInside) {
        _mouseInside = mouseInside;
        if (self.mouseHoverConditionalBlock != nil) {
            self.mouseHoverConditionalBlock(mouseInside);
        }
    }
}

@end
