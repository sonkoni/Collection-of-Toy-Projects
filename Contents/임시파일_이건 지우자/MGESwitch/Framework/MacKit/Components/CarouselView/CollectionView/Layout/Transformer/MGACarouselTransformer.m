//
//  MGACarouselTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
#import "MGACarouselTransformer.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "MGACarouselView.h"

@implementation MGACarouselTransformer

#pragma mark - 생성 & 소멸
- (instancetype)initWithType:(MGACarouselTransformerType)type {
    self = [super init];
    if (self) {
        _minimumScale = 0.65;
        _minimumAlpha = 0.6;
        self.type = type;
        if (type == MGACarouselTransformerTypeZoomOut) {
            self.minimumScale = 0.85;
        } else if (type == MGACarouselTransformerTypeDepth) {
            self.minimumScale = 0.5;
        }
    }
    return self;
}


#pragma mark - 컨트롤
- (CGFloat)proposedInteritemSpacing {
    if (self.carouselView == nil) {
        return 0.0f;
    }
    
    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    
    switch (self.type) {
        case MGACarouselTransformerTypeOverlap:  {
            if (scrollDirection != MGACarouselScrollDirectionHorizontal) {
                return 0.0;
            }
            
            return self.carouselView.itemSize.width * -self.minimumScale * 0.6;
            break;
        }
        case MGACarouselTransformerTypeLinear: {
            if (scrollDirection != MGACarouselScrollDirectionHorizontal) {
                return 0.0;
            }

            return self.carouselView.itemSize.width * -self.minimumScale * 0.2;
            break;
        }
        case MGACarouselTransformerTypeCoverFlow: {
            if (scrollDirection != MGACarouselScrollDirectionHorizontal) {
                return 0.0;
            }
            return -self.carouselView.itemSize.width * sin(M_PI * 0.25 * 0.25 * 3.0);
            break;
        }
        case MGACarouselTransformerTypeFerrisWheel: {
        }
        case MGACarouselTransformerTypeInvertedFerrisWheel: {
            if (scrollDirection != MGACarouselScrollDirectionHorizontal) {
                return 0.0;
            }
            
            return -self.carouselView.itemSize.width * 0.15;
            break;
        }
        case MGACarouselTransformerTypeCubic: {
            return 0.0;
            break;
        }
        default:
            break;
    }
    
    return self.carouselView.interitemSpacing;
    //
    // 아래 셋은 self.carouselView.interitemSpacing를 따라간다.
    // MGACarouselTransformerTypeCrossFading
    // MGACarouselTransformerTypeZoomOut
    // MGACarouselTransformerTypeDepth
}

