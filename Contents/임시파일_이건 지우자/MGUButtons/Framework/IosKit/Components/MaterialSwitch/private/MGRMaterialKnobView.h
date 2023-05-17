//
//  MGRMaterialKnobView.h
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 29/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRMaterialKnobView : UIView

/// MGRMaterialKnobView의 가시적인상태 on, off 에 따라서 색이 바뀌어야한다.
@property (nonatomic) BOOL on;
@property (nonatomic) BOOL touched;
@property (nonatomic) CGFloat animaitonDuration;

@property (nonatomic, strong) CAShapeLayer *rippleLayer;

- (instancetype)initWithFrame:(CGRect)frame switchOn:(BOOL)switchOn;

@end

NS_ASSUME_NONNULL_END

