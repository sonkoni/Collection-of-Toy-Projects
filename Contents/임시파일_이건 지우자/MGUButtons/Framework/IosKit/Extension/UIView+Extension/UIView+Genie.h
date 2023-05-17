//
//  UIView+Genie.h
//  BCGenieEffect
//
//  Created by Bartosz Ciechanowski on 23.12.2012.
//  Copyright (c) 2012 Bartosz Ciechanowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, GenieRectEdge) {
    GenieRectEdgeTop    = 0,
    GenieRectEdgeLeft   = 1,
    GenieRectEdgeBottom = 2,
    GenieRectEdgeRight  = 3
};

@interface UIView (Genie)

/*
 * 애니메이션이 완료되면 뷰의 transform이 destination의 rect와 일치하도록 변경된다. 즉,
 * 뷰의 transform (따라서 frame)은 변경되지만 bounds와 center는 변경되지 않는다.
 */

- (void)genieInTransitionWithDuration:(NSTimeInterval)duration
                      destinationRect:(CGRect)destRect
                      destinationEdge:(GenieRectEdge)destEdge
                           completion:(void (^)(void))completion;


//! 애니메이션이 완료되면 뷰의 transform이 CGAffineTransformIdentity로 변경된다.
- (void)genieOutTransitionWithDuration:(NSTimeInterval)duration
                             startRect:(CGRect)startRect
                             startEdge:(GenieRectEdge)startEdge
                            completion:(void (^)(void))completion;

@end
