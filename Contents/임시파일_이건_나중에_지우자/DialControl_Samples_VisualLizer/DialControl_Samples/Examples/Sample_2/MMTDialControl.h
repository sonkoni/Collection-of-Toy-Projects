//
//  MMTDialControl.h
//  DialControl Project
//
//  Created by Kwan Hyun Son on 2021/11/08.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MMTClockWisePosition) {
    MMTClockWisePosition1  = 1,
    MMTClockWisePosition2  = 2,
    MMTClockWisePosition3  = 3,
    MMTClockWisePosition4  = 4,
    MMTClockWisePosition5  = 5,
    MMTClockWisePosition6  = 6,
    MMTClockWisePosition7  = 7,
    MMTClockWisePosition8  = 8,
    MMTClockWisePosition9  = 9,
    MMTClockWisePosition10 = 10,
    
    MMTClockWisePosition11 = 11,
    MMTClockWisePosition12 = 12,
    MMTClockWisePosition13 = 13,
    MMTClockWisePosition14 = 14,
    MMTClockWisePosition15 = 15,
    MMTClockWisePosition16 = 16,
    MMTClockWisePosition17 = 17,
    MMTClockWisePosition18 = 18,
    MMTClockWisePosition19 = 19,
    MMTClockWisePosition20 = 20,
    
    MMTClockWisePosition21 = 21,
    MMTClockWisePosition22 = 22,
    MMTClockWisePosition23 = 23,
    MMTClockWisePosition24 = 24,
    MMTClockWisePosition25 = 25,
    MMTClockWisePosition26 = 26,
    MMTClockWisePosition27 = 27,
    MMTClockWisePosition28 = 28,
    MMTClockWisePosition29 = 29,
    MMTClockWisePosition30 = 30,
    
    MMTClockWisePosition31 = 31,
    MMTClockWisePosition32 = 32,
    MMTClockWisePosition33 = 33,
    MMTClockWisePosition34 = 34,
    MMTClockWisePosition35 = 35,
    MMTClockWisePosition36 = 36,
    MMTClockWisePosition37 = 37,
    MMTClockWisePosition38 = 38,
    MMTClockWisePosition39 = 39,
    MMTClockWisePosition40 = 40,
    
    MMTClockWisePosition41 = 41,
    MMTClockWisePosition42 = 42,
    MMTClockWisePosition43 = 43,
    MMTClockWisePosition44 = 44,
    MMTClockWisePosition45 = 45,
    MMTClockWisePosition46 = 46,
    MMTClockWisePosition47 = 47,
    MMTClockWisePosition48 = 48,
    MMTClockWisePosition49 = 49,
    MMTClockWisePosition50 = 50,
    
    MMTClockWisePosition51 = 51,
    MMTClockWisePosition52 = 52,
    MMTClockWisePosition53 = 53,
    MMTClockWisePosition54 = 54,
    MMTClockWisePosition55 = 55,
    MMTClockWisePosition56 = 56,
    MMTClockWisePosition57 = 57,
    MMTClockWisePosition58 = 58,
    MMTClockWisePosition59 = 59,
    MMTClockWisePosition0 = 0
};

