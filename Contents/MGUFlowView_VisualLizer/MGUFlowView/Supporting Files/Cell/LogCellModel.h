//
//  LogCellModel.h
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h> /* for CGFloat, CGMacro */

NS_ASSUME_NONNULL_BEGIN

@interface LogCellModel : NSObject

//! left
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *anteMeridiemPostMeridiem;

//! center
@property (nonatomic, strong) NSString *mainDescription;
@property (nonatomic, assign) NSInteger level;

//! left
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *dayOfWeek;

- (instancetype)initWithMainDescription:(NSString * _Nullable)mainDescription
                                  level:(NSInteger)level
                                   time:(NSString * _Nullable)time
               anteMeridiemPostMeridiem:(NSString * _Nullable)anteMeridiemPostMeridiem
                                   date:(NSString * _Nullable)date
                              dayOfWeek:(NSString * _Nullable)dayOfWeek NS_DESIGNATED_INITIALIZER;

//! Convenience initializer
+ (instancetype)prtCellModelWithMainDescription:(NSString * _Nullable)mainDescription
                                          level:(NSInteger)level
                                           time:(NSString * _Nullable)time
                       anteMeridiemPostMeridiem:(NSString * _Nullable)anteMeridiemPostMeridiem
                                           date:(NSString * _Nullable)date
                                      dayOfWeek:(NSString * _Nullable)dayOfWeek;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("new 이용불가. 대신에 - initWithMainDescription:level:time:anteMeridiemPostMeridiem:date:dayOfWeek: 이용바람.")));
- (instancetype)init __attribute__((unavailable("init 이용불가. 대신에 - initWithMainDescription:level:time:anteMeridiemPostMeridiem:date:dayOfWeek: 이용바람.")));

@end

NS_ASSUME_NONNULL_END
