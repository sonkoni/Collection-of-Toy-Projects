//
//  MGALabel+Mulgrim.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGALabel+Extension.h"


#pragma mark - Private Class
@interface _MGAVerticallyCenterLabel : MGALabel
#pragma mark - NS_UNAVAILABLE
+ (instancetype)mgrVerticallyCenterLabelWithString:(NSString *)str NS_UNAVAILABLE;
+ (instancetype)mgrVerticallyCenterMultiLineLabelWithString:(NSString *)str NS_UNAVAILABLE;
@end

@interface _MGAVerticallyCenterLabelCell : NSTextFieldCell
@end
@implementation _MGAVerticallyCenterLabelCell
- (NSRect)titleRectForBounds:(NSRect)cellRect {
    CGFloat frameHeight = cellRect.size.height;
    CGFloat textHeight = [self cellSizeForBounds:cellRect].height; // 텍스트의 높이를 추정한다.
    CGFloat originY = (frameHeight - textHeight) / 2.0; //! vertically center를 위해.
    CGRect newFrame = cellRect;
    newFrame.origin.y = originY;
    return newFrame;
}

// 반드시 필요함...
- (void)editWithFrame:(NSRect)aRect
               inView:(_MGAVerticallyCenterLabel *)controlView
               editor:(NSText*)textObj
             delegate:(id)anObject
                event:(NSEvent*)theEvent {
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super editWithFrame:textFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}
//
- (void)selectWithFrame:(NSRect)aRect
                 inView:(_MGAVerticallyCenterLabel *)controlView
                 editor:(NSText *)textObj
               delegate:(id)anObject
                  start:(NSInteger)selStart
                 length:(NSInteger)selLength {
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super selectWithFrame:textFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

//! 리시버의 내부 요소 (이미지, 텍스트)를 그린다. (보더는 아니다.)
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(_MGAVerticallyCenterLabel *)controlView {
    NSRect textFrame = [self titleRectForBounds:cellFrame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
}
@end
@implementation _MGAVerticallyCenterLabel
+ (Class)cellClass {
    return [_MGAVerticallyCenterLabelCell class];
}
@end

@implementation MGALabel (Extension)
#pragma mark - 서브클래스
+ (instancetype)mgrVerticallyCenterLabelWithString:(NSString *)str {
    return [_MGAVerticallyCenterLabel mgrLabelWithString:str];
}
+ (instancetype)mgrVerticallyCenterMultiLineLabelWithString:(NSString *)str {
    return [_MGAVerticallyCenterLabel mgrMultiLineLabelWithString:str];
}

@end
