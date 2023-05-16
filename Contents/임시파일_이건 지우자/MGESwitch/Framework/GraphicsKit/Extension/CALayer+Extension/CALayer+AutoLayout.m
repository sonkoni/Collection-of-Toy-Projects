//
//  CALayer+AutoLayout.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "CALayer+AutoLayout.h"
#if TARGET_OS_OSX

static NSString *superlayer = @"superlayer";

@implementation CALayer (AutoLayout)

- (void)mgrPinEdgesToSuperlayerEdgesDisableActions:(BOOL)isDisableActions {
    [self mgrPinEdgesToSuperlayerCustomMargins:NSEdgeInsetsZero disableActions:isDisableActions];
}

- (void)mgrPinEdgesToSuperlayerCustomMargins:(NSEdgeInsets)customMargins disableActions:(BOOL)isDisableActions {
    NSCAssert(self.superlayer, @"superlayer 는 nil 이어서는 안된다.");
    if (self.superlayer.layoutManager == nil) {
        self.superlayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    }
    
    customMargins = NSEdgeInsetsMake(-customMargins.top, customMargins.left, customMargins.bottom, -customMargins.right);
    
    CAConstraint *constraint1 = [CAConstraint constraintWithAttribute:kCAConstraintMinX // 왼쪽.
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMinX
                                                               offset:customMargins.left];
    
    CAConstraint *constraint2 = [CAConstraint constraintWithAttribute:kCAConstraintMaxX  // 오른쪽....
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMaxX
                                                               offset:customMargins.right];
    
    CAConstraint *constraint3 = [CAConstraint constraintWithAttribute:kCAConstraintMinY   // 아래쪽.
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMinY
                                                               offset:customMargins.bottom];
    
    CAConstraint *constraint4 = [CAConstraint constraintWithAttribute:kCAConstraintMaxY  // 위쪽
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMaxY
                                                               offset:customMargins.top];
    [self setConstraints:@[constraint1, constraint2, constraint3, constraint4]];
    
    if (isDisableActions == YES) {
        self.actions = @{ @"bounds" : [NSNull null], @"position" : [NSNull null] };
        // @"frame"    : [NSNull null] 이것까지는 없어도 되는듯.
    }
}

- (void)mgrPinCenterToSuperlayerCenterDisableActions:(BOOL)isDisableActions {
    NSCAssert(self.superlayer, @"superlayer 는 nil 이어서는 안된다.");
    if (self.superlayer.layoutManager == nil) {
        self.superlayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    }
    
    CAConstraint *constraint1 = [CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMidX];
    
    CAConstraint *constraint2 = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMidY];

    [self setConstraints:@[constraint1, constraint2]];
    
    if (isDisableActions == YES) {
        self.actions = @{ @"bounds" : [NSNull null], @"position" : [NSNull null] };
        // @"frame"    : [NSNull null] 이것까지는 없어도 되는듯.
    }
}

- (void)mgrPinCenterToSuperlayerCenterWithFixSize:(CGSize)size disableActions:(BOOL)isDisableActions {
    NSCAssert(self.superlayer, @"superlayer 는 nil 이어서는 안된다.");
    if (self.superlayer.layoutManager == nil) {
        self.superlayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    }
    
    self.bounds = CGRectMake(0.0, 0.0, size.width, size.height);

    CAConstraint *constraint1 = [CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMidX];
    
    CAConstraint *constraint2 = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                           relativeTo:superlayer
                                                            attribute:kCAConstraintMidY];

    [self setConstraints:@[constraint1, constraint2]];
    
    if (isDisableActions == YES) {
        self.actions = @{ @"bounds" : [NSNull null], @"position" : [NSNull null] };
        // @"frame"    : [NSNull null] 이것까지는 없어도 되는듯.
    }

}

@end
#endif


/** 애플 샘플코드
 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/BuildingaLayerHierarchy/BuildingaLayerHierarchy.html#//apple_ref/doc/uid/TP40004514-CH6-SW11
 
// Create and set a constraint layout manager for the parent layer.
theLayer.layoutManager=[CAConstraintLayoutManager layoutManager];
 
// Create the first sublayer.
CALayer *layerA = [CALayer layer];
layerA.name = @"layerA";
layerA.bounds = CGRectMake(0.0,0.0,100.0,25.0);
layerA.borderWidth = 2.0;
 
// Keep layerA centered by pinning its midpoint to its parent's midpoint.
[layerA addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMidY]];
[layerA addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMidX]];
[theLayer addSublayer:layerA];
 
// Create the second sublayer
CALayer *layerB = [CALayer layer];
layerB.name = @"layerB";
layerB.borderWidth = 2.0;
 
// Make the width of layerB match the width of layerA.
[layerB addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
                                                 relativeTo:@"layerA"
                                                  attribute:kCAConstraintWidth]];
 
// Make the horizontal midpoint of layerB match that of layerA
[layerB addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                 relativeTo:@"layerA"
                                                  attribute:kCAConstraintMidX]];
 
// Position the top edge of layerB 10 points from the bottom edge of layerA.
[layerB addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                                 relativeTo:@"layerA"
                                                  attribute:kCAConstraintMinY
                                                     offset:-10.0]];
 
// Position the bottom edge of layerB 10 points
//  from the bottom edge of the parent layer.
[layerB addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMinY
                                                     offset:+10.0]];
 
[theLayer addSublayer:layerB];
 */
