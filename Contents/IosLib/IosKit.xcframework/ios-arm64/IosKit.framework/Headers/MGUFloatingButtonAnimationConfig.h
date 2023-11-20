//
//  JJButtonAnimationConfiguration.h
//  MGRFloatingActionButton
//
//  Created by Kwan Hyun Son on 16/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MGRButtonAnimationStyle) {
    MGRButtonAnimationStyleRotation,  // Rotate button image to given angle.
    MGRButtonAnimationStyleTransition // Transition to given image.
};

@interface MGUFloatingButtonAnimationConfig : NSObject
@property (nonatomic) MGRButtonAnimationStyle style;
@property (nonatomic) CGFloat angle;
@property (nonatomic, nullable) UIImage *image;


//! 애니메이션 관련.
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CGFloat        dampingRatio;


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 초기화 메서드 - 반드시 이 메서드로 초기화한다.
- (instancetype)initWithStyle:(MGRButtonAnimationStyle)style;

//! 인수를 넣지 않으면, 디폴트 인수는 (-M_PI / 4.0f)
- (instancetype)initWithRotationAngle:(CGFloat)angle;
- (instancetype)initWithTransitionImage:(UIImage *)image;

@end
NS_ASSUME_NONNULL_END
