//
//  MGERingProgressGroupView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-30
//  ----------------------------------------------------------------------
//

#import <GraphicsKit/MGEAvailability.h>
@class MGERingProgressView;

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 인터페이스

IB_DESIGNABLE @interface MGERingProgressGroupView : MGEView

@property (nonatomic, strong) MGERingProgressView *ringProgressView1;
@property (nonatomic, strong) MGERingProgressView *ringProgressView2;
@property (nonatomic, strong) MGERingProgressView *ringProgressView3;

// IBInspectable 은 매크로를 인식하지 못한다.
#if TARGET_OS_OSX
@property (nonatomic) IBInspectable NSColor *ring1StartColor;
@property (nonatomic) IBInspectable NSColor *ring1EndColor;
@property (nonatomic) IBInspectable NSColor *ring2StartColor;
@property (nonatomic) IBInspectable NSColor *ring2EndColor;
@property (nonatomic) IBInspectable NSColor *ring3StartColor;
@property (nonatomic) IBInspectable NSColor *ring3EndColor;
#elif TARGET_OS_IPHONE
@property (nonatomic) IBInspectable UIColor *ring1StartColor;
@property (nonatomic) IBInspectable UIColor *ring1EndColor;
@property (nonatomic) IBInspectable UIColor *ring2StartColor;
@property (nonatomic) IBInspectable UIColor *ring2EndColor;
@property (nonatomic) IBInspectable UIColor *ring3StartColor;
@property (nonatomic) IBInspectable UIColor *ring3EndColor;
#endif

@property (nonatomic) IBInspectable CGFloat ringWidth;
@property (nonatomic) IBInspectable CGFloat ringSpacing;

- (void)updateWithProgress1:(CGFloat)progress1 progress2:(CGFloat)progress2 progress3:(CGFloat)progress3;

//! scale 디폴트 1.0
///UIImage * generateAppIcon(CGFloat scale);

@end

NS_ASSUME_NONNULL_END
