//
//  MGRGeometryHelper.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGRGeometryHelper.h"

static CGFloat MGRVector2DDistance(CGVector v1, CGVector v2);


#pragma mark - linear interpolation : MGRLerp_

CGFloat MGRLerpDouble(CGFloat progress, CGFloat from, CGFloat to) {
    return from + ((to - from) * progress);
}

CGPoint MGRLerpPoint(CGFloat progress, CGPoint from, CGPoint to) {
    return CGPointMake(MGRLerpDouble(progress, from.x, to.x),
                       MGRLerpDouble(progress, from.y, to.y));
}

CGPoint MGRLerpPointMid(CGPoint from, CGPoint to) {
    return MGRLerpPoint(0.5, from, to);
}

CGSize MGRLerpSize(CGFloat progress, CGSize from, CGSize to) {
    return CGSizeMake(MGRLerpDouble(progress, from.width, to.width),
                      MGRLerpDouble(progress, from.height, to.height));
}

CGRect MGRLerpRect(CGFloat progress, CGRect from, CGRect to) {
    return CGRectMake(MGRLerpDouble(progress, from.origin.x, to.origin.x),
                      MGRLerpDouble(progress, from.origin.y, to.origin.y),
                      MGRLerpDouble(progress, from.size.width, to.size.width),
                      MGRLerpDouble(progress, from.size.height, to.size.height));
}

CGColorRef MGRLerpCreateColor(CGFloat progress, CGColorRef from, CGColorRef to) {
    const CGFloat *fromComponents = CGColorGetComponents(from);
    const CGFloat *toComponents = CGColorGetComponents(to);

    CGFloat fromAlpha, toAlpha, r, g, b, a;
    fromAlpha = CGColorGetAlpha(from);
    toAlpha = CGColorGetAlpha(to);

    r = MGRLerpDouble(progress, fromComponents[0], toComponents[0]);

    CGFloat color1Green = fromComponents[1];
    CGFloat color1Blue = fromComponents[2];
    CGFloat color2Green = toComponents[1];
    CGFloat color2Blue = toComponents[2];

    if (CGColorGetNumberOfComponents(from) == 2) {
        color1Green = fromComponents[0];
        color1Blue  = fromComponents[0];
    }
    if (CGColorGetNumberOfComponents(to) == 2) {
        color2Green = toComponents[0];
        color2Blue  = toComponents[0];
    }

    g = MGRLerpDouble(progress, color1Green, color2Green);
    b = MGRLerpDouble(progress, color1Blue, color2Blue);

    a = MGRLerpDouble(progress, fromAlpha, toAlpha);

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 130000 // Deployment Target 이 13.0이다. 기계가 13 이상부터 다 들어온다.
    return CGColorCreateSRGB(r, g, b, a);
#else
    // Deployment Target 이 13 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 13, *)) {
        return CGColorCreateSRGB(r, g, b, a);
    } else {
        CGFloat colorComponents[4] = { r, g, b, a };
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); // 릴리즈 때문에 변수로 잡아야한다.
        CGColorRef resultColor = CGColorCreate(colorSpace, colorComponents);
        CGColorSpaceRelease(colorSpace);
        return resultColor;
    }
#endif
}


#pragma mark - Normalize
CGPoint MGRNormalizedPoint(CGPoint point) {
    CGFloat distance = MGRDistanceFromZeroToPoint(point);
    return CGPointMake(point.x / distance, point.y / distance);
}

CGVector MGRNormalizedVector(CGVector vector) {
    CGFloat distance = MGRDistanceFromZeroToPoint(MGRPointFromVector(vector));
    return CGVectorMake(vector.dx / distance, vector.dy / distance);
}


#pragma mark - linear distance
CGFloat MGRDistanceToDouble(CGFloat one, CGFloat theOther) {
    return ABS(theOther - one);
}

CGFloat MGRDistanceToCGPoint(CGPoint one, CGPoint theOther) {
    return MGRVector2DDistance(CGVectorMake(one.x, one.y), CGVectorMake(theOther.x, theOther.y));
}

CGFloat MGRDistanceFromZeroToPoint(CGPoint theOther) {
    return MGRDistanceToCGPoint(CGPointZero, theOther);
}

