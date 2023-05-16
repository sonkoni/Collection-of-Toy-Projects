//
//  MGUSegmentTextRenderView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSegmentTextRenderView.h"
#import "MGUSegmentConfiguration.h"

@interface MGUSegmentTextRenderView ()
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, id> *unselectedTextAttributes;
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, id> *selectedTextAttributes;
@end

@implementation MGUSegmentTextRenderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw; // 중요하다. 내부에 글자를 그리는 것이므로, 반드시 설정해줘야한다.
        MGUSegmentConfiguration *configuration = [MGUSegmentConfiguration defaultConfiguration];
        
        _font                 = configuration.titleFont;
        _selectedFont         = configuration.selectedTitleFont;
        _textColor            = configuration.titleTextColor;
        _selectedTextColor    = _textColor;
        _alignment            = configuration.alignment;
        _isSelectedTextGlowON = configuration.isSelectedTextGlowON;
        
        self.backgroundColor  = [UIColor clearColor];
        
        [self setupSelectedAttributes];
        [self setupUnselectedAttributes];
    }
    return self;
    //
    // contentMode 를 UIViewContentModeRedraw 로 반드시 설정해줘야한다. 그렇지 않으면, 애니메이션으로 늘리고 줄이는
    // 세그먼트 버튼을 만들었을 때, 원하는대로 작동하지 않을 것이다.
    // 세그먼트를 펼치거나 닫을 때, 원하는 크기로 텍스트뷰의 글자가 나오지 않을 것이다.
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext(); // 현재 컨텍스트에 그림을 그릴 것이다.
    CGContextSaveGState(context); // 그런데 인디케이터가 존재하지 않는 영역(선택되지 않은 영역)과 선택된 영역을 각각 글자를 칠해야하므로, 돌아가기 위해서는 저장을 해야한다.

    if (!CGRectIsEmpty(self.selectedTextDrawingRect)) { // 인디케이터와 겹치지 않는 영역을 고른다.
        
        //! 인디케이터가 우측에서 걸친경우 좌측 부분의 안걸친 사각형을 영역을 뽑아낸다.
        CGRect beforeMaskFrame = CGRectMake(0, 0, CGRectGetMinX(self.selectedTextDrawingRect), CGRectGetHeight(self.frame));
        //! 인디케이터가 좌측에서 걸친경우 우측 부분의 안걸친 사각형을 영역을 뽑아낸다.
        CGRect afterMaskFrame  = CGRectMake(CGRectGetMaxX(self.selectedTextDrawingRect),
                                           0,
                                           CGRectGetWidth(self.frame) - CGRectGetMaxX(self.selectedTextDrawingRect),
                                           CGRectGetHeight(self.frame));
        
        CGRect unselectedTextDrawingRects[2] = {beforeMaskFrame, afterMaskFrame};
        
        CGContextClipToRects(context, unselectedTextDrawingRects, 2);
    }

    //! 글자의 속성 딕셔너리에서 NSTextAlignmentCenter를 정해줬으므로  width는 그냥 rect를 따라가면 된다.
    //! 그러나 세로부분을 센터로 맞출 수 없으므로 글자의 heght를 뽑아낸 후, 사각형의 hegiht를 정해주고 origin.y도 옮겨야한다.
    CGFloat unselectedTextRectHeight = [self.text sizeWithAttributes:self.unselectedTextAttributes].height;
    CGRect unselectedTextDrawingRect = CGRectMake(rect.origin.x,
                                                  rect.origin.y + (rect.size.height - unselectedTextRectHeight) / 2.0f,
                                                  rect.size.width,
                                                  unselectedTextRectHeight);

    [self.text drawInRect:unselectedTextDrawingRect withAttributes:self.unselectedTextAttributes];

    CGContextRestoreGState(context); // 이제 인디케이터와 겹친영역의 글자를 칠하기 위해 돌아간다.

    if (!CGRectIsEmpty(self.selectedTextDrawingRect)) {
        CGFloat selectedTextRectHeight = [self.text sizeWithAttributes:self.selectedTextAttributes].height;
        CGRect selectedTextDrawingRect = CGRectMake(rect.origin.x,
                                                    rect.origin.y + (rect.size.height - selectedTextRectHeight) / 2.0f,
                                                    rect.size.width,
                                                    selectedTextRectHeight);
        CGContextClipToRect(context, self.selectedTextDrawingRect);

        [self.text drawInRect:selectedTextDrawingRect withAttributes:self.selectedTextAttributes];
    }
}

// 인수로 주어진 size에 가장 적합한 size를 계산하고 반환하도록 뷰에 요청한다. Api:UIKit/UIView/- sizeThatFits: 참고.
- (CGSize)sizeThatFits:(CGSize)size {
    return [self.text sizeWithAttributes:self.unselectedTextAttributes];
    //
    // 이 메서드의 디폴트의 구현은, view의 기존의 size를 돌려준다.
    // 이 메서드는, 리시버의 사이즈를 변경하지 않는다.
    // 글자의 갯수, 폰트 등을 고려하여, 가장 적절한 self의 사이즈를 반환한다. unselected 를 기준으로 한다.
    // 이 메서드는 MGUSegment의 sizeThatFits: 메서드에서 이용되며, MGUSegment의 sizeThatFits: 메서드는 MGUSegmentedControl의 sizeThatFits: 에서 이용된다.
}


#pragma mark - 세터 & 게터
- (void)setSelectedTextDrawingRect:(CGRect)selectedTextDrawingRect {
    _selectedTextDrawingRect = selectedTextDrawingRect;
    [self setNeedsDisplay];
    //
    // 현재 인케이터가 존재하는 곳을 의미한다. 따라서 이 값이 꽂아지면, drawRect: 를 호출해야한다.
}

- (void)setIsSelectedTextGlowON:(BOOL)isSelectedTextGlowON {
    _isSelectedTextGlowON = isSelectedTextGlowON;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;

    [self setupUnselectedAttributes];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    
    [self setupSelectedAttributes];
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    
    [self setupSelectedAttributes];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    [self setupUnselectedAttributes];
}

- (void)setAlignment:(NSTextAlignment)alignment {
    if(_alignment != alignment) {
        _alignment = alignment;
        [self setNeedsDisplay];
    }
}


#pragma mark - Helper
- (void)setupSelectedAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = self.alignment;
    
    NSDictionary *selectedAttributes = @{ NSFontAttributeName            : self.selectedFont,
                                          NSForegroundColorAttributeName : self.selectedTextColor,
                                          NSParagraphStyleAttributeName  : paragraphStyle };
    
    if(self.isSelectedTextGlowON == YES) {
        
        NSShadow * shadow = [NSShadow new];
        shadow.shadowColor = _selectedTextColor;
        shadow.shadowBlurRadius = 5.0f;
        shadow.shadowOffset = CGSizeZero;
        
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:selectedAttributes];
        [temp addEntriesFromDictionary:@{NSShadowAttributeName : shadow}];
        selectedAttributes = [NSDictionary dictionaryWithDictionary:temp];
    }
    
    self.selectedTextAttributes = selectedAttributes;
}

- (void)setupUnselectedAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = self.alignment;
    NSDictionary *unselectedAttributes = @{ NSFontAttributeName            : self.font,
                                            NSForegroundColorAttributeName : self.textColor,
                                            NSParagraphStyleAttributeName  : paragraphStyle };
    self.unselectedTextAttributes = unselectedAttributes;
}

@end
