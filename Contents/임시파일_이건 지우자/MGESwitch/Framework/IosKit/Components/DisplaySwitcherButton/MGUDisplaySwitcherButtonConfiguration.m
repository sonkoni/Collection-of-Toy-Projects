//
//  MGUDisplaySwitcherButtonConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUDisplaySwitcherButtonConfiguration.h"

@implementation MGUDisplaySwitcherButtonConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}


static void CommonInit(MGUDisplaySwitcherButtonConfiguration *self) {
    self->_margin    = 0.0;
    self->_scale     = 0.9;
    self->_lineWidth = 1.0;
    self->_strokeColor            = [UIColor blackColor];
    self->_highlightedStrokeColor = [UIColor lightGrayColor];
}

#pragma mark - Configuration Template
+ (MGUDisplaySwitcherButtonConfiguration *)defaultConfiguration {
    return [[MGUDisplaySwitcherButtonConfiguration alloc] init];
}

+ (MGUDisplaySwitcherButtonConfiguration *)barButtonConfig {
    MGUDisplaySwitcherButtonConfiguration *configuration = [[MGUDisplaySwitcherButtonConfiguration alloc] init];
    configuration.lineWidth = 1.5;
    configuration.margin = 15.0;
    return configuration;
}


#pragma mark - Compare

- (BOOL)isEqualToConfiguration:(MGUDisplaySwitcherButtonConfiguration *)config {
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
    return [self isEqualToConfiguration:[MGUDisplaySwitcherButtonConfiguration defaultConfiguration]];
}

@end


