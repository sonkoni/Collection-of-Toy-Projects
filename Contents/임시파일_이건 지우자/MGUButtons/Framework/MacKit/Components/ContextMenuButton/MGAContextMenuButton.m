//
//  MGAContextMenuButton+Mulgrim.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAContextMenuButton.h"

@interface MGAContextMenuButtonCell : NSPopUpButtonCell
@end
@implementation MGAContextMenuButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(MGAContextMenuButton *)controlView {
    NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
    CGContextRef context = currentContext.CGContext;
    if (context != NULL) {
        CGPathRef path = CGPathCreateWithRoundedRect(controlView.bounds, 5.0, 5.0, NULL);
        CGContextAddPath(context, (CGPathRef)CFAutorelease(path));
        CGContextClip(context);
        NSColor *fillColor = (controlView.isHighlighted == YES) ? controlView.highlightedColor : controlView.hoverColor;
        [fillColor setFill];
        CGContextFillRect(context, frame);
    }
    //
    // 다음과 같이 해도 효과는 동일하다.
//    NSColor *fillColor = (controlView.isHighlighted == YES) ? controlView.highlightedColor : controlView.hoverColor;
//    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:controlView.bounds xRadius:5.0 yRadius:5.0];
//    [fillColor setFill];
//    [path fill];
}

//- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {}
//- (void)drawBorderAndBackgroundWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {}
//- (BOOL)trackMouse:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag {}
//- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {}
//- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView {}
//- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {}
@end

@interface MGAContextMenuButton ()
@property (nonatomic, strong) NSMenuItem *faceItem; // 외부에 보여지는 이미지를 표현하는 고정아이템 역할
@end
@implementation MGAContextMenuButton
@dynamic faceImage;

+ (Class)cellClass {
    return [MGAContextMenuButtonCell class];
}

- (NSSize)sizeThatFits:(NSSize)size {
    return CGSizeMake(46.0, 21.0);
}

- (NSSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(NSRect)frameRect
                    faceImage:(NSImage *)faceImage
                    itemArray:(NSArray <NSMenuItem *>*)itemArray
                   hoverColor:(NSColor *)hoverColor
             highlightedColor:(NSColor *)highlightedColor
        refusesFirstResponder:(BOOL)refusesFirstResponder
                      toolTip:(NSString *)toolTip {
    self = [super initWithFrame:frameRect pullsDown:YES];  // popup 스타일이 아니다.
    if (self) {
        self.target = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
        self.action = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
        self.imagePosition = NSImageOnly;
        self.bezelStyle = NSBezelStyleRecessed;
        self.bordered = YES;
        self.showsBorderOnlyWhileMouseInside = YES; // 버튼 안에 마우스가 들어와야 보더 칼라를 활성화 시키는 옵션
        [self setButtonType:NSButtonTypePushOnPushOff];
        self.preferredEdge = NSRectEdgeMinY;
        _faceItem = [NSMenuItem new]; // 외부에 보여지는 이미지를 표현하는 고정아이템 역할
        self.faceItem.image = faceImage;
        self.faceItem.title = @"";
        self.faceItem.tag = -1004;  // 0 <= 숫자는 태그로 사용될 수 있으므로 걸리지 않을 태그를 설정해주자.
        self.faceItem.hidden = YES; // 컨텐츠로 사용되지 않으므로.
        [self.menu addItem:self.faceItem];
        
        __weak __typeof(self) weakSelf = self;
        [itemArray enumerateObjectsUsingBlock:^(NSMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
            [weakSelf.menu addItem:menuItem];
        }];
        
        _hoverColor = hoverColor;
        _highlightedColor = highlightedColor;
        if (hoverColor == nil) {
            _hoverColor = [NSColor colorWithWhite:0.0 alpha:0.051];
        }
        if (highlightedColor == nil) {
            _highlightedColor = [NSColor colorWithWhite:0.0 alpha:0.1];
        }
        if (faceImage == nil) {
            self.faceItem.image = [NSImage imageWithSystemSymbolName:@"square.grid.3x1.below.line.grid.1x2"
                                            accessibilityDescription:@""];
        }
        self.refusesFirstResponder = refusesFirstResponder; // 탭으로 first responder가 되는 것을 막을 수 있다.
        self.toolTip = toolTip;
    }
    return self;
}

//- (void)drawRect:(NSRect)dirtyRect { [super drawRect:dirtyRect];}


#pragma mark - 세터 & 게터
- (void)setFaceImage:(NSImage *)faceImage {
    self.faceItem.image = faceImage;
}

- (NSImage *)faceImage {
    return self.faceItem.image;
}


#pragma mark - Actions
- (void)resetItemArray:(NSArray <NSMenuItem *>*)itemArray {
    NSMenu *menu = itemArray.firstObject.menu;
    [menu removeAllItems]; // 혹시 다른 메뉴에 붙어 있는 것을 붙이게 되면 앱이 터진다.
    [self.menu removeAllItems];
    [self.menu addItem:self.faceItem];
    [itemArray enumerateObjectsUsingBlock:^(NSMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
        [self.menu addItem:menuItem];
    }];
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithFrame:(NSRect)frameRect { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
- (instancetype)initWithFrame:(NSRect)buttonFrame pullsDown:(BOOL)flag { NSCAssert(FALSE, @"- initWithFrame:pullsDown: 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }

@end
