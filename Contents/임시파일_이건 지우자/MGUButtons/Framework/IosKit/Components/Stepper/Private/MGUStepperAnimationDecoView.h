//
//  MGUStepperAnimationDecoView.h
//  GMStepperExample
//
//  Created by Kwan Hyun Son on 2020/11/09.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUStepperAnimationDecoView : UIView

//! 버튼이 눌렸을 때, 보여줄 색을 의미한다.
//! [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
@property (nonatomic, strong) UIColor *impactColor;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) CGFloat cornerRadius; // 본 클래스의 layer의 cornerRadius 0.0으로 하고 애니메이션 layer에만 먹이자.

- (void)highlightingAnimation;
- (void)unHighlightingAnimation;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
