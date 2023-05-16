//
//  MGACarouselCenterExpandTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGACarouselCenterExpandTransformer.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "MGACarouselView.h"
#import "MGACarouselView_Internal.h"
#import "MGEDisplayLink.h"
#import "NSScrollView+Extension.h"


#pragma mark - MGACarouselCenterExpandTransformer
@interface MGACarouselCenterExpandTransformer ()
/** Rubber Effect 를 위해 **/
@property (nonatomic, strong) MGEDisplayLink *MGEDisplayLink;
@property (nonatomic, assign) CGFloat toggle;
@property (nonatomic, assign) BOOL useRubberEffect;
@property (nonatomic, assign) CGFloat currentOffset;
@end

@implementation MGACarouselCenterExpandTransformer


#pragma mark - Override
//! MGACarouselCollectionViewLayout에서 이 값을 사용하지만, MGACarouselCoverFlowTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGACarouselCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing { //! Cell 끼리 딱 붙어있다.
    return 0.0f;
}

- (void)applyTransformTo:(MGACarouselCellLayoutAttributes *)attributes {
    if (self.carouselView == nil) {
        return;
    }
    
    NSScrollView *scrollView = self.carouselView.scrollView;
    CGFloat itemSizeWidth;
    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        itemSizeWidth = self.carouselView.itemSize.width;
    } else {
        itemSizeWidth = self.carouselView.itemSize.height;
    }
    
    CGFloat position = attributes.position;
    position = MIN(MAX(-position,-1.0) ,1.0); // 오른쪽을 -1.0 왼쪽을 1.0으로 바꾼다.
    
    //! 아래 3개 static 변수는 rubberEffect를 이용할 경우에만 이용한다.
    static NSInteger currentIndex = 0;
    static NSInteger justPastIndex = 0; // currentIndex 바로 옆에 있는 인덱스이며, 현재 인덱스를 기준으로 방금 지나쳐간 인덱스를 의미한다.
    static BOOL needsRubberEffect = NO;
    if (_useRubberEffect == YES) { //! 이 transformer type에서 rubber effect를 사용할 것인가.
        if (self.carouselView.currentIndex != currentIndex) {
            if (self.carouselView.volumeType != MGACarouselVolumeTypeInfinite) {
                if (self.carouselView.currentIndex > currentIndex) {
                    justPastIndex = self.carouselView.currentIndex - 1;
                } else {
                    justPastIndex = self.carouselView.currentIndex + 1;
                }
            } else {
                CGFloat offset;
                if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
                    offset = scrollView.mgrContentOffset.x;
                } else {
                    offset = scrollView.mgrContentOffset.y;
                }
                
                if (offset > self.currentOffset) {
                    justPastIndex = self.carouselView.currentIndex - 1;
                } else {
                    justPastIndex = self.carouselView.currentIndex + 1;
                }
                self.currentOffset = offset;
            }
            
            currentIndex = self.carouselView.currentIndex;
            needsRubberEffect = YES;
        }
          
        if (self.carouselView.rubberEffect == NO) { // rubber effect를 적용할 수 있는 시기인가에 대한 답.
            needsRubberEffect = NO;
            _toggle = 0.0;
        } else {
            if (needsRubberEffect == YES) { // 반드시 물어야한다.
                CGFloat startProgress; // 원래는 단순히 0.0 이었는데, 빠른 pan에 더 정밀하게 반응하게 만들었다.
                if (justPastIndex < currentIndex) { //! <===== 아이템들이 이 방향으로 이동한다.
                    startProgress = (ceil(attributes.position) - attributes.position) + 0.5;
                } else { //! =====> 아이템들이 이 방향으로 이동한다.
                    startProgress = 1 - (ceil(attributes.position) - attributes.position) + 0.5;
                }
                
                if (startProgress >= 1.0) {
                    startProgress = startProgress - 1.0;
                }
                
                [self.MGEDisplayLink invalidate];
                self.MGEDisplayLink.progressBlock = nil;
                needsRubberEffect = NO;
                _toggle = 1.0;
                __weak __typeof(self)weakSelf = self;
                self.MGEDisplayLink.progressBlock = ^(CGFloat progress) {
                    __strong __typeof(weakSelf) self = weakSelf;
                    self.toggle = (1.0 - progress); // 1.0 -> 0.0
                    [self.carouselView.collectionViewLayout invalidateLayout]; // forceInvalidate 을 사용해서는 안된다.
                };
                [self.MGEDisplayLink startAnimationWithStartProgress:startProgress]; // 원래는 0.0으로 했었다.
            }
            
            if (ABS(position) < 1.0) { // 최적화를 시켰다. ① 아래 참조.
                if (position >= 0.5) {
                    position = 1.0; // 포지션은 왼쪽이 1.0이다. 즉, 더 왼쪽으로 이동한다.
                } else if (position >= -0.5) {
//                    position = 0.0;
                    if (justPastIndex < currentIndex) { //! <===== 아이템들이 이 방향으로 이동한다.
                        position = -_toggle;
                    } else { //! =====> 아이템들이 이 방향으로 이동한다.
                        position = _toggle;
                    }
                } else {
                    position = -1.0;
                }
            }
            
            if (justPastIndex < currentIndex) { //! <===== 아이템들이 이 방향으로 이동한다.
                if (attributes.position > -1.5 && attributes.position <= -0.5) { // 원래(attributes.position) 값이므로 왼쪽영역이다.
                    position = position - _toggle;
                }
            } else { //! =====> 아이템들이 이 방향으로 이동한다.
                if (attributes.position < 1.5 && attributes.position >= 0.5) {
                    position = position + _toggle;
                }
            }
        }
    }
    
    
    CGRect rect = scrollView.contentView.bounds;
    attributes.mgrCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

    //! position == 0.0 일때, expand된 상태의 높이를 가지게된다. actualItemSize(또는 itemSize)로 주어지는 것은
    //! normal 상태의 값이다. 즉, ABS(position) == 1.0(normal)이면 ratio == 1 이된다.
    //! ex 30% 40% 30%로 100%를 만든다면, CGFloat ratio = (- (1.0/3.0) * ABS(position)) + (4.0/3.0);
    CGFloat ratio =
    (((-self.expandCellHeightRatio + self.normalCellHeightRatio) / self.normalCellHeightRatio) * ABS(position)) + (self.expandCellHeightRatio / self.normalCellHeightRatio);
        
    //! rubberEffect가 발동할 경우, 진행 상황을 attributes.position으로 Cell에 전달하기 힘들어진다.
    //! 따라서 progress(0.0 ~ 1.0 : 가운데가 0.0)상태를 centerProgress 에 넣어서 전달하자.
    //! ex) expandCellHeightRatio == 0.4, normalCellHeightRatio == 0.3 일 경우
    //! ratio가 1.333333(=정중앙) 일 때, progress는 0.0 이고, ratio가 1.000000 일 때, progress는 1.0 이다.
    CGFloat progress = ((1.0 / (1.0 - (self.expandCellHeightRatio / self.normalCellHeightRatio))) * (ratio - 1.0)) + 1.0;
    progress = MAX(MIN(progress, 1.0), 0.0); // 아마도 progress 는 min max 이내로 잘 나왔을 테지만 한번더 하겠다.
    
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        CGSize size = CGSizeMake(attributes.size.width * ratio, attributes.size.height);
        attributes.size = size;
    } else {
        CGSize size = CGSizeMake(attributes.size.width, attributes.size.height * ratio);
        attributes.size = size;
    }
    
    //! 핵심!!! 이동은 이것으로 해결해야한다.
    // normal size 높이가 30%로 하면 가운데에서 반 이면 15% 이는 35%이동해야함.
