//
//  MGRRouter.h
//  Copyright © 2022 mulgrim. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSViewController (Router)
- (id _Nullable)mgrDigScene:(NSString *)identifier;
- (void)mgrOpenScene:(id)scene animated:(BOOL)animated;
- (void)mgrCloseAnimated:(BOOL)animated; // 자기 자신이 닫힌다.
@end
NS_ASSUME_NONNULL_END
#elif TARGET_OS_IOS
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (Router)
- (id _Nullable)mgrDigScene:(NSString *)identifier;
- (void)mgrOpenScene:(id)scene animated:(BOOL)animated;
- (void)mgrCloseAnimated:(BOOL)animated; // 자기 자신이 닫힌다.
@end
NS_ASSUME_NONNULL_END
#endif

// ----------------------------------------------------------------------

// 씬 라우팅 매크로
#define MGR_ROUTER_INTERFACE(SceneTYPE, Scene, HubTYPE)                                 \
NS_ASSUME_NONNULL_BEGIN                                                                 \
@interface SceneRouter (Scene)                                                          \
- (SceneTYPE)build##Scene:(id _Nullable)data;                                           \
- (void)load##Scene##From:(HubTYPE)hub data:(id _Nullable)data animated:(BOOL)animated; \
@end                                                                                    \
NS_ASSUME_NONNULL_END                                                                   \

NS_ASSUME_NONNULL_BEGIN
// 컨트롤러가 구현. 만약 구현하지 않으면 카테고리로 확장한 기본값으로 처리됨.
@protocol MGRRoutable
- (void)openScene:(id)scene animated:(BOOL)flag;
- (void)closeScene:(id)scene animated:(BOOL)flag;
@end

// 라우터 추상클래스
@interface MGRRouter<__covariant WinType, __covariant ServiceType, __covariant StateType> : NSObject
@property (nonatomic, weak) WinType window;
@property (nonatomic) ServiceType service;
@property (nonatomic) StateType state;
+ (instancetype)service:(ServiceType)service state:(StateType)state;
- (instancetype)initWithService:(ServiceType)service state:(StateType)state;
@end
NS_ASSUME_NONNULL_END
