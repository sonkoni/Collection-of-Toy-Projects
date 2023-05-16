//
//  MGADNSwitch.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@import BaseKit;
@import GraphicsKit;
#import "MGADNSwitch.h"
#import "NSImage+Extension.h"
#import "NSHapticFeedbackManager+Extension.h"
#import "NSBezierPath+Extension.h"


NSNotificationName const MGADNSwitchStateChangedNotification = @"MGADNSwitchStateChangedNotification";

@interface MGADNSwitch ()
@property (nonatomic, assign) CGSize previousSize;
@property (nonatomic, assign) BOOL startSwitchState;        // 터치가 시작될 때, 스위치의 ON OFF 상태
@property (nonatomic, assign) BOOL didChangeWhileTracking;  // 터치가 종료될때까지 한번이라도 최초 상태를 벗어나는 움직임이 존재했는가를 의미한다.

@property (nonatomic, assign) NSTimeInterval animationDuration; // 디폴트 0.4
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, strong) CALayer *borderContainerLayer; // <- 보더를 위해 존재한다.
@property (nonatomic, strong) CAShapeLayer *onBorderLayer; // <- 보더를 위해 존재한다.
@property (nonatomic, strong) CAShapeLayer *offBorderLayer; // <- 보더를 위해 존재한다.
@property (nonatomic, strong) CALayer *knobLayer;
@property (nonatomic, strong) CALayer *circularSublayer;
@property (nonatomic, strong) NSArray <CALayer *>*craters;
@property (nonatomic, strong) CALayer *cloudImageLayer;

//! OFF 상태의 배경에 작은 흰색 점들로 별을 표현할 것이다. 이 점에 해당하는 CALayer들의 배열이다.
@property (nonatomic, strong) NSArray <CALayer *>*stars;

//! 코드는 configuration을 통해 설정을한다.
@property (nonatomic, strong, nullable) MGADNSwitchConfiguration *configuration;

@property (nonatomic, assign, readonly) CGFloat knobLayerMargin; // @dynamic
@property (nonatomic, assign, readonly) CGFloat circularLayerMargin; // @dynamic knobLayer 내부에 들어있는 큰 완전 원형의 layer와의 거리

@property (nonatomic, strong) NSTrackingArea *cursorTrackingArea;
@end


#pragma mark - MGADNSwitch
@implementation MGADNSwitch
@dynamic knobLayerMargin;
@dynamic circularLayerMargin;

#if TARGET_INTERFACE_BUILDER // 인터페이스 빌더로 확인만 하는 용. runtime에서 실행되지 않는다.
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self invalidateIntrinsicContentSize];
    
    self.wantsLayer = YES;
    self.layer = [CALayer layer];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    NSTextField *label = [NSTextField labelWithString:@"Switch"];
    label.font = [NSFont labelFontOfSize:8.0];
    label.alignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}
#endif

#pragma mark -- OVERRIDE NSVIEW
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        //! 디폴트 값
        _handCursorType = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _previousSize = self.frame.size;
    if (CGSizeEqualToSize(_previousSize, CGSizeZero) == NO) {
        CommonInit(self);
    }
}

- (NSSize)sizeThatFits:(NSSize)size {
    CGFloat height = 30.0;
    CGFloat width  = height * 1.75;
    return CGSizeMake(ceil(width), ceil(height));
}

- (NSSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    if (CGSizeEqualToSize(newSize, CGSizeZero) == NO && CGSizeEqualToSize(newSize, self.previousSize) == NO) {
        _previousSize = self.frame.size;
        CommonInit(self);
    }
}

- (void)drawFocusRingMask { // 포커스 링의 바운더리를 잡아준다.
    CGFloat cornerRadius = self.bounds.size.height / 2.0;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:cornerRadius yRadius:cornerRadius];
    [[NSColor blackColor] set];
    [path fill];
}

- (NSRect)focusRingMaskBounds {
    return [self bounds];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return [NSApp isFullKeyboardAccessEnabled];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
//    [self reloadLayer];
}

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
//     스위치가 퍼스트 리스폰더이면 스페이스로 움직이겠다.
    if (self.window.firstResponder == self) {
        NSInteger ch = [theEvent keyCode];
        if (ch == 49) { // Space
            [self setSwitchOn:!self.switchOn withAnimated:YES];
            [self invokeTargetAction];
            return YES;
        }
    }
    return NO;
}

