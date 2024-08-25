//
//  MGUHitView.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-21
//  ----------------------------------------------------------------------
//
// 자신의 특정 서브뷰에서만 userInteraction을 enabled 하고 싶을 때 사용함
// 자신의 외부의 터치도 받고 싶다면 아래의 클래스의 `- pointInside:withEvent:`를 참고하라.
// MGUSwipeTableViewCell
// MGUSwipeCollectionViewCell
// MGUSwipeableContentView
//
// HitView 수퍼뷰에 포함되지만 자신의 내부에 포함되지 않은 영역도 터치가능하다. `hitRectValues`
// HitView 내부의 특정 Rect에 대해서도 가능하다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUHitView : UIView
@property (nonatomic, strong, nullable) NSArray <UIView *>*hitSubViews; // 터치가 가능한 서브뷰
@property (nonatomic, strong, nullable) NSArray <NSValue *>*hitRectValues; // 터치가 가능한 영역

/// 서브뷰는 아니지만 같은 윈도우의 자손
/// `hitSubViews`, `hitRectValues` 프라퍼티들과는 배타적으로 사용한다.
/// 본 프라퍼티에 해당하는 부분을 hit를 disable 시켜서 아래쪽에 깔린 `hitOtherView`에
/// 인터렉션이 전달되게한다.
@property (nonatomic, strong, nullable) NSArray <UIView *>*hitOtherViews;
/// 인터렉션이 전달되지 않고 MGUHitView가 받을 때 처리할 컴플리션 블락
/// 프레임워크 특성으로 두 번칠 수 있다
@property (nonatomic, copy, nullable) void (^hitOtherCompletion)(void);

@end

NS_ASSUME_NONNULL_END
