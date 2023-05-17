//
//  MGATableItemRowView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGATableItemRowView.h"

#define CORNER_RADIUS   (5.0)
#define RECT_INSET      (10.0)

@interface MGATableItemRowView ()
@property (nonatomic, strong) CALayer *myMaskLayer; // lazy
@end

@implementation MGATableItemRowView

- (void)layout {
    [super layout];
    if (self.insetStyle == YES &&
        self.useInsetMask == YES &&
        [self.tableView isKindOfClass:[NSOutlineView class]] == NO) {
        self.myMaskLayer.cornerRadius = CORNER_RADIUS;
        self.layer.mask = self.myMaskLayer;
        self.layer.mask.frame = NSInsetRect(self.layer.bounds, RECT_INSET, 0.0);
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    //
    // 테스트.
    /*
    if (self.isSelected == YES) {
        if (self.isEmphasized == YES) {
            [[NSColor systemRedColor] setFill];
            NSBezierPath *selectionPath = [self selectionPath];
            [selectionPath fill];
        } else {
            [[NSColor systemBlueColor] setFill];
            NSBezierPath *selectionPath = [self selectionPath];
            [selectionPath fill];
        }
    }
     */
}

- (void)setEmphasized:(BOOL)emphasized {
    if (self.highlightStyle == MGATableItemRowViewHighlightStyleGray &&
        self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) { // 소스 리스트에서 만 쓸듯.
        [super setEmphasized:NO];
    } else {
        [super setEmphasized:emphasized];
    }
}

- (BOOL)isEmphasized {
    if (self.highlightStyle == MGATableItemRowViewHighlightStyleGray &&
        self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) { // 소스 리스트에서 만 쓸듯.
        return NO;
    } else {
        return [super isEmphasized];
    }
}

////- (void)drawBackgroundInRect:(NSRect)dirtyRect {} // 배경 그리는 것.
//
//! self.outlineView(또는 테이블 뷰).style == NSTableViewStyleSourceList 일때는 안들어온다.
//! NSTableViewStyleSourceList 때는 visual effect 가 활성화 되는 듯.
- (void)drawSelectionInRect:(NSRect)dirtyRect {
    if (self.highlightStyle == MGATableItemRowViewHighlightStyleDefault) {
        [super drawSelectionInRect:dirtyRect]; // 이렇게 하고 return해도 된다. 디폴트라면.
        return;
        /*
        // 수동으로 한다면 다음과 같다.
        NSRect selectionRect = NSInsetRect(self.bounds, 10.0, 0.0);
        if (self.interiorBackgroundStyle == NSBackgroundStyleEmphasized) { // 셀렉션 && 퍼스트 리스폰더
            [[NSColor selectedContentBackgroundColor] setFill];
            // accentColor 에서 알파(유지)를 제외하고 r, g, b 값에 0.882353 를 곱해준 색(약간 더 어둡게.)
        } else { // self.interiorBackgroundStyle == NSBackgroundStyleNormal 이 외 다른것 안들어옴.
            //! 셀렉션 YES && 퍼스트 리스폰더 NO.
            // 0.862745 0.862745 0.862745 1.000000 이거로 나왔는데, 아마도 부모색에 따라 달라질듯.
            [[NSColor unemphasizedSelectedContentBackgroundColor] setFill];
        }
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:5 yRadius:5];
        [selectionPath fill];
        return;
         */
    }

    if (self.highlightStyle == MGATableItemRowViewHighlightStyleCustom &&
        self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone &&
        self.selectionHighlightColor != nil) {

        if (self.interiorBackgroundStyle == NSBackgroundStyleEmphasized) {  // 선택되고 퍼스트 리스폰더 일때만!
            [self.selectionHighlightColor setFill];
            // 애플의 알고리즘은 [NSColor colorNamed:@"AccentColor"] 를 예로. r,g,b에 각각 0.882353 곱합. 알파 동일.
            // [self.selectionHighlightColor setStroke]; // 스트로크도 가능하다.
            // [[NSColor colorWithCalibratedWhite:.65 alpha:1.0] setStroke];
            // [[NSColor colorWithCalibratedWhite:.82 alpha:1.0] setFill];
        } else { // 선택되고 활성화 되었다가 다른 곳 클릭해서 다른 곳이 활성화되었지만, 선택은 여전할때. (회색에 가깝다.)
            [[NSColor unemphasizedSelectedContentBackgroundColor] setFill];
            //  0.862745 0.862745 0.862745 1.000000 이거로 나왔는데, 아마도 부모색에 따라 달라질듯.
        }

        NSBezierPath *selectionPath = [self selectionPath:dirtyRect];
        [selectionPath fill];
        // [selectionPath stroke]; 스트로크를 원한다면.
        return;
    }
    [super drawSelectionInRect:dirtyRect];
    //
    // 단순하게 색만 먹이고 싶다면.
    // [super drawSelectionInRect:dirtyRect];
    // [[NSColor yellowColor] setFill];
    // NSRectFill(dirtyRect);
}

- (void)drawSeparatorInRect:(NSRect)dirtyRect { // 오직 tableView.gridStyleMask에 horizontal grid 설정이 되어있을 시에만 호출.
    if (self.useCustomSeparator == NO) {
        [super drawSeparatorInRect:dirtyRect];
    } else {
        [self drawCustomSeparatorInRect:dirtyRect]; // 내가 만든 메서드
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wantsLayer = YES;
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithTableView:(NSTableView *)tableView
                       insetStyle:(BOOL)insetStyle
                     useInsetMask:(BOOL)useInsetMask {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _insetStyle = insetStyle;
        self.tableView = tableView;
        _useInsetMask = useInsetMask;
        self.wantsLayer = YES;
    }
    return self;
}


#pragma mark - 세터 & 게터
- (CALayer *)myMaskLayer {
    if (_myMaskLayer == nil) {
        if (self.layer == nil) {
            self.wantsLayer = YES;
        }
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [NSColor blackColor].CGColor;
        layer.masksToBounds = YES;
        _myMaskLayer = layer;
    }
    return _myMaskLayer;
}


#pragma mark - Private
- (void)drawCustomSeparatorInRect:(NSRect)dirtyRect { // 내가 만든 메서드
    if (self.tableView != nil) {
        NSInteger row = [self.tableView rowForView:self];
        if (self.tableView.numberOfRows == row + 1 &&  // 마지막 row 이고
            self.drawLastRowSeparator == NO) { // 마지막 row를 그리지 않는 전략이라면.
            return;
        }
    }
    
    [self.customSeparatorColor setFill];
    dirtyRect.origin.y = dirtyRect.size.height - 1.0;
    dirtyRect.size.height = 1.0;
    // UIEdgeInsetsInsetRect() 해당하는 함수가 AppKit에는 없다.
    dirtyRect.size.width = dirtyRect.size.width - self.customSeparatorInsets.x - self.customSeparatorInsets.y;
    dirtyRect.origin.x = self.customSeparatorInsets.x;
    dirtyRect = CGRectOffset(dirtyRect, [self difference], 0.0); // 스와이프로 인한 차이 보정
    NSRectFill(dirtyRect);
    //
    // NSRect separatorRect = self.bounds;
    // separatorRect.origin.y = NSMaxY(separatorRect) - 1.0;
    // separatorRect.size.height = 1.0;
//    @property (nonatomic, assign) BOOL drawLastRowSeparator; // 아래 설명참고.
}


#pragma mark - Helper
- (NSBezierPath *)selectionPath:(CGRect)dirtyRect {
    if (_insetStyle == YES) {
        NSRect selectionRect = NSInsetRect(dirtyRect, RECT_INSET, 0.0);
        selectionRect = CGRectOffset(selectionRect, [self difference], 0.0); // 스와이프로 인한 차이 보정
        return [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:CORNER_RADIUS yRadius:CORNER_RADIUS];
    } else {
        NSRect selectionRect = NSInsetRect(dirtyRect, 0.0, 0.0);
        selectionRect = CGRectOffset(selectionRect, [self difference], 0.0); // 스와이프로 인한 차이 보정
        return [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:0 yRadius:0];
    }
}

- (CGFloat)difference {
    if ([self.tableView isKindOfClass:[NSOutlineView class]] == YES) {
        return 0.0;
    }
    NSUInteger row = [self.tableView rowForView:self];
    // CGRect rect = [self.tableView rectOfRow:row]; // 고정상태의 자신의 프레임
    CGRect orignialCellViewFrame = [self.tableView frameOfCellAtColumn:0 row:row]; // 고정상태의 celView 프레임
    NSTableCellView *selectedCell = [self.tableView viewAtColumn:0 row:row makeIfNecessary:NO];
    CGRect realCellViewFrame = [selectedCell convertRect:selectedCell.bounds toView:self.tableView];
    return realCellViewFrame.origin.x - orignialCellViewFrame.origin.x;
    //
    // 스와이프로 발생한 차이를 찾는다.
}

//#pragma mark - NS_UNAVAILABLE
//+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
//- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
//- (instancetype)initWithFrame:(NSRect)frameRect { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
//- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end


//! 별거 없다. 이렇게만 하면 SnippetsLab 앱과 똑같이 작동한다.
@implementation SnippetsLabRowView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
@end
