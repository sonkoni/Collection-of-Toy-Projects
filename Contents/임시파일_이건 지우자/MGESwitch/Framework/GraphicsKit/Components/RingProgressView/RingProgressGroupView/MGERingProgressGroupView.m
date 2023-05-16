//
//  MGERingProgressGroupView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGERingProgressGroupView.h"
#import "MGERingProgressView.h"

@implementation MGERingProgressGroupView

#if TARGET_OS_OSX
- (NSView *)hitTest:(NSPoint)point {
    return nil;
}
#endif

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#if TARGET_OS_IPHONE
- (void)layoutSubviews {
    [super layoutSubviews];
#else
- (void)layout {
    [super layout];
#endif
    self.ringProgressView1.frame = self.bounds;
    self.ringProgressView2.frame = CGRectInset(self.bounds,
                                               self.ringWidth + self.ringSpacing,
                                               self.ringWidth + self.ringSpacing);
    self.ringProgressView3.frame = CGRectInset(self.bounds,
                                               (2 * self.ringWidth) + (2 * self.ringSpacing),
                                               (2 * self.ringWidth) + (2 * self.ringSpacing));
}
    

#pragma mark - 생성 & 소멸
static void CommonInit(MGERingProgressGroupView *self) {
#if TARGET_OS_OSX
    self.wantsLayer = YES;
#endif
    self->_ring1StartColor = [MGEColor redColor];
    self->_ring1EndColor   = [MGEColor blueColor];
    
    self->_ring2StartColor = [MGEColor redColor];
    self->_ring2EndColor   = [MGEColor blueColor];
    
    self->_ring3StartColor = [MGEColor redColor];
    self->_ring3EndColor   = [MGEColor blueColor];
    
    self->_ringWidth   = 20.0;
    self->_ringSpacing = 2.0;
    
    self->_ringProgressView1 = [MGERingProgressView new];
    self->_ringProgressView2 = [MGERingProgressView new];
    self->_ringProgressView3 = [MGERingProgressView new];
    
    [self addSubview:self.ringProgressView1];
    [self addSubview:self.ringProgressView2];
    [self addSubview:self.ringProgressView3];
}
    
    
#pragma mark - 세터 & 게터
- (void)setRing1StartColor:(MGEColor *)ring1StartColor {
    if ([_ring1StartColor isEqual:ring1StartColor] == NO) {
        _ring1StartColor = ring1StartColor;
        _ringProgressView1.startColor = ring1StartColor;
    }
    //
    // CGColor는 CGColorEqualToColor 함수로 비교하면된다.
}
    
- (void)setRing1EndColor:(MGEColor *)ring1EndColor {
    if ([_ring1EndColor isEqual:ring1EndColor] == NO) {
        _ring1EndColor = ring1EndColor;
        _ringProgressView1.endColor = ring1EndColor;
    }
}
    
- (void)setRing2StartColor:(MGEColor *)ring2StartColor {
    if ([_ring2StartColor isEqual:ring2StartColor] == NO) {
        _ring2StartColor = ring2StartColor;
        _ringProgressView2.startColor = ring2StartColor;
    }
}

- (void)setRing2EndColor:(MGEColor *)ring2EndColor {
    if ([_ring2EndColor isEqual:ring2EndColor] == NO) {
        _ring2EndColor = ring2EndColor;
        _ringProgressView2.endColor = ring2EndColor;
    }
}

- (void)setRing3StartColor:(MGEColor *)ring3StartColor {
    if ([_ring3StartColor isEqual:ring3StartColor] == NO) {
        _ring3StartColor = ring3StartColor;
        _ringProgressView3.startColor = ring3StartColor;
    }
}
    
- (void)setRing3EndColor:(MGEColor *)ring3EndColor {
    if ([_ring3EndColor isEqual:ring3EndColor] == NO) {
        _ring3EndColor = ring3EndColor;
        _ringProgressView3.endColor = ring3EndColor;
    }
}
    
- (void)setRingWidth:(CGFloat)ringWidth {
    _ringWidth = ringWidth;
    self.ringProgressView1.ringWidth = ringWidth;
    self.ringProgressView2.ringWidth = ringWidth;
    self.ringProgressView3.ringWidth = ringWidth;
#if TARGET_OS_IPHONE
    [self setNeedsLayout];
#else
    [self setNeedsLayout:YES];
#endif
}
    
- (void)setRingSpacing:(CGFloat)ringSpacing {
    _ringSpacing = ringSpacing;
#if TARGET_OS_IPHONE
    [self setNeedsLayout];
#else
    [self setNeedsLayout:YES];
#endif
}

    
#pragma mark - 컨트롤
- (void)updateWithProgress1:(CGFloat)progress1 progress2:(CGFloat)progress2 progress3:(CGFloat)progress3 {
    [self.ringProgressView1 setProgress:progress1 animated:YES];
    [self.ringProgressView2 setProgress:progress2 animated:YES];
    [self.ringProgressView3 setProgress:progress3 animated:YES];
}

/**
//! 디폴트 스케일 1.f
UIImage * generateAppIcon(CGFloat scale) {
    
    CGSize size = CGSizeMake(512.f, 512.f);
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIView *icon = [[UIView alloc] initWithFrame:rect];
    
    icon.backgroundColor = [MGEColor colorWithRed:0.1176470588f green:0.1176470588f blue:0.1254901961f alpha:1.0f];
    RingProgressGroupView *group = [[RingProgressGroupView alloc] initWithFrame:CGRectInset(icon.bounds, 33.f, 33.f)];
    group.ringWidth = 50.f;
    group.ringSpacing = 10.f;
    group.ring1StartColor = [MGEColor colorWithRed:0.8823529412f green:0.f blue:0.07843137255f alpha:1.0f];
    group.ring1EndColor = [MGEColor colorWithRed:1.f green:0.1960784314f blue:0.5294117647f alpha:1.0f];
    group.ring2StartColor = [MGEColor colorWithRed:0.2156862745f green:0.2156862745f blue:0.862745098f alpha:1.0f];
    group.ring2EndColor = [MGEColor colorWithRed:0.7176470588f green:1.f blue:0.f alpha:1.0f];
    group.ring3StartColor = [MGEColor colorWithRed:0.f green:0.7294117647f blue:0.8823529412f alpha:1.0f];
    group.ring3EndColor = [MGEColor colorWithRed:0.f green:0.9803921569f blue:0.8156862745f alpha:1.0f];
    group.ringProgressView1.progress = 1.0;
    group.ringProgressView2.progress = 1.0;
    group.ringProgressView3.progress = 1.0;
    [icon addSubview:group];
    UIGraphicsBeginImageContextWithOptions(size, true, scale);
    [icon drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
*/
@end
