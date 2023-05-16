//
//  MGUFloatingButtonStyles.h
//  MGRFloatingActionButton
//
//  Created by Kwan Hyun Son on 15/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUFloatingButtonStyles : NSObject

@property (nonatomic) UIColor *defaultButtonColor;
@property (nonatomic) UIColor *defaultHighlightedButtonColor;
@property (nonatomic) UIColor *defaultButtonImageColor;

@property (nonatomic) UIColor *defaultShadowColor;
@property (nonatomic) UIColor *defaultOverlayColor;

@property (nonatomic, nullable) UIImage *plusImage;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
