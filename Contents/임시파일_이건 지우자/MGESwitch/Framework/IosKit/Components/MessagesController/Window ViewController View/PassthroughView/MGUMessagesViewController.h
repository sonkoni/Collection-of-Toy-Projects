//
//  MGUMessagesViewController.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesConfig;

NS_ASSUME_NONNULL_BEGIN

@interface MGUMessagesViewController : UIViewController

@property (nonatomic, strong, nullable) MGUMessagesConfig *config;
- (instancetype)initWithConfig:(MGUMessagesConfig *)config;

+ (MGUMessagesViewController *)newInstanceConfig:(MGUMessagesConfig *)config;
- (void)install;
- (void)uninstall;

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
