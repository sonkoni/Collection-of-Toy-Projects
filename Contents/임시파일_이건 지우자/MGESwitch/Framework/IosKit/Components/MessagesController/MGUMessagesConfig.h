//
//  MGUMessagesConfig.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesKeyboardTrackingView;
@class MGUMessagesViewController;
@protocol MGUMessagesAnimator;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUMessagesPresentationStyle) {
    MGUMessagesPresentationStyleTop = 1, // 0은 피하는 것이 좋다.
    MGUMessagesPresentationStyleBottom,
    MGUMessagesPresentationStyleCenter,
    MGUMessagesPresentationStyleCustom
};

// MGUMessagesViewController가 생셩될 경우, status bar에 영향을 준다. 피하고 싶다면, MGUMessagesPresentationContextView를 하자.
typedef NS_ENUM(NSUInteger, MGUMessagesPresentationContext) {
    MGUMessagesPresentationContextAutomatic = 1, // 기댈 수 있는 뷰 컨트롤러가 없을 경우 MGUMessagesViewController를 생성한다.
    MGUMessagesPresentationContextWindowLevel, // MGUMessagesViewController를 생성한다.
    MGUMessagesPresentationContextWindowScene, // MGUMessagesViewController를 생성한다.
    MGUMessagesPresentationContextViewController ,
    MGUMessagesPresentationContextView        // MGUMessagesViewController를 생성하지 않는다.
};

typedef NS_ENUM(NSUInteger, MGUMessagesPresentationDuration) {
    MGUMessagesPresentationDurationAutomatic = 1,
    MGUMessagesPresentationDurationForever,
    MGUMessagesPresentationDurationSeconds,
    MGUMessagesPresentationDurationIndefinite
};

typedef NS_ENUM(NSUInteger, MGUMessagesDimMode) {
    MGUMessagesDimModeNone = 1, // 모달 형태가 아니다.
    MGUMessagesDimModeGray,
    MGUMessagesDimModeColor,
    MGUMessagesDimModeBlur
};

typedef NS_ENUM(NSUInteger, MGUMessagesEvent) {
    MGUMessagesEventWillShow = 1,
    MGUMessagesEventDidShow,
    MGUMessagesEventWillHide,
    MGUMessagesEventDidHide
};

typedef NS_ENUM(NSUInteger, MGUMessagesBecomeKeyWindow) {
    MGUMessagesBecomeKeyWindowAutoMatic = 1, // 딤 모드에 따라.
    MGUMessagesBecomeKeyWindowYES,
    MGUMessagesBecomeKeyWindowNO
} ;

typedef void(^MGUMessagesEventListener)(MGUMessagesEvent event);

@interface MGUMessagesConfig : NSObject

@property (nonatomic, assign) MGUMessagesPresentationDuration duration; //  디폴트 MGUMessagesPresentationDurationAutomatic
@property (nonatomic, assign) NSTimeInterval durationSeconds; // 위의 duration에서 MGUMessagesPresentationDurationSeconds 일때 쓰이는 것.
@property (nonatomic, assign) NSTimeInterval durationIndefiniteDelay; // 위의 duration에서 MGUMessagesPresentationDurationIndefinite 일때 쓰이는 것.
@property (nonatomic, assign) NSTimeInterval durationIndefiniteMinimum; // 위의 duration에서 MGUMessagesPresentationDurationIndefinite 일때 쓰이는 것.

@property (nonatomic, assign) MGUMessagesDimMode dimMode; //  디폴트 MGUMessagesDimModeNone
@property (nonatomic, assign) BOOL dimModeInteractive; // gray, color, blur 일때의 인랙티브 유무, MGUMessagesDimModeNone 일때에는 NO
@property (nonatomic, strong) UIColor *dimColor; // MGUMessagesDimModeColor 에서 쓰임.
@property (nonatomic, assign) UIBlurEffectStyle dimBlurEffectStyle; // MGUMessagesDimModeBlur 에서 쓰임.
@property (nonatomic, assign) CGFloat dimBlurAlpha; // MGUMessagesDimModeBlur 에서 쓰임.

@property (nonatomic, assign) BOOL interactiveHide; //  디폴트 YES - pan gesture 로 날려 버릴 수 있는지 여부.
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle; //  디폴트 UIStatusBarStyleDefault
@property (nonatomic, assign) BOOL prefersStatusBarHidden; //  nullable
@property (nonatomic, assign) BOOL shouldAutorotate; //  디폴트 YES
@property (nonatomic, assign) BOOL ignoreDuplicates; //  디폴트 YES
@property (nonatomic, strong) NSMutableArray <MGUMessagesEventListener>*eventListeners;
@property (nonatomic, strong) NSString *dimModeAccessibilityLabel; // 디폴트  @"dismiss"
@property (nonatomic, assign) MGUMessagesPresentationStyle presentationStyle; //  디폴트 MGUMessagesPresentationStyleTop
@property (nonatomic, strong, nullable) id <MGUMessagesAnimator>animator; // MGUMessagesPresentationStyleCustom 일때 사용함.

@property (nonatomic, assign) MGUMessagesPresentationContext presentationContext; //  디폴트 MGUMessagesPresentationContextAutomatic
@property (nonatomic, assign) UIWindowLevel windowLevel; //  MGUMessagesPresentationContext 의 MGUMessagesPresentationContextWindowLevel, MGUMessagesPresentationContextWindowScene 에서 사
@property (nonatomic, strong) UIWindowScene *windowScene; // presentationContext의 MGUMessagesPresentationContextWindowScene 에서 사용됨
@property (nonatomic, strong) UIViewController *viewController; // presentationContext의 MGUMessagesPresentationContextViewController 에서 사용됨
@property (nonatomic, strong) UIView *view; // presentationContext의 MGUMessagesPresentationContextView 에서 사용됨


@property (nonatomic, strong, nullable) MGUMessagesKeyboardTrackingView *keyboardTrackingView;

@property (nonatomic, copy, nullable) MGUMessagesViewController *(^windowViewController)(MGUMessagesConfig *config);

@property (nonatomic, assign) UIUserInterfaceStyle overrideUserInterfaceStyle; //  @dynamic

@property (nonatomic, assign) MGUMessagesBecomeKeyWindow becomeKeyWindow; // 디폴트 오토매틱
@property (nonatomic, assign, readonly) BOOL shouldBecomeKeyWindow; // @dynamic

@end

NS_ASSUME_NONNULL_END
