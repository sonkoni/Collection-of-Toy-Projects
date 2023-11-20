//
//  UIImage+DarkModeSupport.h
//  DarkMode
//
//  Created by Kwan Hyun Son on 2020/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DarkModeSupport)

+ (UIImage * _Nullable)mgrDynamicImageWithNormalImage:(UIImage *_Nullable)normalImage
                                            darkImage:(UIImage *_Nullable)darkImage;

@end

NS_ASSUME_NONNULL_END
