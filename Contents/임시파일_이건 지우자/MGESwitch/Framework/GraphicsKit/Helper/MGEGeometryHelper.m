//
//  MGEGeometryHelper.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEGeometryHelper.h"

static CGFloat MGEVector2DDistance(CGVector v1, CGVector v2);

#pragma mark - NSInteger CGFloat CGPoint - Null Extention
const NSInteger MGEIntegerNull = NSNotFound;
const BOOL MGEIntegerIsNull(NSInteger value) { return (value == NSNotFound) ? YES : NO; }

const CGFloat MGEFloatNull = INFINITY;
const BOOL MGEFloatIsNull(CGFloat value) { return (value == INFINITY) ? YES : NO; }

const CGPoint MGEPointNull = (CGPoint){INFINITY, INFINITY};
const BOOL MGEPointIsNull(CGPoint point) { return CGPointEqualToPoint(MGEPointNull, point); }


#pragma mark - linear interpolation : MGELerp_
CGFloat MGELerpDouble(CGFloat progress, CGFloat from, CGFloat to) {
    return from + ((to - from) * progress);
}

CGPoint MGELerpPoint(CGFloat progress, CGPoint from, CGPoint to) {
    return CGPointMake(MGELerpDouble(progress, from.x, to.x),
                       MGELerpDouble(progress, from.y, to.y));
}

CGPoint MGELerpPointMid(CGPoint from, CGPoint to) {
    return MGELerpPoint(0.5, from, to);
}

CGSize MGELerpSize(CGFloat progress, CGSize from, CGSize to) {
    return CGSizeMake(MGELerpDouble(progress, from.width, to.width),
                      MGELerpDouble(progress, from.height, to.height));
}

CGRect MGELerpRect(CGFloat progress, CGRect from, CGRect to) {
    return CGRectMake(MGELerpDouble(progress, from.origin.x, to.origin.x),
                      MGELerpDouble(progress, from.origin.y, to.origin.y),
                      MGELerpDouble(progress, from.size.width, to.size.width),
                      MGELerpDouble(progress, from.size.height, to.size.height));
}

CATransform3D MGELerpTransform3D(CGFloat progress, CATransform3D from, CATransform3D to) {
    CATransform3D result = CATransform3DIdentity;
    result.m11 = MGELerpDouble(progress, from.m11, to.m11);
    result.m12 = MGELerpDouble(progress, from.m12, to.m12);
    result.m13 = MGELerpDouble(progress, from.m13, to.m13);
    result.m14 = MGELerpDouble(progress, from.m14, to.m14);
    result.m21 = MGELerpDouble(progress, from.m21, to.m21);
    result.m22 = MGELerpDouble(progress, from.m22, to.m22);
    result.m23 = MGELerpDouble(progress, from.m23, to.m23);
    result.m24 = MGELerpDouble(progress, from.m24, to.m24);
    result.m31 = MGELerpDouble(progress, from.m31, to.m31);
    result.m32 = MGELerpDouble(progress, from.m32, to.m32);
    result.m33 = MGELerpDouble(progress, from.m33, to.m33);
    result.m34 = MGELerpDouble(progress, from.m34, to.m34);
    result.m41 = MGELerpDouble(progress, from.m41, to.m41);
    result.m42 = MGELerpDouble(progress, from.m42, to.m42);
    result.m43 = MGELerpDouble(progress, from.m43, to.m43);
    result.m44 = MGELerpDouble(progress, from.m44, to.m44);
    return result;
}

CGColorRef MGELerpCreateColor(CGFloat progress, CGColorRef from, CGColorRef to) {
    const CGFloat *fromComponents = CGColorGetComponents(from);
    const CGFloat *toComponents = CGColorGetComponents(to);

    CGFloat fromAlpha, toAlpha, r, g, b, a;
    fromAlpha = CGColorGetAlpha(from);
    toAlpha = CGColorGetAlpha(to);

    r = MGELerpDouble(progress, fromComponents[0], toComponents[0]);

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

    g = MGELerpDouble(progress, color1Green, color2Green);
    b = MGELerpDouble(progress, color1Blue, color2Blue);

    a = MGELerpDouble(progress, fromAlpha, toAlpha);

    // Deployment Target 이 13.0이다. 기계가 13 이상부터 다 들어온다. 10.15를 의미함. 110500는 11.5를 의미함.
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 130000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101500)
    return CGColorCreateSRGB(r, g, b, a);
