//
//  NSVisualEffectView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSVisualEffectView+Extension.h"

@implementation NSVisualEffectView (Extension)

+ (NSVisualEffectView *)mgrTitlebarVisualEffectView:(NSTitlebarSeparatorStyle)separatorStyle {
    NSVisualEffectView *visualEffectView = [NSVisualEffectView new];
    visualEffectView.blendingMode = NSVisualEffectBlendingModeWithinWindow; // 툴바(타이틀 바) 스타일
    visualEffectView.material = NSVisualEffectMaterialTitlebar;
    visualEffectView.state = NSVisualEffectStateFollowsWindowActiveState;
    if (separatorStyle == NSTitlebarSeparatorStyleNone) {
        return visualEffectView;
    }
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeZero;
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    CGFloat unitPoint = (scale != 0)? (1.0 / scale) : 1.0;
    if (separatorStyle == NSTitlebarSeparatorStyleLine ||
        separatorStyle == NSTitlebarSeparatorStyleAutomatic) {
        shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:0.49];
        shadow.shadowBlurRadius = unitPoint;
    } else if (separatorStyle == NSTitlebarSeparatorStyleShadow) {
        shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:0.3];
        shadow.shadowBlurRadius = unitPoint * 3.0;
    }
    visualEffectView.shadow = shadow;
    return visualEffectView;
}

+ (NSVisualEffectView *)mgrSidebarVisualEffectView {
    NSVisualEffectView *visualEffectView = [NSVisualEffectView new];
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow; // 윈도우 뒷면을 보이게 하는 효과
    visualEffectView.material = NSVisualEffectMaterialSidebar;
    visualEffectView.state = NSVisualEffectStateFollowsWindowActiveState;
    return visualEffectView;
}

@end

