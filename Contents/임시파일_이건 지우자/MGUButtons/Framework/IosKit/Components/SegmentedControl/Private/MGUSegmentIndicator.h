//
//  MGUSegmentIndicator.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

@interface MGUSegmentIndicator : UIView

@property (nonatomic) CGFloat  cornerRadius;
@property (nonatomic) CGFloat  borderWidth;
@property (nonatomic) UIColor *borderColor;

// 사용하지 않고 그냥 단색으로 갈 수 있다.
@property (nonatomic) BOOL     drawsGradientBackground;
@property (nonatomic) UIColor *gradientTopColor;
@property (nonatomic) UIColor *gradientBottomColor;

@end
