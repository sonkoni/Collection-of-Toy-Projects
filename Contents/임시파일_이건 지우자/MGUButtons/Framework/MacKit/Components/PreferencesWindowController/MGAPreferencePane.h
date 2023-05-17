//
//  MGAPreferencePaneIdentifier.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#ifndef MGAPreferencePane_h
#define MGAPreferencePane_h

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGAPreferencePane <NSObject> // NSViewController만 따를 수 있다.
@optional
@required
- (NSToolbarItemIdentifier)preferencePaneIdentifier;
- (NSString *)preferencePaneTitle;
- (NSImage *)toolbarItemIcon; // 디폴트 NSImage(size: .zero)

//- (NSToolbarItemIdentifier)toolbarItemIdentifier; // 디폴트: preferencePaneIdentifier.toolbarItemIdentifier

@end

NS_ASSUME_NONNULL_END
#endif /* MGAPreferencePane_h */
