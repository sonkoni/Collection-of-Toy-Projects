//
//  MGACarouselCellLayoutAttributes.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//


#import "MGACarouselCellLayoutAttributes.h"
@import GraphicsKit;

@interface MGACarouselCellLayoutAttributes ()
@end

@implementation MGACarouselCellLayoutAttributes
@dynamic mgrCenter;

- (void)dealloc {
    [_dumyLayer removeFromSuperlayer];
    _dumyLayer = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _position = 0.0;
        _diceRadiusRatio = 1.0;
        _centerProgress = 0.0;
        _dumyLayer = [CALayer layer];
        _dumyFrame = CGRectZero;
        _dumyTransform = CATransform3DIdentity;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    
    if ([super isEqual:object] == NO) { // super 클래스가 - isEqual: 메서드를 구현하였으므로, 반드시 넣어야된다.
        return NO;
    }

    return [self isEqualToCarouselCollectionViewLayoutAttributes:(MGACarouselCellLayoutAttributes *)object];
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    NSUInteger result = [super hash]; // super의 hash가 자기 자신의 pointer가 아니라면 같이 섞어서 더 견고하게 만들어볼 수 있다.
    result = prime * result + [[NSNumber numberWithDouble:_position] hash];
    result = prime * result + [[NSNumber numberWithDouble:_diceRadiusRatio] hash]; // private
    result = prime * result + [[NSNumber numberWithDouble:_centerProgress] hash]; // private
    result = prime * result + [[NSValue valueWithCATransform3D:_dumyTransform] hash];
    result = prime * result + [[NSValue valueWithRect:_dumyFrame] hash];
    return result;
}

//! Api:Foundation/protocol NSCopying/- copyWithZone:
- (id)copyWithZone:(NSZone *)zone {
    //! super(UICollectionViewLayoutAttributes)가 <NSCopying> 프로토콜을 따르므로 super copyWithZone:을 호출함
    //! 그렇지 않은 경우. ex: NSObject가 수퍼 클래스라면
    //! MGUCarouselCollectionViewLayoutAttributes *layoutAttributes = [[[self class] allocWithZone:zone] init];
    MGACarouselCellLayoutAttributes *layoutAttributes = [super copyWithZone:zone];
    layoutAttributes->_position = _position;
    layoutAttributes->_diceRadiusRatio = _diceRadiusRatio; // private
    layoutAttributes->_centerProgress = _centerProgress; // private
    layoutAttributes->_dumyTransform = _dumyTransform;
    layoutAttributes->_dumyFrame = _dumyFrame;
    layoutAttributes->_dumyLayer = _dumyLayer;
    
    return layoutAttributes;
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToCarouselCollectionViewLayoutAttributes:(MGACarouselCellLayoutAttributes *)layoutAttributes {
    if (self == layoutAttributes) {
        return YES;
    }

    if (layoutAttributes == nil) {
        return NO;
    }

    BOOL haveEqualPosition = (self.position == layoutAttributes.position);
    BOOL haveEqualDiceRadiusRatio = (self.diceRadiusRatio == layoutAttributes.diceRadiusRatio); // private
    BOOL haveEqualCenterProgress = (self.centerProgress == layoutAttributes.centerProgress); // private
    
    BOOL haveEqualTransform3D = CATransform3DEqualToTransform(self.dumyTransform, layoutAttributes.dumyTransform);
    BOOL haveEqualDumyFrame = CGRectEqualToRect(self.dumyFrame, layoutAttributes.dumyFrame);
    return haveEqualPosition && haveEqualDiceRadiusRatio && haveEqualCenterProgress && haveEqualTransform3D && haveEqualDumyFrame;
}


#pragma mark - 세터 & 게터
- (void)setMgrCenter:(CGPoint)mgrCenter {
    self.frame = MGERectAroundCenter(mgrCenter, self.size);
}

- (CGPoint)mgrCenter {
    return MGERectGetCenter(self.frame);
}


#pragma mark - Actions
- (BOOL)isVisibleOnCollectionView:(NSCollectionView *)collectionView {
    NSScrollView *scrollView = collectionView.enclosingScrollView;
    CGRect result = [collectionView convertRect:self.frame toView:scrollView];
    CGRect intersectionRect = CGRectIntersection(result, scrollView.bounds);
    if (intersectionRect.size.width == 0.0 || intersectionRect.size.height == 0.0) {
        return NO;
    } else {
        return YES;
    }
}
@end
