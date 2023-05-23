//
//  LogCellModel.m
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2021/11/03.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "LogCellModel.h"

@interface LogCellModel ()
@end

@implementation LogCellModel

+ (instancetype)prtCellModelWithMainDescription:(NSString *)mainDescription
                                          level:(NSInteger)level
                                           time:(NSString *)time
                       anteMeridiemPostMeridiem:(NSString *)anteMeridiemPostMeridiem
                                           date:(NSString *)date
                                      dayOfWeek:(NSString *)dayOfWeek {
    return [[LogCellModel alloc] initWithMainDescription:mainDescription
                                                      level:level
                                                       time:time
                                   anteMeridiemPostMeridiem:anteMeridiemPostMeridiem
                                                       date:date
                                                  dayOfWeek:dayOfWeek];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithMainDescription:(NSString *)mainDescription
                                  level:(NSInteger)level
                                   time:(NSString *)time
               anteMeridiemPostMeridiem:(NSString *)anteMeridiemPostMeridiem
                                   date:(NSString *)date
                              dayOfWeek:(NSString *)dayOfWeek {
    self = [super init];
    if (self) {
        _mainDescription = mainDescription;
        _anteMeridiemPostMeridiem = anteMeridiemPostMeridiem;
        _dayOfWeek = dayOfWeek;
        _level = level;
        _time = time;
        _date = date;
    }
    return self;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
