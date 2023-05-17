//
//  UIFont+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIFont+Extension.h"
#import <CoreText/CoreText.h> //! kFractionsType를 쓰기 위해서 필요하다.

@implementation UIFont (Extension)

+ (void)mgrDescription {
    for(NSString *str in UIFont.familyNames){
        NSLog(@"%@", str);
        for(NSString *x in [UIFont fontNamesForFamilyName:str]) {
            NSLog(@"==> %@", x);
        }
    }
}

- (void)mgrGetFontInfo {
    // https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/Introduction/Introduction.html
    // https://developer.apple.com/library/archive/documentation/TextFonts/Conceptual/CocoaTextArchitecture/FontHandling/FontHandling.html
    // https://zhaoxin.pro/15918614844798.html
    
//    NSLog(@"font ascender: %f", self.ascender); // <- iOS에서 정확한 값이 안나온다.
//    NSLog(@"font descender: %f", self.descender);
//    NSLog(@"font leading: %f", self.leading);
//    NSLog(@"font line height: %f", self.ascender - self.descender + self.leading); // 또는 self.lineHeight
    
//    이렇게도 가능하다. iOS 에서도 사용할 수 있음. 위의 식은 iOS 에서 정확한 값이 안나온다.
//    애플한테 질문했더니 Core Text이용하라고 했지만, 거기에도 height 바로뽑아 주는 함수는 없다.
//    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)(self.fontName), self.pointSize, NULL);
//    시스템폰트는 바로 윗줄처럼 이름으로 부르는게 금지라서 단순 브릿지가 더 낫다.
    CTFontRef font = (__bridge CTFontRef)self;
    CGFloat ascent = CTFontGetAscent(font);
    CGFloat descent = CTFontGetDescent(font);
    CGFloat leading = CTFontGetLeading(font);
    NSLog(@"font ascender: %f", ascent);
    NSLog(@"font descender: %f", descent);
    NSLog(@"font leading: %f", leading);
    NSLog(@"font line height: %f", ascent + descent + leading);
}

- (CGFloat)mgrLineHeight {
    //    return self.ascender - self.descender + self.leading; iOS에서 self.ascender에 문제가 있다.
    //    이렇게도 가능하다. iOS 에서도 사용할 수 있음.
    //    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)(self.fontName), self.pointSize, NULL);
    //    시스템폰트는 바로 윗줄처럼 이름으로 부르는게 금지라서 단순 브릿지가 더 낫다.
    CTFontRef ctFont = (__bridge CTFontRef)self;
    return CTFontGetAscent(ctFont) + CTFontGetDescent(ctFont) + CTFontGetLeading(ctFont);
}


+ (UIFont *)mgrSystemFont:(CGFloat)size weight:(UIFontWeight)weight design:(UIFontDescriptorSystemDesign)design {
    UIFontDescriptor *fontDescriptor = [[UIFont systemFontOfSize:size weight:weight] fontDescriptor];
    UIFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:design];
    if (designFontDescriptor) {
        return [UIFont fontWithDescriptor:designFontDescriptor size:0.f];
    }
    return [UIFont fontWithDescriptor:fontDescriptor size:0.0f];
}

+ (UIFont *)mgrSystemItalicFont:(CGFloat)size weight:(UIFontWeight)weight design:(UIFontDescriptorSystemDesign)design {
    UIFontDescriptor *fontDescriptor = [[UIFont systemFontOfSize:size weight:weight] fontDescriptor];
    UIFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:design];
    UIFontDescriptor *italicFontDescriptor = [designFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    if (italicFontDescriptor) {
        return [UIFont fontWithDescriptor:italicFontDescriptor size:0.f];
    } else if (designFontDescriptor) {
        return [UIFont fontWithDescriptor:designFontDescriptor size:0.f];
    }
    return [UIFont fontWithDescriptor:fontDescriptor size:0.0f];
}

+ (UIFont *)mgrSystemPreferredFont:(UIFontTextStyle)style design:(UIFontDescriptorSystemDesign)design {
    UIFontDescriptor *fontDescriptor = [[UIFont preferredFontForTextStyle:style] fontDescriptor];
    UIFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:design];
    if (designFontDescriptor) {
        return [UIFont fontWithDescriptor:designFontDescriptor size:0.f];
    }
    return [UIFont fontWithDescriptor:fontDescriptor size:0.0f];
}

