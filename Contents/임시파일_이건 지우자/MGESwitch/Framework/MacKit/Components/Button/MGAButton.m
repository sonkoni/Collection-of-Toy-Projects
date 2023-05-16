//
//  MGAButton.m
//  ButtonTEST
//
//  Created by Kwan Hyun Son on 2022/11/02.
//

#import "MGAButton.h"

@interface MGAButton ()
@property (nonatomic, assign) BOOL mouseInside;
@property (nonatomic, strong) NSTrackingArea *trackingArea; // lazy
@end

@implementation MGAButton
@synthesize flipped = _flipped; // 반드시 넣어줘야한다.
@dynamic imageDimsWhenDisabled;

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

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isBordered == NO) { // super와의 충돌을 막기 위해.
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect
                                                             xRadius:self.cornerRadius
                                                             yRadius:self.cornerRadius];
        [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
        if (self.backgroundColor != nil) {
            [self.backgroundColor set];
            [path fill];
        }
        if (self.borderColor != nil && self.borderWidth > 0.0) {
            [self.borderColor set];
            [path setLineWidth:(self.borderWidth * 2.0)];
            [path stroke];
        }
    }
    [super drawRect:dirtyRect];
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

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateCurrentImage];
}

- (void)resetCursorRects { // 기본 구현은 아무것도 수행하지 않는다. so super를 호출할 필요가 없다.
    if (self.cursorType != MGAButtonCursorTypeNone && self.isEnabled == YES) {
        NSCursor *cursor = Cursor(self.cursorType);
        [self addCursorRect:self.bounds cursor:cursor];
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

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if ([self.trackingAreas containsObject:self.trackingArea] == NO) {
        [self addTrackingArea:self.trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)event {
    self.mouseInside = NO;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGAButton *self) {
    self->_userInteractionEnabled = YES;
    self.wantsLayer = YES;
}


#pragma mark - 세터 & 게터
- (void)setNormalImage:(NSImage *)normalImage {
    _normalImage = normalImage;
    [self updateCurrentImage];
}

- (void)setDisableImage:(NSImage *)disableImage {
    _disableImage = disableImage;
    [self updateCurrentImage];
}

- (BOOL)imageDimsWhenDisabled {
    NSButtonCell *cell = (NSButtonCell *)self.cell;
    return cell.imageDimsWhenDisabled;
}

- (void)setImageDimsWhenDisabled:(BOOL)imageDimsWhenDisabled {
    NSButtonCell *cell = (NSButtonCell *)self.cell;
    [cell setImageDimsWhenDisabled:imageDimsWhenDisabled];
}

- (NSTrackingArea *)trackingArea {
    if (_trackingArea == nil) {
        NSTrackingAreaOptions trackingAreaOptions =
            NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                     options:trackingAreaOptions
                                                       owner:self
                                                    userInfo:nil];
    }
    return _trackingArea;
}

- (void)setMouseInside:(BOOL)mouseInside {
    if (_mouseInside != mouseInside) {
        _mouseInside = mouseInside;
        if (self.mouseHoverConditionalBlock != nil) {
            self.mouseHoverConditionalBlock(mouseInside);
        }
    }
}


#pragma mark - Actions
- (void)updateCurrentImage {
    if (self.disableImage == nil) {
        [super setImage:self.normalImage];
        return;
    }
    if (self.enabled == YES) {
        [super setImage:self.normalImage];
    } else {
        [super setImage:self.disableImage];
    }
}


#pragma mark - Helper
static NSCursor *Cursor(MGAButtonCursorType cursorType) {
    if (cursorType == MGAButtonArrowCursorType) {
        return [NSCursor arrowCursor];
    } else if (cursorType == MGAButtonIBeamCursorType) {
        return [NSCursor IBeamCursor];
    } else if (cursorType == MGAButtonCrosshairCursorType) {
        return [NSCursor crosshairCursor];
    } else if (cursorType == MGAButtonClosedHandCursorType) {
        return [NSCursor closedHandCursor];
    } else if (cursorType == MGAButtonOpenHandCursorType) {
        return [NSCursor openHandCursor];
    } else if (cursorType == MGAButtonPointingHandCursorType) {
        return [NSCursor pointingHandCursor];
    } else if (cursorType == MGAButtonResizeLeftCursorType) {
        return [NSCursor resizeLeftCursor];
    } else if (cursorType == MGAButtonResizeRightCursorType) {
        return [NSCursor resizeRightCursor];
    } else if (cursorType == MGAButtonResizeLeftRightCursorType) {
        return [NSCursor resizeLeftRightCursor];
    } else if (cursorType == MGAButtonResizeUpCursorType) {
        return [NSCursor resizeUpCursor];
    } else if (cursorType == MGAButtonResizeDownCursorType) {
        return [NSCursor resizeDownCursor];
    } else if (cursorType == MGAButtonResizeUpDownCursorType) {
        return [NSCursor resizeUpDownCursor];
    } else if (cursorType == MGAButtonDisappearingItemCursorType) {
        return [NSCursor disappearingItemCursor];
    } else if (cursorType == MGAButtonIBeamCursorForVerticalLayoutType) {
        return [NSCursor IBeamCursorForVerticalLayout];
    } else if (cursorType == MGAButtonOperationNotAllowedCursorType) {
        return [NSCursor operationNotAllowedCursor];
    } else if (cursorType == MGAButtonDragLinkCursorType) {
        return [NSCursor dragLinkCursor];
    } else if (cursorType == MGAButtonDragCopyCursorType) {
        return [NSCursor dragCopyCursor];
    } else if (cursorType == MGAButtonContextualMenuCursorType) {
        return [NSCursor contextualMenuCursor];
    }
    return nil;
}

@end
