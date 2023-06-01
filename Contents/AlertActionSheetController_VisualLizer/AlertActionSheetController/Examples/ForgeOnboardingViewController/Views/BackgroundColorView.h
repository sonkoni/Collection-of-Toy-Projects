//
//  BackgroundColorView.h
//  AlertActionSheetController
//
//  Created by Kwan Hyun Son on 01/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundColorView : UIView
- (void)setColors:(UIColor *)top bottom:(UIColor *)bottom;
- (CAKeyframeAnimation *)backgroundColorAnimationWithColors:(NSArray <NSArray <UIColor *>*>*)arrayColorArray;
@end

NS_ASSUME_NONNULL_END
