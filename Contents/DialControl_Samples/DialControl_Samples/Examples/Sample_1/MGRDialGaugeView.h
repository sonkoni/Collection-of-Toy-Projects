//
//  MGRDialGaugeView.h
//  DialControl
//
//  Created by Kwan Hyun Son on 20/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


#pragma mark - typedef

typedef NS_ENUM(NSInteger, MGROrangeLampPosition) { // orange lamp 및 손잡이 방향(둘 다 싱크 됨)
    MGROrangeLampPosition12 = 12,
    MGROrangeLampPosition1  = 1,
    MGROrangeLampPosition2  = 2,
    MGROrangeLampPosition3  = 3,
    MGROrangeLampPosition4  = 4,
    MGROrangeLampPosition5  = 5,
    MGROrangeLampPosition6  = 6,
    MGROrangeLampPosition7  = 7,
    MGROrangeLampPosition8  = 8,
    MGROrangeLampPosition9  = 9,
    MGROrangeLampPosition10 = 10,
    MGROrangeLampPosition11 = 11
};


#pragma mark - 인터페이스

@interface MGRDialGaugeView : UIImageView

- (void)setupDialGaugeView;
- (void)rotatePositionOfOrangeLampAt:(MGROrangeLampPosition)position;
- (void)beginningAnimation; // 그냥 쇼.


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
