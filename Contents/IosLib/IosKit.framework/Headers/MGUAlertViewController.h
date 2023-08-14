//
//  MGUAlertViewController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUAlertAction.h>
#import <IosKit/MGUAlertViewConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUAlertViewController : UIViewController

- (instancetype)initWithConfiguration:(nullable MGUAlertViewConfiguration *)configuration
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message
                              actions:(nullable NSArray<MGUAlertAction *> *)actions;

@property (nonatomic, strong, readonly) MGUAlertViewConfiguration *configuration; // nil이면 디폴트 configuration을 이용한다.
@property (nonatomic, strong, nullable) NSString *titleString;   // 메시지 문자열
@property (nonatomic, strong, nullable) NSString *messageString; // 메시지 문자열

@property (nonatomic, strong, nullable) UIView *contentView; // 디폴트 nil. 커스텀 뷰를 추가하고 싶을 때 이 custom view를 이용한다.
@property (nonatomic, strong, nullable) UIView *secondContentView; // 디폴트 nil. 커스텀 뷰를 추가하고 싶을 때 이 custom view를 이용한다.
@property (nonatomic, strong, nullable) UIView *thirdContentView;
@property (nonatomic, strong, nullable) UIViewController *contentViewController; // contentView만 있을 수 있다.
@property (nonatomic, strong, nullable) UIViewController *secondContentViewController; // secondContentView만 있을 수 있다.
@property (nonatomic, strong, nullable) UIViewController *thirdContentViewController; // thirdContentView만 있을 수 있다.

@property (nonatomic) CGFloat maximumWidth; // alert view의 최대 넓이.

@property (nonatomic, strong) NSArray <MGUAlertAction *>*actions; // alert view 응답할 수 있는 MGUAlertAction 객체 배열

//! viewWillAppear 단계에서 alertView에 삽입된다.
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler; // alert view에 표시되는 UITextField객체
@property (nonatomic, strong, readonly) NSArray<UITextField *> *textFields; // alert view에 표시되는 UITextField객체 배열

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