#else
    // Deployment Target 이 13 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(macOS 10.15, iOS 13, *)) {
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


#pragma mark - 현재 Progress 추출. : MGEProgress_ from ~ to 까지의 범위에서 현재 current 값일 때의 progress를 추출해준다.
CGFloat MGEProgressLerpDouble(CGFloat from, CGFloat to, CGFloat current) {
    if (from != to) {
        return (current - from) / (to - from);
    } else {
        NSLog(@"시작과 끝이 같은 값이다.");
        return 1.0;
    }
}

CGFloat MGEProgressLerpPoint(CGPoint from, CGPoint to, CGPoint current) {
    if (CGPointEqualToPoint(from, to) == NO) {
        if (from.x != to.x) {
            return (current.x - from.x) / (to.x - from.x);
        } else { // from과 to가 같지 않음을 가정했고, from.x == to.x 이므로 from.y != to.y 임이 확정되었다.
            return (current.y - from.y) / (to.y - from.y);
        }
    } else {
        NSLog(@"시작점과 끝점이 같은 값이다.");
        return 1.0;
    }
}

CGFloat MGEProgressLerpSize(CGSize from, CGSize to, CGSize current) {
    if (CGSizeEqualToSize(from, to) == NO) {
        if (from.width != to.width) {
            return (current.width - from.width) / (to.width - from.width);
        } else { // from과 to가 같지 않음을 가정했고, from.width == to.width 이므로 from.height != to.height 임이 확정되었다.
            return (current.height - from.height) / (to.height - from.height);
        }
    } else {
        NSLog(@"시작 사이즈와 끝 사이즈가 같은 값이다.");
        return 1.0;
    }
}

CGFloat MGEProgressLerpRect(CGRect from, CGRect to, CGRect current) {
    if (CGRectEqualToRect(from, to) == NO) {
        if (from.origin.x != to.origin.x) {
            return (current.origin.x - from.origin.x) / (to.origin.x - from.origin.x);
        } else if (from.origin.y != to.origin.y) {
            return (current.origin.y - from.origin.y) / (to.origin.y - from.origin.y);
        } else if (from.size.width != to.size.width) {
            return (current.size.width - from.size.width) / (to.size.width - from.size.width);
        } else { // from과 to가 같지 않음을 가정했고, 다른 element가 같으므로 from.size.height != to.size.height 임이 확정되었다.
            return (current.size.height - from.size.height) / (to.size.height - from.size.height);
        }
    } else {
        NSLog(@"시작 Rect와 끝 Rect가 같은 값이다.");
        return 1.0;
    }
}

CGFloat MGEProgressLerpColor(CGColorRef from, CGColorRef to, CGColorRef current) {
    if (CGColorEqualToColor(from, to) == YES) {
        NSLog(@"시작 색과 끝 색이 같은 색이다.");
        return 1.0;
    }
    
    CGFloat fromAlpha = CGColorGetAlpha(from);
    CGFloat toAlpha = CGColorGetAlpha(to);
    CGFloat currentAlpha = CGColorGetAlpha(current);
    if (fromAlpha != toAlpha) {
        return (currentAlpha - fromAlpha) / (toAlpha - fromAlpha);
    }
    
    const CGFloat *fromComponents = CGColorGetComponents(from);
    const CGFloat *toComponents = CGColorGetComponents(to);
    const CGFloat *currentComponents = CGColorGetComponents(current);

    if (fromComponents[0] != toComponents[0]) {
        return (currentComponents[0] - fromComponents[0]) / (toComponents[0] - fromComponents[0]);
    } else if (fromComponents[1] != toComponents[1]) {
        return (currentComponents[1] - fromComponents[1]) / (toComponents[1] - fromComponents[1]);
    } else {
        return (currentComponents[2] - fromComponents[2]) / (toComponents[2] - fromComponents[2]);
    }
}


#pragma mark - Normalize
CGPoint MGENormalizedPoint(CGPoint point) {
    CGFloat distance = MGEDistanceFromZeroToPoint(point);
    if (distance == 0.0) {
        NSCAssert(FALSE, @"distance가 0.0이므로 Normalized가 불가능하다.");
    }
    return CGPointMake(point.x / distance, point.y / distance);
}

CGVector MGENormalizedVector(CGVector vector) {
    CGFloat distance = MGEDistanceFromZeroToPoint(MGEPointFromVector(vector));
    if (distance == 0.0) {
        NSCAssert(FALSE, @"distance가 0.0이므로 Normalized가 불가능하다.");
    }
    return CGVectorMake(vector.dx / distance, vector.dy / distance);
}


