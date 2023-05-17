//
//  MGATableCellView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-24
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGATableCellView
 @abstract      Mouse Hover 를 Detecting을 할 수 있다. NSTableView, NSOutlineView 의 셀로 사용된다.
 @discussion    당연히 view - based이다.
*/

@interface MGATableCellView : NSTableCellView

@property (nonatomic, copy, nullable) void (^mouseHoverConditionalBlock)(BOOL);

@end

NS_ASSUME_NONNULL_END
