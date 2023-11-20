//
//  UIView+Drawing.h
//  DrawTEST
//
//  Created by Kwan Hyun Son on 2020/07/26.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Drawing)

//! - (void)drawRect:(CGRect)rect 에서 호출하며, 첫 번째 인수는 그대로 전달한다.
- (void)mgrDrawVerticalGradientRect:(CGRect)rect colors:(NSArray <UIColor *>*)colors;   // 위에서 아래로
- (void)mgrDrawHorizontalGradientRect:(CGRect)rect colors:(NSArray <UIColor *>*)colors; // 좌에서 우로
- (void)mgrDrawRadialGradientLayerRect:(CGRect)rect colors:(NSArray <UIColor *>*)colors; // 가운데서 퍼짐.
//! conic 은 없다.
@end

NS_ASSUME_NONNULL_END
