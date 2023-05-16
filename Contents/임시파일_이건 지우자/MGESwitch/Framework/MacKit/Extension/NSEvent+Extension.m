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


#pragma mark - DEBUG
- (NSString *)mgrDebugStringEventType {
    if (self.type == NSEventTypeLeftMouseDown) {
        return @"NSEventTypeLeftMouseDown";
    } else if (self.type == NSEventTypeLeftMouseUp) {
        return @"NSEventTypeLeftMouseUp";
    } else if (self.type == NSEventTypeRightMouseDown) {
        return @"NSEventTypeRightMouseDown";
    } else if (self.type == NSEventTypeRightMouseUp) {
        return @"NSEventTypeRightMouseUp";
    } else if (self.type == NSEventTypeMouseMoved) {
        return @"NSEventTypeMouseMoved";
    } else if (self.type == NSEventTypeLeftMouseDragged) {
        return @"NSEventTypeLeftMouseDragged";
    } else if (self.type == NSEventTypeRightMouseDragged) {
        return @"NSEventTypeRightMouseDragged";
    } else if (self.type == NSEventTypeMouseEntered) {
        return @"NSEventTypeMouseEntered";
    } else if (self.type == NSEventTypeMouseExited) {
        return @"NSEventTypeMouseExited";
    } else if (self.type == NSEventTypeKeyDown) {
        return @"NSEventTypeKeyDown";
    } else if (self.type == NSEventTypeKeyUp) {
        return @"NSEventTypeKeyUp";
    } else if (self.type == NSEventTypeFlagsChanged) {
        return @"NSEventTypeFlagsChanged";
    } else if (self.type == NSEventTypeAppKitDefined) {
        return @"NSEventTypeAppKitDefined";
    } else if (self.type == NSEventTypeSystemDefined) {
        return @"NSEventTypeSystemDefined";
    } else if (self.type == NSEventTypeApplicationDefined) {
        return @"NSEventTypeApplicationDefined";
    } else if (self.type == NSEventTypePeriodic) {
        return @"NSEventTypePeriodic";
    } else if (self.type == NSEventTypeCursorUpdate) {
        return @"NSEventTypeCursorUpdate";
    } else if (self.type == NSEventTypeScrollWheel) {
        return @"NSEventTypeScrollWheel";
    } else if (self.type == NSEventTypeTabletPoint) {
        return @"NSEventTypeTabletPoint";
    } else if (self.type == NSEventTypeTabletProximity) {
        return @"NSEventTypeTabletProximity";
    } else if (self.type == NSEventTypeOtherMouseDown) {
        return @"NSEventTypeOtherMouseDown";
    } else if (self.type == NSEventTypeOtherMouseUp) {
        return @"NSEventTypeOtherMouseUp";
    } else if (self.type == NSEventTypeOtherMouseDragged) {
        return @"NSEventTypeOtherMouseDragged";
    } else if (self.type == NSEventTypeGesture) {
        return @"NSEventTypeGesture";
    } else if (self.type == NSEventTypeMagnify) {
        return @"NSEventTypeMagnify";
    } else if (self.type == NSEventTypeSwipe) {
        return @"NSEventTypeSwipe";
    } else if (self.type == NSEventTypeRotate) {
        return @"NSEventTypeRotate";
    } else if (self.type == NSEventTypeBeginGesture) {
        return @"NSEventTypeBeginGesture";
    } else if (self.type == NSEventTypeEndGesture) {
        return @"NSEventTypeEndGesture";
    } else if (self.type == NSEventTypeSmartMagnify) {
        return @"NSEventTypeSmartMagnify";
    } else if (self.type == NSEventTypeQuickLook) {
        return @"NSEventTypeQuickLook";
    } else if (self.type == NSEventTypePressure) {
        return @"NSEventTypePressure";
    } else if (self.type == NSEventTypeDirectTouch) {
        return @"NSEventTypeDirectTouch";
    } else if (self.type == NSEventTypeChangeMode) {
        return @"NSEventTypeChangeMode";
    } else {
        return @"예상치 못한 것이 들어왔다.";
    }
}

- (NSString *)mgrDebugStringEventPhase {
    return MGADebugEvent(self.phase);
}

- (NSString *)mgrDebugStringEventMomentumPhase {
    return MGADebugEvent(self.momentumPhase);
}

#pragma mark - Private
static NSString * MGADebugEvent(NSEventPhase phase) {
    if (phase == NSEventPhaseNone) {
        return @"NSEventPhaseNone";
    } else if (phase == NSEventPhaseBegan) {
        return @"NSEventPhaseBegan";
    } else if (phase == NSEventPhaseStationary) {
        return @"NSEventPhaseStationary";
    } else if (phase == NSEventPhaseChanged) {
        return @"NSEventPhaseChanged";
    } else if (phase == NSEventPhaseEnded) {
        return @"NSEventPhaseEnded";
    } else if (phase == NSEventPhaseCancelled) {
        return @"NSEventPhaseCancelled";
    } else if (phase == NSEventPhaseMayBegin) {
        return @"NSEventPhaseMayBegin";
    } else {
        return @"혼합. 사실은 NS_OPTIONS";
    }
}
@end
