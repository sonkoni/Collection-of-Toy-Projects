//
//  MGRRouter.h
// ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-03
// ----------------------------------------------------------------------
//  라우터를 구성하는 선언과 프로토콜
//

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSResponder (Router)
- (id _Nullable)mgrDigScene:(NSString *)identifier;
- (void)mgrOpenScene:(id)scene animated:(BOOL)animated;
- (void)mgrCloseSceneAnimated:(BOOL)animated; // 자기 자신이 닫힌다.
@end
NS_ASSUME_NONNULL_END
#elif TARGET_OS_IOS
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIResponder (Router)
- (id _Nullable)mgrDigScene:(NSString *)identifier;
- (void)mgrOpenScene:(id)scene animated:(BOOL)animated;
- (void)mgrCloseSceneAnimated:(BOOL)animated; // 자기 자신이 닫힌다.
@end
NS_ASSUME_NONNULL_END
#endif


// ----------------------------------------------------------------------
// 라우터가 구현한다
// 이름이 정해져 있다. 맥의 경우 AppRouter, 폰/패드의 경우 SceneRouter

#if TARGET_OS_OSX
#define __MGR_ROUTER_CLASS      AppRouter
#define __MGR_STATE_CLASS       AppState
#define __MGR_WINDOW_CLASS      NSWindow
#define __MGR_RESPONDER_CLASS   NSResponder
#define __MGR_VIEWCTRL_CLASS    NSViewController
#elif TARGET_OS_IPHONE
#define __MGR_ROUTER_CLASS      SceneRouter
#define __MGR_STATE_CLASS       SceneState
#define __MGR_WINDOW_CLASS      UIWindow
#define __MGR_RESPONDER_CLASS   UIResponder
#define __MGR_VIEWCTRL_CLASS    UIViewController
#endif

@class __MGR_STATE_CLASS;
NS_ASSUME_NONNULL_BEGIN
@protocol MGRRoutering
@property (nonatomic, weak) __MGR_WINDOW_CLASS *window;
@property (nonatomic, readonly) __MGR_STATE_CLASS *state;
- (instancetype)initWith:(__MGR_STATE_CLASS *)state;
@end
NS_ASSUME_NONNULL_END

// 씬 빌드 매크로
#define MGR_ROUTER_BUILD_ONLY(SceneCLASS, Scene, DataCLASS)  \
@interface __MGR_ROUTER_CLASS (Scene)                        \
- (SceneCLASS)build##Scene:(DataCLASS _Nullable)data;        \
@end

// 씬 빌드/로드 매크로
#define MGR_ROUTER_BUILD_LOAD(SceneCLASS, Scene, DataCLASS)  \
@interface __MGR_ROUTER_CLASS (Scene)                        \
- (SceneCLASS)build##Scene:(DataCLASS _Nullable)data;        \
- (void)load##Scene##From:(__MGR_RESPONDER_CLASS *)hub data:(DataCLASS _Nullable)data animated:(BOOL)animated;  \
@end


// ----------------------------------------------------------------------
// 허브 뷰컨트롤러가 구현한다
// 라우터가 씬을 조립해주면 차일드 처리한다. 구현하지 않으면 카테고리 기본값으로 처리된다.

NS_ASSUME_NONNULL_BEGIN
@protocol MGRScenering
- (void)openScene:(__kindof __MGR_VIEWCTRL_CLASS *)scene animated:(BOOL)flag;
- (void)closeScene:(__kindof __MGR_VIEWCTRL_CLASS *)scene animated:(BOOL)flag;
@end
NS_ASSUME_NONNULL_END


// ----------------------------------------------------------------------
// 뷰모델이 열어준다. : 약속된 특정 씬을 로드할 때 사용한다.
// 라우터가 로드 처리를 관장하며 허브 뷰컨트롤러가 MGRScenering 을 처리한다.
typedef void (^MGRSceneLoader)(id _Nullable promised);

// ----------------------------------------------------------------------
// 뷰컨트롤러가 열어준다.
// 뷰컨트롤러가 직접 완성된 씬을 받아 런청을 처리할 때 사용한다. 이 경우는 load 메서드를 사용하지 않을 때 사용한다.
typedef __kindof __MGR_VIEWCTRL_CLASS * _Nonnull (^MGRSceneBuilder)(id _Nullable promised);
