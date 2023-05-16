//
//  MGERingProgressGroupButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGERingProgressGroupButton.h"
#import "MGERingProgressGroupView.h"

#if TARGET_OS_IPHONE

@interface MGERingProgressGroupButton ()
@property (nonatomic, strong) UIView *selectionIndicatorView;
@end

@implementation MGERingProgressGroupButton

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

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted == YES) {
        self.ringProgressGroupView.alpha = 0.3f;
    } else {
        self.ringProgressGroupView.alpha = 1.f;
    }
    //
    // 버튼을 눌렀을 때, 작동한다. override된 메서드이다.
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected == YES) {
        self.selectionIndicatorView.hidden = NO;
    } else {
        self.selectionIndicatorView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //! 자신의 프레임이 정사각형이 아닐 수 있음을 가정한다.
    CGFloat size = MIN(self.bounds.size.width, self.bounds.size.height) - (self.contentMargin * 2);
    self.ringProgressGroupView.frame  = CGRectMake((self.bounds.size.width - size)/2, (self.bounds.size.height - size)/2, size, size);
    self.selectionIndicatorView.frame = self.ringProgressGroupView.frame;

    CGPathRef shadowPath =
    CGPathCreateCopyByStrokingPath([UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.selectionIndicatorView.bounds, -1.f,-1.f)].CGPath,
                                   NULL,
                                   1.0,
                                   kCGLineCapRound,
                                   kCGLineJoinRound,
                                   0.0f);
    
    self.selectionIndicatorView.layer.shadowPath = shadowPath;
    
    CGPathRelease(shadowPath);
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGERingProgressGroupButton *self) {
    self->_selectionIndicatorView = [UIView new]; // 선택했을 때, 흰색 광이 나올 수 있도록한다.
    self.selectionIndicatorView.backgroundColor     = UIColor.clearColor;
    self.selectionIndicatorView.layer.masksToBounds = NO;
    self.selectionIndicatorView.layer.shadowColor   = UIColor.whiteColor.CGColor;
    self.selectionIndicatorView.layer.shadowOpacity = 1.0;
    self.selectionIndicatorView.layer.shadowRadius  = 1.0;
    self.selectionIndicatorView.layer.shadowOffset  = CGSizeZero;
    self.selectionIndicatorView.hidden = YES; // 눌렀을 때만 광이 나게 감춘다.
    self.selectionIndicatorView.userInteractionEnabled = NO;
    [self addSubview:self.selectionIndicatorView];
    
    self->_ringProgressGroupView  = [MGERingProgressGroupView new];
    self.ringProgressGroupView.userInteractionEnabled = NO;
    [self addSubview:self.ringProgressGroupView];
    
    self->_contentMargin = 2.0f;
}


#pragma mark - 세터 & 게터
- (void)setContentMargin:(CGFloat)contentMargin {
    _contentMargin = contentMargin;
    [self setNeedsLayout];
}

@end

#else


@interface _RingProgGroupBtnSelectIndicatorView : NSView
@end
@implementation _RingProgGroupBtnSelectIndicatorView
- (NSView *)hitTest:(NSPoint)point {return nil;}
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) { self.wantsLayer = YES;} return self;
}
@end

@interface MGERingProgressGroupButton ()
@property (nonatomic, strong) _RingProgGroupBtnSelectIndicatorView *selectionIndicatorView;
@end

@interface _MGERingProgressGroupButtonCell : NSButtonCell
@end
@implementation _MGERingProgressGroupButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(MGERingProgressGroupButton *)controlView {
    // [super drawBezelWithFrame:frame inView:controlView];
    if (controlView.isHighlighted == YES) { // 터치 다운.
        controlView.ringProgressGroupView.layer.opacity = 0.3;
    } else {
        controlView.ringProgressGroupView.layer.opacity = 1.0; // 언 하이라이트!
    }
}

