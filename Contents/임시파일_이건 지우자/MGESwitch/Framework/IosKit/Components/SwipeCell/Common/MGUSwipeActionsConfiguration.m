//
//  MGUSwipeActionsConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeActionsConfiguration.h"
#import "MGUSwipeExpansionStyle.h"
#import "MGUSwipeExpanding.h"

@implementation MGUSwipeActionsConfiguration

+ (instancetype)configurationWithActions:(NSArray <MGUSwipeAction *>*)actions {
    MGUSwipeActionsConfiguration *configuration = [[MGUSwipeActionsConfiguration alloc] init];
    configuration.actions = actions;
    return configuration;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUSwipeActionsConfiguration *self) {
    self->_transitionStyle = MGUSwipeTransitionStyleBorder;
    self->_buttonVerticalAlignment = MGUSwipeVerticalAlignmentCenterFirstBaseline;
    self->_maximumButtonWidth = CGFLOAT_MAX;
    self->_minimumButtonWidth = CGFLOAT_MAX;
    self->_buttonPadding = CGFLOAT_MAX;
    self->_buttonSpacing = CGFLOAT_MAX;
}

@end
