//
//  MGAPreferencesWindowController.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MacKit/MGAPreferencesStyleInterface.h>
@protocol MGAPreferencePane;

NS_ASSUME_NONNULL_BEGIN

@interface MGAPreferencesWindowController : NSWindowController
@property (nonatomic, assign, getter = isAnimated) BOOL animated; // @dynamic

@property (nonatomic, assign) BOOL hidesToolbarForSingleItem;


- (instancetype)initWithPreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes
                                  style:(MGAPreferencesStyle)style // 디폴트 MGAPreferencesStyleToolbarItems
                               animated:(BOOL)animated // 디폴트 YES
              hidesToolbarForSingleItem:(BOOL)hidesToolbarForSingleItem;  // 디폴트 YES


/**
Show the preferences window and brings it to front.

If you pass a `PreferencePane.Identifier`, the window will activate the corresponding tab.

- Parameter preferencePane: Identifier of the preference pane to display, or `nil` to show the tab that was open when the user last closed the window.

- Note: Unless you need to open a specific pane, prefer not to pass a parameter at all or `nil`.

- See `close()` to close the window again.
- See `showWindow(_:)` to show the window without the convenience of activating the app.
*/
- (void)showPreferencePane:(nullable NSToolbarItemIdentifier)preferenceIdentifier;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithWindow:(nullable NSWindow *)window NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
