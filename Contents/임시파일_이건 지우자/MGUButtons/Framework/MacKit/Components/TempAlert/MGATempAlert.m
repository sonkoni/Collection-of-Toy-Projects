//
//  MGATempAlert.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/11/07.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGATempAlert.h"
#import "NSWindow+Etc.h"

@interface ImageView : NSImageView
@end
@implementation ImageView
- (BOOL)allowsVibrancy {
    return YES;
}
@end

@interface MGATempAlert ()
@property (strong, nonatomic) NSImageView *imageView;
@property (strong, nonatomic) NSTextField *titleLabel;
@end

@implementation MGATempAlert


#pragma mark - 생성 & 소멸
+ (instancetype)alertWithTitle:(NSString *)title image:(NSImage *)image {
    MGATempAlert *alert = [[MGATempAlert alloc] initPrivate];
    alert.titleLabel.stringValue = title;
    alert.imageView.image = image;
    return alert;
}

- (instancetype)initPrivate {
    self = [super initWithContentRect:CGRectMake(0.0, 0.0, 200.0, 200.0)
                            styleMask:NSWindowStyleMaskBorderless
                              backing:NSBackingStoreBuffered
                                defer:YES]; // 지정 초기화. xib도 이걸 호출함. - initWithCoder: 메서드가 없다.
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGATempAlert *self) {
    self.restorable = NO;
    self.hidesOnDeactivate = NO;
    self.level = NSStatusWindowLevel; // always front
    self.maxSize = CGSizeMake(200.0, 200.0);
    self.minSize = CGSizeMake(200.0, 200.0);
    self.backgroundColor = [NSColor clearColor];
//    self.contentView.layer = [CALayer layer];
    self.contentView.wantsLayer = YES;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 20.0;

    NSVisualEffectView *visualEffectView = [[NSVisualEffectView alloc] initWithFrame:self.contentView.bounds];
    visualEffectView.wantsLayer = YES;
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.material = NSVisualEffectMaterialHUDWindow;
    visualEffectView.state = NSVisualEffectStateActive;
    [self.contentView addSubview:visualEffectView];
    visualEffectView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    
    self->_imageView = [ImageView new];
    self.imageView.wantsLayer = YES;
    self.imageView.layer.opacity = 0.5;
    self.imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.imageView.contentTintColor = [NSColor textColor];
    [visualEffectView addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView.centerXAnchor constraintEqualToAnchor:visualEffectView.centerXAnchor].active = YES;
    [self.imageView.centerYAnchor constraintEqualToAnchor:visualEffectView.centerYAnchor constant:-20.0].active = YES;
    [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.heightAnchor].active = YES;
    NSLayoutConstraint *constraint = [self.imageView.widthAnchor constraintEqualToConstant:60.0];
    constraint.priority = NSLayoutPriorityDefaultHigh;
    constraint.active = YES;
    
    self->_titleLabel = [NSTextField labelWithString:@""];
    self.titleLabel.alignment = NSTextAlignmentCenter;
    self.titleLabel.drawsBackground = NO;
    self.titleLabel.bordered = NO;
    self.titleLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleTitle1 options:@{}];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-35.0].active = YES;
}


#pragma mark - Actions
- (void)setTempAlertPosition {
     NSScreen *screen = [NSScreen mainScreen];
    CGRect frame = screen.visibleFrame;
    CGFloat newOriginX = CGRectGetMidX(frame) - (self.frame.size.width / 2.0); // 가로의 중심을 위해.
    CGFloat newOriginY = CGRectGetMinY(frame) + 90.0; // SnippetsLab 앱의 동작 및 위치를 따라했다.
    [self setFrameOrigin:CGPointMake(newOriginX, newOriginY)];
    //
    // CGFloat newOriginY = CGRectGetMaxY(frame) - self.frame.size.height - (CGRectGetHeight(frame) * 0.164);
    // CGFloat newOriginY = (CGRectGetMinY(frame) + (CGRectGetHeight(frame) * 0.837)) - self.frame.size.height;
}

- (void)showAndAutoHide {
    [self setTempAlertPosition];
    // 시작되지 않았다면 취소가 될 것이다.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self mgrFadeDuration:0.3 fadeIn:YES completionHandler:^{}];
    [self performSelector:@selector(hide) withObject:nil afterDelay:1.2];
}

#pragma mark - Private
- (void)hide {
    [self setTempAlertPosition];
    [self mgrFadeDuration:0.15 fadeIn:NO completionHandler:nil];
}

@end
