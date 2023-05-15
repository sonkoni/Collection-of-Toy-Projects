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

// @enum 메시지 뷰를 표시하기 위한 컨테이너를 선택하는 방법을 지정한다.
// MGUMessagesViewController가 생셩될 경우, status bar에 영향을 준다. 피하고 싶다면, MGUMessagesPresentationContextView를 하자.
typedef NS_ENUM(NSUInteger, MGUMessagesPresentationContext) {
    /**
     적절한 항목이 있는 경우 navigation bar 및 tab bar 아래에 메시지 뷰를 표시한다.
     그렇지 않으면 `UIWindowLevelNormal` 레벨의 새 윈도우에 표시된다.
     해당되는 경우 이 옵션을 사용하여 바 아래에 자동으로 표시한다.
     이 옵션은 하향식(top-down) 검색을 포함하기 때문에 뷰 컨트롤러 계층이 커스텀 컨테이너를 통합할 때 적절한 컨텍스트를 찾지 못할 수 있다.
     이 경우 MGUMessagesPresentationContextViewController 옵션은 보다 타게팅된 컨텍스트를 제공할 수 있다.
    */
    MGUMessagesPresentationContextAutomatic = 1, // 기댈 수 있는 뷰 컨트롤러가 없을 경우 MGUMessagesViewController를 생성한다.
    
    /**
     지정된 윈도우 레벨(UIWindowLevel)에 새 윈도우에 메시지를 표시한다.
     SwiftMessages는 <MarginInsetting> 프로토콜을 따르는 모든 메시지 뷰(예: MessageView)의 상단 여백을 상태 바를 고려하여 자동으로 증가시킨다.
     iOS 13부터 윈도우는 status bar를 더 이상 커버할 수 없다.
     유일한 대안은 Config.prefersStatusBarHidden = true를 설정하여 숨기는 것이다.
    */
    MGUMessagesPresentationContextWindowLevel, // MGUMessagesViewController를 생성한다. case window(windowLevel: UIWindow.Level)
    
    /**
     지정된 윈도우 씬에서 지정된 윈도우 레벨(UIWindowLevel)에 새 윈도우에 메시지를 표시한다.
     SwiftMessages는 <MarginInsetting> 프로토콜을 따르는 모든 메시지 뷰(예: MessageView)의 상단 여백을 상태 바를 고려하여 자동으로 증가시킨다.
     iOS 13부터 윈도우는 status bar를 더 이상 커버할 수 없다.
     유일한 대안은 Config.prefersStatusBarHidden = true를 설정하여 숨기는 것이다.
    */
    MGUMessagesPresentationContextWindowScene, // MGUMessagesViewController를 생성한다. case windowScene(_: WindowScene, windowLevel: UIWindow.Level)
    
    /**
     주어진 뷰 컨트롤러를 스타팅 포인트로 이용하고 parent 뷰 컨트롤러 체인을 서칭하여
     적절한 뷰 컨트롤러가 발견되면 내비게이션 바와 탭 바 아래에 메시지 뷰를 표시한다.
     그렇지 않으면 주어진 뷰 컨트롤러의 뷰에 표시된다.
     이 옵션은 뷰 컨트롤러 계층의 원하는 위치에 배치하기 위해 사용할 수 있다.
    */
    MGUMessagesPresentationContextViewController, // case viewController(_: UIViewController)
    
    /**
     주어진 컨테이너 뷰에서 메세지 뷰를 표시.
    */
    MGUMessagesPresentationContextView        // MGUMessagesViewController를 생성하지 않는다. case view(_: UIView)
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
