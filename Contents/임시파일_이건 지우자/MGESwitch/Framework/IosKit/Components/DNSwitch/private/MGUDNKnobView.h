//
//  MGUDNKnobView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUDNSwitch;

NS_ASSUME_NONNULL_BEGIN

@interface MGUDNKnobView : UIView

@property (nonatomic) BOOL on; // MGUDNKnobView의 가시적인상태
@property (nonatomic) BOOL expand; // Horizontally expanded state of the knob, animates changes
@property (nonatomic) UIView *circularSubview; // Round subview of the knob

//! OFF 상태 일때, 달 모양처럼 보일 수 있게 해주는 원형의 분화구들을 표현하는 뷰 3개의 배열
//! 이 분화구 뷰는 circularSubview의 서브뷰가 된다.
@property (nonatomic) NSArray <UIView *>*craters;

- (instancetype)initWithFrame:(CGRect)frame switchOn:(BOOL)switchOn delegate:(MGUDNSwitch *)delegate;

@end

NS_ASSUME_NONNULL_END


