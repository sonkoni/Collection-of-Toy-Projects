//
//  MGAStepperAnimationDecoView.h
//  MGAStepper_Mac
//
//  Created by Kwan Hyun Son on 2022/11/02.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGAStepperAnimationDecoView : NSView

//! 버튼이 눌렸을 때, 보여줄 색을 의미한다.
//! [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
@property (nonatomic, strong) NSColor *impactColor;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) CGFloat cornerRadius; // 본 클래스의 layer의 cornerRadius 0.0으로 하고 애니메이션 layer에만 먹이자.

- (void)highlightingAnimation;
- (void)unHighlightingAnimation;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