#pragma mark - linear distance
CGFloat MGEDistanceToDouble(CGFloat one, CGFloat theOther) {
    return ABS(theOther - one);
}

CGFloat MGEDistanceToCGPoint(CGPoint one, CGPoint theOther) {
    return MGEVector2DDistance(CGVectorMake(one.x, one.y), CGVectorMake(theOther.x, theOther.y));
}

CGFloat MGEDistanceFromZeroToPoint(CGPoint theOther) {
    return MGEDistanceToCGPoint(CGPointZero, theOther);
}

//! private
static CGFloat MGEVector2DDistance(CGVector v1, CGVector v2) {
    CGFloat xDiff = v2.dx - v1.dx;
    CGFloat yDiff = v2.dy - v1.dy;
    return hypotf(xDiff, yDiff);
}


#pragma mark - 일반도형 : MGERect_, MGETriangle_
CGPoint MGERectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint MGETriangleGetCenterOfGravity(CGPoint a, CGPoint b, CGPoint c) {
    return CGPointMake((a.x + b.x + c.x) / 3.0, (a.y + b.y + c.y) / 3.0);
}

CGPoint MGEPointsGetAveragePoint(NSArray <NSValue *>*points) {
    CGFloat centerX = 0.0;
    CGFloat centerY = 0.0;
    CGFloat cumX = 0.0;
    CGFloat cumY = 0.0;
    for (NSValue *value in points) {
#if TARGET_OS_OSX
        NSPoint point = [value pointValue];
#elif TARGET_OS_IPHONE
        CGPoint point = [value CGPointValue];
#endif
        cumX = cumX + point.x;
        cumY = cumY + point.y;
    }
    centerX = cumX / (CGFloat)points.count;
    centerY = cumY / (CGFloat)points.count;
    return CGPointMake(centerX, centerY);
}


#pragma mark - 사각형 구성 : MGERect_
CGRect MGERectAroundCenter(CGPoint center, CGSize size) {
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}

CGRect MGERectCenteredInRect(CGRect sourceRect, CGRect destRect) {
    CGFloat dx = CGRectGetMidX(sourceRect) - CGRectGetMidX(destRect);
    CGFloat dy = CGRectGetMidY(sourceRect) - CGRectGetMidY(destRect);
    return CGRectOffset(destRect, dx, dy);
}

CGRect MGERectCenteredInRectSize(CGRect sourceRect, CGSize destSize) {
    return MGERectCenteredInRect(sourceRect, (CGRect){CGPointZero, destSize});
}

CGRect MGERectPercent(CGRect sourceRect, CGFloat percentWidth, CGFloat percentHeight) {
    if (sourceRect.size.width < 0.0 || sourceRect.size.height < 0.0) {
        NSCAssert(FALSE, @"rect의 사이즈가 음수이다.");
    }
    CGFloat horizontalInset = (CGRectGetWidth(sourceRect) - CGRectGetWidth(sourceRect) * percentWidth) / 2.0;
    CGFloat verticalInset = (CGRectGetHeight(sourceRect) - CGRectGetHeight(sourceRect) * percentHeight) / 2.0;
    return CGRectInset(sourceRect, horizontalInset, verticalInset);
}

CGRect MGERectForMacFromIosRect(CGRect iosRect, CGFloat superHeight) {
    CGRect macRect = iosRect;
    macRect.origin.y = superHeight - (iosRect.origin.y + iosRect.size.height);
    return macRect;
}

CGRect MGERectForIosFromMacRect(CGRect macRect, CGFloat superHeight) {
    CGRect iosRect = macRect;
    iosRect.origin.y = superHeight - (macRect.origin.y + macRect.size.height);
    return iosRect;
}

#pragma mark - 배율 : MGESize_, MGEAspect_

CGSize MGESizeScaleByFactor(CGSize aSize, CGFloat factor) {
    return CGSizeMake(aSize.width * factor, aSize.height * factor);
}

CGSize MGESizeScaleBothRect(CGRect sourceRect, CGRect destRect) {
    CGSize sourceSize = sourceRect.size;
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return CGSizeMake(scaleW, scaleH);
}

CGPoint MGEPointScaleByFactor(CGPoint point, CGFloat factor) {
    return CGPointMake(point.x * factor, point.y * factor);
}

CGFloat MGEAspectScaleFill(CGSize sourceSize, CGRect destRect) {
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmax(scaleW, scaleH);
}

