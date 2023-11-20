//
//  MGUBioMetricAuthenticator.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-31
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGULAError
 @abstract   LAError enum에서 iOS에 해당하는 것을 따로 묶었다. 보기 편하게.
 @constant   MGULAErrorAuthenticationFailed    Authentication was not successful because user failed to provide valid credentials. 모르겠다. 뭔지
 @constant   MGULAErrorUserCancel              Biometics 가 Run이 발동한 후(앱의 사용은 등록이 된 상태 임) 사용자에 의해 취소됨 (e.g. tapped Cancel button).
 @constant   MGULAErrorUserFallback            Biometics 가 Run이 발동한 후(앱의 사용은 등록이 된 상태 임) 사용자에 의해 (fallback button) 취소됨(Face ID는 2번 실패 후, Touch ID는 3 번 실패 후 fallback button 등장). (Enter Password).
 @constant   MGULAErrorSystemCancel            Authentication(Run 일 듯) was canceled by system (e.g. another application went to foreground).
 @constant   MGULAErrorPasscodeNotSet          Passcode 관련
 @constant   MGULAErrorAppCancel               Authentication(Run 일 듯) was canceled by application (e.g. invalidate was called while authentication was in progress).
 @constant   MGULAErrorInvalidContext          이 호출에 전달된 LAContext 인스턴스는 이전에(previously) invalidated되었다.
 @constant   MGULAErrorBiometryNotAvailable    앱이 Biometrics 승인을 물어봤는데, 거절한 경우.
 @constant   MGULAErrorBiometryNotEnrolled     기계 자체에 FaceID 또는 TouchID 기능 존재하지만, 기계자체에서 등록 활성화가 안되어있음.
 @constant   MGULAErrorBiometryLockout         생체 인식 시도가 너무 많이 실패하여 생체 인식이 잠겼기 때문에 인증에 실패했다. 생체 인식 잠금을 해제하려면 암호가 필요하다. LAPolicyDeviceOwnerAuthenticationWithBiometrics를 평가하면 전제 조건으로 암호(passcode)를 요청한다.
 @constant   MGULAErrorNotInteractive          interactionNotAllowed 프라퍼티 아용하여 forbidden UI를 표시해야 하므로 인증(아마도 Run)에 실패했다.
 @constant   MGULAErrorOther                   기타
 */
typedef NS_ENUM(NSInteger, MGULAError) {
    MGULAErrorAuthenticationFailed = LAErrorAuthenticationFailed,  // -1
    MGULAErrorUserCancel           = LAErrorUserCancel,            // -2
    MGULAErrorUserFallback         = LAErrorUserFallback,          // -3
    MGULAErrorSystemCancel         = LAErrorSystemCancel,          // -4
    MGULAErrorPasscodeNotSet       = LAErrorPasscodeNotSet,        // -5
    MGULAErrorAppCancel            = LAErrorAppCancel,             // -9
    MGULAErrorInvalidContext       = LAErrorInvalidContext,        // -10
    MGULAErrorBiometryNotAvailable = LAErrorBiometryNotAvailable,  // -6
    MGULAErrorBiometryNotEnrolled  = LAErrorBiometryNotEnrolled,   // -7
    MGULAErrorBiometryLockout      = LAErrorBiometryLockout,       // -8
    MGULAErrorNotInteractive       = LAErrorNotInteractive,        // -1004
    MGULAErrorOther                = 1010110
};

void MGULAErrorLog(MGULAError error);
void MGULAErrorLogWithError(NSError *error);

/*!
 @class         MGUBioMetricAuthenticator
 @abstract      ...
 @discussion    ...
 @warning       반드시 + supportBiometry의 값을 고려하고 프로젝트의 코드를 짜야한다. NO이면 biometrics를 완전히 배제한다.
                LAPolicy는 LAPolicyDeviceOwnerAuthenticationWithBiometrics를 사용하라. 1Password 방식이다.
                자세한 설명은 위키(Project:IOs-ObjC/Face ID or Touch ID)를 참고하라.
*/
@interface MGUBioMetricAuthenticator : NSObject

//! Device supports biometrics or not.
//! NO이면(대부분 YES이겠지만) 나머지 메서드를 사용할 필요가 없다. 사용해서는 안되는 쪽으로 알고리즘을 만들겠다.
//! 최초에 이것을 확인하고 NO이면, biometrics를 배제하고 프로젝트를 완성해야한다.
//! if ([MGUBioMetricAuthenticator supportBiometry] == YES) {
//!     // ... BioMetric과 관련된 모든 코드.
//!     // ... BioMetric과 관련된 모든 코드는 이 if문을 통과한 경우만 사용하는 것으로 프로젝트를 완성하는 것이 옳다.
//! } else {
//!     // ... BioMetric 버튼이 존재한다면 hidden 시켜라. 아니면 제거해 버려라.
//! }
@property (class, nonatomic, assign, readonly) BOOL supportBiometry;

//! Deivice의 biometrics 타입이 TouchID인지 FaceID인지 알려준다.
//! LABiometryTypeNone도 존재하지만, + supportBiometry에서 이미 판단되었어야한다.
//! LABiometryTypeTouchID 아니면 LABiometryTypeFaceID를 반환 값으로 간주한다.
@property (class, nonatomic, assign, readonly) LABiometryType biometryType;

