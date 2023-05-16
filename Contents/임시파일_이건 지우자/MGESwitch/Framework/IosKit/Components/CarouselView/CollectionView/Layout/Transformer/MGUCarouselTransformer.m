//
//  MGUCarouselTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselTransformer.h"
#import "MGUCarouselCellLayoutAttributes.h"
#import "MGUCarouselView.h"

@implementation MGUCarouselTransformer

#pragma mark - 생성 & 소멸
- (instancetype)initWithType:(MGUCarouselTransformerType)type {
    self = [super init];
    if (self) {
        _minimumScale = 0.65;
        _minimumAlpha = 0.6;
        self.type = type;
        if (type == MGUCarouselTransformerTypeZoomOut) {
            self.minimumScale = 0.85;
        } else if (type == MGUCarouselTransformerTypeDepth) {
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
    
    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    
    switch (self.type) {
        case MGUCarouselTransformerTypeOverlap:  {
            if (scrollDirection != MGUCarouselScrollDirectionHorizontal) {
                return 0.0;
            }
            
            return self.carouselView.itemSize.width * -self.minimumScale * 0.6;
            break;
        }
        case MGUCarouselTransformerTypeLinear: {
            if (scrollDirection != MGUCarouselScrollDirectionHorizontal) {
                return 0.0;
            }

            return self.carouselView.itemSize.width * -self.minimumScale * 0.2;
            break;
        }
        case MGUCarouselTransformerTypeCoverFlow: {
            if (scrollDirection != MGUCarouselScrollDirectionHorizontal) {
                return 0.0;
            }
            return -self.carouselView.itemSize.width * sin(M_PI * 0.25 * 0.25 * 3.0);
            break;
        }
        case MGUCarouselTransformerTypeFerrisWheel: {
        }
        case MGUCarouselTransformerTypeInvertedFerrisWheel: {
            if (scrollDirection != MGUCarouselScrollDirectionHorizontal) {
                return 0.0;
            }
            
            return -self.carouselView.itemSize.width * 0.15;
            break;
        }
        case MGUCarouselTransformerTypeCubic: {
            return 0.0;
            break;
        }
        default:
            break;
    }
    
    return self.carouselView.interitemSpacing;
    //
    // 아래 셋은 self.carouselView.interitemSpacing를 따라간다.
    // MGUCarouselTransformerTypeCrossFading
    // MGUCarouselTransformerTypeZoomOut
    // MGUCarouselTransformerTypeDepth
}

// MARK: - attributes에 transform 적용
//! NSInteger: zIndex, CGRect: frame, CGFloat: alpha, CGAffineTransform: transform 또는 CATransform3D: transform3D.
- (void)applyTransformTo:(MGUCarouselCellLayoutAttributes *)attributes {
    if (self.carouselView == nil) {
        return;
    }
    
    CGFloat position = attributes.position;
    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    
    CGFloat itemSpacing;
    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        itemSpacing = attributes.bounds.size.width + [self proposedInteritemSpacing];
    } else {
        itemSpacing = attributes.bounds.size.height + [self proposedInteritemSpacing];
    }
    
    if (self.type == MGUCarouselTransformerTypeCrossFading) {
        NSInteger zIndex = 0;
        CGFloat alpha = 0.0;
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
            transform.tx = -itemSpacing * position;
        } else { // vertical
            transform.ty = -itemSpacing * position;
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
        
        attributes.alpha = alpha;
        attributes.transform = transform;
        attributes.zIndex = zIndex;
        return;
    }
//---------------------------------------------------------------------------------------------------------
    if (self.type == MGUCarouselTransformerTypeZoomOut) {
        CGFloat alpha = 0.0f;
        CGAffineTransform transform = CGAffineTransformIdentity;

        if (position >= -DBL_MAX && position < -1.0) {  // [-Infinity,-1)
            alpha = 0.0f; // This page is way off-screen to the left.
        } else if (position >= -1.0 && position <= 1.0) {  // [-1,1]
            // Modify the default slide transition to shrink the page as well
            CGFloat scaleFactor = MAX(self.minimumScale, 1 - ABS(position));
            transform.a = scaleFactor;
            transform.d = scaleFactor;
            
            if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
                CGFloat vertMargin = attributes.bounds.size.height * (1 - scaleFactor) / 2;
                CGFloat horzMargin = itemSpacing * (1 - scaleFactor) / 2;
                transform.tx = position < 0 ? (horzMargin - vertMargin * 2) : (-horzMargin + vertMargin*2);
            } else { // vertical
                CGFloat horzMargin = attributes.bounds.size.width * (1 - scaleFactor) / 2;
                CGFloat vertMargin = itemSpacing * (1 - scaleFactor) / 2;
                transform.ty = position < 0 ? (vertMargin - horzMargin * 2) : (-vertMargin + horzMargin * 2);
            }
            // Fade the page relative to its size.
            alpha = self.minimumAlpha + (scaleFactor-self.minimumScale)/(1-self.minimumScale)*(1-self.minimumAlpha);
            
        } else if (position > 1.0 && position <= DBL_MAX) {  // (1,+Infinity]
            alpha = 0.0f; // This page is way off-screen to the right.
        }
        
        attributes.alpha = alpha;
        attributes.transform = transform;
        return;
    }
//---------------------------------------------------------------------------------------------------------
    if (self.type == MGUCarouselTransformerTypeDepth) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        NSInteger zIndex = 0;
        CGFloat alpha = 0.0;
        
        if (position >= -DBL_MAX && position < -1.0) {  // [-Infinity,-1)
            alpha = 0.0; // This page is way off-screen to the left.
            zIndex = 0;
        } else if (position >= -1.0 && position <= 0.0) {   // [-1,0]
            // Use the default slide transition when moving to the left page
            alpha = 1.0;
            transform.tx = 0.0;
            transform.a = 1.0;
            transform.d = 1.0;
            zIndex = 1;
        } else if (position > 0.0 && position < 1.0) { // (0,1)
            // Fade the page out.
            alpha = 1.0 - position;
            // Counteract the default slide transition
            if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
                transform.tx = itemSpacing * -position;
            } else { // vertical
                transform.ty = itemSpacing * -position;
            }

            // Scale the page down (between minimumScale and 1)
            CGFloat scaleFactor = self.minimumScale
                + (1.0 - self.minimumScale) * (1.0 - ABS(position));
            
            transform.a = scaleFactor;
            transform.d = scaleFactor;
            zIndex = 0;
        } else if (position >= 1.0 && position <= DBL_MAX) {  // [1,+Infinity]
            // This page is way off-screen to the right.
            alpha = 0.0;
            zIndex = 0;
        }
        
        attributes.alpha = alpha;
        attributes.transform = transform;
        attributes.zIndex = zIndex;
        return;
    }
