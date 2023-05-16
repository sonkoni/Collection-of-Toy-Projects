//
//  MGUSimplePopController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGUSimplePopController
 @abstract      심플한 말풍선을 표기할 수 있는 Popup Controller이다.
 @discussion    다른 추가 기능은 없다. 말풍선 주변을 터치했을 때, 발동할 핸들러만 넣을 수 있다.
*/
@interface MGUSimplePopController : UIViewController

/**
 * @brief 이 메서드만 사용하면된다. 아무것도 이용하지 않는다.
 * @param message 말풍선에 적힐 NSAttributedString 객체이다.
 * @param backgroundColor 말풍선의 색에 해당한다.
 * @param barButtonItem 말풍선이 나올 위치가 UIBarButtonItem 객체라면 여기에 그 객체를 넣어야한다.
 * @param sourceView 말풍선이 나올 위치가 UIView 의 서브클래스라면 객체라면 여기에 그 객체를 넣어야한다.
 * @param sourceRect sourceView를 지정했을 때 거기에서 디테일하게 bounds를 정해 줄 수도 있다. 일반적으로
 * @param arrowDirection 말풍선이 나오는 방향. 뾰족한 부분의 방향이다.
 * @param completionBlock 말풍선의 외부를 터치했을 때, 발동하고 싶은 블락이 있다면 넣어라.
 * @discussion 오직 이 메서드만 이용하면된다.
 * @remark barButtonItem 매개변수와 sourceView변수 둘 중에 하나는 반드시 설정해야한다. sourceRect는 sourceView를 이용할 때만 사용된다.
 * @code
        NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"안녕"];
        MGUSimplePopController *pv = [[MGUSimplePopController alloc] initWithMessage:message
                                                                     backgroundColor:[UIColor yellowColor]
                                                                       barButtonItem:nil
                                                                          sourceView:self.topRightButton
                                                                          sourceRect:self.topRightButton.bounds
                                                                      arrowDirection:UIPopoverArrowDirectionAny
                                                                          completion:nil];
 
        // 화면 끝에서 팝오버가 나오면 한쪽 끝이 날카로워지는 문제가 발생할 수 있다. 상황에 따라서 적절히 처리해준다.
        pv.popoverPresentationController.popoverLayoutMargins = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0);
        [self presentViewController:pv animated:YES completion:nil];
        // 이게 끝이다.
 * @endcode
 * @return 이동되어야할 view의 center 좌표를 반환한다.
*/
- (instancetype)initWithMessage:(NSAttributedString *)message
                backgroundColor:(nullable UIColor *)backgroundColor
                  barButtonItem:(nullable UIBarButtonItem *)barButtonItem
                     sourceView:(nullable UIView *)sourceView
                     sourceRect:(CGRect)sourceRect
                 arrowDirection:(UIPopoverArrowDirection)arrowDirection
                     completion:(void(^_Nullable)(void))completionBlock NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

/* ex : Mini Timer
- (IBAction)buttonClicked:(UIButton *)sender {
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"즐겨찾기를 등록하려면, 먼저 시간을 맞추세요."];
    CGRect sourceRect = CGRectMake(sender.bounds.origin.x,
                                   sender.bounds.origin.y - 8.0,
                                   sender.bounds.size.width,
                                   sender.bounds.size.height);
    MGUSimplePopController *pv = [[MGUSimplePopController alloc] initWithMessage:message
                                                                 backgroundColor:[UIColor systemFillColor]
                                                                   barButtonItem:nil
                                                                      sourceView:sender
                                                                      sourceRect:sourceRect
                                                                  arrowDirection:UIPopoverArrowDirectionDown
                                                                      completion:nil];
    pv.popoverPresentationController.popoverLayoutMargins = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0);
    [self.view.window.rootViewController presentViewController:pv animated:YES completion:nil];
}
*/
