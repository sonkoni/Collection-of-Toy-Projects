//
//  MGUActionSheetController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUAlertViewController.h>
#import <IosKit/MGUActionSheetConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUActionSheetController : MGUAlertViewController

#pragma mark - iPhone 용.
- (instancetype)initWithConfiguration:(nullable MGUActionSheetConfiguration *)configuration
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message
                              actions:(nullable NSArray<MGUAlertAction *> *)actions;

#pragma mark - iPad 용.
- (instancetype)initWithConfiguration:(nullable MGUActionSheetConfiguration *)configuration
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message
                              actions:(nullable NSArray<MGUAlertAction *> *)actions
                        barButtonItem:(nullable UIBarButtonItem *)barButtonItem
                           sourceView:(nullable UIView *)sourceView
                           sourceRect:(CGRect)sourceRect;


@property (nonatomic, strong, readonly) MGUActionSheetConfiguration *configuration;

#pragma mark - NS_UNAVAILABLE
@property (nonatomic, strong, nullable) UIView *thirdContentView NS_UNAVAILABLE;
@property (nonatomic, strong, nullable) UIViewController *thirdContentViewController NS_UNAVAILABLE;
@property (nonatomic) CGFloat maximumWidth NS_UNAVAILABLE;
@property (nonatomic, strong, readonly) NSArray<UITextField *> *textFields NS_UNAVAILABLE;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