//    CGFloat translationX =
//    (attributes.position * itemSizeWidth) + (-position * itemSizeWidth * (1.0/6.0));
//    (30 %) + (5 %)
    CGFloat translationX =
    (attributes.position * itemSizeWidth) +
    (-position * itemSizeWidth * ((self.expandCellHeightRatio - self.normalCellHeightRatio) / (2.0 * self.normalCellHeightRatio)));
    //! CoverFlow의 경우는 이렇다.
    //! CGFloat translationX =
    //! attributes.position * (-[self proposedInteritemSpacing] / 3.0) + (-position * itemSizeWidth * 0.55);
    //! attributes.position * A + B, A = 가운데를 제외한 나머지 아이템간의 간격, A + B는 가운데와 바로 옆 아이템간의 간격.
    
    CATransform3D transform3D = CATransform3DIdentity;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        transform3D = CATransform3DTranslate(transform3D, translationX, 0.0, 0.0);
    } else {
        transform3D = CATransform3DTranslate(transform3D, 0.0, translationX, 0.0);
    }

    attributes.zIndex = - (NSInteger)(ABS(attributes.position));
    attributes.centerProgress = progress;
    
    attributes.dumyFrame = attributes.frame;
    attributes.dumyTransform = transform3D;
    
    attributes.dumyLayer.frame = attributes.frame;
    attributes.dumyLayer.transform = transform3D;
    attributes.dumyLayer.zPosition = (CGFloat)attributes.zIndex;
    
    CALayer *collectionViewLayer = self.carouselView.collectionView.layer;
    [attributes.dumyLayer removeFromSuperlayer];
    [collectionViewLayer addSublayer:attributes.dumyLayer];
    CGRect myRect = [attributes.dumyLayer convertRect:attributes.dumyLayer.bounds toLayer:collectionViewLayer];
    attributes.frame = myRect;
    
    //! content view frame 설정
    attributes.dumyLayer.transform = CATransform3DIdentity;
    attributes.dumyLayer.frame = attributes.frame;
    CGRect dumyFrame = [collectionViewLayer convertRect:attributes.dumyFrame toLayer:attributes.dumyLayer];
    attributes.dumyFrame = [self convertDumyFrame:dumyFrame];
    return;
}

