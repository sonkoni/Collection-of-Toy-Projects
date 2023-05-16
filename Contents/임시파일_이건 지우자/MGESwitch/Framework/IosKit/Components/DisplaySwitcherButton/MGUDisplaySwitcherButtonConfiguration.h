//
//  MGUDisplaySwitcherButtonConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUDisplaySwitcherButtonConfiguration : NSObject

@property (nonatomic, strong) UIColor *strokeColor;            // 디폴트 black. path의 stroke color
@property (nonatomic, strong) UIColor *highlightedStrokeColor; // 디폴트 light gray. highlighted stroke color

@property (nonatomic, assign) CGFloat lineWidth;               // 디폴트 1.0
@property (nonatomic, assign) CGFloat margin;                  // 디폴트 0.0f 버튼 내부에 적용되는 margin 버튼 내부로 더 작게 그릴 수 있다.
@property (nonatomic, assign) CGFloat scale;                   // 디폴트 0.9f 버튼을 눌렀을 때, 적용되는 버튼 스케일


//! 템플릿 --------------------------------------------------------
+ (MGUDisplaySwitcherButtonConfiguration *)defaultConfiguration;
+ (MGUDisplaySwitcherButtonConfiguration *)barButtonConfig;


//! 비교 --------------------------------------------------------
- (BOOL)isEqualToConfiguration:(MGUDisplaySwitcherButtonConfiguration *)config;
- (BOOL)isEqualToDefaultConfiguration;
@end

NS_ASSUME_NONNULL_END

