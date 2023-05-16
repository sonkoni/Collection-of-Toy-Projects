//
//  MGUMessages.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <IosKit/MGUMessagesConfig.h>  // 끝
#import <IosKit/MGUMessageView.h>  // MGUMessagesBaseView 상속
#import <IosKit/MGUMessagesCornerRoundingView.h> // 끝
#import <IosKit/MGUMessagesViewControllerTransitioning.h> // 끝

// 내부에서만 쓰이지만, 공개해야 내부도 인식을 해서.
#import <IosKit/MGUMessagesPresenter.h> // MGUMessagesAnimationContext

NS_ASSUME_NONNULL_BEGIN
//MGUMessagesController
//
typedef UIView *_Nonnull (^MGUMessagesViewProvider)(void);

@interface MGUMessagesController : NSObject <MGUMessagesPresenterDelegate>

@property (nonatomic, assign) NSTimeInterval pauseBetweenMessages; // 디폴트 0.5
@property (nonatomic, strong) MGUMessagesConfig *defaultConfig;

#pragma mark - Show
- (void)showPresenter:(MGUMessagesPresenter *)presenter; // 지정 초기화처럼 show는 모두 이것을 거친다.
- (void)showConfig:(MGUMessagesConfig *)config view:(UIView *)view;
- (void)showConfig:(MGUMessagesConfig *)config viewProvider:(MGUMessagesViewProvider)viewProvider;
- (void)showView:(UIView *)view;
- (void)showViewProvider:(MGUMessagesViewProvider)viewProvider;


- (void)hideAnimated:(BOOL)animated;
- (void)hideAll;
- (void)hideIdentifier:(NSString *)identifier;
- (void)hideCountedIdentifier:(NSString *)identifier;

- (NSInteger)countIdentifier:(NSString *)identifier;
- (void)setCount:(NSInteger)count identifier:(NSString *)identifier;

- (BOOL)canBeExchanged; // 내가 만든 확인 메서드이다. 현재 showing 상태이고 hiding이 발동되지 않았는가를 의미한다.
- (NSString *)currentIdentifier; // 내가 만든 확인 메서드이다.


#pragma mark - Accessing messages
- (UIView * _Nullable)currentView;
- (UIView * _Nullable)currentViewWithIdentifier:(NSString *)identifier;
- (UIView * _Nullable)queuedViewWithIdentifier:(NSString *)identifier;
- (UIView * _Nullable)currentOrQueuedWithIdentifier:(NSString *)identifier;


+ (instancetype)sharedInstance; // 사용하든 말든 그건 자유.
@end

NS_ASSUME_NONNULL_END
