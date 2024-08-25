//
//  UIButton+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)

// 터치 다운 시, 하이라이트를 막고 싶다면 마지막 인자에 YES를 대입하라
// 제대로 된 효과를 보려면 버튼의 타입은 커스텀, 스타일은 디폴트이다.
- (void)mgrSetSelectedImage:(nullable UIImage *)selectedImage
                normalImage:(nullable UIImage *)normalImage
           preventHighlight:(BOOL)preventHighlight;

// 셀렉션, 언셀렉션 토글 시에 타이틀이 터치다운에서 미리 변화해버려서 혼란스운 일을 방지한다
- (void)mgrSetNormalTitle:(NSString *)normalTitle
            selectedTitle:(NSString *)selectedTitle
              normalColor:(UIColor *)normalColor // normalTitle, selectedTitle 에 적용
           highlightColor:(UIColor *)highlightColor; // 터치다운 시 적용될 색
@end

@interface UIButton (Shrink)

//! 카테고리를 가장한 서브 클래스를 반환한다. 기능이 shrink밖에 없다. 0.1 보다 작은 값이 오면 디폴트로 0.85로 설정한다.
+ (UIButton *)mgrShinkButton:(CGFloat)scale;

@end

@interface UIButton (Template)

// 애플의 칼라 피커에 사용되는 X 버튼과 유사한 버튼템플릿
// UIAction *action = [UIAction actionWithHandler:^(UIAction *action) {
//     [self dismissViewControllerAnimated:YES completion:^{}];
// }];
//
//
// UIButton *button = [UIButton buttonWithType:UIButtonTypeClose]; iOS 13
// button.translatesAutoresizingMaskIntoConstraints = NO;
// [button.widthAnchor constraintEqualToConstant:30.0].active = YES;
// [button.heightAnchor constraintEqualToConstant:30.0].active = YES;
+ (instancetype)mgrXmarkCircleFillButtonWithAction:(UIAction *)action API_AVAILABLE(ios(15.0));

@end

NS_ASSUME_NONNULL_END
