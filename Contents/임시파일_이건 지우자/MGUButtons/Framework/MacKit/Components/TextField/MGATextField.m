//
//  MGATextField.m
//  TESTTextFieldCell
//
//  Created by Kwan Hyun Son on 2022/10/06.
//

#import "MGATextField.h"
#define kTextOriginXOffset      2
#define kTextWidthAdjust        (kTextOriginXOffset * 2.0)

@interface MGATextFieldCell : NSTextFieldCell
@end

@interface MGATextField ()
@property (nonatomic, strong) NSImageView *leftImageView;
@property (nonatomic, strong, nullable) NSColor *backColor;
@property (nonatomic, strong, nullable) NSColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) MGATextFieldType textFieldType;
@end

@implementation MGATextField
+ (Class)cellClass {
    return [MGATextFieldCell class];
}

- (void)drawFocusRingMask { // 포커스 링의 바운더리를 잡아준다.
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds]
                                                         xRadius:self.cornerRadius
                                                         yRadius:self.cornerRadius];
    [[NSColor blackColor] set];
    [path fill];
}

- (NSRect)focusRingMaskBounds {
    return [self bounds];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.textFieldType == MGATextFieldTypeNormal) {
        [self mgrDrawNormal:dirtyRect];
    } else if (self.textFieldType == MGATextFieldTypeBackImage) {
        [self mgrDrawImageRect:dirtyRect];
    } else if (self.textFieldType == MGATextFieldTypeLine ||
               self.textFieldType == MGATextFieldTypeLineBackgroud) {
        [self mgrDrawLineRect:dirtyRect];
    } else if (self.textFieldType == MGATextFieldTypeBezel ||
               self.textFieldType == MGATextFieldTypeBezelBackgroud) {
        [self mgrDrawBezelRect:dirtyRect];
    } else {
        [self mgrDrawBezelRoundRect:dirtyRect];
    }
    
    [super drawRect:dirtyRect]; // 마지막에 호출해줘야한다.
}

- (NSEdgeInsets)alignmentRectInsets {
    return NSEdgeInsetsZero;
}


#pragma mark - drawRect Helper
- (void)mgrDrawImageRect:(NSRect)dirtyRect {
    if (self.cornerRadius > 0.0) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect
                                                             xRadius:self.cornerRadius
                                                             yRadius:self.cornerRadius];
        [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    }
    [self.backgroundImage drawInRect:dirtyRect];
    //
    //    NSRect rectForBorders = NSMakeRect(2, 2, dirtyRect.size.width-4, dirtyRect.size.height-4);
    //    [image drawInRect:rectForBorders];
    //    [image drawInRect:rectForBorders
    //             fromRect:rectForBorders
    //            operation:NSCompositingOperationSourceOver
    //             fraction:1.0];
}

- (void)mgrDrawNormal:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect
                                                         xRadius:self.cornerRadius
                                                         yRadius:self.cornerRadius];
    if (self.cornerRadius > 0.0) {
        [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    }
    
    if (self.backColor != nil) {
        [self.backColor set];
        [path fill];
    }
    
    if (self.borderColor != nil && self.borderWidth > 0.0) {
        [self.borderColor set];
        [path setLineWidth:(self.borderWidth * 2.0)];
        [path stroke];
    }
}

- (void)mgrDrawLineRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:0.0 yRadius:0.0];
    [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    if (self.textFieldType == MGATextFieldTypeLineBackgroud &&
        self.backColor != nil) {
        [self.backColor set];
        [path fill];
    }
    
    NSColor *color = [NSColor colorWithWhite:0.0 alpha:0.245];
    [color set];
    [path setLineWidth:2.0];
    [path stroke];
}

//! 알고리즘이 더럽다. shadow 처리를 잘 못하겠다.
- (void)mgrDrawBezelRect:(NSRect)dirtyRect {
    NSColor *backColor = self.backColor;
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    
    if (self.textFieldType == MGATextFieldTypeBezelBackgroud) {
        [backColor set];
        [[NSBezierPath bezierPathWithRect:dirtyRect] fill];
    }
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState]; // shadow 영역.
    {
        [[NSColor whiteColor] set];
        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        CGFloat onePixel = 1.0 / scale;
        
        CGRect shadowRect = CGRectInset(dirtyRect, onePixel * 4, onePixel * 3);
        if (self.isFlipped == YES) {
            shadowRect.origin.y = shadowRect.origin.y + onePixel;
        } else {
            shadowRect.origin.y = shadowRect.origin.y - onePixel;
        }
        NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:shadowRect];
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = onePixel;
        shadow.shadowOffset = CGSizeZero;
        shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:0.6];
        [shadow set];
        shadowPath.lineWidth = onePixel;
        [shadowPath stroke]; // 선을 그려야지 shadow가 등장한다.
        [shadowPath fill];
        
        [[NSColor whiteColor] set];
        NSBezierPath *baseLinePath = [NSBezierPath bezierPathWithRect:CGRectInset(dirtyRect, 1.0, 1.0)];
        baseLinePath.lineWidth = onePixel;
        [baseLinePath fill];
    }
    [context restoreGraphicsState];
    
    if (self.textFieldType == MGATextFieldTypeBezelBackgroud) {
        [backColor set];
        [[NSBezierPath bezierPathWithRect:CGRectInset(dirtyRect, 2.0, 2.0)] fill];
    }
}

