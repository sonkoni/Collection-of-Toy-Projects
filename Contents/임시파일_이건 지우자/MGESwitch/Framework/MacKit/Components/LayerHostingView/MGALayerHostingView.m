//
//  MGALayerHostingView.m
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import "MGALayerHostingView.h"
#import "NSView+Etc.h"
#import "NSColor+DarkModeSupport.h"

@interface MGALayerHostingView () <CALayerDelegate>
@end

@implementation MGALayerHostingView
@synthesize flipped = _flipped; // 반드시 넣어줘야한다.

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

- (BOOL)isFlipped {
    return _flipped;
}

- (NSView *)hitTest:(NSPoint)point {
    if (self.userInteractionEnabled == NO) {
        return nil;
    }
    return [super hitTest:point];
}

- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    NSAppearance *effectiveAppearance = self.effectiveAppearance; // OR [NSApp effectiveAppearance];
    if (self.mgrBackgroundColor != nil) {
        [effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
            self.layer.backgroundColor = self.mgrBackgroundColor.CGColor;
        }];
    }
    NSAppearanceName aquaORDarkAqua = [effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
    if ([aquaORDarkAqua isEqualToString:NSAppearanceNameAqua] == YES) {
        //! Aqua 이므로 하고 싶은거 해라.
    } else {
        //! Dark Aqua 이므로 하고 싶은거 해라.
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGALayerHostingView *self) {
    CALayer *layer = [CALayer layer];
    layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.layer = layer;
    self.wantsLayer = YES;
    self.layer.delegate = self;
    [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    self->_userInteractionEnabled = YES;
}


#pragma mark - <CALayerDelegate>
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (CGPointEqualToPoint(self.layer.anchorPoint, (CGPoint){0.5, 0.5}) == NO) {
        [self mgrSetAnchorPoint:(CGPoint){0.5, 0.5}];
    }
    
    if (self.initalBlock != nil) {
        self.initalBlock();
        self.initalBlock = nil;
    }
}


#pragma mark - 세터 & 게터
- (void)setMgrBackgroundColor:(NSColor *)mgrBackgroundColor {
    _mgrBackgroundColor = mgrBackgroundColor;
    if (mgrBackgroundColor == nil) {
        self.layer.backgroundColor = nil;
    } else {
        self.layer.backgroundColor = [mgrBackgroundColor mgrEffectiveCGColor:self];
    }
}

@end
