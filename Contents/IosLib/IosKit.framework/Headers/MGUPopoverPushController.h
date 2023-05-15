//
//  MGUPopoverPushController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//
//  Created by Kwan Hyun Son on 2022/06/23.
// https://noahgilmore.com/blog/popover-uinavigationcontroller-preferredcontentsize/
// https://github.com/noahsark769/NGPopoverForceResizeTest
// https://useyourloaf.com/blog/self-sizing-popovers/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @protocol      <MGUPopoverPushPr>
 @abstract      ...
 @discussion    ...
*/
@protocol MGUPopoverPushPr <NSObject>
@optional
@required
- (void)setPreferredContentSizeFromAutolayout;
/**
// 내부 구현은 무조건 이렇게 하고 viewWillAppear: 에서 때려준다.
- (void)setPreferredContentSizeFromAutolayout {
    CGSize contentSize = [self.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.preferredContentSize = contentSize;
    self.popoverPresentationController.presentedViewController.preferredContentSize  = contentSize;
}
 */
@end

/*!
 @class         MGUPopoverPushController
 @abstract      네비게이션 컨트롤러를 팝오버로 띄우고, 사이즈 변화가 자유롭다.
 @discussion    barButtonItem 또는 sourceView 둘 중 하나만 반드시 설정해야하며, sourceView 설정 시 sourceRect를 설정해야한다.
*/
@interface MGUPopoverPushController : UIViewController

/**
 MGPAddController *addController = [MGPAddController new];
 MGUPopoverPushController *popoverPushController = [[MGUPopoverPushController alloc] initWithRootViewController:addController];
 
 //! 중요: YES 이다. 밑 부분이 여백이 생길 수 있으니 이렇게 하자.
 addController.view.translatesAutoresizingMaskIntoConstraints = YES;
 NSLayoutConstraint *constraint = [addController.view.widthAnchor constraintEqualToAnchor:addController.view.heightAnchor multiplier:375.0/237.0];
 constraint.priority = UILayoutPriorityDefaultHigh;
 constraint.active = YES;
 constraint = [addController.view.widthAnchor constraintEqualToConstant:320.0];
 constraint.priority = UILayoutPriorityDefaultHigh;
 constraint.active = YES;
 
 [popoverPushController setBarButtonItem:sender
                              sourceView:nil
                              sourceRect:CGRectZero
                          arrowDirection:UIPopoverArrowDirectionAny
                              completion:nil];
 
 [popoverPushController changeBlurEffectStyle:UIBlurEffectStyleExtraDark]; // 기본 블러를 변경할 수 있다.
 // 화면 끝에서 팝오버가 나오면 한쪽 끝이 날카로워지는 문제가 발생할 수 있다. 상황에 따라서 적절히 처리해준다.
 popoverPushController.popoverPresentationController.popoverLayoutMargins = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0);

[self presentViewController:popoverPushController animated:YES completion:nil]; // 이걸 대신 쓰면 된다.
 
 */

@property (nonatomic, copy, nullable) void (^completionBlock)(void);
@property (nonatomic, assign) BOOL acceptFirstResponder; // 텍스트 필드가 존재할 때. 띄우면서 퍼스트 리스폰더로 만들것인지여부.
@property (nonatomic, assign) BOOL removeArrow; // 화살표를 제거한다. 디폴트:NO (화살표가 있는 것이 디폴트)
@property (nonatomic, assign) BOOL formSheetWhenHorizontalCompact; // 가로가 콤팩트 일때, FormSheet 형식으로 띄울 것인지 여부. 디폴트 NO. ex: 캘린더

// 기본 블러이펙트의 효과를 다른 것으로 변경하고 싶다면. removeArrow == YES이면 이 메서드는 효과가 없다. 직접 달아라.
- (void)changeBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle;

- (instancetype)initWithRootViewController:(UIViewController <MGUPopoverPushPr>*)rootViewController NS_DESIGNATED_INITIALIZER;

- (void)setBarButtonItem:(nullable UIBarButtonItem *)barButtonItem
              sourceView:(nullable UIView *)sourceView
              sourceRect:(CGRect)sourceRect
          arrowDirection:(UIPopoverArrowDirection)arrowDirection
              completion:(void(^_Nullable)(void))completionBlock;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
