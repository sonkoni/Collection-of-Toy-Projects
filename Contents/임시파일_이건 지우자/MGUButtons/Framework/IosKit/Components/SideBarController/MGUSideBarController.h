//
//  MGUSideBarController.h
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IosKit/MGUSideBarConfig.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGUSideBarDumiController
 @abstract      커스텀 프리젠트는 current context에서 프리젠트를 할 수 없어서 current context를 원할 경우 더미로 올리는 뷰 컨트롤러이다.
 @discussion    UIKit의 UIModalPresentationOverCurrentContext으로 이 더미뷰 컨트롤러를 푸쉬하고 MGUSideBarController를 푸쉬한다. dismiss는 MGUSideBarDismissalAnimator 에서 혹시나 제스처로 인한 취소가 발생할 수 있으므로 확인 후, 디스미스한다.
*/
@interface MGUSideBarDumiController : UIViewController
@property (nonatomic, assign, readwrite) UIStatusBarStyle preferredStatusBarStyle; // 재정의 readwrite로 전환함.
@end

@interface MGUSideBarController : UIViewController
@property (nonatomic, strong) MGUSideBarConfig *configuration;
@property (nonatomic, assign, readwrite) UIStatusBarStyle preferredStatusBarStyle; // 재정의 readwrite로 전환함.
@property (nonatomic, assign) BOOL automaticallyDismissWhenSizeChanged; // 디폴트 NO. 사이즈가 변경되면 자동으로 Dismiss

/*
    MGUSideBarConfig *config = [MGUSideBarConfig new];
    config.transitionStyle = MGUSideBarControllerTransitionStyleTrailing | MGUSideBarControllerTransitionStyleDisplace;
    MGUSideBarController *testController =
    [[MGUSideBarController alloc] initWithViewController:[ViewController new] configuration:config];
    testController.preferredStatusBarStyle =.UIStatusBarStyleLightContent;
    [self presentViewController:testController animated:YES completion:nil];
 */

- (instancetype)initWithViewController:(__kindof UIViewController *)viewController
                         configuration:(nullable MGUSideBarConfig *)configuration NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
