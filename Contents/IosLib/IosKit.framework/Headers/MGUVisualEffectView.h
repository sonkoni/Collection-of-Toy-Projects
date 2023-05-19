//
//  MGUVisualEffectView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGUVisualEffectView는 blur의 intensity 정도를 정할 수 있다.
 * @discussion  생성 후 변화를 주는 것(슬라이드로 intensity change)은 DEBUG 모드에서만 사용해야한다.
 */
@interface MGUVisualEffectView : UIVisualEffectView

- (instancetype)initWithEffect:(UIVisualEffect *)effect intensity:(CGFloat)intensity;

#if DEBUG && TARGET_OS_SIMULATOR  // 디버깅용이다.
@property (nonatomic, assign) CGFloat debugIntensity;
- (instancetype)initWithEffect:(UIVisualEffect *)effect debugIntensity:(CGFloat)debugIntensity;
#endif

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

