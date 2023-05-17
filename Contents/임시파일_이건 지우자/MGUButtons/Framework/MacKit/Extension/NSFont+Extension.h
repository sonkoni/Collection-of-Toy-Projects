//
//  NSFont+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-01
//  ----------------------------------------------------------------------
//
// https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/Introduction/Introduction.html
// https://developer.apple.com/library/archive/documentation/TextFonts/Conceptual/CocoaTextArchitecture/FontHandling/FontHandling.html
// https://zhaoxin.pro/15918614844798.html
// https://stackoverflow.com/questions/4341243/how-do-i-determine-if-a-nsfont-is-installed-on-a-mac-osx-machine-in-objective-c
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFont (Extension)

+ (void)mgrDescription;
+ (BOOL)mgrIsFontFamilyNameInstalledInSystem:(NSString *)fontFamilyName; // 맥킨토시에 패필리폰트가 설치되어 있는가를 또는 현재 앱에 설치되어있는가
+ (BOOL)mgrIsFontNameInstalledInSystem:(NSString *)fontName; // 아래 메서드와 기능은 같다.
- (BOOL)mgrIsFontNameInstalledInSystem; // 맥킨토시에 폰트(리시버)가 설치되어 있는가 또는 현재 앱에 설치되어있는가
- (void)mgrGetFontInfo;
- (CGFloat)mgrLineHeight; // 싱글라인.


/**
 * @brief 멀티 line을 갖는 문자열을 위해 사용하는 메서드이다.
 * @param string 문자열.
 * @param width 폭
 * @param padding 정확한 너비를 측정하려면 Line Fragment Padding을 0으로 설정. (패딩은 페이지 레이아웃에서 텍스트 컨테이너의 텍스트가 그래픽과 같은 페이지의 다른 요소와 너무 가깝게 인접하는 것을 방지하는 데 사용됨.)
 * @discussion ...
 * @remark single line of text 높이에 사용하지 않는다. 애플 문서에는 싱글라인에서 NSLayoutManager 의 - defaultLineHeightForFont:메서드를 이용하라고 했지만 정확하지 않다. 내가 만든 - mgrLineHeight 메서드를 이용하라.

 * @code
        // 예제는 font가 동일하다는 전제.
        CGFloat width = textView.frame.size.width - (2 * textView.textContainerInset.width);
        CGFloat proposedHeight = [textView.font mgrHeightForString:textView.string
                                                             width:width
                                                           padding:textView.textContainer.lineFragmentPadding];
 * @endcode
 * @return ...
*/

- (float)mgrHeightForString:(NSString *)string width:(float)width padding:(float)padding;

+ (NSFont *)mgrSystemFont:(CGFloat)size weight:(NSFontWeight)weight design:(NSFontDescriptorSystemDesign)design;
+ (NSFont *)mgrSystemItalicFont:(CGFloat)size weight:(NSFontWeight)weight design:(NSFontDescriptorSystemDesign)design;
+ (NSFont *)mgrSystemPreferredFont:(NSFontTextStyle)style design:(NSFontDescriptorSystemDesign)design;

+ (NSFont *)mgrSystemPreferredFont:(NSFontTextStyle)style traits:(NSFontDescriptorSymbolicTraits)traits;
+ (NSFont *)mgrSystemPreferredFont:(NSFontTextStyle)style weight:(NSFontWeight)weight;

//! macOS 10.13+ macOS High Sierra 이상부터 사용가능. System Font를 가지고 모노, 이탤릭, 모노+이탤릭을 만든다.
+ (NSFont *)mgrMonospacedSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.13));
+ (NSFont *)mgrItalicSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.13));
+ (NSFont *)mgrMonoItalicSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight API_AVAILABLE(macos(10.13));

//! ex) 현재 폰트가 DS-Digital 또는 DS-Digital-Bold 또는 DS-Digital-Italic 또는 DS-Digital-BoldItalic 일때, 서로 서로 변경될 수 있다.
//! 단, 해당 폰트가 다 깔려 있다는 전제이다.
- (NSFont *)mgrFontWithBold:(BOOL)isBold isItalic:(BOOL)isItalic;


#pragma mark - Parsing
//! 현재 font가 두 번째 인수에 해당하는 text로 표현되었을 때, 첫 번재 인수로 주어진 사이즈 안에 들어갈 수 있는지 여부를 나타낸다.
//! 반환 값이 YES 일때에는 현재 사이즈와 line 갯수를 계산해서 넣어준다.
//! 일반적으로 너무 딱 맞게 하는 것이 부담스러울 것이다. 주어질 textField의 width에서 8.0을 빼서 넣는 것이 좋다.
- (BOOL)mgrBoundingRectWithSize:(CGSize)size
                           text:(NSString *)text
                    currentSize:(CGSize *)currentSize     // result 가 YES 일때에만 설정을 해준다.
                      lineCount:(NSUInteger *)lineCount;  // result 가 YES 일때에만 설정을 해준다.

//! 인라인(한 줄)으로 표현할 수 있는 가장 큰 폰트 사이즈를 반환한다.(최소 사이즈까지 검색했을 때에도 없다면 NSNotFound를 반환한다.)
//! 주어질 textField의 width에서 8.0을 빼서 넣는 것이 좋다.
- (NSUInteger)mgrOneLineBoundingRectWithSize:(CGSize)size
                                        text:(NSString *)text
                            maxFontPointSize:(NSUInteger)maxFontPointSize
                            minFontPointSize:(NSUInteger)minFontPointSize;
@end

NS_ASSUME_NONNULL_END
