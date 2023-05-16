//
//  MGALayerBackedView.h
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGALayerBackedView 는 UIView 처럼 backup layer가 존재하고, anchorPoint 가 0.5, 0.5 이다.
 * @discussion  MacOS는 초기에 시스템이 transform을 강제로 Identity로 조정하는 버그가 존재하여 이를 우회했다.
 * @warning     drawRect: 메서드가 존재하므로서(단지 존재) 발생하는 레이아웃 버그가 있다. split view에서 빠르게 열고 닫으면 layout 이 깨진다.
 */
@interface MGALayerBackedView : NSView
@property (nonatomic, copy, nullable) void (^initalBlock)(void); // 초기화 단계에서만 사용하라.
@property (nonatomic, assign, readwrite, getter=isFlipped) BOOL flipped;
@property(nonatomic, assign, readwrite, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is YES.

@property (nonatomic, strong, nullable) NSColor *mgrBackgroundColor; // 애플이 private으로 backgroundColor 프라퍼티가 있음.
@end
NS_ASSUME_NONNULL_END
