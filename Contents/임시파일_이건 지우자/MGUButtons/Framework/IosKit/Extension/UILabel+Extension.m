//
//  UILabel+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (DynamicSize)

#pragma mark - NSString
- (CGFloat)mgrHeightOfLabelForNormalString {
    // width를 넣었지만, 글자가 width를 삐져나온다고 상상하고, 글자 높이를 구한다고 생각하자.
    CGSize stringSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName : self.font}
                                                context:nil].size;
    return stringSize.height;
}

- (CGFloat)mgrWidthOfLabelForNormalString {
    CGSize  stringSize = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : self.font}
                                                  context:nil].size;
    return stringSize.width;
}


#pragma mark - NSAttributedString
- (CGFloat)mgrHeightOfLabelForAttrString {
    // width를 넣었지만, 글자가 width를 삐져나온다고 상상하고, 글자 높이를 구한다고 생각하자.
    CGSize stringSize = [self.attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil].size;
    return stringSize.height;
    //
    // self.font.lineHeight는 유사한 효과를 가지고 있지만, 최초 등장하는 글자의 font만 가져온다는 치명적인 단점이 있다.
}

- (CGFloat)mgrWidthOfLabelForAttrString {
    CGSize  stringSize = [self.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil].size;
    return stringSize.width;
}


#pragma mark - 라벨의 가로를 고정하고 세로를 결정할 때, 또는 세로를 고정하고 가로를 결정할때 사용한다.
- (CGFloat)mgrRecommendedHeightOfLabelForFixedWidth {
    // 라벨의 높이 (텍스트를 품었을 때의)
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    return size.height;
}

- (CGFloat)mgrRecommendedWidthOfLabelForFixedHeight {
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)];
    return size.width;
}


#pragma mark - 개행의 필요성 확인 메서드
// 높이 비교를 통해서 새 라인이 필요한지 여부를 결정한다
- (BOOL)mgrNeedNewLine {
    NSUInteger recommendedHeight = (NSUInteger)round([self mgrRecommendedHeightOfLabelForFixedWidth]); // 라벨의 높이
    NSUInteger stringHeight = (NSUInteger)round([self mgrHeightOfLabelForAttrString]); // 글자의 높이
    return (recommendedHeight > stringHeight);
    //
    //
    //    if (recommendedHeight > stringHeight) {
    //        return YES;
    //    } else {
    //        return NO;
    //    }
}


#pragma mark - 아직 검토가 필요할듯.
- (UIFont *)mgrOptimisedfindAdaptiveFontWithName:(NSString *)fontName minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize {
    UIFont *tempFont;
    CGFloat tempMax = maxSize;
    CGFloat tempMin = minSize;
    
    while (ceil(tempMin) != ceil(tempMax)) {
        CGFloat testedSize = (tempMax + tempMin) / 2.0;
        tempFont = [UIFont fontWithName:fontName size:testedSize];
        NSDictionary *attributes = @{ NSFontAttributeName : tempFont};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
        
        CGRect textFrame = [attributedString boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil];

        CGFloat difference = self.frame.size.height - textFrame.size.height;
//        println("\(tempMin)-\(tempMax) - tested : \(testedSize) --> difference : \(difference)")
        if(difference > 0.0){
            tempMin = testedSize;
        } else {
            tempMax = testedSize;
        }
    }
        //returning the size -1 (to have enought space right and left)
    return [UIFont fontWithName:fontName size:tempMin - 1.0];
}

- (CGFloat)mgrActualScaleFactor {
    NSAttributedString *attributedText = self.attributedText;
    if (attributedText == nil) {
        return self.font.pointSize;
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    NSDictionary <NSAttributedStringKey, id>*textAttributes =
    @{NSFontAttributeName:self.font};
    [text setAttributes:textAttributes range:NSMakeRange(0, text.length)];
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = self.minimumScaleFactor;
    [text boundingRectWithSize:self.frame.size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       context:context];
    return context.actualScaleFactor;
}

@end

/**
 #define DISPLAY_FONT_MINIMUM 6
 #define DISPLAY_FONT_MAXIMUM 150
 
- (UIFont*)fontToFitHeight {
    float minimumFontSize = DISPLAY_FONT_MINIMUM;
    float maximumFontSize = DISPLAY_FONT_MAXIMUM;
    float fontSizeAverage = 0;
    float textAndLabelHeightDifference = 0;

    while(minimumFontSize <= maximumFontSize){
        fontSizeAverage = minimumFontSize + (maximumFontSize - minimumFontSize) / 2;
        if(self.text){
            float labelHeight = self.frame.size.height;
            float testStringHeight = [self.text sizeWithAttributes:@{
                                                                NSFontAttributeName: [self.font fontWithSize:fontSizeAverage]
                                                                }].height;

            textAndLabelHeightDifference = labelHeight - testStringHeight;

            if(fontSizeAverage == minimumFontSize || fontSizeAverage == maximumFontSize){
                return [self.font fontWithSize:fontSizeAverage- (textAndLabelHeightDifference < 0)];
            }
            if(textAndLabelHeightDifference < 0){
                maximumFontSize = fontSizeAverage - 1;
            }
            else if(textAndLabelHeightDifference > 0){
                minimumFontSize = fontSizeAverage + 1;
            }
            else{
                return [self.font fontWithSize:fontSizeAverage];
            }
        }
        else {
            break; //Prevent infinite loop
        }
    }
    return [self.font fontWithSize:fontSizeAverage-2];
}
*/

/** 잘 못 만든 것 같다.
- (UIFont *)mgrOptimisedfindAdaptiveFontWithName:(NSString *)fontName
                                         minSize:(CGFloat)minSize
                                         maxSize:(CGFloat)maxSize {
    UIFont *tempFont;
    CGFloat tempMax = maxSize;
    CGFloat tempMin = minSize;
    
    while (ceil(tempMin) != ceil(tempMax)) {
        CGFloat testedSize = (tempMax + tempMin) / 2.0;
        tempFont = [UIFont fontWithName:fontName size:testedSize];
        NSDictionary *attributes = @{ NSFontAttributeName : tempFont};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
        CGRect textFrame = [attributedString boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil];
        
        CGFloat difference = textFrame.size.height - testedSize;
        if (ABS(difference) > FLT_EPSILON) {
            tempMax = testedSize;
        } else {
            tempMin = testedSize;
        }
    }
        
        //returning the size -1 (to have enought space right and left)
//    return [UIFont fontWithName:fontName size:tempMin - 1.0];
    return [UIFont fontWithName:fontName size:floor(tempMin)];
}
 */