- (void)resetCursorRects { // 기본 구현은 아무것도 수행하지 않는다. so super를 호출할 필요가 없다.
    if (self.isHandCursorType == YES && self.isEnabled == YES) {
        [self addCursorRect:self.bounds cursor:[NSCursor pointingHandCursor]];
    }
    //
    // 특정 뷰의 커서는 이렇게 설정하는 것이 맞다. 이전에는 NSTrackingArea 설정하고나서 - mouseEntered: - mouseExited:에서
    // 설정했었는데, 이 버튼으로 아쿠아 모드, 다크 아쿠아 모드 토글 시에 풀려 버리는 일이 발생했다. 현재 area에 설정을 원한다면
    // - resetCursorRects 메서드를 사용하는 것이 옳다.
    // 예전의 코드는 다음과 같다.
//    - (void)mouseEntered:(NSEvent *)theEvent{
//        //! super를 부르지 않아야 흐를 수 있다. - addTrackingArea: 해야 들어온다.
//        if (self.isHandCursorType == YES && [self isEnabled] == YES) {
//            NSCursor *cursor = [NSCursor pointingHandCursor];
//            [cursor set];
//        }
//    }
//    - (void)mouseExited:(NSEvent *)theEvent{
//        //! super를 부르지 않아야 흐를 수 있다. - addTrackingArea: 해야 들어온다.
//        NSCursor *cursor = [NSCursor arrowCursor];
//        [cursor set];
//    }
}


