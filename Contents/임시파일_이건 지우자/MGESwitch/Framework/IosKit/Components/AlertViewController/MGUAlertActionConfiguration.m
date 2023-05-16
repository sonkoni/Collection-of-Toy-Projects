//
//  MGUAlertActionConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertActionConfiguration.h"

@implementation MGUAlertActionConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _titleColor = [UIColor darkGrayColor];
        _disabledTitleColor = [UIColor grayColor];
        _highlightedButtonBackgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.2];
    }
    return self;
}

@end
