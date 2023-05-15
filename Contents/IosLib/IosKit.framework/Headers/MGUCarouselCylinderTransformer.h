//
//  MGUCarouselCylinderTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUCarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUCarouselCylinderTransformer : MGUCarouselTransformer

 // 위, 아래, 왼쪽, 오른쪽에서 쳐다보는 효과를 가져다 준다. 디폴트 0.0 (-0.1 ~ 0.1)
@property (nonatomic, assign) CGFloat eyePositionXY;

+ (instancetype)cylinderTransformerWithInverted:(BOOL)inverted;
- (instancetype)initWithCylinderTransformerWithInverted:(BOOL)inverted;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
