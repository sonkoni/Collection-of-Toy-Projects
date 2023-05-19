//
//  MGUFloatingButton.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-11-13
//  ----------------------------------------------------------------------
//
// 이 헤더만 받으면 된다.

#import <IosKit/MGUFloatingItem.h>
#import <IosKit/MGUFloatingButtonAnimationConfig.h>
#import <IosKit/MGUFloatingItemAnimationConfig.h>
#import <IosKit/MGUFloatingItemsLayout.h>
@class MGUFloatingButton;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef
typedef NS_ENUM(NSInteger, MGUFloatingButtonPosition) {
    MGUFloatingButtonPositionLeftUp,       // 화면의 좌 상에 해당하는 위치
    MGUFloatingButtonPositionLeftDown,     // 화면의 좌 하에 해당하는 위치
    MGUFloatingButtonPositionRightDown,    // 화면의 우 하에 해당하는 위치
    MGUFloatingButtonPositionRightUp       // 화면의 우 상에 해당하는 위치
};

//! 버튼의 상태를 의미한다. 열림. 닫힘. 열리려함. 닫히려함.
typedef NS_ENUM(NSInteger, MGRFloatingActionButtonState) {
    MGRFloatingActionButtonStateClosed,       // 정지상태 : 그냥 메인 버튼 한개만 보인상태
    MGRFloatingActionButtonStateOpen,         // 정지상태 : 다 튀어나온 상태
    MGRFloatingActionButtonStateClosing,      // 닫히려고 할때 : 이제 닫힐 것이다.
    MGRFloatingActionButtonStateOpening       // 열리려고 할때 : 이제 열릴 것이다.
};


#pragma mark - 델리게이트

// <MGUFloatingButtonDelegate> - MGUFloatingButton 클래스의 델리게이트 프로토콜.
@protocol MGUFloatingButtonDelegate <NSObject>
@required
@optional
- (void)floatingActionButtonWillOpen: (MGUFloatingButton *)button;
- (void)floatingActionButtonDidOpen:  (MGUFloatingButton *)button;
- (void)floatingActionButtonWillClose:(MGUFloatingButton *)button;
- (void)floatingActionButtonDidClose: (MGUFloatingButton *)button;
@end


#pragma mark - 인터페이스

IB_DESIGNABLE /* 순서가 중요하다. 다음과 같은 IB_DESIGNABLE 다음에는 @interface 나와야한다. 그 사이에 아무것도 존재해서는 안된다. */
@interface MGUFloatingButton : UIControl

@property (nonatomic, copy, nullable) void (^itemConfiguration)(MGUFloatingItem *item);
@property (nonatomic, weak) id <MGUFloatingButtonDelegate>delegate;

@property (nonatomic, strong) NSMutableArray <MGUFloatingItem *>*items;
@property (nonatomic, strong) NSMutableArray <MGUFloatingItem *>*enabledItems;

@property (nonatomic, strong, nullable) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) IBInspectable UIColor *buttonColor;
@property (nonatomic, strong, nullable) IBInspectable UIColor *highlightedButtonColor;
@property (nonatomic, assign) MGRFloatingActionButtonState buttonState;
@property (nonatomic, assign) IBInspectable CGFloat buttonDiameter;
@property (nonatomic, assign) IBInspectable CGFloat itemSizeRatio;
@property (nonatomic, assign) IBInspectable BOOL closeAutomatically; // 디폴트 YES

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, nullable) IBInspectable UIImage *buttonImage;
@property (nonatomic, strong) IBInspectable UIColor *buttonImageColor;
@property (nonatomic, assign) IBInspectable CGSize buttonImageSize;

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *itemContainerView;

@property (nonatomic, strong) MGUFloatingButtonAnimationConfig *buttonAnimationConfiguration;
@property (nonatomic, strong) MGUFloatingItemAnimationConfig *itemAnimationConfiguration;

//===== MGUFloatingItemAnimationConfig
@property (nonatomic, readonly) BOOL isOnLeftSideOfScreen; // MGUFloatingItemAnimationConfig 에서 사용


/* 초기화 관련 */
- (instancetype)initOnlyActionButtonWithTitle:(NSString *_Nullable)title
                                        image:(UIImage *_Nullable)image
                                  actionBlock:(MGRFloatingActionBlock _Nullable)actionBlock;


- (MGUFloatingItem *)addItem:(NSString *_Nullable)title
                       image:(UIImage *_Nullable)image
                 actionBlock:(MGRFloatingActionBlock _Nullable)actionBlock;

- (void)displayInView:(UIView *)superview onPosition:(MGUFloatingButtonPosition)position; // 디폴트 위치.

@end
NS_ASSUME_NONNULL_END

