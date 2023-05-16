//
//  MGACarouselTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//
// 편하게 사용할 수 있는 Convenience Transformer - 구체적인 Transformer는 Additional configuration 폴더에 만든다.

#import <Cocoa/Cocoa.h>
@class MGACarouselView;
@class MGACarouselCellLayoutAttributes;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NS_ENUM MGACarouselTransformerType
typedef NS_ENUM(NSInteger, MGACarouselTransformerType) {
    MGACarouselTransformerTypeCrossFading = 1,
    MGACarouselTransformerTypeZoomOut,
    MGACarouselTransformerTypeDepth,
    
    MGACarouselTransformerTypeOverlap,
    MGACarouselTransformerTypeLinear,
    
    MGACarouselTransformerTypeCoverFlow,
    MGACarouselTransformerTypeFerrisWheel,
    MGACarouselTransformerTypeInvertedFerrisWheel,
    MGACarouselTransformerTypeCubic,
    
    MGACarouselTransformerTypeLockWoodSpecial //! 재정의한 Transformer에 해당한다.
};


#pragma mark - MGACarouselViewTransformer 클래스
@interface MGACarouselTransformer : NSObject

@property (nonatomic, weak, nullable) MGACarouselView *carouselView;
@property (nonatomic, assign) CGFloat minimumScale;                 // 디폴트 0.65
@property (nonatomic, assign) CGFloat minimumAlpha;                 // 디폴트 0.6
@property (nonatomic, assign) MGACarouselTransformerType type;

- (void)applyTransformTo:(MGACarouselCellLayoutAttributes *)attributes;
- (CGFloat)proposedInteritemSpacing;
- (void)carouselViewWillBeginDragging:(MGACarouselView *)carouselView; // 필요할 경우 사용한다.

- (instancetype)initWithType:(MGACarouselTransformerType)type;

- (CGRect)convertDumyFrame:(CGRect)frame; // backingScaleFactor 에 맞춰서 적절하게 조정한다.

#pragma mark - NS_UNAVAILABLE
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
//
// 아래 셋은 self.carouselView.interitemSpacing과 동일하다. 즉, - proposedInteritemSpacing 를 사용안함.
// MGACarouselTransformerTypeCrossFading
// MGACarouselTransformerTypeZoomOut
// MGACarouselTransformerTypeDepth
//
// 아래 둘의 거의 유사하며, - proposedInteritemSpacing의 차이만 존재한다.
// MGACarouselTransformerTypeOverlap,
// MGACarouselTransformerTypeLinear,
