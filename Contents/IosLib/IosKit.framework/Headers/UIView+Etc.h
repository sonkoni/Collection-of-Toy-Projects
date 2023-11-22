//
//  UIView+Etc.h
//
//  Created by Kwan Hyun Son on 26/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Etc)

/**
 * @brief 앱에서 아랍어를 지원하고, 아랍어로 앱이 구동되었다면 방향을 찾을 수 있다.
 * @discussion 아랍어를 지원하는 앱에서 아랍어와 같은 방향으로 언어가 구성되어있다면 YES이다.
 * @remark NO가 일반적인 상황이다.
 * @code
    if ([self mgrIsRTLLocale] == YES) {
        // 아랍어 같은 방향이다.
    }
 * @endcode
 * @return 아랍어처럼 Right to Left 이면 YES, 일반적인 언어라면, NO. 단, 앱 자체에서 아랍어를 제공해야한다.
*/
- (BOOL)mgrIsRTLLocale;

//! 사용해서는 안될 듯. 이것은 디버깅용이다. 메모리 상태의 뷰를 카피한다. 예전에는 사용했지만, 지금은 금지된듯.
//! https://developer.apple.com/forums/thread/681266
//! https://stackoverflow.com/questions/67776944/nssecurecoding-writing-uiview-to-disk
- (__kindof UIView *)mgrCopyView;

// 손가락이 터치되었을 시, 가장 가까운 뷰를 찾아준다.
//
// [self addTarget:self action:@selector(buttonClicked:forEvent:) forControlEvents:UIControlEventTouchUpInside];
//
// - (void)buttonClicked:(id)sender forEvent:(UIEvent *)event {
//     UITouch *touch = [[event allTouches] anyObject];
//     CGPoint touchPoint = [touch locationInView:self]; // 터치한 위치를 가져오기
//     UIView *view = [self mgrFindClosestViewToPoint:touchPoint views:viewList];
//     if (self.selectedIndex != view.tag) {
//         self.selectedIndex = view.tag;
//         [self sendActionsForControlEvents:UIControlEventValueChanged];
//     }
// }
- (UIView *)mgrFindClosestViewToPoint:(CGPoint)point views:(NSArray <UIView *>*)views;

@end

NS_ASSUME_NONNULL_END
