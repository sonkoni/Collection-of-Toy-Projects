//
//  MGEGradientGenerator.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-30
//  ----------------------------------------------------------------------
//
// gradient CGImage를 만들기 위한 객체이다.


#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGEGradientGenerator : NSObject

@property (nonatomic) CGFloat edgeAngle;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGSize size;
@property (nonatomic) CGColorRef startColor;
@property (nonatomic) CGColorRef endColor;

- (CGImageRef)image;

@end

NS_ASSUME_NONNULL_END


