//
//  MGUCarouselLinearTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselLinearTransformer.h"
#import "MGUCarouselCellLayoutAttributes.h"
#import "MGUCarouselView.h"

@interface MGUCarouselLinearTransformer ()
@property (nonatomic, assign) BOOL isRegular; // 아래 둘 중에 무엇을 쓸 것인지 결정한다.
@property (nonatomic, assign) CGFloat ratioShownAtTheEnd; // 세 아이템만 나올때, 보여질 비율. 아래 것과 배반 isRegular == NO
@property (nonatomic, assign) CGFloat regularSpaceRatio; // 세 아이템 상황이 아닐때 사용. 위의 것과 배반 isRegular == YES
@end

@implementation MGUCarouselLinearTransformer

#pragma mark - Override
- (CGFloat)proposedInteritemSpacing {
    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    
    if (self.isRegular == NO) {
        if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
            return (0.5 * self.carouselView.frame.size.width) +
                    ((self.minimumScale - 2 * self.ratioShownAtTheEnd - 2)/2.0) * self.carouselView.itemSize.width;
        } else {
            return (0.5 * self.carouselView.frame.size.height) +
                    ((self.minimumScale - 2 * self.ratioShownAtTheEnd - 2)/2.0) * self.carouselView.itemSize.height;
        }
    } else {
        if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
            return (self.minimumScale + (2 * self.regularSpaceRatio) - 1) * self.carouselView.itemSize.width * 0.5;
        } else {
            return (self.minimumScale + (2 * self.regularSpaceRatio) - 1) * self.carouselView.itemSize.height * 0.5;
        }
    }
}

- (void)applyTransformTo:(MGUCarouselCellLayoutAttributes *)attributes {
    if (self.carouselView == nil) {
        return;
    }
    
    CGFloat position = attributes.position;
    
    // Static Analyzer 에서 이 주석 부분이 사용되지 않는 것이 확인되었다.
//    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
//    CGFloat itemSpacing;
//    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
//        itemSpacing = attributes.bounds.size.width + [self proposedInteritemSpacing];
//    } else {
//        itemSpacing = attributes.bounds.size.height + [self proposedInteritemSpacing];
//    }
    
    CGFloat scale = MAX(1 - (1-self.minimumScale) * ABS(position), self.minimumScale);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    attributes.transform = transform;
    
    CGFloat alpha = MAX(1 - (1-self.minimumAlpha) * ABS(position), self.minimumAlpha); // 원본에는 MAX를 하지 않아서 가운데 3개 밖에 안보임.
    attributes.alpha = alpha;
    
    NSInteger zIndex = (1 - ABS(position)) * 10;
    attributes.zIndex = zIndex;
    return;
}


#pragma mark - 생성 & 소멸
+ (instancetype)linearTransformerWithMinimumScale:(CGFloat)minimumScale
                                     MinimumAlpha:(CGFloat)minimumAlpha
                                        isRegular:(BOOL)isRegular
                                            ratio:(CGFloat)ratio {
    return [[self alloc] initWithLinearTransformerWithMinimumScale:minimumScale
                                                      MinimumAlpha:minimumAlpha
                                                         isRegular:isRegular
                                                             ratio:ratio];
}

- (instancetype)initWithLinearTransformerWithMinimumScale:(CGFloat)minimumScale
                                             MinimumAlpha:(CGFloat)minimumAlpha
                                                isRegular:(BOOL)isRegular
                                                    ratio:(CGFloat)ratio  {
    self = [super initWithType:MGUCarouselTransformerTypeLockWoodSpecial];
    if (self) {
        self.minimumScale = minimumScale;
        self.minimumAlpha = minimumAlpha;
        self.ratioShownAtTheEnd = ratio;
        self.regularSpaceRatio = ratio;
        self.isRegular = isRegular;
    }
    return self;
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type { NSCAssert(FALSE, @"- initWithType: 사용금지."); return nil; }
@end

//
//! proposedInteritemSpacing - 옴니 그래플 참고하라.
// 셋 만 등장하는 경우.
// 0.5*l + ((α-2β-2)/2)*d  여기서 α는 크기에 대한 비율, β는 보이는 비율, l은 콜렉션뷰의 길이, d는 아이템의 길이
//
// 일정한 간격을 사용하는 경우.
// (α+2μ-1)*d*0.5 여기서 μ는 중앙과 바로 옆 아이템의 눈에 보이는 간격을 만드는 비율, d는 아이템의 길이
