//
//  MGUSwipeActionButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import "MGUSwipeActionsConfiguration.h"
@class MGUSwipeAction;

NS_ASSUME_NONNULL_BEGIN

/*!
 * @class SwipeActionButton
 * @abstract 기존에는 UIButton 의 서브클래스였다.
 * @discussion 나중에 image가 움직일 것을 대비하여 만들었다.
 * @warning 혹시나 나중에 문제가 되면 SwipeActionButton_OLD파일로 돌아가자.
 */
@interface MGUSwipeActionButton : UIControl

@property (nonatomic, assign) CGFloat spacing; // 디폴트 8.0
@property (nonatomic, assign) BOOL shouldHighlight; // 디폴트 YES
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor;
@property (nonatomic, assign) CGFloat maximumImageHeight; // 디폴트 0.0. 모든 SwipeActionButton에서의 최댓값을 넣어준다.
@property (nonatomic, assign) MGUSwipeVerticalAlignment verticalAlignment; // 디폴트 centerFirstBaseline
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

- (instancetype)initWithAction:(MGUSwipeAction *)action NS_DESIGNATED_INITIALIZER;
- (CGFloat)preferredWidth:(CGFloat)maximum;


#pragma mark - NS_UNAVAILABLE
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
