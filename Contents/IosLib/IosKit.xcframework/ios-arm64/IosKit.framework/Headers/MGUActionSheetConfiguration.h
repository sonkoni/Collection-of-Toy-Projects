//
//  MGUActionSheetConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUAlertViewConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUActionSheetConfiguration : MGUAlertViewConfiguration

@property (nonatomic) BOOL isFullAppearance;

//! MGUAlertViewTransitionStyleFGSlideFromTop 사용불가
//! MGUAlertViewTransitionStyleFGSlideFromTopRotation 사용불가
//! @property (nonatomic) MGUAlertViewTransitionStyle transitionStyle;

//! @property (nonatomic) BOOL swipeDismissalGestureEnabled; // 무조건 NO값을 갖게 만든다.
//! @property (nonatomic) BOOL alwaysArrangesActionButtonsVertically; // 무조건 YES값을 갖게 만든다.

+ (MGUActionSheetConfiguration *)dosePickerConfiguration;
+ (MGUActionSheetConfiguration *)forgeSaveAlarmConfiguration;
@end

NS_ASSUME_NONNULL_END
