//
//  MGAView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-04
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGAView 는 UIView 처럼 backup layer가 존재한다.
 * @discussion  색깔과 방향(flipped) 및 userInteractionEnabled을 설정할 수 있다.
 * @warning     drawRect: 메서드가 존재하므로서(단지 존재) 발생하는 레이아웃 버그가 있다. 주석처리하여 우회했다.
 */
@interface MGAView : NSView
@property (nonatomic, assign, readwrite, getter=isFlipped) BOOL flipped;
@property(nonatomic, assign, readwrite, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is YES.
@property (nonatomic, strong, nullable) NSColor *mgrBackgroundColor; // 애플이 private으로 backgroundColor 프라퍼티가 있음.
@end

NS_ASSUME_NONNULL_END
