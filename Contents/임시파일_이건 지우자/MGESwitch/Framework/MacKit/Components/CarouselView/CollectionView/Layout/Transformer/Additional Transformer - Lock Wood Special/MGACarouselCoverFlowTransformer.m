//
//  MGACarouselCoverFlowTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
#import "MGACarouselCoverFlowTransformer.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "MGACarouselView.h"
#import "MGACarouselView_Internal.h"
#import "NSScrollView+Extension.h"

//! 아래 3개 static 변수는 rubberEffect를 이용할 경우에만 이용한다.
static NSInteger currentIndex = 0;
static NSInteger justPastIndex = 0; // currentIndex 바로 옆에 있는 인덱스이며, 현재 인덱스를 기준으로 방금 지나쳐간 인덱스를 의미한다.
static BOOL needsRubberEffect = NO;

#pragma mark - MGACarouselCoverFlowTransformer
@interface MGACarouselCoverFlowTransformer ()
@property (nonatomic, assign) CGFloat eyePosition;

/** Rubber Effect 를 위해 **/
@property (nonatomic, strong) MGEDisplayLink *MGEDisplayLink;
@property (nonatomic, assign) CGFloat toggle;
@property (nonatomic, assign) BOOL useRubberEffect;
@property (nonatomic, assign) CGFloat currentOffset;
@end


@implementation MGACarouselCoverFlowTransformer

#pragma mark - Override
 //! MGACarouselCollectionViewLayout의 - layoutAttributesForElementsInRect: 가시권 rect를 조절하는데, 사용한다.
- (CGFloat)minimumScale {
    //! README 파일 참고하라.
    //!  1. scale = eye / (eye + distance) <- 이걸 쓰겠다.
    //!  2. distance = eye * (1.0/scale - 1.0)
    //!  3. eye = distance * ( scale / (1.0-scale) )
    CGFloat eyePosition = self.eyePosition;
    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        return eyePosition / (eyePosition + self.carouselView.itemSize.width);
    } else {
        return eyePosition / (eyePosition + self.carouselView.itemSize.height);
    }
}

//! MGACarouselCollectionViewLayout에서 이 값을 사용하지만, MGACarouselCoverFlowTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGACarouselCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing {
    if (self.carouselView == nil) {
        return 0.0;
    }

    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        return -self.carouselView.itemSize.width * (3.0 / 4.0); // 0.75
    } else {
        return -self.carouselView.itemSize.height * (3.0 / 4.0); // 0.75
    }
}

- (void)applyTransformTo:(MGACarouselCellLayoutAttributes *)attributes {
    NSScrollView *scrollView = self.carouselView.scrollView;
    if (self.carouselView == nil) {
        return;
    }
    
    CGFloat itemSizeWidth;
    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        itemSizeWidth = self.carouselView.itemSize.width;
    } else {
        itemSizeWidth = self.carouselView.itemSize.height;
    }
    
    CGFloat position = attributes.position;
    position = MIN(MAX(-position,-1.0) ,1.0); // 오른쪽을 -1.0 왼쪽을 1.0으로 바꾼다.
    
    if (_useRubberEffect == YES) { //! 이 transformer type에서 rubber effect를 사용할 것인가.
        if (self.carouselView.currentIndex != currentIndex) {
            if (self.carouselView.volumeType != MGACarouselVolumeTypeInfinite) { // 유한!
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
                
                if (offset > _currentOffset) {
                    justPastIndex = self.carouselView.currentIndex - 1;
                } else {
                    justPastIndex = self.carouselView.currentIndex + 1;
                }
                _currentOffset = offset;
            }
            
            currentIndex = self.carouselView.currentIndex;
            needsRubberEffect = YES;
        }
        //! 무한에서 offset을 점핑 시킬때 방향을 잘못 잡는 경우가 생기므로
        if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
            _currentOffset = scrollView.mgrContentOffset.x;
        } else {
            _currentOffset = scrollView.mgrContentOffset.y;
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
    
    CGFloat rotation = (M_PI_4 * 1.7) * position;
    CGRect rect = scrollView.contentView.bounds;
    attributes.mgrCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

    CGFloat translationZ = - (ABS(position) * itemSizeWidth);
    CGFloat translationX =
    attributes.position * (-[self proposedInteritemSpacing] / 3.0) + (-position * itemSizeWidth * 0.55);
    //! attributes.position * A + B, A = 가운데를 제외한 나머지 아이템간의 간격 A + B는 가운데와 바로 옆 아이템간의 간격.
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0 / self.eyePosition;  // 음수로 커질 수록(작으질 수록) 더 많이 꺾인다.
    
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        transform3D = CATransform3DTranslate(transform3D, translationX, 0.0, translationZ);
        transform3D = CATransform3DRotate(transform3D, rotation, 0.0, 1.0, 0.0);
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(self.eyePositionXY, 1.0, 0.0, 0.0));
    } else {
        transform3D = CATransform3DTranslate(transform3D, 0.0, translationX, translationZ);
        transform3D = CATransform3DRotate(transform3D, rotation, -1.0, 0.0, 0.0);
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(self.eyePositionXY, 0.0, 1.0, 0.0));
    }
    
    static CGFloat sideRadian = (M_PI_4 * 1.7);
    CGFloat p = ABS(attributes.position);
    if (1.0 > p && (sideRadian != ABS(rotation))) {
        attributes.zIndex = 10000 - ABS(rotation*100); // 회전 중에 겹칠 수가 있다.
    } else {
        attributes.zIndex = - (NSInteger)(p * 100);
    }
    attributes.centerProgress = ABS(position); // 가운데 정면을 보고 있다면 0.0 뉘여져 있다면 1.0 이 값을 사용하는 것은 자유다.

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
    // - convertRect:toLayer: 소숫점 자리까지 다 나온다. 출렁이는 부작용이 발생한다.
    // - convertRect:toView: 는 적절하게 커팅되서 나오는 듯. 여기서 contentview의 프레임을 레이어로 추정하므로 여기서 적절하게 맞춰
    // 주는 것이 타당할 듯.
    return;
}

