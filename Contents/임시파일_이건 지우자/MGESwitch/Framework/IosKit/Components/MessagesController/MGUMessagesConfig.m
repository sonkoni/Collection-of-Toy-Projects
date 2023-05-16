//
//  MGUMessagesConfig.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "UIWindow+Extension.h"
#import "MGUMessagesConfig.h"
#import "MGUMessagesKeyboardTrackingView.h"
#import "MGUMessagesViewController.h"
#import "MGUMessagesAnimationContext.h"

@interface MGUMessagesConfig ()
@property (nonatomic, assign) NSInteger overrideUserInterfaceStyleRawValue; // nullable
@end

@implementation MGUMessagesConfig
@dynamic overrideUserInterfaceStyle;
@dynamic shouldBecomeKeyWindow;

#pragma mark - 생성 & 소멸
- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUMessagesConfig *self) {
    self->_duration = MGUMessagesPresentationDurationAutomatic;
    self->_dimMode = MGUMessagesDimModeNone;
    self->_interactiveHide = YES;
    self->_preferredStatusBarStyle = UIStatusBarStyleDefault;
    self->_shouldAutorotate = YES;
    self->_ignoreDuplicates = YES;
    self->_eventListeners = [NSMutableArray array];
    self->_dimModeAccessibilityLabel = @"dismiss";
    self->_presentationStyle = MGUMessagesPresentationStyleTop;
    self->_presentationContext = MGUMessagesPresentationContextAutomatic;
    
    self->_overrideUserInterfaceStyleRawValue = MGEIntegerNull;
    self->_becomeKeyWindow = MGUMessagesBecomeKeyWindowAutoMatic;
}

- (BOOL)dimModeInteractive {
    if (self.dimMode == MGUMessagesDimModeNone) {
        return NO;
    } else {
        return _dimModeInteractive;
    }
}

#pragma mark - 세터 & 게터
- (void)setOverrideUserInterfaceStyle:(UIUserInterfaceStyle)overrideUserInterfaceStyle {
    self.overrideUserInterfaceStyleRawValue = overrideUserInterfaceStyle;
}

- (void)setPresentationContext:(MGUMessagesPresentationContext)presentationContext {
    _presentationContext = presentationContext;
    if (presentationContext == MGUMessagesPresentationContextWindowScene) {
        if (@available(iOS 13.0, *)) {} else {
            NSCAssert(FALSE, @"windowScene is not supported below iOS 13.0.");
        }
    }
}

- (BOOL)shouldBecomeKeyWindow {
    if (self.becomeKeyWindow == MGUMessagesBecomeKeyWindowYES) {
        return YES;
    } else if (self.becomeKeyWindow == MGUMessagesBecomeKeyWindowNO) {
        return NO;
    } else {
        if (self.dimMode == MGUMessagesDimModeNone) {
            return NO;
        } else { // .gray, .color, .blur:
            return YES;
        }
    }
}

- (UIWindowScene *)windowScene {
    if (self.presentationContext == MGUMessagesPresentationContextWindowScene) {
        if (_windowScene == nil) {
            NSCAssert(FALSE, @"값 설정이 제대로 되지 않았다.");
        }
        return _windowScene;
    } else {
        return [UIWindow mgrKeyWindow].windowScene;
    }
}

- (UIWindowLevel)windowLevel {
    if (self.presentationContext == MGUMessagesPresentationContextWindowLevel || self.presentationContext == MGUMessagesPresentationContextWindowScene) {
        if (MGEFloatIsNull(_windowLevel) == YES) {
            NSCAssert(FALSE, @"값 설정이 제대로 되지 않았다.");
        }
        return _windowLevel;
    }
    
    return MGEFloatNull;
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    if (self.overrideUserInterfaceStyleRawValue == UIUserInterfaceStyleLight) {
        return UIUserInterfaceStyleLight;
    } else if (self.overrideUserInterfaceStyleRawValue == UIUserInterfaceStyleDark) {
        return UIUserInterfaceStyleDark;
    } else {
        return UIUserInterfaceStyleUnspecified;
    }
}

@end