+ (UIFont *)mgrSystemPreferredFont:(UIFontTextStyle)style traits:(UIFontDescriptorSymbolicTraits)traits {
    UIFont *font = [UIFont preferredFontForTextStyle:style];
    UIFontDescriptor *descriptor =
    [font.fontDescriptor fontDescriptorWithSymbolicTraits:[font.fontDescriptor symbolicTraits]|traits];
    return [UIFont fontWithDescriptor:descriptor size:0.0];
}

+ (UIFont *)mgrSystemPreferredFont:(UIFontTextStyle)style weight:(UIFontWeight)weight {
    UIFont *font = [UIFont preferredFontForTextStyle:style];
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    NSDictionary <UIFontDescriptorAttributeName,id>*attributes =
    @{UIFontDescriptorTraitsAttribute : @{UIFontWeightTrait : @(weight)}};
    fontDescriptor = [fontDescriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:0.0];
}

+ (UIFont *)mgrSystemMonoFont:(CGFloat)size weight:(UIFontWeight)weight {
    return [UIFont mgrSystemFont:size weight:weight design:UIFontDescriptorSystemDesignMonospaced];
}

+ (UIFont *)mgrSystemSerifFont:(CGFloat)size weight:(UIFontWeight)weight {
    return [UIFont mgrSystemFont:size weight:weight design:UIFontDescriptorSystemDesignSerif];
}

+ (UIFont *)mgrSystemRoundFont:(CGFloat)size weight:(UIFontWeight)weight {
    return [UIFont mgrSystemFont:size weight:weight design:UIFontDescriptorSystemDesignRounded];
}

+ (UIFont *)mgrSystemItalicFont:(CGFloat)size weight:(UIFontWeight)weight {
    return [UIFont mgrSystemItalicFont:size weight:weight design:UIFontDescriptorSystemDesignDefault];
}


#pragma mark - 분수 표현 방법
+ (UIFont *)mgrFractionSystemFontOfSize:(CGFloat)pointSize {
    UIFontDescriptor *systemFontDesc = [UIFont systemFontOfSize:pointSize].fontDescriptor;
    
    NSDictionary <UIFontDescriptorAttributeName, id> *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute : @[@{
                                                         UIFontFeatureTypeIdentifierKey   : @(kFractionsType),
                                                         UIFontFeatureSelectorIdentifierKey : @(kDiagonalFractionsSelector)
                                                     }]
        };
    
    
    UIFontDescriptor *fractionFontDesc = [systemFontDesc fontDescriptorByAddingAttributes:attributes];
    
    return [UIFont fontWithDescriptor:fractionFontDesc size:pointSize];
}

+ (UIFont *)mgrFractionSystemFontOfSize:(CGFloat)pointSize weight:(UIFontWeight)weight {
    UIFontDescriptor *systemFontDesc = [UIFont systemFontOfSize:pointSize weight:weight].fontDescriptor;
    
    NSDictionary <UIFontDescriptorAttributeName, id> *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute : @[@{
                                                         UIFontFeatureTypeIdentifierKey   : @(kFractionsType),
                                                         UIFontFeatureSelectorIdentifierKey : @(kDiagonalFractionsSelector)
                                                     }]
        };
    
    
    UIFontDescriptor *fractionFontDesc = [systemFontDesc fontDescriptorByAddingAttributes:attributes];
    
    return [UIFont fontWithDescriptor:fractionFontDesc size:pointSize];
}

+ (UIFont *)mgrFractionPreferredFontForTextStyle:(UIFontTextStyle)textStyle {
    
    UIFont *font = [UIFont preferredFontForTextStyle:textStyle];
    UIFontDescriptor *descriptor = font.fontDescriptor;
    NSDictionary <UIFontDescriptorAttributeName, id>*attributes = @{
        UIFontDescriptorFeatureSettingsAttribute : @[@{
                                                         UIFontFeatureTypeIdentifierKey   : @(kFractionsType),
                                                         UIFontFeatureSelectorIdentifierKey : @(kDiagonalFractionsSelector)
                                                     }]
        };
    
    descriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:descriptor size:font.pointSize];
}

@end
