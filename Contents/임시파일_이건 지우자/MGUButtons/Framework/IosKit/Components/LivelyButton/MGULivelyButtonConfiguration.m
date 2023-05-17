//
//  MGULivelyButtonConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGULivelyButtonConfiguration.h"

@implementation MGULivelyButtonConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _margin    = 0.0f;
    _scale     = 0.9f;
    _lineWidth = 1.0f;
    _strokeColor            = [UIColor blackColor];
    _highlightedStrokeColor = [UIColor lightGrayColor];
}


#pragma mark - Configuration Template
+ (MGULivelyButtonConfiguration *)defaultConfiguration {
    return [[MGULivelyButtonConfiguration alloc] init];
}

+ (MGULivelyButtonConfiguration *)blue_2_D_D_Config {
    MGULivelyButtonConfiguration *configuration = [[MGULivelyButtonConfiguration alloc] init];
    
    configuration.lineWidth = 2.0f;
    configuration.strokeColor            = [UIColor blueColor];
    configuration.highlightedStrokeColor = [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0];
    return configuration;
}

+ (MGULivelyButtonConfiguration *)black_4_15_D_Config {
    MGULivelyButtonConfiguration *configuration = [[MGULivelyButtonConfiguration alloc] init];
    
    configuration.lineWidth = 4.0f;
    configuration.margin = 15.0f;
    return configuration;
}


#pragma mark - Compare

- (BOOL)isEqualToConfiguration:(MGULivelyButtonConfiguration *)config {
    if (self.margin != config.margin) {
        return NO;
    }
    
    if (self.scale != config.scale) {
        return NO;
    }
    
    if (self.lineWidth != config.lineWidth) {
        return NO;
    }
    
    if ([self.strokeColor isEqual:config.strokeColor] == NO) {
        return NO;
    }
    
    if ([self.highlightedStrokeColor isEqual:config.highlightedStrokeColor] == NO) {
        return NO;
    }
    return YES;
}

- (BOOL)isEqualToDefaultConfiguration {
    return [self isEqualToConfiguration:[MGULivelyButtonConfiguration defaultConfiguration]];
}

@end


