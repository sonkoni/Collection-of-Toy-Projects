//
//  MGUAlertActionConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

//! Alert 버튼의 적흰 타이틀의 폰트와 색깔을 정한다.

NS_ASSUME_NONNULL_BEGIN

@interface MGUAlertActionConfiguration : NSObject

@property (strong, nonatomic) UIFont *titleFont; // The font used to display the button title.
@property (strong, nonatomic) UIColor *titleColor; // The text color used to display the button title.
@property (strong, nonatomic) UIColor *disabledTitleColor; // The text color used to display the button title when the action is disabled.

@property (strong, nonatomic) UIColor *highlightedButtonBackgroundColor; // 눌러졌을 때, 버튼의 배경색

@end

NS_ASSUME_NONNULL_END
