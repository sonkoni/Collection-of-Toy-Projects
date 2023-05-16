//
//  NSButton+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-16
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/49946099/disable-nsbutton-without-grayed-image

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSButton (Extension)

// enable 을 NO 했을 때, 회색으로 나오는 것을 방지하게 해준다.
@property(nonatomic, getter=mgrIsUserInteractionEnabled) BOOL mgrUserInteractionEnabled;

// Notes 앱의 사이드바에서 호버시 나오는 버튼의 스타일 세팅이다.
- (void)mgrSideBarNotesStyleWithImage:(NSImage *)image tintColor:(NSColor *_Nullable)tintColor;

// 일반 flat 한 이미지 하나짜리 버튼이다.
- (void)mgrFlatStyleWithImage:(NSImage * _Nullable)image tintColor:(NSColor *_Nullable)tintColor;

- (void)mgrAddTarget:(nullable id)target
              action:(nullable SEL)action;

//! 위키 - Project:Solution/NSButton
- (void)mgrAddTarget:(nullable id)target
              action:(nullable SEL)action
    forControlEvents:(NSEventMask)controlEvents;

@end

NS_ASSUME_NONNULL_END
