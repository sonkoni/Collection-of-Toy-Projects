//
//  UILabel+Extension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-04-15
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UILabel (DynamicSize)
//! 현재 문자열에 대하여, 라벨을 만든다고 할때, 라벨의 가로와 세로를 구해준다.
//! 단, 라벨의 가로와 세로 어떤 것도 미리 정해진 기준이 없고, 문자열(및 속성)만을 고려하여 라벨을 만든다고 가정했을 때이다.
//! 개행이 없는 한 한줄짜리로 가정하고 값을 반환한다.
- (CGFloat)mgrWidthOfLabelForNormalString;
- (CGFloat)mgrHeightOfLabelForNormalString;
- (CGFloat)mgrWidthOfLabelForAttrString;
- (CGFloat)mgrHeightOfLabelForAttrString; // 글자의 높이

//! 라벨의 가로를 고정하고 세로를 결정할 때, 또는 세로를 고정하고 가로를 결정할때 사용한다.
- (CGFloat)mgrRecommendedHeightOfLabelForFixedWidth; // 라벨의 높이 (텍스트를 품었을 때의)
- (CGFloat)mgrRecommendedWidthOfLabelForFixedHeight;

/// 높이 비교를 통해서 새 라인이 필요한지 여부를 결정한다
- (BOOL)mgrNeedNewLine;


// 정리가 제대로 안되어있다. 우선 넣자. 라벨의 크기가 고정일 때, 그 세로에 맞게 폰트의 사이즈를 뽑아주는 알고리즘이다.
// https://stackoverflow.com/questions/8812192/how-to-set-font-size-to-fill-uilabel-height
// https://stackoverflow.com/questions/31768036/how-to-adjust-a-uilabel-font-size-based-on-the-height-available-to-the-label
- (UIFont *)mgrOptimisedfindAdaptiveFontWithName:(NSString *)fontName minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize;


// https://stackoverflow.com/questions/31416163/uilabel-get-current-scale-factor-when-minimumscalefactor-was-set
/*
    self.label1.text = text
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
    CGFloat scale1 = [self.label1 mgrActualScaleFactor];
 */
- (CGFloat)mgrActualScaleFactor;

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2020-04-15 : 라이브러리 정리됨
 */
