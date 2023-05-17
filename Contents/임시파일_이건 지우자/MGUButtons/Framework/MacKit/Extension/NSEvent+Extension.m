//
//  NSEvent+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSEvent+Extension.h"

@implementation NSEvent (Extension)
static NSArray <NSNumber *>*_mgrUserInteractionEvents = nil;

+ (NSArray <NSNumber *>*)mgrUserInteractionEvents {
    if (_mgrUserInteractionEvents == nil) {
        NSMutableArray <NSNumber *>*mgrUserInteractionEvents =
        @[@(NSEventTypeLeftMouseDown),
          @(NSEventTypeLeftMouseUp),
          @(NSEventTypeRightMouseDown),
          @(NSEventTypeRightMouseUp),
          @(NSEventTypeLeftMouseDragged),
          @(NSEventTypeRightMouseDragged),
          @(NSEventTypeKeyDown),
          @(NSEventTypeKeyUp),
          @(NSEventTypeScrollWheel),
          @(NSEventTypeTabletPoint),
          @(NSEventTypeOtherMouseDown),
          @(NSEventTypeOtherMouseUp),
          @(NSEventTypeOtherMouseDragged),
          @(NSEventTypeGesture),
          @(NSEventTypeMagnify),
          @(NSEventTypeSwipe),
          @(NSEventTypeRotate),
          @(NSEventTypeBeginGesture),
          @(NSEventTypeEndGesture),
          @(NSEventTypeSmartMagnify),
          @(NSEventTypeQuickLook),
          @(NSEventTypeDirectTouch)].mutableCopy;
        if (@available(macOS 10.10.3, *)) {
            [mgrUserInteractionEvents addObject:@(NSEventTypePressure)];
        }
        _mgrUserInteractionEvents = mgrUserInteractionEvents.copy;
      }
      return _mgrUserInteractionEvents;
}

- (BOOL)mgrIsUserInteraction {
    return [[NSEvent mgrUserInteractionEvents] containsObject:@(self.type)];
}

- (NSPoint)mgrLocationInView:(NSView *)view {
    if (view == nil) {
        return CGPointZero;
    }
    NSPoint globalLocation = [self locationInWindow];
    return [view convertPoint:globalLocation fromView:nil];
}
@end
