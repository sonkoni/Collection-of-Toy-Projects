//
//  NSOutlineView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-09
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOutlineView (Extension)

// 최초에 [self reloadData]; 를 먼저 때리고 expand 또는 collapse를 하라.
- (void)mgrExpandItem:(id _Nullable)item animated:(BOOL)animated;
- (void)mgrCollapseItem:(id _Nullable)item animated:(BOOL)animated;

//! recursively 가 YES 일때, 데이터가 많다면 위험할 수 있다.
- (void)mgrExpandItem:(id _Nullable)item recursively:(BOOL)recursively animated:(BOOL)animated;
- (void)mgrCollapseItem:(id _Nullable)item recursively:(BOOL)recursively animated:(BOOL)animated;

//! Source List 스타일:(Column 1개 짜리)의 설정. Source list은 master detail 인터페이스를 구동하는 사이드바를 표시한다. source list에서 item을 선택하면 인접한 detail 영역의 content가 설정된다. XIB 에서 OutlineView가 두 가지로 나온다. 완전히 프로그래머틱하게 할 수 있도록 설정을 적어두었다. 아직 다 적지는 못했다.
- (void)mgrSetupSourceList;

@end

NS_ASSUME_NONNULL_END