- (void)carouselViewWillBeginDragging:(MGACarouselView *)carouselView {
    NSScrollView *scrollView = self.carouselView.scrollView;
    // [super carouselViewWillBeginDragging:carouselView]; super에서는 아무것도 구현하지 않았다.
    if (_useRubberEffect == YES) {
        if (self.carouselView.scrollDirection == MGACarouselScrollDirectionHorizontal) {
            _currentOffset = scrollView.mgrContentOffset.x;
        } else {
            _currentOffset = scrollView.mgrContentOffset.y;
        }
        // 무한으로 Drag 할때, 잘찾지 못하는 버그가 존재한다.
        // macOS에서 스와이프 스크롤링으로 멈춰야할 할때, 수동으로 내가 멈추는 애니메이션을 만드므로 그런 문제가 생긴다.
        // scrollViewDidScroll: 이 제대로 마지막까지 치지 못한다.
        currentIndex = self.carouselView.currentIndex;
    }
}


#pragma mark - 생성 & 소멸
+ (instancetype)coverFlowTransformerWithRubberEffect:(BOOL)useRubberEffect {
    return [[self alloc] initWithCoverFlowTransformerWithRubberEffect:useRubberEffect];
}

- (instancetype)initWithCoverFlowTransformerWithRubberEffect:(BOOL)useRubberEffect {
    self = [super initWithType:MGACarouselTransformerTypeLockWoodSpecial];
    if (self) {
        _eyePositionXY = 0.0f;
        _currentOffset = 0.0f;
        self.eyePosition = 500.0f;
        self.useRubberEffect = useRubberEffect;
        self.MGEDisplayLink = [MGEDisplayLink displayLinkWithDuration:0.2
                                                   easingFunctionType:MGEEasingFunctionTypeEaseInOutSine
                                                        progressBlock:nil
                                                      completionBlock:nil];
    }
    return self;
}


#pragma mark - 세터 & 게터
- (void)setEyePositionXY:(CGFloat)eyePositionXY {
    eyePositionXY = MIN(MAX(eyePositionXY, -0.1), 0.1);
    _eyePositionXY = eyePositionXY;
    [self.carouselView.collectionViewLayout forceInvalidate];
}

@end

//
/** ① 최적화를 시켰다. 원래는 이런 식이었다.
if (self.carouselView.rubberEffect == YES && ABS(position) < 1.0) {
    if (ABS(position) < 0.5) {
        position = 0.0;
    } else if (ABS(position) > 0.5) {
        position = position > 0.0 ? 1.0 : -1.0;
    } else {
        if (position == 0.5) {
            position = 1.0;
        } else { // position == - 0.5
            position = 0.0;
        }
    }
    
    if (position == 0.0) {
        if (justPastIndex < currentIndex) { //! <===== 아이템들이 이 방향으로 이동한다.
            position = -_toggle;
        } else { //! =====> 아이템들이 이 방향으로 이동한다.
            position = _toggle;
        }
    }
}
*/
