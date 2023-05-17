//
//  NSWindow+Etc.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSWindow+Etc.h"

@implementation NSWindow (Etc)

- (void)mgrSetRootViewController:(NSViewController *)viewController {
    self.contentViewController = viewController;
    viewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    viewController.view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
}

- (void)mgrSetTitle:(NSString *)title subtitle:(NSString *)subtitle iconImage:(NSImage *)iconImage {
    self.title = title;
    self.subtitle = subtitle;
    // 이것으로 NSWindowDocumentIconButton이 생성된다. 앱 아이콘을 가져와서 버튼을 만들 것이다.
    self.representedFilename = [NSBundle mainBundle].bundleURL.path; //! file:// 을 제거해준다.
//    self.representedURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundleURL.path];
//    [self setTitleWithRepresentedFilename:[NSBundle mainBundle].bundleURL.path]; // title과 이이콘 동시에 설정한다.
    if (iconImage != nil) { // 만약 니가 원하는 아이콘을 넣고 싶다면
        // 아이콘 버튼이 representedFilename을 넣음으로 해서 만들어졌다. 도큐먼트 앱이 아닌 이상 버튼은 없다.
        NSButton *button = [self standardWindowButton:NSWindowDocumentIconButton];
        button.image = iconImage;
        // 이렇게 버튼을 눌렀을 때.(컨트롤+클릭이 아니라) 액션을 작동하게 할 수도 있다.
//        button.target = who;
//        button.action = @selector(abcdefg:);
    }
    //
    //
    // - setTitleWithRepresentedFilename: 이것은 파인더의 메커니즘을 보여주는 것으로 보인다.
    // 인자로 파일이름(전체 경로)을 넣어주면, 여기에서 끝부분을 타이틀로 사용하고 전체 이름에 해당하는 경로에서 아이콘을 가져와 설정한다.
    // [self.window setTitleWithRepresentedFilename:@"/Users/kwanhyunson"]; 이렇게 설정하면 타이틀과 아이콘 둘다 자동 설정된다.
}

- (void)mgrSetMiniwindowTitle:(NSString *)miniwindowTitle miniwindowImage:(NSImage *)miniwindowImage {
    self.miniwindowTitle = miniwindowTitle;
    if (miniwindowImage != nil) {
        self.miniwindowImage = miniwindowImage;
    }
}

- (void)mgrFadeDuration:(CGFloat)duration
                 fadeIn:(BOOL)fadeIn
      completionHandler:(void(^_Nullable)(void))completionHandler {
    self.alphaValue = (fadeIn == YES) ? 0.0 : 1.0;
    [self makeKeyAndOrderFront:nil];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = duration;
        self.animator.alphaValue = (fadeIn == YES) ? 1.0 : 0.0;
    } completionHandler:^{
        if (fadeIn == NO) {
            [self close]; // 결과적으로 닫아야지.
        }
        self.alphaValue = 1.0; // 복구는 해야지.
        if (completionHandler != nil) {
            completionHandler();
        }
    }];
}

- (void)mgrShowAllConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    NSMutableArray *views = @[self.contentView].mutableCopy;
    while (views.count > 0) {
        NSView *view = views.firstObject;
        [views removeObject:view];
        [views addObjectsFromArray:view.subviews];
        if([view hasAmbiguousLayout] == YES) {
            NSLog(@"View has ambiguous layout=%@", view);
        }
        [constraints addObjectsFromArray:view.constraints];
    }
    [self visualizeConstraints:constraints];
}

- (void)mgrHideAllConstraints {
    [self visualizeConstraints:@[]];
}
@end