//---------------------------------------------------------------------------------------------------------
    if (self.type == MGUCarouselTransformerTypeOverlap || self.type == MGUCarouselTransformerTypeLinear) {
        if (scrollDirection != MGUCarouselScrollDirectionHorizontal) { return;}// 이 타입은 수직 모드를 지원하지 않는다.
        
        CGFloat scale = MAX(1 - (1-self.minimumScale) * ABS(position), self.minimumScale);
        
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        attributes.transform = transform;

        CGFloat alpha = (self.minimumAlpha + (1-ABS(position))*(1-self.minimumAlpha));
        attributes.alpha = alpha;
        NSInteger zIndex = (1 - ABS(position)) * 10;
        attributes.zIndex = zIndex;
        return;
    }
//---------------------------------------------------------------------------------------------------------
    if (self.type == MGUCarouselTransformerTypeCoverFlow) {
        if (scrollDirection != MGUCarouselScrollDirectionHorizontal) {
            // This type doesn't support vertical mode
            return;
        }
        
        position = MIN(MAX(-position,-1.0) ,1.0);
        CGFloat rotation = sin(position * M_PI * 0.5) * M_PI * 0.25 * 1.5;
        CGFloat translationZ = -itemSpacing * 0.5 * ABS(position);
        CATransform3D transform3D = CATransform3DIdentity;
        transform3D.m34 = -0.002;
        transform3D = CATransform3DRotate(transform3D, rotation, 0, 1, 0);
        transform3D = CATransform3DTranslate(transform3D, 0, 0, translationZ);
        attributes.zIndex = 100 - (NSInteger)(ABS(position));
        attributes.transform3D = transform3D;
        return;
    }
