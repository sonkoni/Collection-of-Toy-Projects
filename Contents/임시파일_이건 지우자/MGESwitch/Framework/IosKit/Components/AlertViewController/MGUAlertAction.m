//
//  MGUAlertAction.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertAction.h"

@implementation MGUAlertAction

- (instancetype)initWithTitle:(NSString *)title
                        style:(UIAlertActionStyle)style
                      handler:(void (^_Nullable)(MGUAlertAction *action))handler
                configuration:(nullable MGUAlertActionConfiguration *)configuration {
    self = [super init];

    if (self) {
        _title = title;
        _style = style;
        _handler = handler;
        _configuration = configuration;
        _enabled = YES;
    }

    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.actionButton.enabled = enabled; // 만들어 진 후에 변화가 있을때 반응할 것이다.
}

@end
