//
//  MGAButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-01
//  ----------------------------------------------------------------------
//
// XUISwitch 참고하는 것이 더 좋을듯.
// NSFontCatalog (Archon->ObjcSubject->NSFontCatalog) 참고
// https://stackoverflow.com/questions/29911989/cocoa-nsview-change-cursor <- 약간 잘못나온듯.

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 https://developer.apple.com/documentation/appkit/nscursor
 @enum       MGAButtonCursorType
 @abstract   ......
 @constant
 @constant
 @constant
 */
typedef NS_ENUM(NSUInteger, MGAButtonCursorType) {
    MGAButtonCursorTypeNone = 0,
    MGAButtonArrowCursorType, // ⬉
    MGAButtonIBeamCursorType,
    MGAButtonCrosshairCursorType, // +
    MGAButtonClosedHandCursorType,
    MGAButtonOpenHandCursorType,
    MGAButtonPointingHandCursorType, // 6 👆
    MGAButtonResizeLeftCursorType,
    MGAButtonResizeRightCursorType,
    MGAButtonResizeLeftRightCursorType,
    MGAButtonResizeUpCursorType,
    MGAButtonResizeDownCursorType,
    MGAButtonResizeUpDownCursorType,
    MGAButtonDisappearingItemCursorType,
    MGAButtonIBeamCursorForVerticalLayoutType,
    MGAButtonOperationNotAllowedCursorType,
    MGAButtonDragLinkCursorType,
    MGAButtonDragCopyCursorType,
    MGAButtonContextualMenuCursorType
};

/*!
 * @abstract    @c MGAButton
 * @discussion  UIButton에 비슷하게 만들었다. 마우스가 hover in 또는 hover out 되었을때, 커서의 모양 및, 실행할 블락을 설정할 수 있다.
 
    __weak __typeof(self) weakSelf = self;
    self.mouseHoverConditionalBlock = ^(BOOL isHoverOK) {
        if (NSApp.isActive == YES) { // super에서 inactive 상태도 추적하므로 거를 필요가 있다.
            if (isHoverOK == YES) {
                weakSelf.rightButton.hidden = NO;
            } else {
                weakSelf.rightButton.hidden = YES;
            }
        }
    };
 */
@interface MGAButton : NSButton

@property (nonatomic, assign, readwrite, getter=isFlipped) BOOL flipped;
@property(nonatomic, assign, readwrite, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is YES
@property (nonatomic, strong, nullable) NSImage *normalImage;
@property (nonatomic, strong, nullable) NSImage *disableImage;
@property (nonatomic, assign) BOOL imageDimsWhenDisabled; // disable 되었을 때. 회색으로 나오는지.

@property (nonatomic, assign) MGAButtonCursorType cursorType; // 마우스로 들어왔을 때(Hover In)의 커서타입.
@property (nonatomic, copy, nullable) void (^mouseHoverConditionalBlock)(BOOL); // hover in & out 시 실행 block

//! NSButton의 bordered(getter=isBordered) 프라퍼티가 NO 일때만 사용된다. super와의 충돌을 막기 위해.
@property (nonatomic, strong, nullable) NSColor *backgroundColor;
@property (nonatomic, strong, nullable) NSColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