// MARK: - attributes에 transform 적용
//! NSInteger: zIndex, CGRect: frame, CGFloat: alpha, CGAffineTransform: transform 또는 CATransform3D: transform3D.
- (void)applyTransformTo:(MGACarouselCellLayoutAttributes *)attributes {
    if (self.carouselView == nil) {
        return;
    }
    
    CGFloat position = attributes.position;
    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    
    CGFloat itemSpacing;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        itemSpacing = attributes.size.width + [self proposedInteritemSpacing];
    } else {
        itemSpacing = attributes.size.height + [self proposedInteritemSpacing];
    }
    
    NSInteger zIndex = 0;
    CGFloat alpha = 0.0;
    CATransform3D transform3D = CATransform3DIdentity;
    
    if (self.type == MGACarouselTransformerTypeCrossFading) {
        if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
            transform3D = CATransform3DTranslate(CATransform3DIdentity, -itemSpacing * position, 0.0, 0.0);
        } else { // vertical
            transform3D = CATransform3DTranslate(CATransform3DIdentity, 0.0, -itemSpacing * position, 0.0);
        }
        
        if (ABS(position) < 1) { // [-1,1]
            // Use the default slide transition when moving to the left page
            alpha = 1.0 - ABS(position);
            zIndex = 1;
        } else { // (1,+Infinity]
            // This page is way off-screen to the right.
            alpha = 0.0;
            zIndex = INT_MIN;
        }
    } else if (self.type == MGACarouselTransformerTypeZoomOut) {
        if (position >= -DBL_MAX && position < -1.0) {  // [-Infinity,-1)
            alpha = 0.0f; // This page is way off-screen to the left.
        } else if (position >= -1.0 && position <= 1.0) {  // [-1,1]
            // Modify the default slide transition to shrink the page as well
            CGFloat scaleFactor = MAX(self.minimumScale, 1 - ABS(position));
            transform3D = CATransform3DScale(transform3D, scaleFactor, scaleFactor, 1.0);
            if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
                CGFloat vertMargin = attributes.size.height * (1 - scaleFactor) / 2;
                CGFloat horzMargin = itemSpacing * (1 - scaleFactor) / 2;
                CGFloat transformTx = position < 0 ? (horzMargin - vertMargin * 2) : (-horzMargin + vertMargin*2);
                transform3D = CATransform3DTranslate(transform3D, transformTx, 0.0, 0.0);
            } else { // vertical
                CGFloat horzMargin = attributes.size.width * (1 - scaleFactor) / 2;
                CGFloat vertMargin = itemSpacing * (1 - scaleFactor) / 2;
                CGFloat transformTy = position < 0 ? (vertMargin - horzMargin * 2) : (-vertMargin + horzMargin * 2);
                transform3D = CATransform3DTranslate(transform3D, 0.0, transformTy, 0.0);
            }
            // Fade the page relative to its size.
            alpha = self.minimumAlpha + (scaleFactor-self.minimumScale)/(1-self.minimumScale)*(1-self.minimumAlpha);
            
        } else if (position > 1.0 && position <= DBL_MAX) {  // (1,+Infinity]
            alpha = 0.0f; // This page is way off-screen to the right.
        }
    } else if (self.type == MGACarouselTransformerTypeDepth) {
        if (position >= -DBL_MAX && position < -1.0) {  // [-Infinity,-1)
            alpha = 0.0; // This page is way off-screen to the left.
            zIndex = 0;
        } else if (position >= -1.0 && position <= 0.0) {   // [-1,0]
            // Use the default slide transition when moving to the left page
            alpha = 1.0;
            zIndex = 1;
        } else if (position > 0.0 && position < 1.0) { // (0,1)
            // Fade the page out.
            alpha = 1.0 - position;
            // Counteract the default slide transition
            if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
                transform3D = CATransform3DTranslate(transform3D, itemSpacing * -position, 0.0, 0.0);
            } else { // vertical
                transform3D = CATransform3DTranslate(transform3D, 0.0, itemSpacing * -position, 0.0);
            }

            // Scale the page down (between minimumScale and 1)
            CGFloat scaleFactor = self.minimumScale
                + (1.0 - self.minimumScale) * (1.0 - ABS(position));
            
            transform3D = CATransform3DScale(transform3D, scaleFactor, scaleFactor, 1.0);
            zIndex = 0;
        } else if (position >= 1.0 && position <= DBL_MAX) {  // [1,+Infinity]
            // This page is way off-screen to the right.
            alpha = 0.0;
            zIndex = 0;
        }
    } else if (self.type == MGACarouselTransformerTypeOverlap || self.type == MGACarouselTransformerTypeLinear) {
        if (scrollDirection != MGACarouselScrollDirectionHorizontal) { return;}// 이 타입은 수직 모드를 지원하지 않는다.
        
        CGFloat scale = MAX(1 - (1-self.minimumScale) * ABS(position), self.minimumScale);
        transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0);
        alpha = (self.minimumAlpha + (1-ABS(position))*(1-self.minimumAlpha));
        zIndex = (1 - ABS(position)) * 10;
    } else if (self.type == MGACarouselTransformerTypeCoverFlow) {
        if (scrollDirection != MGACarouselScrollDirectionHorizontal) {
            // This type doesn't support vertical mode
            return;
        }
        
        position = MIN(MAX(-position,-1.0) ,1.0);
        CGFloat rotation = sin(position * M_PI * 0.5) * M_PI * 0.25 * 1.5;
        CGFloat translationZ = -itemSpacing * 0.5 * ABS(position);
        alpha = 1.0;
        transform3D.m34 = -0.002;
        transform3D = CATransform3DRotate(transform3D, rotation, 0, 1, 0);
        transform3D = CATransform3DTranslate(transform3D, 0, 0, translationZ);
        // zIndex = 100 - (NSInteger)(ABS(position));
        CGFloat p = ABS(attributes.position);
        if (1.0 > p ) {
            zIndex = 10000 - ABS(rotation*100); // 회전 중에 겹칠 수가 있다.
        } else {
            zIndex = - (NSInteger)(p * 100);
        }
    } else if (self.type == MGACarouselTransformerTypeFerrisWheel || self.type == MGACarouselTransformerTypeInvertedFerrisWheel) {
        if (scrollDirection != MGACarouselScrollDirectionHorizontal) {
            // 이 타입은 수직 모드를 지원하지 않는다.
            return;
        }
        // http://ronnqvi.st/translate-rotate-translate
        if (position >= -5.0 && position <= 5.0) {
            CGFloat itemSpacing = attributes.size.width + [self proposedInteritemSpacing];
            CGFloat count = 14.0;
            CGFloat circle = M_PI * 2.0;
            CGFloat radius = itemSpacing * count / circle;
            CGFloat ty = radius * (self.type == MGACarouselTransformerTypeFerrisWheel ? 1 : -1);
            CGFloat theta = circle / count;
            CGFloat rotation = position * theta * (self.type == MGACarouselTransformerTypeFerrisWheel ? 1 : -1);
            
            transform3D = CATransform3DTranslate(transform3D, -position*itemSpacing, ty, 0.0);
            transform3D = CATransform3DRotate(transform3D, rotation, 0.0, 0.0, 1.0);
            transform3D = CATransform3DTranslate(transform3D, 0.0, -ty, 0.0);
            zIndex = (NSInteger)((4.0-ABS(position)*10));
        }
        
        alpha = ABS(position) < 0.5 ? 1 : self.minimumAlpha;
    } else if (self.type == MGACarouselTransformerTypeCubic) {
        if (position >= -DBL_MAX && position <= -1.0) {  // [-Infinity,-1]
            alpha = 0.0;
        } else if (position > -1.0 && position < 1.0) {   // (-1,0)
            
            alpha = 1.0;
            zIndex = (NSInteger)( (1 - position) * 10);
            CGFloat direction = position < 0 ? 1 : -1;
            CGFloat theta = position * M_PI * 0.5 * (scrollDirection == MGACarouselScrollDirectionHorizontal ? 1 : -1);
            CGFloat radius = scrollDirection == MGACarouselScrollDirectionHorizontal ? attributes.size.width : attributes.size.height;
            transform3D.m34 = -0.002;
            
            if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
                // ForwardX -> RotateY -> BackwardX
                attributes.mgrCenter = CGPointMake(attributes.mgrCenter.x + direction*radius*0.5, attributes.mgrCenter.y);
                transform3D = CATransform3DRotate(transform3D, theta, 0, 1, 0); // RotateY
                transform3D = CATransform3DTranslate(transform3D,-direction*radius*0.5, 0, 0); // BackwardX
            } else { // vertical
                // ForwardY -> RotateX -> BackwardY
                attributes.mgrCenter = CGPointMake(attributes.mgrCenter.x, attributes.mgrCenter.y + direction*radius*0.5);
                transform3D = CATransform3DRotate(transform3D, theta, 1.0, 0.0, 0.0); // RotateX
                transform3D = CATransform3DTranslate(transform3D, 0.0, -direction*radius * 0.5, 0.0); // BackwardY
            }
        } else if (position >= 1.0 && position <= DBL_MAX) {
            alpha = 0.0;
        } else {
            alpha = 0.0;
            zIndex = 0;
        }
    }
    
    //! 공통.
    attributes.alpha = alpha;
    attributes.zIndex = zIndex;

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
}

- (void)carouselViewWillBeginDragging:(MGACarouselView *)carouselView {}

#pragma mark - Internal Helper
- (CGRect)convertDumyFrame:(CGRect)dumyFrame {
    if ([NSScreen mainScreen].backingScaleFactor == 2.0) {
        return (CGRect){MGRHalfRound(dumyFrame.origin.x),
                        MGRHalfRound(dumyFrame.origin.y),
                        MGRHalfRound(dumyFrame.size.width),
                        MGRHalfRound(dumyFrame.size.height)};
    } else {
        return (CGRect){roundl(dumyFrame.origin.x),
                        roundl(dumyFrame.origin.y),
                        roundl(dumyFrame.size.width),
                        roundl(dumyFrame.size.height)};
    }
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
