//
//  UIFont+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-03
//  ----------------------------------------------------------------------
//
// https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/Introduction/Introduction.html
// https://developer.apple.com/library/archive/documentation/TextFonts/Conceptual/CocoaTextArchitecture/FontHandling/FontHandling.html
// https://zhaoxin.pro/15918614844798.html

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Extension)

// 실제 존재하는 font 이름을 알려준다. Mac OS 는 NSFontManager로 한다.
+ (void)mgrDescription;
- (void)mgrGetFontInfo;
- (CGFloat)mgrLineHeight;

+ (UIFont *)mgrSystemFont:(CGFloat)size weight:(UIFontWeight)weight design:(UIFontDescriptorSystemDesign)design;
+ (UIFont *)mgrSystemItalicFont:(CGFloat)size weight:(UIFontWeight)weight design:(UIFontDescriptorSystemDesign)design;
+ (UIFont *)mgrSystemPreferredFont:(UIFontTextStyle)style design:(UIFontDescriptorSystemDesign)design;

+ (UIFont *)mgrSystemPreferredFont:(UIFontTextStyle)style traits:(UIFontDescriptorSymbolicTraits)traits;
+ (UIFont *)mgrSystemPreferredFont:(UIFontTextStyle)style weight:(UIFontWeight)weight;

+ (UIFont *)mgrSystemMonoFont:(CGFloat)size weight:(UIFontWeight)weight;
+ (UIFont *)mgrSystemSerifFont:(CGFloat)size weight:(UIFontWeight)weight;
+ (UIFont *)mgrSystemRoundFont:(CGFloat)size weight:(UIFontWeight)weight;
+ (UIFont *)mgrSystemItalicFont:(CGFloat)size weight:(UIFontWeight)weight;


#pragma mark - 분수 표현 방법 : 3/5 => ⅗ 또한 만약 13/5 => 1⅗ 이런방식으로 표현하려면 약간의 처리가 필요하다.

/**
 * @brief 분수식을 표현한다.
 * @param pointSize 폰트의 크기
 * @discussion 분수에 해당하는 문자열을 찾아서 그 부분을 바꿔준다. 만약
 * @remark 슬래쉬(/)가 사용된다. 애플에서 제공하는 방식이며 #import <CoreText/CoreText.h> 가 필요하다.
 * @code
        self.label.font = [UIFont mgrFractionFontOfSize:30.0 weight:UIFontWeightLight];
        self.label.text = @"The Fraction is: 23/271";
        // 12/271 => ⅗ 이런 형태로 바뀐다.
 
        NSDictionary <NSAttributedStringKey, id>*attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:20.0],
                                                                 NSForegroundColorAttributeName : [UIColor blackColor] };

        NSString *string = @"This is a mixed fraction 312/13";
        NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                         attributes:attributes];
 
        [attribString addAttributes:@{NSFontAttributeName : [UIFont mgrFractionFontOfSize:20.0]}
                              range:[string rangeOfString:@"12/13"]];
 
        self.label2.attributedText = attribString;
        // 312/13 => 3⅗ 이런 형태로 바뀐다.
 
 
 * @endcode
 * @return 분수에 해당하는 식은 이러한 형태(⅗)로 바꿔준다.
*/

+ (UIFont *)mgrFractionSystemFontOfSize:(CGFloat)pointSize;
+ (UIFont *)mgrFractionSystemFontOfSize:(CGFloat)pointSize weight:(UIFontWeight)weight;
+ (UIFont *)mgrFractionPreferredFontForTextStyle:(UIFontTextStyle)textStyle;
@end

NS_ASSUME_NONNULL_END