//! private
static CGFloat MGRVector2DDistance(CGVector v1, CGVector v2) {
    CGFloat xDiff = v2.dx - v1.dx;
    CGFloat yDiff = v2.dy - v1.dy;
    return hypotf(xDiff, yDiff);
}


#pragma mark - 일반도형 : MGRRect_, MGRTriangle_
CGPoint MGRRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint MGRTriangleGetCenterOfGravity(CGPoint a, CGPoint b, CGPoint c) {
    return CGPointMake((a.x + b.x + c.x) / 3.0, (a.y + b.y + c.y) / 3.0);
}

CGPoint MGRPointsGetAveragePoint(NSArray <NSValue *>*points) {
    CGFloat centerX = 0.0;
    CGFloat centerY = 0.0;
    CGFloat cumX = 0.0;
    CGFloat cumY = 0.0;
    for (NSValue *value in points) {
        CGPoint point = [value CGPointValue];
        cumX = cumX + point.x;
        cumY = cumY + point.y;
    }
    centerX = cumX / (CGFloat)points.count;
    centerY = cumY / (CGFloat)points.count;
    return CGPointMake(centerX, centerY);
}


#pragma mark - 사각형 구성 : MGRRect_
CGRect MGRRectAroundCenter(CGPoint center, CGSize size) {
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}

CGRect MGRRectCenteredInRect(CGRect sourceRect, CGRect destRect) {
    CGFloat dx = CGRectGetMidX(sourceRect) - CGRectGetMidX(destRect);
    CGFloat dy = CGRectGetMidY(sourceRect) - CGRectGetMidY(destRect);
    return CGRectOffset(destRect, dx, dy);
}

CGRect MGRRectCenteredInRectSize(CGRect sourceRect, CGSize destSize) {
    return MGRRectCenteredInRect(sourceRect, (CGRect){CGPointZero, destSize});
}

CGRect MGRRectPercent(CGRect sourceRect, CGFloat percentWidth, CGFloat percentHeight) {
    if (sourceRect.size.width < 0.0 || sourceRect.size.height < 0.0) {
        NSCAssert(FALSE, @"rect의 사이즈가 음수이다.");
    }
    CGFloat horizontalInset = (CGRectGetWidth(sourceRect) - CGRectGetWidth(sourceRect) * percentWidth) / 2.0;
    CGFloat verticalInset = (CGRectGetHeight(sourceRect) - CGRectGetHeight(sourceRect) * percentHeight) / 2.0;
    return CGRectInset(sourceRect, horizontalInset, verticalInset);
}


#pragma mark - 배율 : MGRSize_, MGRAspect_

CGSize MGRSizeScaleByFactor(CGSize aSize, CGFloat factor) {
    return CGSizeMake(aSize.width * factor, aSize.height * factor);
}

CGSize MGRSizeScaleBothRect(CGRect sourceRect, CGRect destRect) {
    CGSize sourceSize = sourceRect.size;
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return CGSizeMake(scaleW, scaleH);
}

CGPoint MGRPointScaleByFactor(CGPoint point, CGFloat factor) {
    return CGPointMake(point.x * factor, point.y * factor);
}

CGFloat MGRAspectScaleFill(CGSize sourceSize, CGRect destRect) {
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmax(scaleW, scaleH);
}

CGFloat MGRAspectScaleFit(CGSize sourceSize, CGRect destRect) {
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmin(scaleW, scaleH);
}

#pragma mark - 피팅 : MGRRect_

CGRect MGRRectByFillingRect(CGRect sourceRect, CGRect destRect) {
    CGFloat aspect = MGRAspectScaleFill(sourceRect.size, destRect);
    CGSize destSize = MGRSizeScaleByFactor(sourceRect.size, aspect);
    return MGRRectAroundCenter(MGRRectGetCenter(destRect), destSize);
}

CGRect MGRRectByFittingRect(CGRect sourceRect, CGRect destRect) {
    CGFloat aspect = MGRAspectScaleFit(sourceRect.size, destRect);
    CGSize destSize = MGRSizeScaleByFactor(sourceRect.size, aspect);
    return MGRRectAroundCenter(MGRRectGetCenter(destRect), destSize);
}

