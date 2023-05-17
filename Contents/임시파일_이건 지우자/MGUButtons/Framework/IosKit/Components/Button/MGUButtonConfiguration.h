//
//  MGUButtonConfiguration.h
//  MGUButtons
//
//  Created by Kwan Hyun Son on 2020/07/22.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUButton;

NS_ASSUME_NONNULL_BEGIN

@interface MGUButtonConfiguration : NSObject

//! 초기화 단계에서 적용된다. 생성후에도 적용시킬 수 있다.
- (void)applyConfigurationOnMGUButton:(MGUButton *)button;

+ (MGUButtonConfiguration *)defaultConfiguration;
+ (MGUButtonConfiguration *)standardPlayPauseConfiguration;
+ (MGUButtonConfiguration *)standardBackwardConfiguration;
+ (MGUButtonConfiguration *)standardForwardConfiguration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

/** 우선 Private
+ (UIImage *)standardPlayImage API_AVAILABLE(ios(13.0));
+ (UIImage *)standardPauseImage API_AVAILABLE(ios(13.0));
+ (UIImage *)standardBackwardImage API_AVAILABLE(ios(13.0));
+ (UIImage *)standardForwardImage API_AVAILABLE(ios(13.0));
*/


