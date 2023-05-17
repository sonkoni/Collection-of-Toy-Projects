//
//  MGAPreferencesTabViewController.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGAPreferencesStyleInterface.h"
@protocol MGAPreferencePane;

NS_ASSUME_NONNULL_BEGIN

@interface MGAPreferencesTabViewController : NSViewController <NSToolbarDelegate, MGAPreferencesStyleControllerDelegate>
@property (nonatomic, assign, getter = isAnimated) BOOL animated; // 디폴트 true
@property (nonatomic, assign, readonly) NSInteger preferencePanesCount; // @dynamic
@property (nonatomic, strong, readonly) NSWindow *window; // @dynamic
@property (nonatomic, strong, readonly, nullable) NSViewController *activeViewController; // @dynamic


- (void)configurePreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes
                           style:(MGAPreferencesStyle)style;


- (void)restoreInitialTab;

@end

NS_ASSUME_NONNULL_END
