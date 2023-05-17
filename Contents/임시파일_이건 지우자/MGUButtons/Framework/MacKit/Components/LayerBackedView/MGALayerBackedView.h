//
//  MGALayerBackedView.h
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGAView 는 UIView 처럼 backup layer가 존재하고, anchorPoint 가 0.5, 0.5 이다.
 * @discussion  MacOS는 초기에 시스템이 transform을 강제로 Identity로 조정하는 버그가 존재하여 이를 우회했다.
 */
@interface MGALayerBackedView : NSView
@property (nonatomic, copy, nullable) void (^initalBlock)(void); // 초기화 단계에서만 사용하라.
@property (nonatomic, assign, readwrite, getter=isFlipped) BOOL flipped;
@property(nonatomic, assign, readwrite, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is YES.
@end

NS_ASSUME_NONNULL_END
