//
//  NSFont+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSFont+Extension.h"
#import <CoreText/CoreText.h> //! kFractionsType를 쓰기 위해서 필요하다. + mgrDescription 사용.

@implementation NSFont (Extension)

+ (void)mgrDescription {
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    for (NSString *family in fontManager.availableFontFamilies) {
        NSLog(@"family Name : %@", family);
        NSArray <NSArray *>*fonts = [fontManager availableMembersOfFontFamily:family];
        for (NSArray *font in fonts){
            NSLog(@"font => %@", font);
        }
    }
}

+ (BOOL)mgrIsFontFamilyNameInstalledInSystem:(NSString *)fontFamilyName {
    if (fontFamilyName == nil) {
        NSCAssert(FALSE, @"이름을 넣으라고 미친놈아!");
        return NO;
    }

    NSFontDescriptor *fontDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontFamilyAttribute:fontFamilyName}];
    NSArray <NSFontDescriptor *>*matches = [fontDescriptor matchingFontDescriptorsWithMandatoryKeys:nil];
    return ([matches count] > 0);

    /** 이 방식도 가능할 듯
    NSArray <NSString *>*availableFontFamilies = [NSFontManager sharedFontManager].availableFontFamilies;
    return [availableFontFamilies containsObject:fontFamilyName];
     */
}

+ (BOOL)mgrIsFontNameInstalledInSystem:(NSString *)fontName {
    if (fontName == nil) {
        NSCAssert(FALSE, @"이름을 넣으라고 미친놈아!");
        return NO;
    }

    NSFontDescriptor *fontDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontNameAttribute:fontName}];
    NSArray <NSFontDescriptor *>*matches = [fontDescriptor matchingFontDescriptorsWithMandatoryKeys:nil];
    return ([matches count] > 0);
    
    /** 이 방식도 가능할 듯
    NSArray <NSString *>*availableFonts = [NSFontManager sharedFontManager].availableFonts;
    return [availableFonts containsObject:fontName];
    */
}

- (BOOL)mgrIsFontNameInstalledInSystem {
    if (self.fontName == nil) {
        return NO;
    }

    NSFontDescriptor *fontDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontNameAttribute:self.fontName}];
    NSArray <NSFontDescriptor *>*matches = [fontDescriptor matchingFontDescriptorsWithMandatoryKeys: nil];
    return ([matches count] > 0);
    
    /** 이 방식도 가능할 듯
    NSArray <NSString *>*availableFonts = [NSFontManager sharedFontManager].availableFonts;
    return [availableFonts containsObject:self.fontName];
     */
}


- (void)mgrGetFontInfo {
    // https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/Introduction/Introduction.html
    // https://developer.apple.com/library/archive/documentation/TextFonts/Conceptual/CocoaTextArchitecture/FontHandling/FontHandling.html
    // https://zhaoxin.pro/15918614844798.html
//    NSLog(@"font ascender: %f", self.ascender); <- iOS에서 정확한 값이 안나온다.
//    NSLog(@"font descender: %f", self.descender);
//    NSLog(@"font leading: %f", self.leading);
//    NSLog(@"font line height: %f", self.ascender - self.descender + self.leading);
//
//    NSLayoutManager *layoutManager = [NSLayoutManager new];
//    NSLog(@"font line height: %f", [layoutManager defaultLineHeightForFont:self]); Mac에서만 사용가능하지만 제대로 작동도 않는다.

    
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

- (float)mgrHeightForString:(NSString *)string width:(float)width padding:(float)padding {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(width, FLT_MAX)];
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    [textStorage addAttribute:NSFontAttributeName value:self range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:padding]; // 정확한 너비를 측정하려면 Line Fragment Padding을 0으로 설정. (패딩은 페이지 레이아웃에서 텍스트 컨테이너의 텍스트가 그래픽과 같은 페이지의 다른 요소와 너무 가깝게 인접하는 것을 방지하는 데 사용됨.)
    
    (void) [layoutManager glyphRangeForTextContainer:textContainer]; // layoutManager 은 layout을 lazily하게 수행하므로, 반환되는 NSRange가 필요치 않더라도 이 메서드로 텍스트 레이아웃을 강제해야한다.
    return [layoutManager usedRectForTextContainer:textContainer].size.height;
}

