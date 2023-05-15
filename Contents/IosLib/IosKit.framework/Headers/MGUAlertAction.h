//
//  MGUAlertAction.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUAlertActionConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUAlertAction : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) UIAlertActionStyle style;
@property (nonatomic, strong, readonly, nullable) void (^handler)(MGUAlertAction *action);
@property (nonatomic, strong, readonly, nullable) MGUAlertActionConfiguration *configuration;

@property (nonatomic) BOOL enabled;
@property (nonatomic, weak, nullable) UIButton *actionButton; //! WEAK !!!!

- (instancetype)initWithTitle:(NSString *)title
                        style:(UIAlertActionStyle)style
                      handler:(void (^_Nullable)(MGUAlertAction *action))handler
                configuration:(nullable MGUAlertActionConfiguration *)configuration;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