typedef NS_ENUM(NSUInteger, MMTCounterClockWisePosition) {
    MMTCounterClockWisePosition1  = MMTClockWisePosition59,
    MMTCounterClockWisePosition2  = MMTClockWisePosition58,
    MMTCounterClockWisePosition3  = MMTClockWisePosition57,
    MMTCounterClockWisePosition4  = MMTClockWisePosition56,
    MMTCounterClockWisePosition5  = MMTClockWisePosition55,
    MMTCounterClockWisePosition6  = MMTClockWisePosition54,
    MMTCounterClockWisePosition7  = MMTClockWisePosition53,
    MMTCounterClockWisePosition8  = MMTClockWisePosition52,
    MMTCounterClockWisePosition9  = MMTClockWisePosition51,
    MMTCounterClockWisePosition10 = MMTClockWisePosition50,
    
    MMTCounterClockWisePosition11 = MMTClockWisePosition49,
    MMTCounterClockWisePosition12 = MMTClockWisePosition48,
    MMTCounterClockWisePosition13 = MMTClockWisePosition47,
    MMTCounterClockWisePosition14 = MMTClockWisePosition46,
    MMTCounterClockWisePosition15 = MMTClockWisePosition45,
    MMTCounterClockWisePosition16 = MMTClockWisePosition44,
    MMTCounterClockWisePosition17 = MMTClockWisePosition43,
    MMTCounterClockWisePosition18 = MMTClockWisePosition42,
    MMTCounterClockWisePosition19 = MMTClockWisePosition41,
    MMTCounterClockWisePosition20 = MMTClockWisePosition40,
    
    MMTCounterClockWisePosition21 = MMTClockWisePosition39,
    MMTCounterClockWisePosition22 = MMTClockWisePosition38,
    MMTCounterClockWisePosition23 = MMTClockWisePosition37,
    MMTCounterClockWisePosition24 = MMTClockWisePosition36,
    MMTCounterClockWisePosition25 = MMTClockWisePosition35,
    MMTCounterClockWisePosition26 = MMTClockWisePosition34,
    MMTCounterClockWisePosition27 = MMTClockWisePosition33,
    MMTCounterClockWisePosition28 = MMTClockWisePosition32,
    MMTCounterClockWisePosition29 = MMTClockWisePosition31,
    MMTCounterClockWisePosition30 = MMTClockWisePosition30,
    
    MMTCounterClockWisePosition31 = MMTClockWisePosition29,
    MMTCounterClockWisePosition32 = MMTClockWisePosition28,
    MMTCounterClockWisePosition33 = MMTClockWisePosition27,
    MMTCounterClockWisePosition34 = MMTClockWisePosition26,
    MMTCounterClockWisePosition35 = MMTClockWisePosition25,
    MMTCounterClockWisePosition36 = MMTClockWisePosition24,
    MMTCounterClockWisePosition37 = MMTClockWisePosition23,
    MMTCounterClockWisePosition38 = MMTClockWisePosition22,
    MMTCounterClockWisePosition39 = MMTClockWisePosition21,
    MMTCounterClockWisePosition40 = MMTClockWisePosition20,
    
    MMTCounterClockWisePosition41 = MMTClockWisePosition19,
    MMTCounterClockWisePosition42 = MMTClockWisePosition18,
    MMTCounterClockWisePosition43 = MMTClockWisePosition17,
    MMTCounterClockWisePosition44 = MMTClockWisePosition16,
    MMTCounterClockWisePosition45 = MMTClockWisePosition15,
    MMTCounterClockWisePosition46 = MMTClockWisePosition14,
    MMTCounterClockWisePosition47 = MMTClockWisePosition13,
    MMTCounterClockWisePosition48 = MMTClockWisePosition12,
    MMTCounterClockWisePosition49 = MMTClockWisePosition11,
    MMTCounterClockWisePosition50 = MMTClockWisePosition10,
    
    MMTCounterClockWisePosition51 = MMTClockWisePosition9,
    MMTCounterClockWisePosition52 = MMTClockWisePosition8,
    MMTCounterClockWisePosition53 = MMTClockWisePosition7,
    MMTCounterClockWisePosition54 = MMTClockWisePosition6,
    MMTCounterClockWisePosition55 = MMTClockWisePosition5,
    MMTCounterClockWisePosition56 = MMTClockWisePosition4,
    MMTCounterClockWisePosition57 = MMTClockWisePosition3,
    MMTCounterClockWisePosition58 = MMTClockWisePosition2,
    MMTCounterClockWisePosition59 = MMTClockWisePosition1,
    MMTCounterClockWisePosition0  = MMTClockWisePosition0
};

@interface MMTDialControl : UIControl

@property (nonatomic, assign, readonly, getter = isFull) BOOL full; // 지금 현재 12시 방향으로 바늘이 가르키고 있다면 이것이 한 바퀴 돈 상태라면 YES를 뱉는다.
@property (nonatomic, copy, nullable) void (^normalSoundPlayBlock)(void);


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder  __attribute__((unavailable("initWithCoder: 이용 불가. 다른 메서드 이용바람.")));
@end

NS_ASSUME_NONNULL_END