+ (NSFont *)mgrSystemFont:(CGFloat)size weight:(NSFontWeight)weight design:(NSFontDescriptorSystemDesign)design {
    NSFontDescriptor *fontDescriptor = [[NSFont systemFontOfSize:size weight:weight] fontDescriptor];
    NSFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:design];
    if (designFontDescriptor) {
        return [NSFont fontWithDescriptor:designFontDescriptor size:0.0];
    }
    return [NSFont fontWithDescriptor:fontDescriptor size:0.0];
}

+ (NSFont *)mgrSystemItalicFont:(CGFloat)size weight:(NSFontWeight)weight design:(NSFontDescriptorSystemDesign)design {
    NSFontDescriptor *fontDescriptor = [[NSFont systemFontOfSize:size weight:weight] fontDescriptor];
    NSFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:design];
    NSFontDescriptor *italicFontDescriptor = [designFontDescriptor fontDescriptorWithSymbolicTraits:NSFontDescriptorTraitItalic];
    if (italicFontDescriptor) {
        return [NSFont fontWithDescriptor:italicFontDescriptor size:size];
    } else if (designFontDescriptor) {
        return [NSFont fontWithDescriptor:designFontDescriptor size:size];
    }
    return [NSFont fontWithDescriptor:fontDescriptor size:size];
}

+ (NSFont *)mgrSystemPreferredFont:(NSFontTextStyle)style design:(NSFontDescriptorSystemDesign)design {
    // NSFontTextStyleOptionKey 에대한 정보가 없다.
    NSFontDescriptor *fontDescriptor = [[NSFont preferredFontForTextStyle:style options:@{}] fontDescriptor];
    NSFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:design];
    if (designFontDescriptor) {
        return [NSFont fontWithDescriptor:designFontDescriptor size:0.0];
    }
    return [NSFont fontWithDescriptor:fontDescriptor size:0.0];
}

+ (NSFont *)mgrSystemPreferredFont:(NSFontTextStyle)style traits:(NSFontDescriptorSymbolicTraits)traits {
    NSFont *font = [NSFont preferredFontForTextStyle:style options:@{}];
    NSFontDescriptor *descriptor =
    [font.fontDescriptor fontDescriptorWithSymbolicTraits:[font.fontDescriptor symbolicTraits]|traits];
    return [NSFont fontWithDescriptor:descriptor size:0.0];
}

+ (NSFont *)mgrSystemPreferredFont:(NSFontTextStyle)style weight:(NSFontWeight)weight {
    NSFont *font = [NSFont preferredFontForTextStyle:style options:@{}];
    NSFontDescriptor *fontDescriptor = font.fontDescriptor;
    NSDictionary <NSFontDescriptorAttributeName,id>*attributes =
    @{NSFontTraitsAttribute : @{NSFontWeightTrait : @(weight)}};
    fontDescriptor = [fontDescriptor fontDescriptorByAddingAttributes:attributes];
    return [NSFont fontWithDescriptor:fontDescriptor size:0.0];
}


+ (NSFont *)mgrMonospacedSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight {
    if (@available(macOS 10.15, *)) {
        return [NSFont monospacedSystemFontOfSize:fontSize weight:weight];
    } else {
        // NSFontDescriptorTraitMonoSpace 값이 macOS 10.13+ 부터 사용가능.
        NSFont *font = [NSFont systemFontOfSize:fontSize weight:weight]; // macOS 10.11+
        NSFontDescriptor *styleDescriptor =
        [font.fontDescriptor fontDescriptorWithSymbolicTraits:[font.fontDescriptor symbolicTraits]|NSFontDescriptorTraitMonoSpace];
        return [NSFont fontWithDescriptor:styleDescriptor size:font.pointSize];
    }
}

+ (NSFont *)mgrItalicSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight {
    NSFont *font = [NSFont systemFontOfSize:fontSize weight:weight]; // macOS 10.11+
    NSFontDescriptor *styleDescriptor =
    [font.fontDescriptor fontDescriptorWithSymbolicTraits:[font.fontDescriptor symbolicTraits]|NSFontDescriptorTraitItalic];
    return [NSFont fontWithDescriptor:styleDescriptor size:font.pointSize];
}

+ (NSFont *)mgrMonoItalicSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight {
    NSFont *font = [NSFont systemFontOfSize:fontSize weight:weight]; // macOS 10.11+
    NSFontDescriptor *styleDescriptor =
    [font.fontDescriptor fontDescriptorWithSymbolicTraits:[font.fontDescriptor symbolicTraits]|NSFontDescriptorTraitMonoSpace|NSFontDescriptorTraitItalic];
    return [NSFont fontWithDescriptor:styleDescriptor size:font.pointSize];
}

