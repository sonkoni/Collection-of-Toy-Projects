//
//  MGUSwipeAccessibilityCustomAction.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeAccessibilityCustomAction.h"
#import "MGUSwipeAction.h"

@implementation MGUSwipeAccessibilityCustomAction

- (instancetype)initWithAction:(MGUSwipeAction *)action
                     indexPath:(NSIndexPath *)indexPath
                        target:(id)target
                      selector:(SEL)selector {
    _action = action;
    _indexPath = indexPath;
    
    NSString *name = nil;
    if (action.accessibilityLabel != nil) {
        name = action.accessibilityLabel;
    } else if (action.title != nil) {
        name = action.title;
    } else if (action.image.accessibilityIdentifier != nil) {
        name = action.title;
    }
    
    if (name != nil) {
        return [super initWithName:name target:target selector:selector];
    } else {
        return nil;
    }
}

@end