@property (nonatomic, assign) NSTimeInterval touchIDAuthenticationAllowableReuseDuration; // 디폴트 60.0
@property (nonatomic, strong, null_resettable) NSString *defalutLocalizedReason; // 위키 : Project:IOs-ObjC/Face ID or Touch ID
@property (nonatomic, nullable, copy) NSString *localizedFallbackTitle; // 디폴트 nil
@property (nonatomic, nullable, copy) NSString *localizedCancelTitle; // 디폴트 nil


+ (instancetype)sharedAuthenticator; // Can also be initialized with '- init' or '+ new'.


//! 1. 전제 조건. Device 가 Biometrics 기능이 존재해야한다. e.g. Face ID, Touch ID 기능 자체가 존재해야한다.
//! 2. 전제 조건. Device 기능이 활성화 되여야한다. e.g. Face ID 기능을 제공하는 Device라고 하더라도 Face ID가 등록이 안되어있다면 처녀등록 불가능하다.
//! 3. 전제 조건. 본 앱이 Biometrics 승인을 받을 준비가 되어있어야한다. 앱을 받자마자 승인 요청하는 것이 아니라, master 비번을 등록이 완료가 되고 난 시점 이후에 Biometrics 승인요청을 해야한다. 바로 할 것인지, 아니면 다음에 앱을 켰을 때 또는 백그라운드에서 다시 복귀했을 때 하던지 그것은 상황에 따라 결정한다. 즉, 현재 앱의 계정이 정해지고(새로 만든 것이든, 기존의 계정에서 가져온 것이든) master 비번까지 정해졌을 때, 그 이 후로 호출해야한다. 이는 User Defaults로 기록해야하며, 만일 앱을 완전히 지우지 않은 상태에서 다른 계정으로 바뀌거나 계정을 날리면, 새로운 계정이 준비될 master 비번까지 준비 될때까지 승인 받을 준비가 되지 않은 것으로 해야한다.
//! 4. 전제 조건. 이미 승인 받은 상태가 아니여야한다. 이는 User Defaults로 기록해야하며 만일 앱을 완전히 지우지 않은 상태에서 다른 계정으로 바뀌거나 계정을 날리면 승인 받은 상태를 다시 받지 않은 상태로 수정해야한다.
//! 5. replyHandler : 위의 4가지 상태를 모두 만족했을 때, - evaluatePolicy:localizedReason: 를 호출하면 승인을 처녀 요청하게 된다. 승인을 요청하는 것은 대문에서 하자. 이미 다 완성된 상태에서 승인요청을하고 승인요청에 수락하면 수락 후, 문을 여는 알고리즘으로 들어가자. 거절하면 거절로 마무리 짓는다. 이 후의 조정은 앱의 설정에서 안내하는 것으로 한다.
/**
 * @brief                  최초 등록 시, 사용하는 메서드. virgin Request인지 앱 자체가 판단하지 못한다.
 * @param policy           LAPolicyDeviceOwnerAuthenticationWithBiometrics 사용.
                           (1Password 방식) 자세한 설명은 위키(Project:IOs-ObjC/Face ID or Touch ID)를 참고.
 * @param localizedReason  승인만 요청해도 Run이 되는 구조이므로 메시가 존재해야한다. 없으면 디폴트를 사용할 것이다.
 * @param readyBlock       ...
 * @param determinedBlock  ...
 * @param replyBlock       success == YES이면 문을 여는 알고리즘 들어가고, 성공 유무와 상관없이 determined YES로 설정해준다.
 * @discussion             사용하기 전에 확인해야할 사항이 반드시 존재한다.
 * @remark         ...
 * @code
        
 * @endcode
*/
- (void)virginRequestAuthorizationWithPolicy:(LAPolicy)policy
                             localizedReason:(NSString * _Nullable)localizedReason
                                  readyBlock:(BOOL(^)(void))readyBlock
                             determinedBlock:(BOOL(^)(void))determinedBlock
                                  replyBlock:(void(^)(BOOL success, NSError *error))replyBlock;
/**
 * @brief                  Run 하는 메서드.
 * @param policy           LAPolicyDeviceOwnerAuthenticationWithBiometrics 사용.
                           (1Password 방식) 자세한 설명은 위키(Project:IOs-ObjC/Face ID or Touch ID)를 참고.
 * @param localizedReason  @"" - 아무거나 넣어도 될듯.
 * @param reply            ... Fallback에 대비해야한다.
 * @discussion             ...
 * @remark                 ...
 * @code
        
 * @endcode
*/
- (void)evaluatePolicy:(LAPolicy)policy
       localizedReason:(NSString *)localizedReason
                 reply:(void(^)(BOOL success, NSError * __nullable error))reply;
/// Typical error codes returned by this call are:
/// @li          LAErrorUserFallback if user tapped the fallback button
/// @li          LAErrorUserCancel if user has tapped the Cancel button
/// @li          LAErrorSystemCancel if some system event interrupted the evaluation (e.g. Home button pressed).

#pragma mark - Deprecated
+ (BOOL)canAuthenticate __attribute__((deprecated("BiometricAuthentication 샘플코드에서 참고했는데, 사용되는 곳이 없었다. https://github.com/rushisangani/BiometricAuthentication")));

@end

NS_ASSUME_NONNULL_END
