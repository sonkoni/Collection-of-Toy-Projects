//
//  MGAShrinkButton.h
//  RotationTEST
//
//  Created by Kwan Hyun Son on 2022/10/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

//! 이미지 하나 넣는 flat 한 shrink 버튼이다.
@interface MGAShrinkButton : NSButton
@property (nonatomic, copy, nullable) void (^initalBlock)(void); // 초기화 단계에서만 사용하라.

//! 카테고리를 가장한 서브 클래스를 반환한다. 기능이 shrink밖에 없다. 0.1 보다 작은 값이 오면 디폴트로 0.85로 설정한다.
+ (MGAShrinkButton *)mgrShinkButton:(CGFloat)scale;
@end

NS_ASSUME_NONNULL_END
