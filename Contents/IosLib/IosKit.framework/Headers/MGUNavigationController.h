//
//  MGUNavigationController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//
// pop이 정상적으로 완료되었을 때(성공 시)를 감시하여 completion block을 실행할 수 있게 만든 light한
// UINavigationController의 서브 클래스

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUNavigationController : UINavigationController
@property (nonatomic, copy, nullable) void (^popSuccessCompletion)(void);
@property (nonatomic, copy, nullable) void (^popCancelledCompletion)(void);
@end

NS_ASSUME_NONNULL_END