//! rubberEffect에서 offset 정보를 확인하고 싶다.
- (void)carouselViewWillBeginDragging:(MGACarouselView *)carouselView {
    // [super carouselViewWillBeginDragging:carouselView]; super에서는 아무것도 구현하지 않았다.
    NSScrollView *scrollView = self.carouselView.scrollView;
    if (_useRubberEffect == YES) {
        if (self.carouselView.scrollDirection == MGACarouselScrollDirectionHorizontal) {
            _currentOffset = scrollView.mgrContentOffset.x;
        } else {
            _currentOffset = scrollView.mgrContentOffset.y;
        }
    }
}


#pragma mark - 생성 & 소멸
+ (instancetype)centerExpandTransformerWithRubberEffect:(BOOL)useRubberEffect {
    return [[self alloc] initWithCenterExpandTransformerWithRubberEffect:useRubberEffect];
}

- (instancetype)initWithCenterExpandTransformerWithRubberEffect:(BOOL)useRubberEffect {
    return [self initWithCenterExpandTransformerWithRubberEffect:useRubberEffect
                                           normalCellHeightRatio:0.3
                                           expandCellHeightRatio:0.4];

}

- (instancetype)initWithCenterExpandTransformerWithRubberEffect:(BOOL)useRubberEffect
                                          normalCellHeightRatio:(CGFloat)normalCellHeightRatio
                                          expandCellHeightRatio:(CGFloat)expandCellHeightRatio {
    self = [super initWithType:MGACarouselTransformerTypeLockWoodSpecial];
    if (self) {
        _normalCellHeightRatio = normalCellHeightRatio;
        _expandCellHeightRatio = expandCellHeightRatio;
        _currentOffset = 0.0f;
        self.useRubberEffect = useRubberEffect;
        self.MGEDisplayLink = [MGEDisplayLink displayLinkWithDuration:0.2
                                                   easingFunctionType:MGEEasingFunctionTypeEaseInOutSine
                                                        progressBlock:nil
                                                      completionBlock:nil];
        if (normalCellHeightRatio > expandCellHeightRatio) {
            NSCAssert(FALSE, @"normalCellHeightRatio > expandCellHeightRatio 은 잘못된 설정이다.");
        }
    }
    return self;
    
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGACarouselTransformerType)type { NSCAssert(FALSE, @"- initWithType: 사용금지."); return nil; }
@end
