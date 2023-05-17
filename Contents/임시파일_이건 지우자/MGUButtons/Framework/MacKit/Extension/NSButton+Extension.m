//
//  NSButton+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSButton+Extension.h"
#import "NSView+Etc.h"
#import <Quartz/Quartz.h>

@implementation NSButton (Extension)

- (void)setMgrUserInteractionEnabled:(BOOL)mgrUserInteractionEnabled {
    if (mgrUserInteractionEnabled == YES) {
        self.enabled = YES;
        NSButtonCell *cell = self.cell;
        if ([cell isKindOfClass:[NSButtonCell class]] == YES) {
            cell.imageDimsWhenDisabled = YES;
        }
    } else {
        self.enabled = NO;
        NSButtonCell *cell = self.cell;
        if ([cell isKindOfClass:[NSButtonCell class]] == YES) {
            cell.imageDimsWhenDisabled = NO;
        }
    }
    //
    // 이런 방식도 있을 수 있다.
//    class CustomButton: NSButton {
//        var isUserInteractionEnabled = true
//
//        override func hitTest(_ point: NSPoint) -> NSView? {
//            return isUserInteractionEnabled ? super.hitTest(point) : nil
//        }
//    }
}

- (BOOL)mgrIsUserInteractionEnabled {
    return self.isEnabled;
}

- (void)mgrSideBarNotesStyleWithImage:(NSImage *)image tintColor:(NSColor *)tintColor {
    self.bezelStyle = NSBezelStyleRecessed;
    self.bordered = NO;
    self.imagePosition = NSImageOnly;
    self.focusRingType = NSFocusRingTypeNone;
    self.title = @"";
    if (tintColor != nil) {
        self.contentTintColor = tintColor;
        image.template = YES;
    }
    self.image = image;
}

- (void)mgrFlatStyleWithImage:(NSImage *)image tintColor:(NSColor *_Nullable)tintColor {
    self.bezelStyle = NSBezelStyleRegularSquare;
    [self setButtonType:NSButtonTypeMomentaryPushIn];
    self.bordered = NO;
    self.imagePosition = NSImageOnly;
    self.focusRingType = NSFocusRingTypeNone;
    self.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.title = @"";
    if (tintColor != nil) {
        self.contentTintColor = tintColor;
        image.template = YES;
    }
    if (image != nil) {
        self.image = image;
    }
}

- (void)mgrAddTarget:(nullable id)target
              action:(nullable SEL)action {
    self.target = target;
    self.action = action;
}

- (void)mgrAddTarget:(nullable id)target
              action:(nullable SEL)action
    forControlEvents:(NSEventMask)controlEvents {
    self.target = target;
    self.action = action;
    [self sendActionOn:controlEvents];
}

@end