#pragma mark -- OVERRIDE - NSResponder - Responding to Mouse Events
- (BOOL)acceptsFirstResponder {
    return [NSApp isFullKeyboardAccessEnabled];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled == YES) {
        [self knobExpand:YES];
        self.startSwitchState = self.switchOn;
        self.didChangeWhileTracking = NO;
        if (self.switchOn == NO) {
//            [self decoLayerAnimationForExand:NO];
        }
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (self.isEnabled == YES) {
        CGFloat x = [self convertPoint:[theEvent locationInWindow] fromView:nil].x;
        if ( (x > self.frame.size.width / 2) && (self.switchOn == NO) ) {          // off 상태인데 on  상태 영역을 넘어갔다면
            self.switchOn = YES;
            self.didChangeWhileTracking = YES; // <- 터치가 시작되고 처음 state에서 움직였는지 체크한다.
            [NSHapticFeedbackManager mgrPerformFeedbackPattern:NSHapticFeedbackPatternGeneric
                                               performanceTime:NSHapticFeedbackPerformanceTimeNow];
        } else if ( (x < self.frame.size.width / 2) && (self.switchOn == YES) ) {  // on  상태인데 off 상태 영역을 넘어갔다면
            self.switchOn = NO;
            self.didChangeWhileTracking = YES; // <- 터치가 시작되고 처음 state에서 움직였는지 체크한다.
            [NSHapticFeedbackManager mgrPerformFeedbackPattern:NSHapticFeedbackPatternGeneric
                                               performanceTime:NSHapticFeedbackPerformanceTimeNow];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.isEnabled == YES) {
        if (self.didChangeWhileTracking == NO) {
            self.switchOn = !self.switchOn;
            [self invokeTargetAction];
            [NSHapticFeedbackManager mgrPerformFeedbackPattern:NSHapticFeedbackPatternGeneric
                                               performanceTime:NSHapticFeedbackPerformanceTimeNow];
        } else if (self.switchOn != self.startSwitchState) {
            [self invokeTargetAction];
        }
        
        [self knobExpand:NO];  // <- setExpand: 메서드에 의해 expandKnobView: 가 호출된다.
        self.didChangeWhileTracking = NO; // <- 다시 재설정한다.
        
        if (self.switchOn == NO) {
//            [self decoLayerAnimationForExand:YES];
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent{
    //! super를 부르지 않아야 흐를 수 있다. - addTrackingArea: 해야 들어온다.
    if (self.mouseHoverConditionalBlock != nil) {
        self.mouseHoverConditionalBlock(YES);
    }
    // 예전에 커서 세팅했던 코드. 적절하지 않다. - resetCursorRects 메서드에서 설정했다.
//    if (self.isHandCursorType == YES && [self isEnabled] == YES) {
//        NSCursor *cursor = [NSCursor pointingHandCursor];
//        [cursor set];
//    }
}

- (void)mouseExited:(NSEvent *)theEvent{
    //! super를 부르지 않아야 흐를 수 있다. - addTrackingArea: 해야 들어온다.
    if (self.mouseHoverConditionalBlock != nil) {
        self.mouseHoverConditionalBlock(NO);
    }
    // 예전에 커서 세팅했던 코드. 적절하지 않다. - resetCursorRects 메서드에서 설정했다.
//    NSCursor *cursor = [NSCursor arrowCursor];
//    [cursor set];
}


#pragma mark -- OVERRIDE <NSStandardKeyBindingResponding>
- (void)moveLeft:(id)sender { // 좌측 화살표. 퍼스트리스폰더일 때만 작동함.
    if (self.switchOn == YES) {
        [self setSwitchOn:NO withAnimated:YES];
        [self invokeTargetAction];
    }
}

- (void)moveRight:(id)sender { // 우측 화살표. 퍼스트리스폰더일 때만 작동함.
    if (self.switchOn == NO) {
        [self setSwitchOn:YES withAnimated:YES];
        [self invokeTargetAction];
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(NSRect)frameRect
                     switchOn:(BOOL)switchOn
                configuration:(MGADNSwitchConfiguration *)configuration {
    self = [super initWithFrame:frameRect];
    if (self) {
        _handCursorType = YES;
        _switchOn = switchOn;
        _previousSize = frameRect.size;
        //! 코드로 초기화하는 것은 _configuration을 갖는다.
        _configuration = (configuration != nil)? configuration : [MGADNSwitchConfiguration defaultConfiguration];
        [_configuration apply:self];
        if (CGSizeEqualToSize(_previousSize, CGSizeZero) == NO) {
            CommonInit(self);
        }
    }
    return self;
}

static void CommonInit(MGADNSwitch *self) {
    for (CALayer *layer in self.layer.sublayers.reverseObjectEnumerator) {
        [layer removeFromSuperlayer];
        [layer removeAllAnimations];
    }
    
    self->_animationDuration = 0.3;
    
    if (self.configuration == nil) { // xib로 초기화했다면, xib로 설정한것 빼고는 디폴트 값으로 설정하라.
        MGADNSwitchConfiguration *configuration = [MGADNSwitchConfiguration defaultConfiguration];
        [configuration applyWithNIB:self];
    }
    
    // The Switch is enabled per default
    self.enabled = YES;
    
    // Root layer
    self.layer = [CALayer layer]; // self.layer.delegate = self;
    self.wantsLayer = YES;
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [NSScreen mainScreen].backingScaleFactor;
//    self.layer.allowsEdgeAntialiasing = YES;
    self.layer.masksToBounds = NO; // Allow shadow to flow over bounds of the layer

    // Background layer
    self->_backgroundLayer = [CALayer layer];
    self.backgroundLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
//    self.backgroundLayer.shouldRasterize = YES;
//    self.backgroundLayer.rasterizationScale = [NSScreen mainScreen].backingScaleFactor;
//    self.backgroundLayer.allowsEdgeAntialiasing = YES;
    self.backgroundLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.backgroundLayer.frame = self.layer.bounds;
    self.backgroundLayer.masksToBounds = NO;
    [self.layer addSublayer:self.backgroundLayer];
    
    // Border Layer
    self->_borderContainerLayer = [CALayer layer];
    self->_onBorderLayer = [CAShapeLayer layer];
    self->_offBorderLayer = [CAShapeLayer layer];
    self.borderContainerLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.onBorderLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.offBorderLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
//    self.borderContainerLayer.shouldRasterize = YES;
//    self.onBorderLayer.shouldRasterize = YES;
//    self.offBorderLayer.shouldRasterize = YES;
//    self.borderContainerLayer.rasterizationScale = [NSScreen mainScreen].backingScaleFactor;
//    self.onBorderLayer.rasterizationScale = [NSScreen mainScreen].backingScaleFactor;
//    self.offBorderLayer.rasterizationScale = [NSScreen mainScreen].backingScaleFactor;
//    self.borderContainerLayer.allowsEdgeAntialiasing = YES;
//    self.onBorderLayer.allowsEdgeAntialiasing = YES;
//    self.offBorderLayer.allowsEdgeAntialiasing = YES;
    self.borderContainerLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.borderContainerLayer.frame = self.layer.bounds;
//    self.borderContainerLayer.frame = CGRectIntegral(self.layer.bounds);
    self.borderContainerLayer.masksToBounds = YES;
    self.borderContainerLayer.cornerRadius = self.layer.bounds.size.height / 2.0;
    [self.layer addSublayer:self.borderContainerLayer];
    self.onBorderLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.onBorderLayer.frame = self.borderContainerLayer.bounds;
    self.offBorderLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.offBorderLayer.frame = self.borderContainerLayer.bounds;
    [self.borderContainerLayer addSublayer:self.onBorderLayer];
    [self.borderContainerLayer addSublayer:self.offBorderLayer];
    self.onBorderLayer.fillColor = [NSColor clearColor].CGColor;
    self.offBorderLayer.fillColor = [NSColor clearColor].CGColor;
    
    CGFloat borderWidth = self.frame.size.height / 7.0;
    NSBezierPath *path = [self pathForRightStartRoundRect:self.layer.bounds]; // <- 애니메이션을 안주므로 아무거나 넣어도 된다.
    CGPathRef quartzPath = [path newMgrCGPath];
    self.onBorderLayer.path = quartzPath;
    CGPathRelease(quartzPath); // 반드시 수동 릴리즈 해야한다.
    
    self.onBorderLayer.strokeColor = self.onBorderColor.CGColor;
    self.onBorderLayer.lineWidth   = borderWidth;
    self.offBorderLayer.strokeColor = self.offBorderColor.CGColor;
    self.offBorderLayer.lineWidth   = borderWidth;
//
    if (self.switchOn == NO) {
        NSBezierPath *path = [self pathForLeftStartRoundRect:self.layer.bounds];
        CGPathRef quartzPath = [path newMgrCGPath];
        self.offBorderLayer.path = quartzPath;
        CGPathRelease(quartzPath); // 반드시 수동 릴리즈 해야한다.
    } else {
        self.offBorderLayer.strokeStart = 1.0;
        NSBezierPath *path = [self pathForRightStartRoundRect:self.layer.bounds];
        CGPathRef quartzPath = [path newMgrCGPath];
        self.offBorderLayer.path = quartzPath;
        CGPathRelease(quartzPath); // 반드시 수동 릴리즈 해야한다.
    }
    
    // Star Layers
    // shortcuts
    CGFloat w = self.layer.bounds.size.width;
    CGFloat h = self.layer.bounds.size.height;
    CGFloat x = h * 0.05; // 높이의 5%
    CALayer *s1 = [CALayer layer];
    CALayer *s2 = [CALayer layer];
    CALayer *s3 = [CALayer layer];
    CALayer *s4 = [CALayer layer];
    CALayer *s5 = [CALayer layer];
    CALayer *s6 = [CALayer layer];
    CALayer *s7 = [CALayer layer];
    s1.frame = CGRectMake(w * 0.50, h - (h * 0.16 + x), x, x);
    s2.frame = CGRectMake(w * 0.62, h - (h * 0.33 + x * 0.6), x * 0.6, x * 0.6);
    s3.frame = CGRectMake(w * 0.70, h - (h * 0.15 + x), x, x);
    s4.frame = CGRectMake(w * 0.83, h - (h * 0.39 + x * 1.4), x * 1.4, x * 1.4);
    s5.frame = CGRectMake(w * 0.70, h - (h * 0.54 + x * 0.8), x * 0.8, x * 0.8);
    s6.frame = CGRectMake(w * 0.52, h - (h * 0.73 + x * 1.3), x * 1.3, x * 1.3);
    s7.frame = CGRectMake(w * 0.82, h - (h * 0.66 + x * 1.1), x * 1.1, x * 1.1);
    self->_stars = @[s1, s2, s3, s4, s5, s6, s7];
    for (CALayer *star in self.stars) {
        star.masksToBounds = YES;
        star.cornerRadius  = star.frame.size.height / 2.0;
        star.backgroundColor = [NSColor whiteColor].CGColor;
        [self.layer addSublayer:star];
        if (self.switchOn == YES) {
            star.opacity = 0.0;
        }
    }
    
    // Knob layer
    self->_knobLayer = [CALayer layer];
    self.knobLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.knobLayer.autoresizingMask = kCALayerHeightSizable;
    self.knobLayer.backgroundColor = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0].CGColor;
//    self.knobLayer.shadowColor = [[NSColor blackColor] CGColor];
//    self.knobLayer.shadowOffset = CGSizeMake(0.0, -2.0); // -6.5
//    self.knobLayer.shadowRadius = 1.0; // 2.5
//    self.knobLayer.shadowOpacity = 0.3; // 0.15
    [self.layer addSublayer:self.knobLayer];
    self->_circularSublayer = [CALayer layer];
    self.circularSublayer.masksToBounds = YES;
    [self.knobLayer addSublayer:self.circularSublayer];
    
    // Cloud imageLayer
    self->_cloudImageLayer = [CALayer layer];
    [self.layer addSublayer:self.cloudImageLayer];
    self.cloudImageLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.cloudImageLayer.contentsGravity = kCAGravityResizeAspect;
    self.cloudImageLayer.contents = [NSImage mgrImageNamed:@"MGUDNSwitchCloud" bundle:[NSBundle mgrMacRes]];
    CGSize size = CGSizeMake(self.layer.bounds.size.width / 3.0, self.layer.bounds.size.width * 0.23);
    CGPoint origin = CGPointMake(self.layer.bounds.size.width / 3.0,
                                 (self.layer.bounds.size.height - (self.frame.size.height * 0.4) - size.height));
    self.cloudImageLayer.frame = (CGRect){(CGPoint)origin, (CGSize)size};
    if (self.switchOn == NO) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.cloudImageLayer.transform = CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 1.0);  //! 최초가 OFF 상태이면 안보이게 하기 위해서
        [CATransaction commit];
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backgroundLayer.cornerRadius = self.backgroundLayer.bounds.size.height / 2.0;
    self.knobLayer.frame = [self knobLayerFrameForONState:self.switchOn];
    self.knobLayer.cornerRadius = self.knobLayer.bounds.size.height / 2.0;

    self.circularSublayer.frame = CGRectMake(self.circularLayerMargin,
                                             self.circularLayerMargin,
                                             self.knobLayer.frame.size.height - self.circularLayerMargin*2.0,
                                             self.knobLayer.frame.size.height - self.circularLayerMargin*2.0);
    self.circularSublayer.cornerRadius = self.circularSublayer.bounds.size.height / 2.0;
    if (self.switchOn == YES) {
        self.backgroundLayer.backgroundColor = self.onTintColor.CGColor;
        self.knobLayer.backgroundColor = self.onThumbTintColor.CGColor;
        self.circularSublayer.backgroundColor = self.onSubThumbColor.CGColor;
        self.circularSublayer.transform = CATransform3DMakeRotation(M_PI * -0.5, 0.0, 0.0, 1.0);
    } else {
        self.backgroundLayer.backgroundColor = self.offTintColor.CGColor;
        self.knobLayer.backgroundColor = self.offThumbTintColor.CGColor;
        self.circularSublayer.backgroundColor = self.offSubThumbColor.CGColor;
    }
    
    // setupCraters
    w = self.knobLayer.frame.size.width;
    h = self.knobLayer.frame.size.height;
    CALayer *topLeft = [CALayer layer];
    CALayer *topRight = [CALayer layer];
    CALayer *bottom = [CALayer layer];
    
    CGFloat superHeight = self.circularSublayer.frame.size.height;
    CGRect topLeftFrame = ConvertMacRectFromiOSRect(CGRectMake(0.0, h * 0.1, w * 0.2, w * 0.2), superHeight);
    CGRect topRightFrame = ConvertMacRectFromiOSRect(CGRectMake(w * 0.5, 0.0, w * 0.3,  w * 0.3), superHeight);
    CGRect bottomFrame = ConvertMacRectFromiOSRect(CGRectMake(w * 0.4, h * 0.5, w * 0.25, w * 0.25), superHeight);
    topLeft.frame = topLeftFrame;
    topRight.frame = topRightFrame;
    bottom.frame = bottomFrame;
    self->_craters = @[topLeft, topRight, bottom];
    for (CALayer *crater in self.craters) {
        crater.masksToBounds = YES;
        crater.cornerRadius  = crater.frame.size.height / 2.0;
        [self.circularSublayer addSublayer:crater];
        crater.backgroundColor = self.offSubThumbColor.CGColor;
        crater.borderColor   = self.offThumbTintColor.CGColor;
        crater.borderWidth   = self.circularLayerMargin;
        if (self.switchOn == YES) {
            crater.opacity = 0.0;
        }
    }
    [CATransaction commit];
    
    if(self->_cursorTrackingArea != nil) { // [self.trackingAreas containsObject:self.cursorTrackingArea] 필요할것 같기도하고...
        [self removeTrackingArea:self.cursorTrackingArea];
    }
    
    //! Api:AppKit/NSTrackingArea 참고. 자세히 정리했다.
    //! XUISwitch 에서 영감을 받아서 알고리즘을 구현했다.
    //! NSFontCatalog (Archon->ObjcSubject->NSFontCatalog) 참고
    //! https://stackoverflow.com/questions/29911989/cocoa-nsview-change-cursor <- 약간 잘못나온듯.
    NSTrackingAreaOptions options =
        NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect;
    self->_cursorTrackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:self.cursorTrackingArea];
}


#pragma mark - 세터 & 게터
//- (void)setChecked:(BOOL)checked {
//    if (_checked != checked) {
//		_checked = checked;
//        [self propagateValue:@(checked) forBinding:@"checked"];
//    }
//
//    [self reloadLayer];
//}

- (void)setSwitchOn:(BOOL)switchOn {
    if (_switchOn != switchOn ) {
        _switchOn = switchOn;
        [self moveSwitchToOn:switchOn];
    }
}

- (CGFloat)knobLayerMargin {
    return self.frame.size.height / 10.0;
}

- (CGFloat)circularLayerMargin {
    return self.knobLayer.bounds.size.height / 12.0;
}


#pragma mark - Action
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated {
    if (self.switchOn != switchOn) {
        if (animated == YES) {
            [self setSwitchOn:switchOn];
//            [self decoLayerAnimationForExand:!switchOn];
        } else {
            _switchOn = switchOn;
            CommonInit(self);
        }
    }
}

//! - setSwitchOn: 에서만 호출된다.
- (void)moveSwitchToOn:(BOOL)switchToOn {
    if (switchToOn == YES) {
        NSBezierPath *path = [self pathForLeftStartRoundRect:self.frame];
        CGPathRef quartzPath = [path newMgrCGPath];
        self.offBorderLayer.path = quartzPath;
        CGPathRelease(quartzPath); // 반드시 수동 릴리즈 해야한다.
        self.offBorderLayer.strokeStart = 0.0;
    } else {
        NSBezierPath *path = [self pathForRightStartRoundRect:self.frame];
        CGPathRef quartzPath = [path newMgrCGPath];
        self.offBorderLayer.path = quartzPath;
        CGPathRelease(quartzPath); // 반드시 수동 릴리즈 해야한다.
        self.offBorderLayer.strokeStart = 1.0;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    CGFloat knobRadius = self.knobLayer.frame.size.width / 2.0;
    if (switchToOn == YES) {
        self.backgroundLayer.backgroundColor = self.onTintColor.CGColor;
        self.knobLayer.backgroundColor = self.onThumbTintColor.CGColor;
        self.knobLayer.position = CGPointMake(self.frame.size.width -knobRadius - self.knobLayerMargin, self.knobLayer.position.y);
        self.circularSublayer.backgroundColor = self.onSubThumbColor.CGColor;
        self.offBorderLayer.strokeStart = 1.0;
        self.circularSublayer.position = CGPointMake(self.knobLayer.frame.size.width - self.knobLayer.frame.size.height / 2.0, self.circularSublayer.position.y);
        self.circularSublayer.transform = CATransform3DMakeRotation(M_PI * -0.5, 0.0, 0.0, 1.0);
        for (CALayer *crater in self.craters) {
            crater.opacity = 0.0;
        }
    } else {
        self.backgroundLayer.backgroundColor = self.offTintColor.CGColor;
        self.knobLayer.backgroundColor = self.offThumbTintColor.CGColor;
        self.knobLayer.position = CGPointMake(knobRadius + self.knobLayerMargin, self.knobLayer.position.y);
        self.circularSublayer.backgroundColor = self.offSubThumbColor.CGColor;
        self.circularSublayer.position = CGPointMake(self.knobLayer.frame.size.height / 2.0, self.circularSublayer.position.y);
        self.offBorderLayer.strokeStart = 0.0;
        self.circularSublayer.transform = CATransform3DIdentity;
        for (CALayer *crater in self.craters) {
            crater.opacity = 1.0;
        }
    }
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.4];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithCustomName:MGRMediaTimingFunctionEaseOutBack]];
    for (int i = 0; i < self.stars.count; i++) {
        if (switchToOn == YES) {
            self.stars[i].opacity = 0.0;
        } else {
            self.stars[i].opacity = 1.0;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.stars[i].transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.stars[i].transform = CATransform3DIdentity;
            });
        });
    }
    [CATransaction commit];
    
    //! 구름 나오는 부분을 약간 탄력을 줘보자.
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    if (switchToOn == YES) {
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithCustomName:MGRMediaTimingFunctionEaseOutBack];
        [CATransaction setAnimationTimingFunction:timingFunction];
        self.cloudImageLayer.transform = CATransform3DIdentity;
    } else {
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [CATransaction setAnimationTimingFunction:timingFunction];
        self.cloudImageLayer.transform = CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 1.0);
    }
    [CATransaction commit];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MGADNSwitchStateChangedNotification
                                                        object:self  // poster(보내는 놈)
                                                      userInfo:nil];
}

