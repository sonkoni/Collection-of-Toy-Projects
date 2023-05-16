//
//  MGAPopUpMenuItemContentView.m
//  NSPopUpButtonCustomizing
//
//  Created by Kwan Hyun Son on 2022/05/13.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAPopUpMenuItemContentView.h"
#import "NSImage+Extension.h"

@interface MGAPopUpMenuItemContentView ()
@property (nonatomic, strong) NSVisualEffectView *highlightView;
@end

@implementation MGAPopUpMenuItemContentView

- (NSSize)sizeThatFits:(NSSize)size {
    return CGSizeMake(NSViewNoIntrinsicMetric, 22.0);
}

- (NSSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(NSRect)rect {
    if ([self enclosingMenuItem].isHighlighted == YES) {
        self.highlightView.hidden = NO;
        self.textLabel.cell.backgroundStyle = NSBackgroundStyleEmphasized;
        self.leftImageView.cell.backgroundStyle = NSBackgroundStyleEmphasized;
        self.rightImageView.cell.backgroundStyle = NSBackgroundStyleEmphasized;
        self.rightImageView2.cell.backgroundStyle = NSBackgroundStyleEmphasized;
//        [[NSColor selectedMenuItemColor] set];
//        [NSBezierPath fillRect:rect];
    } else {
        [super drawRect: rect];
        self.highlightView.hidden = YES;
        self.textLabel.cell.backgroundStyle = NSBackgroundStyleNormal;
        self.leftImageView.cell.backgroundStyle = NSBackgroundStyleNormal;
        self.rightImageView.cell.backgroundStyle = NSBackgroundStyleNormal;
        self.rightImageView2.cell.backgroundStyle = NSBackgroundStyleNormal;
    }
    
    //! 선택한 상태인데 체크이미지가 보이지 않거나 선택하지 않았는데 보인다면 ==> 상태 스위치
    if ((self.selected == YES && self.leftImageView.hidden == YES) ||
        (self.selected == NO && self.leftImageView.hidden == NO)) {
        self.leftImageView.hidden = !self.leftImageView.hidden;
    }
}

- (void)mouseUp:(NSEvent *)event {
    //! dismiss the menu
    NSMenuItem *menuItem = [self enclosingMenuItem];
    NSMenu *menu = menuItem.menu;
    [menu cancelTracking];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGAPopUpMenuItemContentView *self) {
    self->_highlightView = [[NSVisualEffectView alloc] initWithFrame:[self bounds]];
    self.highlightView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    self.highlightView.material = NSVisualEffectMaterialSelection;
    self.highlightView.emphasized = YES;
    self.highlightView.state = NSVisualEffectStateActive; // 디폴트 NSVisualEffectStateFollowsWindowActiveState
    [self addSubview:self.highlightView positioned:NSWindowBelow relativeTo:nil];
    self.highlightView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.highlightView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.highlightView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.highlightView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.highlightView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5.0].active = YES;
    self.highlightView.maskImage = [NSImage mgrMaskWithCornerRadius:4.0];
    self.highlightView.hidden = YES;
        
    self->_textLabel = [NSTextField labelWithString:@"HP-Print-3F-Deskjet 4606 series"];
    [self.textLabel sizeToFit];
    [self addSubview:self.textLabel];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.textLabel.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.safeAreaLayoutGuide.leadingAnchor multiplier:1.2].active = YES; // 수퍼뷰 좌측에서 22.0이다.
    //! 절대 길이는 수퍼뷰에서 22.0, 상하 간격은 없다.
    self.textLabel.textColor = [NSColor controlTextColor];
//    label.font = [NSFont systemFontOfSize:13.0 weight:NSFontWeightRegular]; 디폴트.
    
    self->_leftImageView = [NSImageView new];
    NSImageSymbolConfiguration *config = [NSImageSymbolConfiguration configurationWithTextStyle:NSFontTextStyleHeadline
                                                                                          scale:NSImageSymbolScaleSmall];
    NSImage *image = [NSImage mgrSystemSymbolName:@"checkmark"
                         accessibilityDescription:@"checkmark 에 대한 시스템 이미지. mac 11.0"
                                withConfiguration:config];
    self.leftImageView.image = image;
    [self.leftImageView sizeToFit];
    [self addSubview:self.leftImageView];
    self.leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5.0].active = YES;
    [self.leftImageView.trailingAnchor constraintEqualToAnchor:self.textLabel.leadingAnchor constant:0.0].active = YES;
    [self.leftImageView.firstBaselineAnchor constraintEqualToAnchor:self.textLabel.firstBaselineAnchor].active = YES;
    [self.leftImageView.lastBaselineAnchor constraintEqualToAnchor:self.textLabel.lastBaselineAnchor].active = YES;
    
    
    config = [NSImageSymbolConfiguration configurationWithTextStyle:NSFontTextStyleHeadline
                                                              scale:NSImageSymbolScaleMedium];
    self->_rightImageView = [NSImageView new];
    self.rightImageView.image = [NSImage mgrSystemSymbolName:@"wifi"
                                    accessibilityDescription:@"wifi 에 대한 시스템 이미지. mac 11.0"
                                           withConfiguration:config];
    [self.rightImageView sizeToFit];
    [self addSubview:self.rightImageView];
    self.rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14.0].active = YES;
    [self.rightImageView.firstBaselineAnchor constraintEqualToAnchor:self.textLabel.firstBaselineAnchor].active = YES;
    [self.rightImageView.lastBaselineAnchor constraintEqualToAnchor:self.textLabel.lastBaselineAnchor].active = YES;
    
    self->_rightImageView2 = [NSImageView new];
    self.rightImageView2.image = [NSImage mgrSystemSymbolName:@"lock.fill"
                                    accessibilityDescription:@"lock.fill 에 대한 시스템 이미지. mac 11.0"
                                           withConfiguration:config];
    [self.rightImageView2 sizeToFit];
    [self addSubview:self.rightImageView2];
    self.rightImageView2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightImageView2.trailingAnchor constraintEqualToAnchor:self.rightImageView.leadingAnchor constant:-14.0].active = YES;
    [self.rightImageView2.firstBaselineAnchor constraintEqualToAnchor:self.textLabel.firstBaselineAnchor].active = YES;
    [self.rightImageView2.lastBaselineAnchor constraintEqualToAnchor:self.textLabel.lastBaselineAnchor].active = YES;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected == YES && self.leftImageView.hidden == YES) { // selected == YES 이므로 보여줘야하는 상황
        self.leftImageView.hidden = NO;
    } else if (selected == NO && self.leftImageView.hidden == NO) { // selected == NO 이므로 감춰야하는 상황
        self.leftImageView.hidden = YES;
    }
}

@end
