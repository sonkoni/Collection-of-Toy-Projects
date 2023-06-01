//
//  ForgeOnboardingViewController.h
//  MGUAlertView_koni
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgeOnboardingViewController : UIViewController
@property (nonatomic, assign) BOOL verginLoad; // 디폴트 NO

- (instancetype)initWithVerginLoad:(BOOL)verginLoad NS_DESIGNATED_INITIALIZER; // 앱 생애 주기에서 최초라면 YES를 집어 넣어라.

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