CGFloat MGEAspectScaleFit(CGSize sourceSize, CGRect destRect) {
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmin(scaleW, scaleH);
}

#pragma mark - 피팅 : MGERect_

CGRect MGERectByFillingRect(CGRect sourceRect, CGRect destRect) {
    CGFloat aspect = MGEAspectScaleFill(sourceRect.size, destRect);
    CGSize destSize = MGESizeScaleByFactor(sourceRect.size, aspect);
    return MGERectAroundCenter(MGERectGetCenter(destRect), destSize);
}

CGRect MGERectByFittingRect(CGRect sourceRect, CGRect destRect) {
    CGFloat aspect = MGEAspectScaleFit(sourceRect.size, destRect);
    CGSize destSize = MGESizeScaleByFactor(sourceRect.size, aspect);
    return MGERectAroundCenter(MGERectGetCenter(destRect), destSize);
}

CGRect MGERectSquareByFittingRect(CGRect destRect) {
    CGFloat length = MIN(destRect.size.width, destRect.size.height);
    CGFloat x = (destRect.size.width - length) / 2.0;
    CGFloat y = (destRect.size.height - length) / 2.0;
    return CGRectMake(destRect.origin.x + x, destRect.origin.y + y, length, length);
}


#pragma mark - 트랜스폼 : MGETransform_ CGAffineTransform - view, MGETransform3D_ CATransform3D - layer
CGFloat MGETransformGetXScale(CGAffineTransform t) {
    return sqrt(t.a * t.a + t.c * t.c); //! 음수까지 고려한다면 다음을 곱하라. (t.a/ABS(t.a))
    // 피타고라스의 정리를 이용해 빗변 길이을 구하는 형식
}

CGFloat MGETransformGetYScale(CGAffineTransform t) {
    return sqrt(t.b * t.b + t.d * t.d); //! 음수까지 고려한다면 다음을 곱하라. (t.d/ABS(t.d))
    // 피타고라스의 정리를 이용해 빗변 길이을 구하는 형식
}

CGFloat MGETransformGetRotation(CGAffineTransform t) {
    return atan2f(t.b, t.a); // 대체 atan2f(t.c, t.d)
    // 직각삼각형의 각도
}

CGPoint MGETransformGetTranslation(CGAffineTransform t) {
    return CGPointMake(t.tx, t.ty);
}

CGVector MGETransformGetVector(CGAffineTransform t, CGVector vector) {
    CGFloat oldX = vector.dx;
    CGFloat oldY = vector.dy;
    CGFloat newX = (oldX * t.a) + (oldY * t.c) + (1.0 * t.tx);
    CGFloat newY = (oldX * t.b) + (oldY * t.d) + (1.0 * t.ty);
    return CGVectorMake(newX, newY);
}

//------------------------------------------------------------------------------------------------------------------------
CGFloat MGETransform3DGetXScale(CATransform3D transform) {
    return transform.m11;
}

CGFloat MGETransform3DGetYScale(CATransform3D transform) {
    return transform.m22;
}

CGFloat MGETransform3DGetZScale(CATransform3D transform) {
    return transform.m33;
}

CGFloat MGETransform3DGetXTranslation(CATransform3D transform) {
    return transform.m41;
}

CGFloat MGETransform3DGetYTranslation(CATransform3D transform) {
    return transform.m42;
}

CGFloat MGETransform3DGetZTranslation(CATransform3D transform) {
    return transform.m43;
}

CGFloat MGETransform3DGetZRotationAngle(CATransform3D transform) {
    return atan2(transform.m12, transform.m11);
}

CGFloat MGETransform3DGetXRotationAngle(CATransform3D transform) {
    return atan2(transform.m23, transform.m22);
}

CGFloat MGETransform3DGetYRotationAngle(CATransform3D transform) {
    return atan2(transform.m31, transform.m11);
}

CIVector * MGETransform3DGetVector(CATransform3D t, CIVector *vector) {
    CGFloat oldX = vector.X;
    CGFloat oldY = vector.Y;
    CGFloat oldZ = vector.Z;
    CGFloat newX = (oldX * t.m11) + (oldY * t.m21) + (oldZ * t.m31) + (1.0 * t.m41);
    CGFloat newY = (oldX * t.m12) + (oldY * t.m22) + (oldZ * t.m32) + (1.0 * t.m42);
    CGFloat newZ = (oldX * t.m13) + (oldY * t.m23) + (oldZ * t.m33) + (1.0 * t.m43);
    return [CIVector vectorWithX:newX Y:newY Z:newZ];
}


