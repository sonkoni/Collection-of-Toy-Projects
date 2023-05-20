//
//  MGRDialControl.h
//  DialControl
//
//  Created by Kwan Hyun Son on 20/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGRDialControl;
@class MGRSound;
NS_ASSUME_NONNULL_BEGIN

#pragma mark - 프로토콜
@protocol MGRDialControlDelegate <NSObject>
@required
// - (void)rulerViewDidScroll:(MGRDialControl *)rulerView currentDisplayValue:(CGFloat)currentDisplayValue; // 스크롤이 움직여서 값이 바뀔때만 호출.
@optional
@end


#pragma mark - 인터페이스
@interface MGRDialControl : UIControl

@property (nonatomic, weak) id <MGRDialControlDelegate> delegate;
@property (nonatomic, copy, nullable) void (^normalSoundPlayBlock)(void);
- (void)beginningAnimation; // 그냥 쇼


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
