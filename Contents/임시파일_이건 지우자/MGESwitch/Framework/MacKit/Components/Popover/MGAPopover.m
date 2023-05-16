//
//  MGAPopover.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAPopover.h"

// 디버그 용.
//@interface XWindow : NSWindow
//@end
//@implementation XWindow
//- (void)dealloc {
//    NSLog(@"나죽어....");
//}
//@end

@interface MGAPopover ()
@property (weak, nonatomic) NSWindow *window;
@property (nonatomic, strong) id <NSObject>observer;
@end


@implementation MGAPopover

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    if (self.window != nil) {
        [self.window close];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        __weak __typeof(self) weakSelf = self;
        _observer = [nc addObserverForName:NSPopoverDidCloseNotification
                                    object:self
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:^(NSNotification *note) {
            if (weakSelf.window != nil) {
                [weakSelf.window close];
            }
        }];
    }
    return self;
}

- (void)showRelativeToRect:(NSRect)positioningRect
                    ofView:(NSView *)positioningView
             preferredEdge:(NSRectEdge)preferredEdge {
    CGRect fullRect = positioningView.bounds;
    if (CGRectContainsRect(fullRect, positioningRect) == YES) {
        [super showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
    } else {
        CGRect windowFrameRect = [positioningView convertRect:positioningRect toView:nil];
        CGRect screenFrameRect = [positioningView.window convertRectToScreen:windowFrameRect];
        NSWindow *invisibleWindow = [[NSWindow alloc] initWithContentRect:screenFrameRect
                                                                styleMask:NSWindowStyleMaskBorderless
                                                                  backing:NSBackingStoreBuffered
                                                                    defer:NO];
        invisibleWindow.releasedWhenClosed = NO; // 윈도우 컨트롤러가 없는 윈도우는 그냥 close 하면 터지네.
        invisibleWindow.backgroundColor = [NSColor redColor];
        invisibleWindow.alphaValue = 0.0;
        [invisibleWindow makeKeyAndOrderFront:positioningView];
        
        [super showRelativeToRect:invisibleWindow.contentView.frame
                           ofView:invisibleWindow.contentView
                    preferredEdge:NSMinYEdge];
        [self.contentViewController.view.window makeKeyWindow];
        [NSApp activateIgnoringOtherApps:YES];
        self.window = invisibleWindow;
    }
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
