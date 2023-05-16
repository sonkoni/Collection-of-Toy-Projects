//
//  LTEmitter.m
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 26/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUMorphingLabelEmitter.h"
@import BaseKit;

@interface MGUMorphingLabelEmitter ()
@end

@implementation MGUMorphingLabelEmitter

- (CAEmitterLayer *)layer { // lazy
    if(_layer == nil) {
        _layer = [CAEmitterLayer layer];
        _layer.emitterPosition = CGPointMake(10.0f, 10.0f);
        _layer.emitterSize = CGSizeMake(10.0f, 1.0f);
        _layer.renderMode = kCAEmitterLayerUnordered;
        _layer.emitterShape = kCAEmitterLayerLine;
    }
    return _layer;
}

- (CAEmitterCell *)cell { // lazy
    if(_cell == nil) {
        _cell = CAEmitterCell.new;
        _cell.name = @"sparkle";
        _cell.birthRate = 150.0;
        _cell.velocity = 50.0;
        _cell.velocityRange = -80.0;
        _cell.lifetime = 0.16;
        _cell.lifetimeRange = 0.1;
        _cell.emissionLongitude = M_PI / 2.0 * 2.0;
        _cell.emissionRange = M_PI / 2.0 * 2.0;
        _cell.scale = 0.1;
        _cell.yAcceleration = 100.0;
        _cell.scaleSpeed = -0.06;
        _cell.scaleRange = 0.1;
    }
    return _cell;
}

- (instancetype)initWithName:(NSString *)name
                particleName:(NSString *)particleName
                    duration:(CGFloat)duration {
    self = [super init];
    if(self) {
        self.cell.name = name;
        self.duration = duration;
        UIImage *image = [UIImage imageNamed:particleName inBundle:[NSBundle mgrIosRes] withConfiguration:nil];
        if (image == nil) {
            NSAssert(false, @"이미지를 찾을 수 없다.");
        }
        self.cell.contents = (__bridge id)(image.CGImage); // NSImage는 바로 대입가능. 위키에 설명함.
    }
    
    return self;
}

- (void)play {
    
    if (self.layer.emitterCells.count > 0) {
        return;
    }
    
    self.layer.emitterCells = @[self.cell];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf) self = weakSelf;
        self.layer.birthRate = 0.0f;
    });
}

- (void)stop {
    if (self.layer.superlayer != nil) {
        self.layer.emitterCells = nil;
        [self.layer removeFromSuperlayer];
    }
}

- (MGUMorphingLabelEmitter *)update:(MGUMorphingLabelEmitterConfigureClosure)configureClosure {
    configureClosure(self.layer, self.cell);
    return self;
}

@end
