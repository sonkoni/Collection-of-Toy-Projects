//
//  CRFlatSwitch.h
//  MGUFlatSwitch
//
//  Created by Kwan Hyun Son on 24/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

// * 순서가 중요하다. 다음과 같은 IB_DESIGNABLE 다음에는 @interface 나와야한다. 그 사이에 아무것도 존재해서는 안된다.
NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE @interface MGUFlatSwitch : UIControl

@property (nonatomic) IBInspectable UIColor *checkMarkNCircleStrokeColor; // <- v 색과 v가 원 둘레로 변신했을 때의 색.
@property (nonatomic) IBInspectable UIColor *baseCircleStrokeColor;       // <- v 모양이 나타났을 때, 원 둘레의 색.
@property (nonatomic) IBInspectable CGFloat lineWidth;
@property (nonatomic) IBInspectable CFTimeInterval animationDuration;
//@property (assign, nonatomic) IBInspectable BOOL selected;

@property (nonatomic, copy, nullable) void (^didSelectAnimationCompletionHandler)(void);
@property (nonatomic, copy, nullable) void (^didUnselectAnimationCompletionHandler)(void);

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; // 공개하자.
@end

NS_ASSUME_NONNULL_END