CGRect MGRRectSquareByFittingRect(CGRect destRect) {
    CGFloat length = MIN(destRect.size.width, destRect.size.height);
    CGFloat x = (destRect.size.width - length) / 2.0;
    CGFloat y = (destRect.size.height - length) / 2.0;
    return CGRectMake(destRect.origin.x + x, destRect.origin.y + y, length, length);
}

#pragma mark - 트랜스폼 : MGRTransform_

CGFloat MGRTransformGetXScale(CGAffineTransform t) {
    return sqrt(t.a * t.a + t.c * t.c);
    // 피타고라스의 정리를 이용해 빗변 길이을 구하는 형식
}

CGFloat MGRTransformGetYScale(CGAffineTransform t) {
    return sqrt(t.b * t.b + t.d * t.d);
    // 피타고라스의 정리를 이용해 빗변 길이을 구하는 형식
}

CGFloat MGRTransformGetRotation(CGAffineTransform t) {
    return atan2f(t.b, t.a); // 대체 atan2f(t.c, t.d)
    // 직각삼각형의 각도
}

//------------------------------------------------------------------------------------------------------------------------
CGFloat MGRTransform3DGetScale(CATransform3D transform) {
    return transform.m11;
}

CGFloat MGRTransform3DGetRotationAngle(CATransform3D transform) {
    return atan2(transform.m12, transform.m11);
}


#pragma mark - Rotate Point About Origin

//! 원점(0.0, 0.0)을 중심으로 회전. x축 위에 있는 점을 시계방향(radian이 양수이면)으로 회전시킴.
CGPoint MGRRotatePoint(CGPoint endPoint, CGFloat radian) {
    float sin = sinf(radian);
    float cos = cosf(radian);
    return CGPointMake(cos * endPoint.x - sin * endPoint.y,
                       sin * endPoint.x + cos * endPoint.y);
}

//! 시계방향으로 회전함!!
CGPoint MGRRotatePointAboutCenter(CGPoint center, CGPoint A, CGFloat radian) {
    /******⬇︎⬇︎⬇︎⬇︎center에서 A를 잇는 벡터를 구한다.⬇︎⬇︎⬇︎⬇︎******/
    CGPoint V1 = CGPointMake(A.x - center.x, A.y - center.y);

    
    /******⬇︎⬇︎⬇︎⬇︎벡터V1에서 angle만큼 돌린다.⬇︎⬇︎⬇︎⬇︎******/
    CGPoint V2 = CGPointMake(cosf(radian) * V1.x - sinf(radian) * V1.y,
                             sinf(radian) * V1.x + cosf(radian) * V1.y); // 삼각함수를 이용하여 회전시킨다.
    
    /******⬇︎⬇︎⬇︎⬇︎벡터V2를 center를 더하여 결과적으로 center를 중심으로 점 A를 angle만큼 돌려서 나온 점의 좌표를 구한다.⬇︎⬇︎⬇︎⬇︎******/
    CGPoint B = CGPointMake(center.x + V2.x, center.y + V2.y);
    
    return B;
}

//! x축과의 각
CGFloat MGRRotationAngleAboutCenter(CGPoint center, CGPoint A) {
    return atan2(A.y - center.y, A.x - center.x);
}


#pragma mark - Random Function
CGPoint MGRRandomPositionForSize(CGSize size) {
    NSInteger x = arc4random() % ((NSInteger)size.width);
    NSInteger y = arc4random() % ((NSInteger)size.height);
    return CGPointMake((CGFloat)x, (CGFloat)y);
}


#pragma mark - Etc
CGVector MGRVectorFromPoint(CGPoint point) {
    return CGVectorMake(point.x, point.y);
}

CGPoint MGRPointFromVector(CGVector vector) {
    return CGPointMake(vector.dx, vector.dy);
}

CGFloat MGRRadianFromDegree(CGFloat degree) {
    return (degree / 180.0) * M_PI;
}

CGFloat MGRDegreeFromRadian(CGFloat radian) {
    return (radian / M_PI) * 180.0;
}
