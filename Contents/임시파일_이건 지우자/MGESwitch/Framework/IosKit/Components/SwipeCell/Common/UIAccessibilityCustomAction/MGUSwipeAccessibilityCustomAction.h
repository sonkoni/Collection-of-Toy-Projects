//
//  MGUSwipeAccessibilityCustomAction.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUSwipeAction;
NS_ASSUME_NONNULL_BEGIN

@interface MGUSwipeAccessibilityCustomAction : UIAccessibilityCustomAction

@property (nonatomic, strong) MGUSwipeAction *action;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithAction:(MGUSwipeAction *)action
                     indexPath:(NSIndexPath *)indexPath
                        target:(id)target
                      selector:(SEL)selector;
@end

NS_ASSUME_NONNULL_END
