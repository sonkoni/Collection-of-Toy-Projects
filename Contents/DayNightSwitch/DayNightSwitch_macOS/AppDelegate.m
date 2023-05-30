//
//  AppDelegate.m
//  DayNightSwitch_macOS
//
//  Created by Kwan Hyun Son on 2022/03/08.
//

#import "AppDelegate.h"
#import "WindowController.h"

@interface AppDelegate ()
@property (nonatomic, strong) WindowController *windowController;
@property (nonatomic, weak) NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //! - windowNibName 를 재정의 했으므로 - initWithWindow:에 nil을 넣어 초기화도 가능함.
    _windowController = [[WindowController alloc] initWithWindowNibName:NSStringFromClass([WindowController class])];
    [self.windowController showWindow:nil]; // [self.windowController.window makeKeyAndOrderFront:self]; <- 대신에 이것도 가능함.
    _window = self.windowController.window;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

// Single-window app을 x 버튼 눌렀다가 독을 클릭하면 메인 윈도우가 뜨지 않은 현상을 해결한다.
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (flag) {
        return NO;
    } else {
       [self.window makeKeyAndOrderFront:self];
        return YES;
    }
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

@end
