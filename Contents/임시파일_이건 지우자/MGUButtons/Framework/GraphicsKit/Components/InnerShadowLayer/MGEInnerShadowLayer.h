//
//  MGEInnerShadowLayer.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-11-08
//  ----------------------------------------------------------------------
// https://blog.helftone.com/demystifying-inner-shadows-in-quartz/
//

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGEInnerShadowLayer : CALayer

@property (nonatomic, assign) CGColorRef innerShadowColor; // shadow opacity를 포함한다.
@property (nonatomic, assign) CGSize innerShadowOffset; // 빛의 광원이 위치하는 점이라고 생각하는 것이 방향을 잡는데 도움이된다.
@property (nonatomic, assign) CGFloat innerShadowBlurRadius;

@property (nonatomic, assign, nullable) CGPathRef path; // NULL 가능.(NULL 이면 cornerRadius 이용함.) 특정한 Path로 이너 쉐도우를 만들 수도 있다.


- (instancetype)initWithInnerShadowColor:(CGColorRef)innerShadowColor
                       innerShadowOffset:(CGSize)innerShadowOffset
                   innerShadowBlurRadius:(CGFloat)innerShadowBlurRadius;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