- (NSFont *)mgrFontWithBold:(BOOL)isBold isItalic:(BOOL)isItalic {
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *font;
    if (isBold == YES) {
        font = [fontManager convertFont:self toHaveTrait:NSBoldFontMask];
    } else {
        font = [fontManager convertFont:self toNotHaveTrait:NSBoldFontMask];
    }
    if (isItalic == YES) {
        font = [fontManager convertFont:font toHaveTrait:NSItalicFontMask];
    } else {
        font = [fontManager convertFont:font toNotHaveTrait:NSItalicFontMask];
    }

    return font;
    //
    /** NSFontDescriptor를 통해서도 가능하다.
    NSFontDescriptorSymbolicTraits symbolicTraits = [self.fontDescriptor symbolicTraits] | NSFontDescriptorTraitBold | NSFontDescriptorTraitItalic; // 기존 성질에다가 볼드와 이탤릭을 더한다.
    if (isBold == NO) {
        symbolicTraits = symbolicTraits ^ NSFontDescriptorTraitBold; // Bold 제외
    }
    if (isItalic == NO) {
        symbolicTraits = symbolicTraits ^ NSFontDescriptorTraitItalic; // Italic 제외
    }
    
    NSFontDescriptor *fontDescriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits];
    return [NSFont fontWithDescriptor:fontDescriptor size:self.pointSize];
    
    //! 다음과 같이 NSFontDescriptor를 최초에 직접 만들어서 시작할 수도 있다.
    NSFontDescriptor *fontDescriptor = [NSFontDescriptor fontDescriptorWithName:@"Menlo" size:25.0];
    NSFontDescriptorSymbolicTraits symbolicTraits = [fontDescriptor symbolicTraits] | NSFontDescriptorTraitBold | NSFontDescriptorTraitItalic; // 기존 성질에다가 볼드와 이탤릭을 더한다.
    if (isBold == NO) {
        symbolicTraits = symbolicTraits ^ NSFontDescriptorTraitBold; // Bold 제외
    }
    if (isItalic == NO) {
        symbolicTraits = symbolicTraits ^ NSFontDescriptorTraitItalic; // Italic 제외
    }
    NSFontDescriptor *resultDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits];
    return [NSFont fontWithDescriptor:resultDescriptor size:fontDescriptor.pointSize];
    */
}


#pragma mark - Parsing
- (BOOL)mgrBoundingRectWithSize:(CGSize)size
                           text:(NSString *)text
                    currentSize:(CGSize *)currentSize
                      lineCount:(NSUInteger *)lineCount {
    CGRect currentFrame = [text boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:self}
                                             context:nil];
    CGRect destFrame = CGRectMake(0.0, 0.0, size.width, size.height);
    BOOL result = CGRectContainsRect(destFrame, currentFrame);
    if (result == YES) {
        *currentSize = CGSizeMake(currentFrame.size.width, currentFrame.size.height);
        *lineCount = (NSInteger)(floor((currentFrame.size.height + 2.0) / [self mgrLineHeight])); // 지랄 같은 오차가 존재한다.
    }
    return result;
}

- (NSUInteger)mgrOneLineBoundingRectWithSize:(CGSize)size
                                        text:(NSString *)text
                            maxFontPointSize:(NSUInteger)maxFontPointSize
                            minFontPointSize:(NSUInteger)minFontPointSize {
    NSUInteger result = NSNotFound;
//    NSFont *maxFont = [self fontWithSize:(CGFloat)maxFontPointSize];
    NSFont *minFont = [self fontWithSize:(CGFloat)minFontPointSize];
    // 최소롤 테스트를 했을 때에도 1라인 이 안되면 그냥 나가면된다.
    CGSize currentSize = CGSizeZero;
    NSUInteger lineCount = NSNotFound;
    BOOL contain = [minFont mgrBoundingRectWithSize:size text:text currentSize:&currentSize lineCount:&lineCount];
    if (contain == NO || lineCount != 1) { // 최대한 작게해도 넘친다. 아니면 1줄을 넘어간다.
        return result;
    }
    for (NSInteger i = maxFontPointSize; i >= minFontPointSize; i--) {
        NSFont *tempFont = [self fontWithSize:i];
        BOOL isContain = [tempFont mgrBoundingRectWithSize:size
                                                      text:text
                                               currentSize:&currentSize
                                                 lineCount:&lineCount];
        if (isContain == YES && lineCount == 1) {
            result = i;
            break;
        }
    }
    return result;
}
@end
