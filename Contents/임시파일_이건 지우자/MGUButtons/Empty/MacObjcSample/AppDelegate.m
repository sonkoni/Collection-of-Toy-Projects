//
//  AppDelegate.m
//  MacObjcEmpty
//
//  Created by Kiro on 2022/11/16.
//

#import "AppDelegate.h"
//@import MacKit;

@interface AppDelegate ()
@property (strong) IBOutlet NSWindow *window;
//@property (weak) IBOutlet NSView *container1;
//@property (weak) IBOutlet NSView *container2;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    self.window.backgroundColor = [NSColor blackColor];
//
//    MGAImageView *imageView = [MGAImageView new];
//    imageView.image = [NSImage imageNamed:@"Yosemite"];
//    imageView.contentMode = kCAGravityResizeAspectFill;
//    [self.container1 addSubview:imageView];
//    [imageView mgrPinEdgesToSuperviewEdges];
//
//    MGAReflectionView *reflectionView =
//        [[MGAReflectionView alloc] initWithFrame:self.container2.bounds
//                                           alpha:0.6
//                                        location:0.5
//                               originalImageView:imageView];
//
//    [self.container2 addSubview:reflectionView];
//    [reflectionView mgrPinEdgesToSuperviewEdges];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
