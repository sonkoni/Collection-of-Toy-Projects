//
//  MGAUserInteractionPausableWindow.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAUserInteractionPausableWindow.h"
#import "NSEvent+Extension.h"
#import <objc/runtime.h>

@implementation MGAUserInteractionPausableWindow


- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)style
                            backing:(NSBackingStoreType)backingStoreType
                              defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    if (self) {
        _userInteractionEnabled = YES;
    }
    return self;
}


- (void)sendEvent:(NSEvent *)event {
    if (self.userInteractionEnabled == NO && [event mgrIsUserInteraction] == YES) {
        return;
    }
    [super sendEvent:event];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    // Deactivate toolbar interactions from the Main Menu.
    if (sel_isEqual(aSelector, @selector(toggleToolbarShown:)) == YES) {
        return NO;
    }
    return [super respondsToSelector:aSelector];
}

@end
