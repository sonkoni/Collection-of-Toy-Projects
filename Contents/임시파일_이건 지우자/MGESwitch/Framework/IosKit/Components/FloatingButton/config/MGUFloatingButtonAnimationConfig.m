//
//  JJButtonAnimationConfiguration.m
//  MGRFloatingActionButton
//
//  Created by Kwan Hyun Son on 16/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUFloatingButtonAnimationConfig.h"

@implementation MGUFloatingButtonAnimationConfig

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 & 소멸 메서드

- (instancetype)initWithStyle:(MGRButtonAnimationStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        _duration     = 0.3f;
        _dampingRatio = 0.55f;
    }
    return self;
}

- (instancetype)initWithRotationAngle:(CGFloat)angle {
    self = [self initWithStyle:MGRButtonAnimationStyleRotation];
    _angle = angle;
    return self;
}

- (instancetype)initWithTransitionImage:(UIImage *)image {
    self = [self initWithStyle:MGRButtonAnimationStyleTransition];
    _image = image;
    return self;
}

@end
