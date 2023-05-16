//
//  NSEvent+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-24
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSEvent (Extension)

// Events triggered by user interaction.
@property (class, nonatomic, readonly) NSArray <NSNumber *>*mgrUserInteractionEvents;

// Whether the event was triggered by user interaction.
@property (nonatomic, assign, readonly) BOOL mgrIsUserInteraction;

- (NSPoint)mgrLocationInView:(NSView *)view; // 일반적으로 마우스 다운 이벤트 발생 시, 해당 뷰에서의 좌표를 반환한다.


#pragma mark - DEBUG
- (NSString *)mgrDebugStringEventType; // NSEventType(NS_ENUM -> String)
- (NSString *)mgrDebugStringEventPhase; // NSEventPhase(NS_OPTIONS -> String)
- (NSString *)mgrDebugStringEventMomentumPhase; // NSEventPhase(NS_OPTIONS -> String)

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-05-24 : 라이브러리 정리됨
*/
