//
//  MGADisclosurePopUpButton.m
//  ButtonTEST
//
//  Created by Kwan Hyun Son on 2022/10/03.
//

#import "MGADisclosurePopUpButton.h"
#import "NSColor+Etc.h"

@interface MGADisclosurePopUpButton ()
@property (nonatomic, strong) NSMenuItem *faceItem; // 외부에 보여지는 이미지를 표현하는 고정아이템 역할
@property (nonatomic, strong) NSColor *privateHighlightedColor;
@end

@interface MGADisclosurePopUpButtonCell : NSPopUpButtonCell
@end
@implementation MGADisclosurePopUpButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(MGADisclosurePopUpButton *)controlView {
    NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
    CGContextRef context = currentContext.CGContext;
    if (context != NULL) {
        CGRect myFrme = [controlView alignmentRectForFrame:frame]; // 정확하지가 않다. 조금 옮겨야한다.
        CGFloat originX = (frame.size.width - myFrme.size.width) / 2.0;
        CGFloat originY = (frame.size.height - myFrme.size.height) / 2.0;
        myFrme = CGRectMake(originX, originY, myFrme.size.width, myFrme.size.height);
        CGPathRef path = CGPathCreateWithRoundedRect(myFrme, 5.0, 5.0, NULL);
        CGContextAddPath(context, (CGPathRef)CFAutorelease(path));
        CGContextClip(context);
        NSColor *highlightedColor = controlView.highlightedColor;
        if (highlightedColor == nil) {
            highlightedColor = controlView.privateHighlightedColor;
        }
        NSColor *fillColor = (controlView.isHighlighted == YES) ? highlightedColor : controlView.normalColor;
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

//@interface MGADisclosurePopUpButton ()
//@property (nonatomic, strong) NSMenuItem *faceItem; // 외부에 보여지는 이미지를 표현하는 고정아이템 역할
//@property (nonatomic, strong) NSColor *privateHighlightedColor;
//@end

@implementation MGADisclosurePopUpButton

+ (Class)cellClass {
    return [MGADisclosurePopUpButtonCell class];
}

- (NSSize)sizeThatFits:(NSSize)size {
    return CGSizeMake(40.0, 40.0);
}

- (NSSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(NSRect)frameRect
                    itemArray:(NSArray <NSMenuItem *>*)itemArray
                  normalColor:(NSColor *)normalColor
             highlightedColor:(NSColor * _Nullable)highlightedColor
                      toolTip:(NSString *)toolTip {
    self = [super initWithFrame:frameRect pullsDown:YES];  // popup 스타일이 아니다.
    if (self) {
        self.target = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
        self.action = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
        self.imagePosition = NSNoImage;
        self.bezelStyle = NSBezelStyleRegularSquare;
        self.bordered = YES;
        self.showsBorderOnlyWhileMouseInside = NO;
        [self setButtonType:NSButtonTypeMomentaryPushIn];
        self.preferredEdge = NSRectEdgeMinY;
        _faceItem = [NSMenuItem new]; // 외부에 보여지는 이미지를 표현하는 고정아이템 역할
        self.faceItem.image = nil;
        self.faceItem.title = @"";
        self.faceItem.tag = -1004;  // 0 <= 숫자는 태그로 사용될 수 있으므로 걸리지 않을 태그를 설정해주자.
        self.faceItem.hidden = YES; // 컨텐츠로 사용되지 않으므로.
        [self.menu addItem:self.faceItem];
        
        __weak __typeof(self) weakSelf = self;
        [itemArray enumerateObjectsUsingBlock:^(NSMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
            [weakSelf.menu addItem:menuItem];
        }];
        
        self.normalColor = normalColor;
        _highlightedColor = highlightedColor;
        if (normalColor == nil) {
            self.normalColor = [NSColor colorWithWhite:0.0 alpha:0.051];
        }
        
        NSPopUpButtonCell *cell = self.cell;
        [cell setArrowPosition:NSPopUpArrowAtCenter];
        self.refusesFirstResponder = YES; // 탭으로 first responder가 되는 것을 막을 수 있다.
        self.toolTip = toolTip;
        
    }
    return self;
}


- (void)setNormalColor:(NSColor *)normalColor {
    _normalColor = normalColor;
    if (normalColor == nil) {
        _privateHighlightedColor = nil;
    } else {
        CGFloat r = 0;
        CGFloat g = 0;
        CGFloat b = 0;
        CGFloat a = 0;
        [normalColor mgrGetRed:&r green:&g blue:&b alpha:&a];
        r = MAX(0.0, (r * 255.0) - 20.0) / 255.0;
        g = MAX(0.0, (g * 255.0) - 20.0) / 255.0;
        b = MAX(0.0, (b * 255.0) - 20.0) / 255.0;
        _privateHighlightedColor = [NSColor colorWithRed:r green:g blue:b alpha:a];
    }
    [self setBezelColor:normalColor]; // 갱신을 위해.
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