- (void)knobExpand:(BOOL)expand {
    //! width를 height로 잡은 know how에 주목하자. 가로 세로가 동일한 원에서 시작하지만, 터치에 따라서 width 가 변신해야한다.
    //! 즉, height는 그대로이므로 height를 이용하여, width 값을 조정해주면, 추가적인 변수를 만들지 않아도 된다.
    CGFloat newWidth;
    if (expand == YES) { //! <- 시작 시
        newWidth = self.knobLayer.frame.size.height * 1.25;
    } else {                    //! <- 종료 시
        newWidth = self.knobLayer.frame.size.height;
    }

    CGFloat newOriginX;
    //! 스위치는 ON일때 손잡이가 오른쪽에 있다.
    if (self.switchOn == YES) { //! 오른쪽 일때 : 시작 또는 종료 시 오른쪽일 경우
        newOriginX = self.frame.size.width - newWidth - self.knobLayerMargin;
    } else { //! 왼쪽 일때 : 시작 또는 종료 시 왼쪽일 경우
        newOriginX = self.knobLayer.frame.origin.x; // <- 수퍼뷰의 무빙에 의해 전혀 문제가 생기지 않는다.
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    self.knobLayer.frame = CGRectMake(newOriginX, self.knobLayer.frame.origin.y, newWidth, self.knobLayer.frame.size.height);
    
    /// 2. circularSubLayer의 센터이동. 움직이지 않는 것처럼 보이기 위한 변화이다.
    if (self.switchOn == YES) {
        self.circularSublayer.position = CGPointMake(self.knobLayer.frame.size.width - self.knobLayer.frame.size.height / 2.0, self.circularSublayer.position.y);
    } else {
        self.circularSublayer.position = CGPointMake(self.knobLayer.frame.size.height / 2.0, self.circularSublayer.position.y);
    }
    
    [CATransaction commit];
}

//! Target Action을 보낸다.
- (void)invokeTargetAction {
    if (self.action != NULL) {
        BOOL success = [NSApp sendAction:self.action to:self.target from:self];
#if DEBUG
        if (success == YES) {
            NSLog(@"액션 보내기 성공");
        } else {
            NSLog(@"액션 보내기 실패");
        }
#endif
    }
}


#pragma mark - Helper
- (CGRect)knobLayerFrameForONState:(BOOL)oNState {
    CGFloat w = self.frame.size.height - (2.0 * self.knobLayerMargin);
    if (oNState == YES) {
        return CGRectMake(self.frame.size.width - w - self.knobLayerMargin, self.knobLayerMargin, w, w);
    } else {
        return  CGRectMake(self.knobLayerMargin, self.knobLayerMargin, w, w);
    }
}

//! border 애니메이션을 위해서는 start point가 각각 달라야한다.
- (NSBezierPath *)pathForLeftStartRoundRect:(CGRect)rect {
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat radius = rect.size.height / 2.0;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, radius)];
    
    [path appendBezierPathWithArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:180.0 endAngle:90.0 clockwise:YES];
    [path lineToPoint:CGPointMake(width - radius, height)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(width - radius, radius) radius:radius startAngle:90.0 endAngle:270.0 clockwise:YES];
    [path lineToPoint:CGPointMake(radius, 0.0)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(radius, height - radius) radius:radius startAngle:270.0 endAngle:180.0 clockwise:YES];
    // 만약, CGPath로 쌩으로 만드는 것을 확인하고 싶다면, ObjSubject - BorderRadiusShadow 프로젝트를 확인하라.
    //! 좌측에서 시작하여 시계방향으로 도는 path이다.
    return path;
}

