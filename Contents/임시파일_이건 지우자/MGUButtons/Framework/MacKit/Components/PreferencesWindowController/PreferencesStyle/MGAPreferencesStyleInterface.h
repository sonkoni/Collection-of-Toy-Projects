//
//  MGAPreferencePaneIdentifier.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#ifndef MGAPreferencesStyleInterface_h
#define MGAPreferencesStyleInterface_h

#import <Cocoa/Cocoa.h>
@protocol MGAPreferencesStyleControllerDelegate;
//
NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGAPreferencesStyle
 @abstract   ......
 @constant   MGAPreferencesStyleToolbarItems     .....
 @constant   MGAPreferencesStyleSegmentedControl   .....
 */
typedef NS_ENUM(NSUInteger, MGAPreferencesStyle) {
    MGAPreferencesStyleToolbarItems = 0,
    MGAPreferencesStyleSegmentedControl
};

@protocol MGAPreferencesStyleController <NSObject>
@optional
@required
- (void)setDelegate:(id <MGAPreferencesStyleControllerDelegate>)delegate;
- (id <MGAPreferencesStyleControllerDelegate> _Nullable)delegate;

- (BOOL)isKeepingWindowCentered;
- (NSArray <NSToolbarItemIdentifier>*)toolbarItemIdentifiers;
- (NSToolbarItem * _Nullable)toolbarItemPreferenceIdentifier:(NSToolbarItemIdentifier)preferenceIdentifier;
- (void)selectTabIndex:(NSInteger)index;
@end

@protocol MGAPreferencesStyleControllerDelegate <NSObject>
@optional
@required
- (void)activateTabPreferenceIdentifier:(NSToolbarItemIdentifier)preferenceIdentifier animated:(BOOL)animated;
- (void)activateTabIndex:(NSInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
#endif /* MGAPreferencesStyleInterface_h */
