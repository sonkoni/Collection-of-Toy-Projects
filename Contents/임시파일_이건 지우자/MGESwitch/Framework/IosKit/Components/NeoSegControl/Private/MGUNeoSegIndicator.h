//
//  MGUNeoSegIndicator.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUNeoSegConfiguration;

@interface MGUNeoSegIndicator : UIView

@property (nonatomic) CGFloat  cornerRadius;
@property (nonatomic) CGFloat  borderWidth;  // @dynamic
@property (nonatomic) UIColor *borderColor;  // @dynamic

// =============================================================================
//! 사용하지 않고 그냥 단색으로 갈 수 있다.
@property (nonatomic) BOOL     drawsGradientBackground; // @dynamic
@property (nonatomic) BOOL     segmentIndicatorShadowHidden;
@property (nonatomic) BOOL     isSegmentIndicatorBarStyle;
@property (nonatomic) UIColor *gradientTopColor;        // @dynamic
@property (nonatomic) UIColor *gradientBottomColor;     // @dynamic

@property (nonatomic, readonly) BOOL shrink;

- (void)shrink:(BOOL)isShrink frame:(CGRect)frame;  // MGUSegmentedControl의 Pan으로 작동한다.
- (void)moveToFrame:(CGRect)frame animated:(BOOL)animated;


- (instancetype)initWithFrame:(CGRect)frame
                       config:(MGUNeoSegConfiguration *)config NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