//! 알고리즘이 더럽다. shadow 처리를 잘 못하겠다.
- (void)mgrDrawBezelRoundRect__:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState]; // shadow 영역.
    {
        [[NSColor whiteColor] set];
        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        CGFloat onePixel = 1.0 / scale;
        
        CGRect shadowRect = CGRectInset(dirtyRect, onePixel * 4, onePixel * 3);
        if (self.isFlipped == YES) {
            shadowRect.origin.y = shadowRect.origin.y + onePixel;
        } else {
            shadowRect.origin.y = shadowRect.origin.y - onePixel;
        }
        NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRoundedRect:shadowRect xRadius:5.0 yRadius:5.0];
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = onePixel;
        shadow.shadowOffset = CGSizeZero;
        shadow.shadowColor = [NSColor colorWithWhite:0.0 alpha:0.7];
        [shadow set];
        shadowPath.lineWidth = onePixel;
        [shadowPath stroke]; // 선을 그려야지 shadow가 등장한다.
        [shadowPath fill];
        NSBezierPath *baseLinePath = [NSBezierPath bezierPathWithRoundedRect:CGRectInset(dirtyRect, 1.0, 1.0)
                                                                        xRadius:5.0
                                                                        yRadius:5.0];
        baseLinePath.lineWidth = 0.5;
        [baseLinePath fill];
    }
    
    [context restoreGraphicsState];
    
    // 진짜 더럽게 만들었다. 어떻게 해야할지 모르겠다.
    // 아무래도 방법은 shadow를 두개 만들어서 겹치는 것이 해결책일 것으로 사료된다. rect를 줄이면 radius에 문제가 발생해버린다.
    [[NSColor whiteColor] set];
    dirtyRect.size.height =  dirtyRect.size.height /2.0;
    NSBezierPath *baseLinePath = [NSBezierPath bezierPathWithRoundedRect:CGRectInset(dirtyRect, 1.0, 1.0)
                                                                    xRadius:5.0
                                                                    yRadius:5.0];
    baseLinePath.lineWidth = 0.5;
    [baseLinePath fill];
}

- (void)mgrDrawBezelRoundRect:(NSRect)dirtyRect {
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState]; // shadow 영역.
    {
        CGRect tempRect = CGRectInset(dirtyRect, 1.0, 0.0);
        tempRect.origin.y = tempRect.size.height - 5.0;
        tempRect.size.height = 5.0;
        [[NSBezierPath bezierPathWithRect:tempRect] addClip];
        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        CGFloat onePixel = 1.0 / scale;
        NSBezierPath *shadowPath =
        [NSBezierPath bezierPathWithRoundedRect:CGRectInset(dirtyRect, onePixel, onePixel) xRadius:5.0 yRadius:5.0];
        
        NSAffineTransform *transform = [NSAffineTransform transform];
        [transform translateXBy:0.0 yBy:0.5];
        [shadowPath transformUsingAffineTransform:transform];
        
        NSColor *shadowColor = [NSColor colorWithWhite:0.0 alpha:0.15]; // 235 목표 236
        [shadowColor set];
        [shadowPath fill];
    }
    [context restoreGraphicsState];

    [context saveGraphicsState]; // shadow 영역.
    {
        CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
        CGFloat onePixel = 1.0 / scale;
        NSBezierPath *shadowPath =
        [NSBezierPath bezierPathWithRoundedRect:CGRectInset(dirtyRect, onePixel, onePixel) xRadius:5.0 yRadius:5.0];
        NSColor *shadowColor = [NSColor colorWithWhite:0.0 alpha:0.07]; // 235 목표 236
        [shadowColor set];
        [shadowPath fill];
    }
    [context restoreGraphicsState];
    
    NSBezierPath *areaPath =
    [NSBezierPath bezierPathWithRoundedRect:CGRectInset(dirtyRect, 1.0, 1.0) xRadius:5.0 yRadius:5.0];
    [[NSColor whiteColor] set];
    [areaPath fill];
    
}

- (BOOL)isFlipped {
    return YES;
}

