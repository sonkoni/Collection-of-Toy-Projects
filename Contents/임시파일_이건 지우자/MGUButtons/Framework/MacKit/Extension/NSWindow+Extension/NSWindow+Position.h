//  NSWindow+Position.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-18
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

/*!
 @enum       MGAWindowPositionType
 @abstract   미리 정해 놓은 포지션 타입이다. 사이즈가 먼저 정해져야하며, 사이즈를 바꾸면 포지션은 바꾸기전과 달라질 것이다.
 @constant   MGAWindowPositionTypeAboutPanel About Panel을 띄울때의 위치를 유사하게 재현했다.
 @constant   MGAWindowPositionTypeUnDefined1 .....
 @constant   MGAWindowPositionTypeUnDefined1 .....
 */

typedef NS_ENUM(NSUInteger, MGAWindowPositionType) {
    MGAWindowPositionTypeAboutPanel = 1, // 0은 피하는 것이 좋다.
    MGAWindowPositionTypeUnDefined1,
    MGAWindowPositionTypeUnDefined2
};

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (Position)

#pragma mark - position 메서드 : main screen(현재의 키 스크린)의 visibleFrame 에서 계산한다. 아래 독과 위의 메뉴바를 제외한 영역에서의 좌표를 논한다.
// 좌표만 옮길 뿐이다. Show는 - makeKeyAndOrderFront: 메서드 이용하라.
- (void)mgrCenter; // NSWindow에는 - center 메서드가 존재한다. 중앙에서 약간 위로. - mgrCenter 메서드는 완전 중앙이다.
- (void)mgrSetVisibleFrameOrigin:(NSPoint)point geometryFlipped:(BOOL)isGeometryFlipped; // YES 이면 iOS 좌표로 간주.

//! Template
- (void)mgrSetPosition:(MGAWindowPositionType)positionType; // 아직 MGAWindowPositionTypeAboutPanel만 만들었다.

@end

NS_ASSUME_NONNULL_END

//
// https://www.raywenderlich.com/613-windows-and-windowcontroller-tutorial-for-macos
