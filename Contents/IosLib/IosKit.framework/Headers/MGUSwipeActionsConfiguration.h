//
//  MGUSwipeActionsConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUSwipeExpansionStyle;
@class MGUSwipeAction;
@protocol MGUSwipeExpanding;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUSwipeTransitionStyle) {
    MGUSwipeTransitionStyleBorder = 0,
    MGUSwipeTransitionStyleDrag,
    MGUSwipeTransitionStyleReveal
};

typedef NS_ENUM(NSUInteger, MGUSwipeVerticalAlignment) {
    MGUSwipeVerticalAlignmentCenterFirstBaseline = 0,
    MGUSwipeVerticalAlignmentCenter
};

typedef CGFloat MGUSwipeActionsOrientation NS_TYPED_EXTENSIBLE_ENUM;
static const MGUSwipeActionsOrientation MGUSwipeActionsOrientationLeft = -1.0; // The left side of the cell.
static const MGUSwipeActionsOrientation MGUSwipeActionsOrientationRight = 1.0; // The right side of the cell.


@interface MGUSwipeActionsConfiguration : NSObject

@property (nonatomic, strong, nullable) NSArray <MGUSwipeAction *>*actions;
@property (nonatomic, assign) MGUSwipeTransitionStyle transitionStyle; // 디폴트 SwipeTransitionStyleBorder
@property (nonatomic, strong, nullable) MGUSwipeExpansionStyle *expansionStyle;
@property (nonatomic, strong, nullable) id <MGUSwipeExpanding>expansionDelegate;

@property (nonatomic, strong, nullable) UIColor *backgroundColor; // SwipeActionsView의 background color. 가장 밑바닥 배경

@property (nonatomic, assign) MGUSwipeVerticalAlignment buttonVerticalAlignment;
@property (nonatomic, assign) CGFloat maximumButtonWidth; // null 을 CGFLOAT_MAX 로 표현해보자.
@property (nonatomic, assign) CGFloat minimumButtonWidth; // null 을 CGFLOAT_MAX 로 표현해보자.
@property (nonatomic, assign) CGFloat buttonPadding; // null 을 CGFLOAT_MAX 로 표현해보자.
@property (nonatomic, assign) CGFloat buttonSpacing; // null 을 CGFLOAT_MAX 로 표현해보자.


//! 배열의 첫 번째 요소가 가장 edge에 배치된다.
+ (instancetype)configurationWithActions:(NSArray <MGUSwipeAction *>*)actions;

@end

NS_ASSUME_NONNULL_END
