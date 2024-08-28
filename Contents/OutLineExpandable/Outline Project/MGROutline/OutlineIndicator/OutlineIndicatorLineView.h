//
//  OutlineIndicatorLineView.h
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/08/26.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct CG_BOXABLE MGROutlineIndicatorKnobPosition {
    BOOL isBottom;
    CGFloat xOrigin;
} MGROutlineIndicatorKnobPosition;


CG_INLINE MGROutlineIndicatorKnobPosition MGROutlineIndicatorKnobPositionMake(BOOL isBottom, CGFloat xOrigin) {
    MGROutlineIndicatorKnobPosition position = {isBottom, xOrigin};
    return position;
}

@interface OutlineIndicatorLineView : UIView

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat lineWidth; // 디폴트 :
@property (nonatomic, assign) CGFloat knobRadius; // 디폴트 :
@property (nonatomic, assign) MGROutlineIndicatorKnobPosition knobPosition;  // 디폴트 :(YES, 20.0) <- 크게 의미없다.

- (instancetype)initWithFrame:(CGRect)frame
                  strokeColor:(UIColor * _Nullable)strokeColor NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
