//
//  MessageView.h
//  MGUAlertView_koni
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaveView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *topWaveColor;
@property (nonatomic, strong) UIColor *bottomWaveColor;
@property (nonatomic, strong) NSLayoutConstraint *topWaveHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomWaveHeightConstraint;


- (instancetype)initWithFrame:(CGRect)frame
                 topWaveColor:(UIColor *)topWaveColor
              bottomWaveColor:(UIColor *)bottomWaveColor NS_DESIGNATED_INITIALIZER;;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
