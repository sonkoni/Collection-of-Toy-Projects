//
//  MGUMessagesBaseView.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesAnimationContext;

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGUMessagesTheme
 @abstract   ......
 @constant   MGUMessagesThemeInfo     .....
 @constant   MGUMessagesThemeSuccess   .....
 @constant   MGUMessagesThemeWarning   .....
 @constant   MGUMessagesThemeError   .....
 */
typedef NS_ENUM(NSUInteger, MGUMessagesTheme) {
    MGUMessagesThemeInfo = 1, // 0은 피하는 것이 좋다.
    MGUMessagesThemeSuccess,
    MGUMessagesThemeWarning,
    MGUMessagesThemeError
};

typedef NS_ENUM(NSUInteger, MGUMessagesIconStyle) {
    MGUMessagesIconStyleDefault = 1, // 0은 피하는 것이 좋다.
    MGUMessagesIconStyleLight,
    MGUMessagesIconStyleSubtle,
    MGUMessagesIconStyleNone
};

typedef NSString * MGUMessagesIconName NS_TYPED_ENUM;
static MGUMessagesIconName const MGUMessagesIconNameError  = @"MGUMessagesErrorIcon";
static MGUMessagesIconName const MGUMessagesIconNameWarning = @"MGUMessagesWarningIcon";
static MGUMessagesIconName const MGUMessagesIconNameSuccess = @"MGUMessagesSuccessIcon";
static MGUMessagesIconName const MGUMessagesIconNameInfo = @"MGUMessagesInfoIcon";
static MGUMessagesIconName const MGUMessagesIconNameErrorLight  = @"MGUMessagesErrorIconLight";
static MGUMessagesIconName const MGUMessagesIconNameWarningLight = @"MGUMessagesWarningIconLight";
static MGUMessagesIconName const MGUMessagesIconNameSuccessLight = @"MGUMessagesSuccessIconLight";
static MGUMessagesIconName const MGUMessagesIconNameInfoLight = @"MGUMessagesInfoIconLight";
static MGUMessagesIconName const MGUMessagesIconNameErrorSubtle = @"MGUMessagesErrorIconSubtle";
static MGUMessagesIconName const MGUMessagesIconNameWarningSubtle = @"MGUMessagesWarningIconSubtle";
static MGUMessagesIconName const MGUMessagesIconNameSuccessSubtle = @"MGUMessagesSuccessIconSubtle";
static MGUMessagesIconName const MGUMessagesIconNameInfoSubtle = @"MGUMessagesInfoIconSubtle";


extern UIImage * _Nullable makeImageWithStyleAndTheme(MGUMessagesIconStyle style, MGUMessagesTheme theme);

@protocol MGUMessagesMarginAdjustable <NSObject>
@optional
@required
- (UIEdgeInsets)layoutMarginAdditions;

- (BOOL)collapseLayoutMarginAdditions;
- (void)setCollapseLayoutMarginAdditions:(BOOL)collapseLayoutMarginAdditions;

- (BOOL)respectSafeArea;
- (void)setRespectSafeArea:(BOOL)respectSafeArea;

- (CGFloat)bounceAnimationOffset;
- (void)setBounceAnimationOffset:(CGFloat)bounceAnimationOffset;

- (UIEdgeInsets)defaultMarginAdjustmentWithContext:(MGUMessagesAnimationContext *)context;
@end

IB_DESIGNABLE @interface MGUMessagesBaseView : UIView <MGUMessagesMarginAdjustable> // BackgroundViewable,
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, assign) UIEdgeInsets layoutMarginAdditions; // @dynamic
@property (nonatomic, assign) BOOL respectSafeArea; // 디폴트 YES
@property (nonatomic, assign) IBInspectable CGFloat topLayoutMarginAddition; // 디폴트 0.0
@property (nonatomic, assign) IBInspectable CGFloat leftLayoutMarginAddition; // 디폴트 0.0
@property (nonatomic, assign) IBInspectable CGFloat bottomLayoutMarginAddition; // 디폴트 0.0
@property (nonatomic, assign) IBInspectable CGFloat rightLayoutMarginAddition; // 디폴트 0.0
@property (nonatomic, assign) IBInspectable BOOL collapseLayoutMarginAdditions; // 디폴트 YES
@property (nonatomic, assign) IBInspectable CGFloat bounceAnimationOffset; // 디폴트 5.0

@property (nonatomic, assign) CGFloat backgroundHeight; // nullable

@property (nonatomic, copy, nullable) void (^tapHandler)(MGUMessagesBaseView *view);

- (void)installContentView:(UIView *)contentView insets:(UIEdgeInsets)insets;
- (void)installBackgroundView:(UIView *)backgroundView insets:(UIEdgeInsets)insets;
- (void)installBackgroundVerticalView:(UIView *)backgroundView insets:(UIEdgeInsets)insets;

- (void)configureDropShadow;
- (void)configureNoDropShadow;

- (void)configureBackgroundViewSideMargin:(CGFloat)sideMargin;
- (void)configureBackgroundViewWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
