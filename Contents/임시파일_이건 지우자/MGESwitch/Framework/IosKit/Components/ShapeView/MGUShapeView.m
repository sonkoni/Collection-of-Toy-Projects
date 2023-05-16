//
//  MGUShapeView.m
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//

#import "MGUShapeView.h"

@implementation MGUShapeView
@dynamic shapeLayer;

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)(self.layer);
}

@end
