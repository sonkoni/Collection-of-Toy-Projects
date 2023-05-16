//
//  NSTableView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-27
//  ----------------------------------------------------------------------
//
// iOS 처럼 편의 메서드를 추가했다.

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTableView (Extension)
@property (nonatomic, assign) NSEdgeInsets mgrContentInset;

//! iOS 의 - cellForRowAtIndexPath: 메서드와 효과 동일.
- (nullable __kindof NSTableCellView *)mgrCellForRow:(NSInteger)row column:(NSInteger)column;


#pragma mark - Select & Deselect
- (void)mgrSelectRow:(NSInteger)row animated:(BOOL)animated;
- (void)mgrDeselectRow:(NSInteger)row animated:(BOOL)animated;

//! allowsMultipleSelection 에서만 사용.
- (void)mgrSelectRowAtIndexes:(NSIndexSet *)indexSet animated:(BOOL)animated;
- (void)mgrSelectAllRowAnimated:(BOOL)animated;
- (void)mgrDeselectRowAtIndexes:(NSIndexSet *)indexSet animated:(BOOL)animated;
- (void)mgrDeselectAllRowAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
