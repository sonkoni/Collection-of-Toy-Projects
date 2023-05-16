//
//  MGUSwipeDecoEdgeView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUSwipeDecoEdgeView : UIView

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *swipeDecoLeftColor; // @dynamic
@property (nonatomic, strong) UIColor *swipeDecoRightColor; // @dynamic


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
