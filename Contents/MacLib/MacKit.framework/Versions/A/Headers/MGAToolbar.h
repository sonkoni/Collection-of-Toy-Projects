//
//  MGAToolbar.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-04
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSToolbarItem * _Nonnull (^MGAToolbarItemProviderBlock)(void);

@interface MGAToolbar : NSToolbar

@end

NS_ASSUME_NONNULL_END