- (void)mouseEntered:(NSEvent *)event {
    MGERingProgressGroupButton *controlView = (MGERingProgressGroupButton *)self.controlView;
    CGRect bounds = controlView.layer.bounds;
    controlView.layer.cornerRadius = MIN(bounds.size.width, bounds.size.height) / 2.0;
    controlView.layer.backgroundColor = [[NSColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
}

- (void)mouseExited:(NSEvent *)event {
    MGERingProgressGroupButton *controlView = (MGERingProgressGroupButton *)self.controlView;
    controlView.layer.backgroundColor = [NSColor clearColor].CGColor;
}

- (void)setState:(NSControlStateValue)state {
    [super setState:state];
    MGERingProgressGroupButton *controlView = (MGERingProgressGroupButton *)(self.controlView);
    if (state == NSControlStateValueOn) { // on : 흰색 shadow 보여줌.
        controlView.selectionIndicatorView.hidden = NO;
    } else {  // off : 흰색 shadow 감춤.
        controlView.selectionIndicatorView.hidden = YES;
    }
}

// - (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView {}
// - (BOOL)trackMouse:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag {}
// - (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {}
// - (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView {}
// - (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {}
// - (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {}
@end

@implementation MGERingProgressGroupButton

+ (Class)cellClass {
    return [_MGERingProgressGroupButtonCell class];
}

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

//! 제대로 작동하지 않는다. Cell에서 만져줘야한다.
//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//}
//- (void)setState:(NSControlStateValue)state {
//    [super setState:state];
//}

- (void)layout {
    [super layout];
    //! 자신의 프레임이 정사각형이 아닐 수 있음을 가정한다.
    CGFloat size = MIN(self.bounds.size.width, self.bounds.size.height) - (self.contentMargin * 2);
    self.ringProgressGroupView.frame  = CGRectMake((self.bounds.size.width - size)/2, (self.bounds.size.height - size)/2, size, size);
    self.selectionIndicatorView.frame = self.ringProgressGroupView.frame;

    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectInset(self.selectionIndicatorView.bounds, -1.0,-1.0), NULL);
    CGPathRef shadowPath =
    CGPathCreateCopyByStrokingPath((CGPathRef)CFAutorelease(path),
                                   NULL,
                                   1.0,
                                   kCGLineCapRound,
                                   kCGLineJoinRound,
                                   0.0f);
    self.selectionIndicatorView.layer.shadowPath = (CGPathRef)CFAutorelease(shadowPath);
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGERingProgressGroupButton *self) {
    self.wantsLayer = YES;
    self.layer.masksToBounds = NO;
    // 선택했을 때, 흰색 광이 나올 수 있도록한다.
    self->_selectionIndicatorView = [_RingProgGroupBtnSelectIndicatorView new];
    self.selectionIndicatorView.layer = [CALayer layer];
    self.selectionIndicatorView.shadow = [NSShadow new]; // Dark Mode 일때 쓰인다. 모든 프라퍼티를 설정하라.
    self.selectionIndicatorView.shadow.shadowColor = [NSColor whiteColor];
    self.selectionIndicatorView.shadow.shadowOffset = CGSizeZero;
    self.selectionIndicatorView.shadow.shadowBlurRadius = 1.0;
    self.selectionIndicatorView.layer.masksToBounds = NO;
    self.selectionIndicatorView.layer.shadowColor   = [NSColor whiteColor].CGColor;
    self.selectionIndicatorView.layer.shadowOpacity = 1.0;
    self.selectionIndicatorView.layer.shadowRadius  = 1.0;
    self.selectionIndicatorView.layer.shadowOffset  = CGSizeZero;
    self.selectionIndicatorView.hidden = YES; // 눌렀을 때만 광이 나게 감춘다.
    [self addSubview:self.selectionIndicatorView];
    self->_ringProgressGroupView  = [MGERingProgressGroupView new];
    [self addSubview:self.ringProgressGroupView];
    self->_contentMargin = 2.0;
    self.title = @"";
    self.bordered = YES;
    self.showsBorderOnlyWhileMouseInside = YES; //! 이렇게 해야 cell에서 mouseEntered:, mouseExited: 호출됨.
    self.bezelStyle = NSBezelStyleInline;
    //
    // NSBezelStyleRegularSquare
    // NSBezelStyleRecessed
}


#pragma mark - 세터 & 게터
- (void)setContentMargin:(CGFloat)contentMargin {
    _contentMargin = contentMargin;
    [self setNeedsLayout:YES];
}

@end


#endif
