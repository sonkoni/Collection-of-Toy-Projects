//
//  NSToolbar+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-15
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSToolbar (Extension)
- (void)mgrAddItemWithItemIdentifier:(NSToolbarIdentifier)identifier; // 마지막 아이템 뒤에 추가한다.
- (void)mgrRemoveItemForIdentifier:(NSToolbarIdentifier)identifier; // 해당하는 아이덴티파이어를 만나게 되는 최초 한개 지운다.
- (void)mgrRemoveAllItemsForIdentifier:(NSToolbarIdentifier)identifier; // 해당하는 아이덴티파이어에 해당하는 것을 모두 지운다.
- (BOOL)mgrHasCurrentItemIdentifier:(NSToolbarIdentifier)identifier; // 현재 툴바에 이 아이덴티 파이어에 존재하는가 여부. 넘처 흘러도 존재하는 것.

@end

NS_ASSUME_NONNULL_END