#pragma mark - Rotate Point About Origin

//! 원점(0.0, 0.0)을 중심으로 회전. x축 위에 있는 점을 시계방향(radian이 양수이면)으로 회전시킴.
CGPoint MGERotatePoint(CGPoint endPoint, CGFloat radian) {
    float sin = sinf(radian);
    float cos = cosf(radian);
    return CGPointMake(cos * endPoint.x - sin * endPoint.y,
                       sin * endPoint.x + cos * endPoint.y);
}

//! 시계방향으로 회전함!!
CGPoint MGERotatePointAboutCenter(CGPoint center, CGPoint A, CGFloat radian) {
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
CGFloat MGERotationAngleAboutCenter(CGPoint center, CGPoint A) {
    return atan2(A.y - center.y, A.x - center.x);
}


#pragma mark - Random Function
CGPoint MGERandomPositionForSize(CGSize size) {
    NSInteger x = arc4random() % ((NSInteger)size.width);
    NSInteger y = arc4random() % ((NSInteger)size.height);
    return CGPointMake((CGFloat)x, (CGFloat)y);
}


#pragma mark - Etc
CGVector MGEVectorFromPoint(CGPoint point) {
    return CGVectorMake(point.x, point.y);
}

CGPoint MGEPointFromVector(CGVector vector) {
    return CGPointMake(vector.dx, vector.dy);
}

CGFloat MGERadianFromDegree(CGFloat degree) {
    return (degree / 180.0) * M_PI;
}

CGFloat MGEDegreeFromRadian(CGFloat radian) {
    return (radian / M_PI) * 180.0;
}


const CGPathRef MGEPathCreateWithRoundedRect(CGRect rect,
                                             CGFloat cornerRadius,
                                             CACornerMask maskedCorners,
                                             const CGAffineTransform * __nullable transform) {
    CGPoint topPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint bottomPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint leftPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPoint rightPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    
    CGFloat maxRadius = MIN(rect.size.width, rect.size.height) / 2.0;
    maxRadius = MIN(maxRadius, cornerRadius);
    
    CGFloat widthStraight_2 = (rect.size.width / 2.0) - maxRadius;
    CGFloat heightStraight_2 = (rect.size.height / 2.0) - maxRadius;
    
    CGMutablePathRef myCGPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(myCGPath, NULL, leftPoint.x, leftPoint.y + heightStraight_2);
    CGPathAddLineToPoint(myCGPath, NULL, leftPoint.x, leftPoint.y - heightStraight_2);
    
    if (maskedCorners & kCALayerMinXMinYCorner) {
        CGPathAddArc(myCGPath, NULL, leftPoint.x + maxRadius, leftPoint.y - heightStraight_2, maxRadius, M_PI, -M_PI_2, NO);
    } else {
        CGPathAddLineToPoint(myCGPath, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGPathAddLineToPoint(myCGPath, NULL, topPoint.x - widthStraight_2, topPoint.y);
    }
    
    CGPathAddLineToPoint(myCGPath, NULL, topPoint.x + widthStraight_2, topPoint.y);
    
    if (maskedCorners & kCALayerMaxXMinYCorner) {
        CGPathAddArc(myCGPath, NULL, topPoint.x + widthStraight_2, topPoint.y + maxRadius, maxRadius, -M_PI_2, 0, NO);
    } else {
        CGPathAddLineToPoint(myCGPath, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGPathAddLineToPoint(myCGPath, NULL, rightPoint.x, rightPoint.y - heightStraight_2);
    }
    
    CGPathAddLineToPoint(myCGPath, NULL, rightPoint.x, rightPoint.y + heightStraight_2);
    
    if (maskedCorners & kCALayerMaxXMaxYCorner) {
        CGPathAddArc(myCGPath, NULL, rightPoint.x - maxRadius, rightPoint.y + heightStraight_2, maxRadius, 0, M_PI_2, NO);
    } else {
        CGPathAddLineToPoint(myCGPath, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        CGPathAddLineToPoint(myCGPath, NULL, bottomPoint.x + widthStraight_2, bottomPoint.y);
    }
    
    CGPathAddLineToPoint(myCGPath, NULL, bottomPoint.x - widthStraight_2, bottomPoint.y);
    
    if (maskedCorners & kCALayerMinXMaxYCorner) {
        CGPathAddArc(myCGPath, NULL, bottomPoint.x - widthStraight_2, bottomPoint.y - maxRadius, maxRadius, M_PI_2, M_PI, NO);
    } else {
        CGPathAddLineToPoint(myCGPath, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGPathAddLineToPoint(myCGPath, NULL, leftPoint.x, leftPoint.y + heightStraight_2);
    }
    
    CGPathCloseSubpath(myCGPath);
    CGPathRef result = CGPathCreateCopyByTransformingPath(myCGPath, transform);
    CGPathRelease(myCGPath);
    return result;
//
//    self.shapeLayer.path = myCGPath;
//    CGPathRelease(myCGPath); /// 반드시 Release 해야한다. 그리는 주체가 C이다.
}

NSArray <NSNumber *>* MGEStrideFloat(CGFloat from, CGFloat to, CGFloat by) {
    if (from == CGFLOAT_MAX || from == CGFLOAT_MIN ||
        to == CGFLOAT_MAX || to == CGFLOAT_MIN ||
        by == CGFLOAT_MAX || by == CGFLOAT_MIN) {
        NSCAssert(FALSE, @"이런 상황에서는 사용하지 말자. For 문 또는 while 문을 사용하라.");
    }
    NSMutableArray <NSNumber *>*result = @[].mutableCopy;
    if (by == 0) {
        NSCAssert(FALSE, @"Fatal error : MGEStrideFloat함수의 by 매개변수는 0을 넣을 수 없다.");
        return result;
    }
    if (from == to) {
        return result;
    }

    // 반대방향으로 가는 경우 : 좌우의 문제가 아니라 from -> to 로 갈 수 있는지의 문제이다.
    // ---> 으로 전개 된다고 가정하자. <--- 의 경우도 논리 전개가 같다.
    //                   from           to
    //      (from + by) 이 값이 from의 좌측에 있으면 원소 없이 나간다. from을 0 지점으로 옮기자.
    //     by ... 0 ... (to - from) <- 이런 상태이면 나가는 것
    // by * (to - from) < 0.0 이면 나간다.
    // 즉,
    if ( (by * (to - from)) < 0.0 ) {
        return result;
    }

    // 정방향으로 가는 경우 : 좌우의 문제가 아니라 from -> to 로 갈 수 있는지의 문제이다. 여기서 부터는 무조건 1개 이상이다.
    CGFloat distance = ABS(to - from);
    for (NSInteger i = 0; TRUE; i++) {
        CGFloat current = from + (by * i);
        CGFloat currentDistance = ABS(current - from);
        if (currentDistance < distance) {
            [result addObject:@(current)];
        } else {
            break;
        }
    }
    return result;
}

NSArray <NSNumber *>*MGEStrideInt(NSInteger from, NSInteger to, NSInteger by) {
    if (from == NSIntegerMax || from == NSIntegerMin ||
        to == NSIntegerMax || to == NSIntegerMin ||
        by == NSIntegerMax || by == NSIntegerMin) {
        NSCAssert(FALSE, @"이런 상황에서는 사용하지 말자. For 문 또는 while 문을 사용하라.");
    }
    NSMutableArray <NSNumber *>*result = @[].mutableCopy;
    if (by == 0) {
        NSCAssert(FALSE, @"Fatal error : MGEStrideInt함수의 by 매개변수는 0을 넣을 수 없다.");
        return result;
    }
    if (from == to) {
        return result;
    }

    // 반대방향으로 가는 경우 : 좌우의 문제가 아니라 from -> to 로 갈 수 있는지의 문제이다.
    // ---> 으로 전개 된다고 가정하자. <--- 의 경우도 논리 전개가 같다.
    //                   from           to
    //      (from + by) 이 값이 from의 좌측에 있으면 원소 없이 나간다. from을 0 지점으로 옮기자.
    //     by ... 0 ... (to - from) <- 이런 상태이면 나가는 것
    // by * (to - from) < 0.0 이면 나간다.
    // 즉,
    if ( (by * (to - from)) < 0 ) {
        return result;
    }

    // 정방향으로 가는 경우 : 좌우의 문제가 아니라 from -> to 로 갈 수 있는지의 문제이다. 여기서 부터는 무조건 1개 이상이다.
    CGFloat distance = ABS(to - from);
    for (NSInteger i = 0; TRUE; i++) {
        CGFloat current = from + (by * i);
        CGFloat currentDistance = ABS(current - from);
        if (currentDistance < distance) {
            [result addObject:@(current)];
        } else {
            break;
        }
    }
    return result;
}