- (NSBezierPath *)pathForRightStartRoundRect:(CGRect)rect {
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat radius = rect.size.height / 2.0;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width, radius)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(width - radius, height - radius) radius:radius startAngle:0.0 endAngle:270.0 clockwise:YES];
    [path lineToPoint:CGPointMake(radius, 0.0)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(radius, height - radius) radius:radius startAngle:270.0 endAngle:90.0 clockwise:YES];
    [path lineToPoint:CGPointMake(width - radius, height)];
    [path appendBezierPathWithArcWithCenter:CGPointMake(width - radius, height - radius) radius:radius startAngle:90.0 endAngle:0.0 clockwise:YES];
    /// 만약, CGPath로 쌩으로 만드는 것을 확인하고 싶다면, ObjSubject - BorderRadiusShadow 프로젝트를 확인하라.
    
    //! 감춰진 상태에서 시계방향으로 보여줄려고한다. start Point로만 조작하려고 한다.(애니메이션에서 startStoke endStorke 둘다 쓰는 것은 번거롭다.)
    //! 우측에서 반시계방향으로 돌아 만들어진 path이다. (왜냐하면 다음줄에서 reverse하므로.)
    return [path bezierPathByReversingPath];
}

//! iOS의 frame을 MacOS의 frame으로 바꿔준다.
CGRect ConvertMacRectFromiOSRect(CGRect iOSRect, CGFloat superHeight) {
    CGRect macRect = iOSRect;
    macRect.origin.y = superHeight - (iOSRect.origin.y + iOSRect.size.height);
    return macRect;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithFrame:(NSRect)frameRect { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }


#pragma mark --- Bindings Extension : 선택 사항인듯. Tom Dalling 이라는 사람이 바인딩 편하게 하려고 만든듯. view 변화 -> 모델갱신을 가능하게 하기 위해?
// https://stackoverflow.com/questions/1169097/can-you-manually-implement-cocoa-bindings
// http://tomdalling.com/blog/cocoa/implementing-your-own-cocoa-bindings/
- (void)propagateValue:(id)value forBinding:(NSBindingName)binding {
    NSParameterAssert(binding != nil); // binding 이 nil 이이면 경고!
    
    // WARNING: bindingInfo contains NSNull, so it must be accounted for
    NSDictionary <NSBindingInfoKey, id>*bindingInfo = [self infoForBinding:binding];
    if(bindingInfo == nil) { // 뭔지는 잘 모르겠는데, bindingInfo == nil로 들어온다. 잘 모르겠다. 등록하면 달라지는 듯.
        return; // there is no binding
    }
    
    // apply the value transformer, if one has been set
    NSDictionary *bindingOptions = bindingInfo[NSOptionsKey];
    if(bindingOptions != nil) {
        NSValueTransformer *transformer = bindingOptions[NSValueTransformerBindingOption];
        if(transformer == nil || (id)transformer == [NSNull null]) {
            NSString *transformerName = bindingOptions[NSValueTransformerNameBindingOption];
            if(transformerName && (id)transformerName != [NSNull null]){
                transformer = [NSValueTransformer valueTransformerForName:transformerName];
            }
        }
        
        if(transformer != nil && (id)transformer != [NSNull null]){
            if([[transformer class] allowsReverseTransformation]){
                value = [transformer reverseTransformedValue:value];
            } else {
                NSLog(@"WARNING: binding \"%@\" has value transformer, but it doesn't allow reverse transformations in %s", binding, __PRETTY_FUNCTION__);
            }
        }
    }
    
    id boundObject = bindingInfo[NSObservedObjectKey];
    if(boundObject == nil || boundObject == [NSNull null]) {
        NSLog(@"ERROR: NSObservedObjectKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
        return;
    }
    
    NSString *boundKeyPath = bindingInfo[NSObservedKeyPathKey];
    if(boundKeyPath == nil || (id)boundKeyPath == [NSNull null]) {
        NSLog(@"ERROR: NSObservedKeyPathKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
        return;
    }
    
    [boundObject setValue:value forKeyPath:boundKeyPath];
}

#pragma mark - <NSAccessibility> & NSObject (NSAccessibility) 관련. NSAccessibility 카테고리에서 대부분 폐기되고 <NSAccessibility>로 넘어갔는데, 뭐로 바꿔야할지 모르겠다.
//! https://bugs.chromium.org/p/chromium/issues/detail?id=386671
#pragma mark --- <NSAccessibility>
- (BOOL)isAccessibilityElement { // - (BOOL)accessibilityIsIgnored API_DEPRECATED("Use isAccessibilityElement instead", macos(10.1,10.10));
    [super isAccessibilityElement];
    return NO;
}

#pragma mark --- @interface NSObject (NSAccessibility)
- (id)accessibilityHitTest:(NSPoint)point {
	return self;
}

/**
- (NSArray <NSAccessibilityAttributeName>*)accessibilityAttributeNames {
	static NSArray *attributes = nil;
	if (attributes == nil)
	{
		NSMutableArray *mutableAttributes = [[super accessibilityAttributeNames] mutableCopy];
		if (mutableAttributes == nil)
			mutableAttributes = [NSMutableArray new];
		
		// Add attributes
		if (![mutableAttributes containsObject:NSAccessibilityValueAttribute])
			[mutableAttributes addObject:NSAccessibilityValueAttribute];
		
		if (![mutableAttributes containsObject:NSAccessibilityEnabledAttribute])
			[mutableAttributes addObject:NSAccessibilityEnabledAttribute];
		
		if (![mutableAttributes containsObject:NSAccessibilityDescriptionAttribute])
			[mutableAttributes addObject:NSAccessibilityDescriptionAttribute];
		
		// Remove attributes
		if ([mutableAttributes containsObject:NSAccessibilityChildrenAttribute])
			[mutableAttributes removeObject:NSAccessibilityChildrenAttribute];
		
		attributes = [mutableAttributes copy];
	}
	return attributes;
}

- (id)accessibilityAttributeValue:(NSAccessibilityAttributeName)attribute {
	id retVal = nil;
	if ([attribute isEqualToString:NSAccessibilityRoleAttribute])
		retVal = NSAccessibilityCheckBoxRole;
	else if ([attribute isEqualToString:NSAccessibilityValueAttribute])
		retVal = [NSNumber numberWithInt:self.checked];
	else if ([attribute isEqualToString:NSAccessibilityEnabledAttribute])
		retVal = [NSNumber numberWithBool:self.enabled];
	else
		retVal = [super accessibilityAttributeValue:attribute];
	return retVal;
}

- (BOOL)accessibilityIsAttributeSettable:(NSAccessibilityAttributeName)attribute {
	BOOL retVal;
	if ([attribute isEqualToString:NSAccessibilityValueAttribute])
		retVal = YES;
	else if ([attribute isEqualToString:NSAccessibilityEnabledAttribute])
		retVal = NO;
	else if ([attribute isEqualToString:NSAccessibilityDescriptionAttribute])
		retVal = NO;
	else
		retVal = [super accessibilityIsAttributeSettable:attribute];
	return retVal;
}

- (void)accessibilitySetValue:(nullable id)value forAttribute:(NSAccessibilityAttributeName)attribute {
	if ([attribute isEqualToString:NSAccessibilityValueAttribute]) {
		BOOL invokeTargetAction = self.checked != [value boolValue];
		self.checked = [value boolValue];
		if (invokeTargetAction) {
			[self invokeTargetAction];
		}
	}
	else {
		[super accessibilitySetValue:value forAttribute:attribute];
	}
}

- (NSArray<NSAccessibilityActionName> *)accessibilityActionNames {
	static NSArray *actions = nil;
	if (actions == nil)
	{
		NSMutableArray *mutableActions = [[super accessibilityActionNames] mutableCopy];
		if (mutableActions == nil)
			mutableActions = [NSMutableArray new];
		if (![mutableActions containsObject:NSAccessibilityPressAction])
			[mutableActions addObject:NSAccessibilityPressAction];
		actions = [mutableActions copy];
	}
	return actions;
}

- (void)accessibilityPerformAction:(NSAccessibilityActionName)action {
	if ([action isEqualToString:NSAccessibilityPressAction]) {
		self.checked = ![self checked];
		[self invokeTargetAction];
	}
	else {
		[super accessibilityPerformAction:action];
	}
}

**/

@end
