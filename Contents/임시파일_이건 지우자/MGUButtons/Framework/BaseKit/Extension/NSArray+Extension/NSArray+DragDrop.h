//
//  NSArray+DragDrop.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-11
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (DragDrop)

// Dest Index를 제거되지 않은 상태로 가정하고 알고리즘이 제작되었다.
- (void)mgrDragFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)mgrDragFromIndexes:(NSIndexSet *)fromIndexes toIndex:(NSUInteger)toIndex;

@end

NS_ASSUME_NONNULL_END