//---------------------------------------------------------------------------------------------------------
    if (self.type == MGUCarouselTransformerTypeFerrisWheel || self.type == MGUCarouselTransformerTypeInvertedFerrisWheel) {
        if (scrollDirection != MGUCarouselScrollDirectionHorizontal) {
            // 이 타입은 수직 모드를 지원하지 않는다.
            return;
        }
        // http://ronnqvi.st/translate-rotate-translate
        NSInteger zIndex = 0;
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        if (position >= -5.0 && position <= 5.0) {
            
            CGFloat itemSpacing = attributes.bounds.size.width + [self proposedInteritemSpacing];
            CGFloat count = 14.0;
            CGFloat circle = M_PI * 2.0;
            CGFloat radius = itemSpacing * count / circle;
            CGFloat ty = radius * (self.type == MGUCarouselTransformerTypeFerrisWheel ? 1 : -1);
            CGFloat theta = circle / count;
            CGFloat rotation = position * theta * (self.type == MGUCarouselTransformerTypeFerrisWheel ? 1 : -1);
            
            transform = CGAffineTransformTranslate(transform, -position*itemSpacing, ty);
            transform = CGAffineTransformRotate(transform, rotation);
            transform = CGAffineTransformTranslate(transform, 0.0, -ty);
            zIndex = (NSInteger)((4.0-ABS(position)*10));
        }
        
        attributes.alpha = ABS(position) < 0.5 ? 1 : self.minimumAlpha;
        attributes.transform = transform;
        attributes.zIndex = zIndex;
        return;
    }
//---------------------------------------------------------------------------------------------------------
    if (self.type == MGUCarouselTransformerTypeCubic) {
        
        if (position >= -DBL_MAX && position <= -1.0) {  // [-Infinity,-1]
            attributes.alpha = 0.0;
        } else if (position > -1.0 && position < 1.0) {   // (-1,0)
            
            attributes.alpha = 1.0;
            attributes.zIndex = (NSInteger)( (1 - position) * 10);
            CGFloat direction = position < 0 ? 1 : -1;
            CGFloat theta = position * M_PI * 0.5 * (scrollDirection == MGUCarouselScrollDirectionHorizontal ? 1 : -1);
            CGFloat radius = scrollDirection == MGUCarouselScrollDirectionHorizontal ? attributes.bounds.size.width : attributes.bounds.size.height;
            
            CATransform3D transform3D = CATransform3DIdentity;
            transform3D.m34 = -0.002;
            
            if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
                // ForwardX -> RotateY -> BackwardX
                attributes.center = CGPointMake(attributes.center.x + direction*radius*0.5, attributes.center.y);
                transform3D = CATransform3DRotate(transform3D, theta, 0, 1, 0); // RotateY
                transform3D = CATransform3DTranslate(transform3D,-direction*radius*0.5, 0, 0); // BackwardX
            } else { // vertical
                // ForwardY -> RotateX -> BackwardY
                attributes.center = CGPointMake(attributes.center.x, attributes.center.y + direction*radius*0.5);
                transform3D = CATransform3DRotate(transform3D, theta, 1.0, 0.0, 0.0); // RotateX
                transform3D = CATransform3DTranslate(transform3D, 0.0, -direction*radius * 0.5, 0.0); // BackwardY
            }
            
            attributes.transform3D = transform3D;
        } else if (position >= 1.0 && position <= DBL_MAX) {
            attributes.alpha = 0.0;
        } else {
            attributes.alpha = 0.0;
            attributes.zIndex = 0;
        }
        return;
    }
}

- (void)carouselViewWillBeginDragging:(MGUCarouselView *)carouselView {}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
