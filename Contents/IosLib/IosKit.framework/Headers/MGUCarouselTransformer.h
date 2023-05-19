//
//  MGUCarouselTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//
// 편하게 사용할 수 있는 Convenience Transformer - 구체적인 Transformer는 Additional configuration 폴더에 만든다.

#import <UIKit/UIKit.h>
@class MGUCarouselView;
@class MGUCarouselCellLayoutAttributes;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NS_ENUM MGUCarouselTransformerType
typedef NS_ENUM(NSInteger, MGUCarouselTransformerType) {
    MGUCarouselTransformerTypeCrossFading = 1,
    MGUCarouselTransformerTypeZoomOut,
    MGUCarouselTransformerTypeDepth,
    
    MGUCarouselTransformerTypeOverlap,
    MGUCarouselTransformerTypeLinear,
    
    MGUCarouselTransformerTypeCoverFlow,
    MGUCarouselTransformerTypeFerrisWheel,
    MGUCarouselTransformerTypeInvertedFerrisWheel,
    MGUCarouselTransformerTypeCubic,
    
    MGUCarouselTransformerTypeLockWoodSpecial //! 재정의한 Transformer에 해당한다.
};


#pragma mark - MGUCarouselViewTransformer 클래스
@interface MGUCarouselTransformer : NSObject

@property (nonatomic, weak, nullable) MGUCarouselView *carouselView;
@property (nonatomic, assign) CGFloat minimumScale;                 // 디폴트 0.65
@property (nonatomic, assign) CGFloat minimumAlpha;                 // 디폴트 0.6
@property (nonatomic, assign) MGUCarouselTransformerType type;

- (void)applyTransformTo:(MGUCarouselCellLayoutAttributes *)attributes;
- (CGFloat)proposedInteritemSpacing;
- (void)carouselViewWillBeginDragging:(MGUCarouselView *)carouselView; // 필요할 경우 사용한다.

- (instancetype)initWithType:(MGUCarouselTransformerType)type;


#pragma mark - NS_UNAVAILABLE
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
//
// 아래 셋은 self.carouselView.interitemSpacing과 동일하다. 즉, - proposedInteritemSpacing 를 사용안함.
// MGUCarouselTransformerTypeCrossFading
// MGUCarouselTransformerTypeZoomOut
// MGUCarouselTransformerTypeDepth
//
// 아래 둘의 거의 유사하며, - proposedInteritemSpacing의 차이만 존재한다.
// MGUCarouselTransformerTypeOverlap,
// MGUCarouselTransformerTypeLinear,