#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(NSRect)frameRect
              backgroundColor:(NSColor * _Nullable)backgroundColor
                  borderColor:(NSColor * _Nullable)borderColor
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius
                      padding:(CGFloat)padding
                textFieldType:(MGATextFieldType)textFieldType {
    self = [super initWithFrame:frameRect];
    if (self) {
        _backColor = backgroundColor;
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        _cornerRadius = cornerRadius;
        _padding = padding;
        _textFieldType = textFieldType;
        self.lineBreakMode = NSLineBreakByClipping; // 일반 텍스트 필드
        self.cell.scrollable = YES;
        self.drawsBackground = NO;
        _backgroundImage = [NSImage imageNamed:@"svsv"];
        self.bordered = NO;
        self.bezeled = NO;
        _leftImageView = [NSImageView new];
        [self addSubview:self.leftImageView];
        self.leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.leftImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0.0].active = YES;
        [self.leftImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:2.0].active = YES;
        [self.leftImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-2.0].active = YES;
        [self.leftImageView.widthAnchor constraintEqualToConstant:padding].active = YES;
        self.leftImageView.imageScaling = NSImageScaleProportionallyDown;
        
        if (_textFieldType == MGATextFieldTypeRound) {
            self.cornerRadius = 5.0;
            if (self.padding < 5.0) {
                self.padding = 5.0;
            }
        }
    }
    return self;
}

#pragma mark - 세터 & 게터
- (void)setLeftImage:(NSImage *)leftImage {
    _leftImage = leftImage;
    self.leftImageView.image = leftImage;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithFrame:(NSRect)frameRect { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
+ (instancetype)labelWithString:(NSString *)stringValue { NSCAssert(FALSE, @"+ labelWithString: 사용금지."); return nil; }
+ (instancetype)wrappingLabelWithString:(NSString *)stringValue { NSCAssert(FALSE, @"+ wrappingLabelWithString: 사용금지."); return nil; }
+ (instancetype)labelWithAttributedString:(NSAttributedString *)attributedStringValue { NSCAssert(FALSE, @"+ labelWithAttributedString: 사용금지."); return nil; }
+ (instancetype)textFieldWithString:(NSString *)stringValue { NSCAssert(FALSE, @"+ textFieldWithString: 사용금지."); return nil; }
@end


@implementation MGATextFieldCell

- (NSRect)titleRectForBounds:(NSRect)cellRect {
    CGFloat frameHeight = cellRect.size.height;
    CGFloat textHeight = [self cellSizeForBounds:cellRect].height; // 텍스트의 높이를 추정한다.
    CGFloat originY = (frameHeight - textHeight) / 2.0; //! vertically center를 위해.
    
    MGATextField *nonBorderTextField = (MGATextField *)(self.controlView);
    CGFloat padding = nonBorderTextField.padding;
    CGFloat cornerRadius = nonBorderTextField.cornerRadius;
    CGRect imageFrame = CGRectZero;
    CGRect newFrame = CGRectZero;
    NSDivideRect(cellRect, &imageFrame, &newFrame, (padding), NSMinXEdge);
    newFrame.origin.x = newFrame.origin.x + kTextOriginXOffset; // 2
    if (nonBorderTextField.isFlipped == YES) {
        newFrame.origin.y = originY - 1;
    } else {
        newFrame.origin.y = originY + 1;
    }
    newFrame.size.height = textHeight;
    newFrame.size.width = newFrame.size.width - kTextWidthAdjust;
    if (cornerRadius > 0.0) {
        cornerRadius = MIN(cornerRadius, (cellRect.size.height / 2.0));
        newFrame.size.width = newFrame.size.width - cornerRadius;
    } 
    return newFrame;
    //
    // https://stackoverflow.com/questions/11775128/set-text-vertical-center-in-nstextfield
}

// 반드시 필요함...
- (void)editWithFrame:(NSRect)aRect
               inView:(MGATextField *)controlView
               editor:(NSText*)textObj
             delegate:(id)anObject
                event:(NSEvent*)theEvent {
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super editWithFrame:textFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}
//
- (void)selectWithFrame:(NSRect)aRect
                 inView:(MGATextField *)controlView
                 editor:(NSText *)textObj
               delegate:(id)anObject
                  start:(NSInteger)selStart
                 length:(NSInteger)selLength {
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super selectWithFrame:textFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}


//! 리시버의 내부 요소 (이미지, 텍스트)를 그린다. (보더는 아니다.)
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(MGATextField *)controlView {
    NSRect textFrame = [self titleRectForBounds:cellFrame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
}

// back 그리기
//- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//    [super drawWithFrame:cellFrame inView:controlView];
//}

@end
#undef kTextOriginXOffset
#undef kTextWidthAdjust
