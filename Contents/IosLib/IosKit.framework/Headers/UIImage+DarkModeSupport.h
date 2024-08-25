//
//  UIImage+DarkModeSupport.h
//  DarkMode
//
//  Created by Kwan Hyun Son on 2020/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DarkModeSupport)

/// 원본 칼라를 사용하고 싶다면, color에 모두 nil을 넣어라.
+ (UIImage *_Nullable)mgrDynamicImageWithNormalImage:(UIImage *_Nullable)normalImage
                                           darkImage:(UIImage *_Nullable)darkImage
                                         normalColor:(UIColor *_Nullable)normalColor
                                           darkColor:(UIColor *_Nullable)darkColor;

@end

NS_ASSUME_NONNULL_END
