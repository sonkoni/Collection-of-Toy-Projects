//
//  NSAttributedString+Extension.h
//
//  Created by Kwan Hyun Son on 2022/02/03.
//
// https://stackoverflow.com/questions/19584908/ios7-textkit-bullet-point-alignment/26715297#26715297
// https://stackoverflow.com/questions/66026071/how-can-i-add-uiview-to-uitextview
//! UIFontCatalog, NSFontCatalog 를 참고하자

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif
#import <BaseKit/NSString+Etc.h>


NS_ASSUME_NONNULL_BEGIN

extern MGRRegularExpStr const MGRRegularExpStrIndentType1;
extern MGRRegularExpStr const MGRRegularExpStrIndentType2;
extern MGRRegularExpStr const MGRRegularExpStrIndentType3;

@interface NSAttributedString (Extension)

- (NSDictionary <NSAttributedStringKey, id>*)mgrAttrs; // 일반적으로 전체적으로 먹여져 있을 때.

#if TARGET_OS_IPHONE
- (NSMutableAttributedString *)mgrAppendImage:(UIImage *)image;
#endif

// 인덴트에 대한 내용
- (instancetype)initWithListString:(NSString *)string
                              font:(UIFont *)font
                 regularExpression:(MGRRegularExpStr)regularExpression;
- (instancetype)initWithAttributedListString:(NSAttributedString *)attributedString
                                        font:(UIFont *)font
                           regularExpression:(MGRRegularExpStr)regularExpression;

@end

NS_ASSUME_NONNULL_END

//    (NSDictionary<NSAttributedStringKey, id> *)attrs;
    
//    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
//    paragraphStyle.lineHeightMultiple = 1.5;
    
//    NSShadow *shadow = [NSShadow new];
//    shadow.shadowColor = [UIColor blueColor];
//    shadow.shadowBlurRadius = 3.0;
//    shadow.shadowOffset = CGSizeMake(-10.0, 10.0);
    
    
//    NSParagraphStyleAttributeName : paragraphStyle
//    NSShadowAttributeName : shadow
//    NSFontAttributeName : [UIFont italicSystemFontOfSize:20]
//    NSForegroundColorAttributeName : [UIColor systemOrangeColor]
//    NSBackgroundColorAttributeName : [UIColor systemGreenColor]
    
//    NSStrokeColorAttributeName : [UIColor systemGreenColor],
//    NSStrokeWidthAttributeName : @(-5.0)  // 글자 크기의 백분율로 지정된다. 내부를 orangeColor로 채우고 stroke를 바깥에 채우려면 음수로 한다.
    
//    NSUnderlineColorAttributeName : [UIColor systemBlueColor],
//    NSUnderlineStyleAttributeName : @(NSUnderlineStyleDouble|NSUnderlineStylePatternDashDotDot)
    
//    NSStrikethroughColorAttributeName : [UIColor systemBlueColor],
//    NSStrikethroughStyleAttributeName : @(NSUnderlineStyleDouble|NSUnderlineStylePatternDashDotDot)
