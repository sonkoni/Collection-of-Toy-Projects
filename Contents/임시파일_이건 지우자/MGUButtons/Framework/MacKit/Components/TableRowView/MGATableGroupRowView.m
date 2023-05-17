//
//  MGATableGroupRowView.m
//  JustTEST
//
//  Created by Kwan Hyun Son on 2022/11/10.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGATableGroupRowView.h"

@implementation MGATableGroupRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    //! 이상하게 - drawSeparatorInRect: 호출이 안되어서 강제로 호출하겠다.
    [self drawSeparatorInRect:dirtyRect];
}

// 오직 tableView.gridStyleMask에 horizontal grid 설정이 되어있을 시에만 호출.
//! 이상하게 호출이 안된다. drawRect: 에서 호출하겠다.
- (void)drawSeparatorInRect:(NSRect)dirtyRect {
    [[NSColor separatorColor] setFill];
    dirtyRect.origin.y = dirtyRect.size.height - 1.0;
    dirtyRect.size.height = 1.0;
    NSRectFill(dirtyRect);
}

@end
