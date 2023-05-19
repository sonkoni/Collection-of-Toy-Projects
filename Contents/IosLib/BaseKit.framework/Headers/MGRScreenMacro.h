//
//  MGRScreenMacro.h
//  Copyright © 2022 mulgrim. All rights reserved.
//

#ifndef MGRScreenMacro_h
#define MGRScreenMacro_h
#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE)
#define MGR_SCREEN_RATIO        ([UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width)
#define MGR_SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define MGR_SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)
#define MGR_SCREEN_IS_16_9      (2 > MGR_SCREEN_RATIO)  /* iPhone8 이하 및 Se 모델 등 홈버튼 있는 모델 */
#define MGR_SCREEN_IS_18_9      (2 < MGR_SCREEN_RATIO)  /* iPhoneX 이상 노치 모델 */
#endif

#endif /* MGRScreenMacro_h */
