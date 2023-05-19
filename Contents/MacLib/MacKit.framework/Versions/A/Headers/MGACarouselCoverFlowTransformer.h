//
//  MGACarouselCoverFlowTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//
#import <MacKit/MGACarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGACarouselCoverFlowTransformer : MGACarouselTransformer

 // 위, 아래, 왼쪽, 오른쪽에서 쳐다보는 효과를 가져다 준다. 디폴트 0.0 (-0.1 ~ 0.1)
@property (nonatomic, assign) CGFloat eyePositionXY;

+ (instancetype)coverFlowTransformerWithRubberEffect:(BOOL)useRubberEffect;
- (instancetype)initWithCoverFlowTransformerWithRubberEffect:(BOOL)useRubberEffect;

- (instancetype)initWithType:(MGACarouselTransformerType)type NS_UNAVAILABLE; // 사용금지...
@end

NS_ASSUME_NONNULL_END
