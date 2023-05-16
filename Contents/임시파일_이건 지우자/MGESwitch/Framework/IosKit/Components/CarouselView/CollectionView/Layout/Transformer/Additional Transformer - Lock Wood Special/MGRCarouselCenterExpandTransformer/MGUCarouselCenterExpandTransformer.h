//
//  MGUCarouselCenterExpandTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//
// 모든 셀이 바로 옆에 spacing 0.0으로 붙어있으면서, 가운데 셀만 더 커지는 transformer이다.
// transform을 커지게 하는 것인 아니라. frame의 실제 사이즈를 커지게한다.

#import <IosKit/MGUCarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MGUCarouselCenterExpandTransformer 클래스
@interface MGUCarouselCenterExpandTransformer : MGUCarouselTransformer

//! 디폴트 Ratio는 normalCellHeightRatio = 0.3, expandCellHeightRatio = 0.4
@property (nonatomic, assign) CGFloat normalCellHeightRatio; // 일반적인 셀의 높이의 비율 : 전체 콜렉션 뷰의 높이에 대한
@property (nonatomic, assign) CGFloat expandCellHeightRatio; // 커지는 셀의 높이의 비율 : 전체 콜렉션 뷰의 높이에 대한

+ (instancetype)centerExpandTransformerWithRubberEffect:(BOOL)useRubberEffect;
- (instancetype)initWithCenterExpandTransformerWithRubberEffect:(BOOL)useRubberEffect;

- (instancetype)initWithCenterExpandTransformerWithRubberEffect:(BOOL)useRubberEffect
                                          normalCellHeightRatio:(CGFloat)normalCellHeightRatio
                                          expandCellHeightRatio:(CGFloat)expandCellHeightRatio;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
//
// 세 칸을 보여주는 콜렉션 뷰에서 딱 맞게 떨어지면서 정지화면에서 세 개를 보여주고 가운데가 커지는 상황을 유도하려면,
// 예를 들어 normalCellHeightRatio = 0.3, expandCellHeightRatio = 0.4 로하면
// 0.3 + 0.4 + 0.3 이런 방식으로 구성된다. 즉, 합계가 100 %

