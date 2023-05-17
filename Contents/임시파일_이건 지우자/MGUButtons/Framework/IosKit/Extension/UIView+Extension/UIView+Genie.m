//
//  UIView+Genie.m
//  BCGenieEffect
//
//  Created by Bartosz Ciechanowski on 23.12.2012.
//  Copyright (c) 2012 Bartosz Ciechanowski. All rights reserved.
//

#import "UIView+Genie.h"
#import <GraphicsKit/MGEEasingHelper.h>
#import <BaseKit/BaseKit.h>

#pragma mark - Constants

/* Animation 매개변수
 *
 * Genie effect는 곡선 애니메이션과 슬라이드 애니메이션으로 구성된 두 가지 애니메이션으로 구성된다.
 * 곡선 애니메이션은 Genie effect의 모양을 잡기위해 베지어 곡선을 움직이고, 슬라이드 애니메이션은 animated view를 rect(램프)로 슬라이드(in or out)한다.
 
 * 이 매개 변수는 두 가지 애니메이션이 시작/종료되어야하는 진행률(progress)을 나타낸다.
 * 이 값은 [0.0, 1.0] 범위에 있어야한다.
 *
 * 예:
 * 애니메이션 지속 시간이 2초로 설정된 경우 곡선 애니메이션은 0.0에서 시작하고 0.8 초에서 끝나고 슬라이드 애니메이션은 0.6 초에서 시작하여 2.0 초에 종료된다.
 */
static const double curvesAnimationStart = 0.0;
static const double curvesAnimationEnd   = 0.4;
static const double slideAnimationStart  = 0.3;
static const double slideAnimationEnd    = 1.0;

/* Performance 매개변수
 *
 * 사소하지 않은 CATransform3D의 디폴트 linear 보간으로 인해 'wild'하게 작동하기 때문에
 * discrete 애니메이션을 사용하기로 결정했다. 즉, 각 프레임은 별개이며 별도로 계산된다.
 * 이렇게하면 애니메이션이 올바르게 작동하지만, 매우 긴 duration 및 / 또는 큰 뷰에서 일부 성능 문제가 발생할 수 있다.
 */
static const CGFloat kSliceSize = 10.0f; // height / width of a single slice
static const NSTimeInterval kFPS = 60.0; // assumed animation's FPS

/*
 * Antialiasing 매개변수
 * kRenderMargin 상수에서 0.0과 1.0 사이의 눈에 띄는 차이가 있지만 값이 클수록 가장자리 품질이 크게 향상되지 않으며 성능이 저하된다.
 * 기본값은 효과가 있으며 품질이 향상되었다고 확신할 수있는 경우에만 변경해야한다.
 * 이렇게 적혀있지만, 그냥 0.0으로 때려보 무방하다. 가장자리 부근의 이미지가 손실되는 것을 막기 위해 약간 더 넓게 스크린샷을 뜨려고 마련된 상수.
 */
static const CGFloat kRenderMargin = 2.0;

//! 한 앱에서는 여기로 조정하고 가자. elastic과 back은 사용할 수 없다.
static const MGEEasingFunctionType easingFunctionType = MGEEasingFunctionTypeEaseInOutCubic;
//static const MGEEasingFunctionType easingFunctionType = MGEEasingFunctionTypeEaseOutBounce;


#pragma mark - Structs & enums boilerplate
typedef NS_ENUM(NSInteger, GenieAxis) {
    GenieAxisX = 0, // horizontal
    GenieAxisY = 1  // vertical
};

typedef struct GenieTrapezoidVertices {
    CGPoint aPoint;
    CGPoint bPoint;
    CGPoint cPoint;
    CGPoint dPoint;
} GenieTrapezoidVertices;

typedef struct GenieLineSegment {
    CGPoint aPoint;
    CGPoint bPoint;
} GenieLineSegment;

typedef GenieLineSegment GenieCurveSegment;

// static GenieLineSegment const GenieLineSegmentZero = {0,};

CG_INLINE GenieLineSegment GenieLineSegmentMake(CGPoint aPoint, CGPoint bPoint) {
    GenieLineSegment segment = {aPoint, bPoint};
    return segment;
}

//! BCRectEdgeTop, BCRectEdgeBottom 은 BCAxisY, 그렇지 않으면 
GenieAxis axisForEdge(GenieRectEdge edge) {
    if (edge == GenieRectEdgeTop || edge == GenieRectEdgeBottom) {
        return GenieAxisY;
    } else {
        return GenieAxisX;
    }
}

GenieAxis reverseAxis(GenieAxis axis) {
    if (axis == GenieAxisX) {
        return GenieAxisY;
    } else {
        return GenieAxisX;
    }
}

//! BCRectEdgeBottom, BCRectEdgeRight YES를 반환, 그렇지 않으면 NO
BOOL isEdgeNegative(GenieRectEdge edge) {
    if (edge == GenieRectEdgeBottom || edge == GenieRectEdgeRight) {
        return YES;
    } else {
        return NO;
    }
}

//! BCRectEdgeTop, BCRectEdgeBottom YES를 반환, 그렇지 않으면 NO
BOOL isEdgeVertical(GenieRectEdge edge) {
    if (edge == GenieRectEdgeTop || edge == GenieRectEdgeBottom) {
        return YES;
    } else {
        return NO;
    }
}


@implementation UIView (Genie)

#pragma mark - publics
- (void)genieInTransitionWithDuration:(NSTimeInterval)duration
                      destinationRect:(CGRect)destRect
                      destinationEdge:(GenieRectEdge)destEdge
                           completion:(void (^)(void))completion {
    
    [self genieTransitionWithDuration:duration
                                 edge:destEdge
                      destinationRect:destRect
                              reverse:NO
                           completion:completion];
}

- (void)genieOutTransitionWithDuration:(NSTimeInterval)duration
                             startRect:(CGRect)startRect
                             startEdge:(GenieRectEdge)startEdge
                            completion:(void (^)(void))completion {
    
    [self genieTransitionWithDuration:duration
                                 edge:startEdge
                      destinationRect:startRect
                              reverse:YES
                           completion:completion];
}


#pragma mark - privates
- (void)genieTransitionWithDuration:(NSTimeInterval) duration
                               edge:(GenieRectEdge)edge
                    destinationRect:(CGRect)destRect
                            reverse:(BOOL)reverse
                         completion:(void (^)(void))completion {
    NSAssert(!CGRectIsNull(destRect), @"destRect가 nil이다. 이러면 안된다.");

    GenieAxis axis = axisForEdge(edge);
    self.transform = CGAffineTransformIdentity;
    
    UIImage *snapshot = [self renderSnapshotWithMarginForAxis:axis]; // 약간 넓게 스냅샷을 뜬 후.
    NSArray <CALayer *>*slices = [self sliceImagesFromImage:snapshot toLayersAlongAxis:axis]; // 슬라이스로 썰어버린다.
    
    // Bezier 계산.
    CGFloat xInset = axis == GenieAxisY ? -kRenderMargin : 0.0f;
    CGFloat yInset = axis == GenieAxisX ? -kRenderMargin : 0.0f;
    
    CGRect marginedDestRect = CGRectInset(destRect,
                                          xInset * destRect.size.width / self.bounds.size.width,
                                          yInset * destRect.size.height / self.bounds.size.height);
    CGFloat endRectDepth = isEdgeVertical(edge) ? marginedDestRect.size.height : marginedDestRect.size.width;
    GenieLineSegment startLineSegment =
    bezierEndPointsForTransition(edge, [self convertRect:CGRectInset(self.bounds, xInset, yInset) toView:self.superview]);
    
    GenieLineSegment endLineSegment = bezierEndPointsForTransition(edge, marginedDestRect);
    GenieLineSegment orthogonalProjection = startLineSegment;
    
    if (axis == GenieAxisX) {
        orthogonalProjection.aPoint.x = endLineSegment.aPoint.x;
        orthogonalProjection.bPoint.x = endLineSegment.bPoint.x;
    } else {
        orthogonalProjection.aPoint.y = endLineSegment.aPoint.y;
        orthogonalProjection.bPoint.y = endLineSegment.bPoint.y;
    }
    
    GenieCurveSegment firstCurveSegment  = {startLineSegment.aPoint, orthogonalProjection.aPoint};
    GenieCurveSegment secondCurveSegment = {startLineSegment.bPoint, orthogonalProjection.bPoint};
    
    // View hierarchy setup
    NSString *sumKeyPath = isEdgeVertical(edge) ? @"@sum.bounds.size.height" : @"@sum.bounds.size.width";
    CGFloat totalSize = [[slices valueForKeyPath:sumKeyPath] doubleValue];
    
    CGFloat sign = isEdgeNegative(edge) ? -1.0 : 1.0;

    //! ERROR 또는 Warning
    BOOL error   = NO;
    BOOL warning = NO;
    if (axis == GenieAxisX) {
        if (sign * (startLineSegment.aPoint.x - endLineSegment.aPoint.x) > 0.0f) {
            error = YES;
        } else if (sign*(startLineSegment.aPoint.x + sign * totalSize - endLineSegment.aPoint.x) > 0.0f) {
            warning = YES;
        }
    } else {
        if (sign * (startLineSegment.aPoint.y - endLineSegment.aPoint.y) > 0.0f) {
            error = YES;
        } else if (sign * (startLineSegment.aPoint.y + sign * totalSize - endLineSegment.aPoint.y) > 0.0f) {
            warning = YES;
        }
    }
    
    if (error == YES) {
        NSLog(@"ERROR: animated view의 %@ edge와 %@ rect의 %@ edge 사이의 거리가 정확하지 않다. 애니메이션은 실행되지 않을 것이다!",
              edgeDescription(edge),
              edgeDescription(edge),
              reverse ? @"start" : @"destination");
        if(completion != nil) {
            completion();
        }
        return;
    } else if (warning == YES) {
        NSLog(@"Warning: animated view의 %@ edge와 %@ rect의 %@ edge가 오버랩된다. Glitches may occur.",
        edgeDescription((edge + 2) % 4),
        reverse ? @"start" : @"destination",
        edgeDescription(edge));
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:[self.superview bounds]];
    containerView.clipsToBounds = self.superview.clipsToBounds; // if superview does it then we should probably do it as well
    containerView.backgroundColor = [UIColor clearColor];    
    [self.superview insertSubview:containerView belowSubview:self];
    
    //! NSValue는 CATransform3D
    NSMutableArray <NSMutableArray <NSValue *>*>*transforms = [NSMutableArray arrayWithCapacity:[slices count]];
    
    for (CALayer *layer in slices) {
        [containerView.layer addSublayer:layer];
        
        // info.plist에서 'Renders with edge antialiasing'= YES를 사용하면 슬라이스가 border로 렌더링된다.
        // 이렇게하면 UIView가 예상대로 표시된다.
        layer.edgeAntialiasingMask = 0;
        
        [transforms addObject:[NSMutableArray array]];
    }
    

    BOOL previousHiddenState = self.hidden;
    self.hidden = YES; // 애니메이션 중에 self를 숨긴다. 슬라이스가 대신 표시된다.
    
    // Animation frames
    NSInteger totalFrame = (NSInteger)(duration * kFPS);
    double tSignShift = reverse ? -1.0 : 1.0;
    
    for (int i = 0; i < totalFrame; i++) {
        
        double progress = (CGFloat)i / (totalFrame - 1.0); // 0.0 ~ 1.0
        double t = tSignShift * (progress - 0.5) + 0.5;    // 0.0 ~ 1.0, revere 이면 1.0 ~ 0.0
        //! t가 0.0 ~ 0.4에 변하면 curveP는 0.0 ~ 1.0이고 그 이후부터는 그때부터는 쭉 1.0이다.
        double curveProgress = progressOfSegmentWithinTotalProgress(curvesAnimationStart, curvesAnimationEnd, t); // 0.0, 0.4, t
        
        if (axis == GenieAxisX) {
            firstCurveSegment.bPoint.y = MGEEasingFunction(easingFunctionType,
                                                           curveProgress,
                                                           startLineSegment.aPoint.y,
                                                           endLineSegment.aPoint.y,
                                                           1.0);
            
            secondCurveSegment.bPoint.y = MGEEasingFunction(easingFunctionType,
                                                            curveProgress,
                                                            startLineSegment.bPoint.y,
                                                            endLineSegment.bPoint.y,
                                                            1.0);
        } else {
            firstCurveSegment.bPoint.x  = MGEEasingFunction(easingFunctionType,
                                                            curveProgress,
                                                            startLineSegment.aPoint.x,
                                                            endLineSegment.aPoint.x,
                                                            1.0);
            
            secondCurveSegment.bPoint.x = MGEEasingFunction(easingFunctionType,
                                                            curveProgress,
                                                            startLineSegment.bPoint.x,
                                                            endLineSegment.bPoint.x,
                                                            1.0);
        }
        
        //! t가 0.3까지는 slideP는 0.0이다가 그때부터 0.0 ~ 1.0으로 변한다.
        double slideProgress  = progressOfSegmentWithinTotalProgress(slideAnimationStart, slideAnimationEnd, t);
        CGFloat startPosition = 0.0;
        if (axis == GenieAxisX) {
            startPosition = MGEEasingFunction(easingFunctionType,
                                              slideProgress,
                                              firstCurveSegment.aPoint.x,
                                              firstCurveSegment.bPoint.x,
                                              1.0);
        } else {
            startPosition = MGEEasingFunction(easingFunctionType,
                                              slideProgress,
                                              firstCurveSegment.aPoint.y,
                                              firstCurveSegment.bPoint.y,
                                              1.0);
        }
        
        NSArray <NSValue *>*trs = [self transformationsForSlices:slices
                                                            edge:edge
                                                   startPosition:startPosition
                                                       totalSize:totalSize
                                                     firstBezier:firstCurveSegment
                                                    secondBezier:secondCurveSegment
                                                  finalRectDepth:endRectDepth];
        
        [trs enumerateObjectsUsingBlock:^(NSValue * obj, NSUInteger idx, BOOL *stop) {
            [(NSMutableArray *)transforms[idx] addObject:obj];
        }];
    }
    
    // Animation firing
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [containerView removeFromSuperview];
    
        CGSize startSize = self.frame.size;
        CGSize endSize = destRect.size;
    
        CGPoint startOrigin = self.frame.origin;
        CGPoint endOrigin = destRect.origin;
        
        //! 램프 위치로 실제 실제 animated view를 옮길 수 있게 transform한다.
        if (reverse == NO) {
            CGAffineTransform transform =
            CGAffineTransformMakeTranslation(endOrigin.x - startOrigin.x, endOrigin.y - startOrigin.y); // move to destination
            transform = CGAffineTransformTranslate(transform, -startSize.width/2.0, -startSize.height/2.0); // move top left corner to origin
            transform = CGAffineTransformScale(transform, endSize.width/startSize.width, endSize.height/startSize.height); // scale
            transform = CGAffineTransformTranslate(transform, startSize.width/2.0, startSize.height/2.0); // move back
            self.transform = transform;
        }
        
        //! 실제 animated view를 최종 위치로 옮겨(크기도 맞게 변하게 해서) 보여준다.
        self.hidden = previousHiddenState;
        if (completion != nil) {
            completion();
        }
    }];
    
    [slices enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        anim.duration = duration;
        anim.values = transforms[idx];
        anim.calculationMode = kCAAnimationDiscrete; //! 이걸 사용해야된다.
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        [layer addAnimation:anim forKey:@"transform"];
    }];
    
    [CATransaction commit];
}

//! 약간 넓게 스크린 뜨는 것 뿐이다.
- (UIImage *)renderSnapshotWithMarginForAxis:(GenieAxis)axis {
    CGSize contextSize = self.frame.size;
    CGFloat xOffset = 0.0f;
    CGFloat yOffset = 0.0f;
    
    if (axis == GenieAxisY) {
        xOffset = kRenderMargin;
        contextSize.width = contextSize.width + (2.0 * kRenderMargin);
    } else {
        yOffset = kRenderMargin;
        contextSize.height = contextSize.height + (2.0 * kRenderMargin);
    }
    
    //! if you want to see border added for antialiasing pass YES as second param
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, xOffset, yOffset);
    
    [self.layer renderInContext:context];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

//! vertical(BCAxisY, top, bottom)은 행으로 10.0f씩 자른다. horizontal(BCAxisX, left, right)은 열로 10.0f 자른다.
- (NSArray <CALayer *>*)sliceImagesFromImage:(UIImage *)image toLayersAlongAxis:(GenieAxis)axis {
    CGFloat scale = image.scale;
    CGRect sliceRect = CGRectNull;
    
    CGFloat totalSize = (axis == GenieAxisY) ? image.size.height : image.size.width;
    NSInteger count = (NSInteger)ceil(totalSize / kSliceSize); // 올림함수.
    NSMutableArray <CALayer *>*slices = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        if (axis == GenieAxisX) {
            sliceRect = CGRectMake(kSliceSize * scale * i, 0.0, kSliceSize * scale, image.size.height * scale);
        } else {
            sliceRect = CGRectMake(0.0, kSliceSize * scale * i, image.size.width * scale, kSliceSize * scale);
        }
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, sliceRect);
        UIImage *sliceImage = [UIImage imageWithCGImage:imageRef
                                                  scale:scale
                                            orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        CALayer *layer = [CALayer layer];
        layer.anchorPoint = CGPointZero; // anchorPoint를 옮긴다.
        layer.bounds = CGRectMake(0.0, 0.0, sliceImage.size.width, sliceImage.size.height);
        layer.contents = (__bridge id)(sliceImage.CGImage);
        layer.contentsScale = scale;
        //! layer.contentsGravity = kCAGravityResize; <- 디폴트.
        [slices addObject:layer];        
    }
    
    return slices;
}

//! startPosition에 위치했을 때(조각 모음이 이루는 전체 모양의 첫 번째 조각 레이어)의 그 순간 모든 조각 레이어들의 transform을 모아놓은 배열.
- (NSArray <NSValue *>*)transformationsForSlices:(NSArray <CALayer *>*)slices
                                            edge:(GenieRectEdge) edge
                                   startPosition:(CGFloat)startPosition
                                       totalSize:(CGFloat)totalSize
                                     firstBezier:(GenieCurveSegment)firstCurveSegment
                                    secondBezier:(GenieCurveSegment)secondCurveSegment
                                  finalRectDepth:(CGFloat)rectDepth {
    
    NSMutableArray <NSValue *>*transformations = [NSMutableArray arrayWithCapacity:[slices count]];
    GenieAxis axis = axisForEdge(edge);

    CGFloat rectPartStart = 0.0f;
    if (axis == GenieAxisX) {
        rectPartStart = firstCurveSegment.bPoint.x;
    } else { //
        rectPartStart = firstCurveSegment.bPoint.y;
    }
    
    CGFloat sign = isEdgeNegative(edge) ? -1.0 : 1.0;
    __block CGFloat position = startPosition;
    __block GenieTrapezoidVertices trapezoid = {CGPointZero, CGPointZero, CGPointZero, CGPointZero};
    
    //! slide 애니메이션을 위한 베지어패스의를 타고 내려오는 start position.
    CGPoint p1 = bezierAxisIntersection(firstCurveSegment, axis, position);
    CGPoint p2 = bezierAxisIntersection(secondCurveSegment, axis, position);
    
    if (edge == GenieRectEdgeTop) {
        trapezoid.aPoint = p1;
        trapezoid.bPoint = p2;
    } else if (edge == GenieRectEdgeLeft) {
        trapezoid.cPoint = p1;
        trapezoid.aPoint = p2;
    } else if (edge == GenieRectEdgeBottom) {
        trapezoid.dPoint = p1;
        trapezoid.cPoint = p2;
    } else if (edge == GenieRectEdgeRight) {
        trapezoid.bPoint = p1;
        trapezoid.dPoint = p2;
    }

    NSEnumerationOptions enumerationOptions = isEdgeNegative(edge) ? NSEnumerationReverse : 0;

    [slices enumerateObjectsWithOptions:enumerationOptions usingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
    
        CGFloat size = isEdgeVertical(edge) ? layer.bounds.size.height : layer.bounds.size.width;
        //! 어쨌건 움직이므로 slices들의 원점(위치)들에는 관심이 없다. 한조각임.
        //! 현재 위치를 가지고 변해야할 transform을 던져주므로 맞게 변하게된다.
        //! 마지막에 position이 갱신된다.
        CGFloat endPosition = position + sign * size;
        
         //! 음수 및 0일 때가 일반적 범위에 놓인다. 양수이면 rect범위 여기를 넘는 조각은 overflow 영역에서 처리한다.
        double overflow = sign * (endPosition - rectPartStart);
        
        if (overflow <= 0.0f) { //! slice is still in bezier part
            CGPoint p1 = bezierAxisIntersection(firstCurveSegment, axis, endPosition);
            CGPoint p2 = bezierAxisIntersection(secondCurveSegment, axis, endPosition);
            
            if (edge == GenieRectEdgeTop) {
                trapezoid.cPoint = p1;
                trapezoid.dPoint = p2;
            } else if (edge == GenieRectEdgeLeft) {
                trapezoid.dPoint = p1;
                trapezoid.bPoint = p2;
            } else if (edge == GenieRectEdgeBottom) {
                trapezoid.bPoint = p1;
                trapezoid.aPoint = p2;
            } else if (edge == GenieRectEdgeRight) {
                trapezoid.aPoint = p1;
                trapezoid.cPoint = p2;
            }
            
        } else { // final rect part
             // how deep inside final rect "bottom" part of slice is
            CGFloat shrunkSliceDepth = overflow*rectDepth/(double)totalSize;
            
            if (edge == GenieRectEdgeTop) {
                trapezoid.cPoint = firstCurveSegment.bPoint; //! 끝점이다. firstCurveSegment는 도착했다.
                if (axis == GenieAxisX) {
                    trapezoid.cPoint.x = trapezoid.cPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.cPoint.y = trapezoid.cPoint.y + (sign * shrunkSliceDepth);
                }
                
                trapezoid.dPoint = secondCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.dPoint.x = trapezoid.dPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.dPoint.y = trapezoid.dPoint.y + (sign * shrunkSliceDepth);
                }
                
            } else if (edge == GenieRectEdgeLeft) {
                trapezoid.dPoint = firstCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.dPoint.x = trapezoid.dPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.dPoint.y = trapezoid.dPoint.y + (sign * shrunkSliceDepth);
                }
                
                trapezoid.bPoint = secondCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.bPoint.x = trapezoid.bPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.bPoint.y = trapezoid.bPoint.y + (sign * shrunkSliceDepth);
                }
                
            } else if (edge == GenieRectEdgeBottom) {
                trapezoid.bPoint = firstCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.bPoint.x = trapezoid.bPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.bPoint.y = trapezoid.bPoint.y + (sign * shrunkSliceDepth);
                }
                
                trapezoid.aPoint = secondCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.aPoint.x = trapezoid.aPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.aPoint.y = trapezoid.aPoint.y + (sign * shrunkSliceDepth);
                }
                
            } else if (edge == GenieRectEdgeRight) {
                trapezoid.aPoint = firstCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.aPoint.x = trapezoid.aPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.aPoint.y = trapezoid.aPoint.y + (sign * shrunkSliceDepth);
                }
                
                trapezoid.cPoint = secondCurveSegment.bPoint;
                if (axis == GenieAxisX) {
                    trapezoid.cPoint.x = trapezoid.cPoint.x + (sign * shrunkSliceDepth);
                } else {
                    trapezoid.cPoint.y = trapezoid.cPoint.y + (sign * shrunkSliceDepth);
                }
            }
        }
        
        CATransform3D transform = [self transformRect:layer.bounds toTrapezoid:trapezoid];
        [transformations addObject:[NSValue valueWithCATransform3D:transform]];
    
        if (edge == GenieRectEdgeTop) {
            trapezoid.aPoint = trapezoid.cPoint;
            trapezoid.bPoint = trapezoid.dPoint;
        } else if (edge == GenieRectEdgeLeft) {
            trapezoid.cPoint = trapezoid.dPoint;
            trapezoid.aPoint = trapezoid.bPoint;
        } else if (edge == GenieRectEdgeBottom) {
            trapezoid.dPoint = trapezoid.bPoint;
            trapezoid.cPoint = trapezoid.aPoint;
        } else if (edge == GenieRectEdgeRight) {
            trapezoid.bPoint = trapezoid.aPoint;
            trapezoid.dPoint = trapezoid.cPoint;
        }
        //! position이 갱신되어 다음 idx position에 영향을 준다.
        position = endPosition;
    }];

    if (isEdgeNegative(edge) == YES) {
        return [[transformations reverseObjectEnumerator] allObjects];
    }

    return transformations;
}

// 직사각형을 일반 사각형(평행사변형과 같은, 평행사변형보다 더 불규칙적인 사각형도 가능하다.)으로 만드는 알고리즘.
// based on http://stackoverflow.com/a/12820877/558816
// X와 Y는 항상 0으로 가정되므로 계산에서 제외된다. 이를 위해서 anchorPoint를 zero로 만들었다.
// transform matrix의 사소한 오류조차도 큰 결함을 일으킬 수 있기 때문에 정확한 계산을 위해 모든 계산은 CGFloat을 사용한다.
- (CATransform3D)transformRect:(CGRect)rect toTrapezoid:(GenieTrapezoidVertices)trapezoid {

    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    CGFloat x1a = trapezoid.aPoint.x;
    CGFloat y1a = trapezoid.aPoint.y;
    
    CGFloat x2a = trapezoid.bPoint.x;
    CGFloat y2a = trapezoid.bPoint.y;
    
    CGFloat x3a = trapezoid.cPoint.x;
    CGFloat y3a = trapezoid.cPoint.y;
    
    CGFloat x4a = trapezoid.dPoint.x;
    CGFloat y4a = trapezoid.dPoint.y;
    
    CGFloat y21 = y2a - y1a,
    y32 = y3a - y2a,
    y43 = y4a - y3a,
    y14 = y1a - y4a,
    y31 = y3a - y1a,
    y42 = y4a - y2a;
    
    CGFloat a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    CGFloat b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    CGFloat c = - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43);
    
    CGFloat d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    CGFloat e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    CGFloat f = -(W*(x4a*(H*y1a*y32) - x3a*(H)*y1a*y42 + H*x2a*y1a*y43));
    
    CGFloat g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    CGFloat h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    CGFloat i = H*(W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    const CGFloat kEpsilon = 0.0001;
    
    if(fabs(i) < kEpsilon) {
        i = kEpsilon* (i > 0 ? 1.0 : -1.0);
    }
    
    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};
    
    return transform;
}


#pragma mark - C convinience functions
//! 움직일 때 fix된 두 개의 점
static GenieLineSegment bezierEndPointsForTransition(GenieRectEdge edge, CGRect endRect) {
    switch (edge) {
        case GenieRectEdgeTop:
            return GenieLineSegmentMake(CGPointMake(CGRectGetMinX(endRect), CGRectGetMinY(endRect)),
                                        CGPointMake(CGRectGetMaxX(endRect), CGRectGetMinY(endRect)));
        case GenieRectEdgeBottom:
            return GenieLineSegmentMake(CGPointMake(CGRectGetMaxX(endRect), CGRectGetMaxY(endRect)),
                                        CGPointMake(CGRectGetMinX(endRect), CGRectGetMaxY(endRect)));
        case GenieRectEdgeRight:
            return GenieLineSegmentMake(CGPointMake(CGRectGetMaxX(endRect), CGRectGetMinY(endRect)),
                                        CGPointMake(CGRectGetMaxX(endRect), CGRectGetMaxY(endRect)));
        case GenieRectEdgeLeft:
            return GenieLineSegmentMake(CGPointMake(CGRectGetMinX(endRect), CGRectGetMaxY(endRect)),
                                        CGPointMake(CGRectGetMinX(endRect), CGRectGetMinY(endRect)));
    }
    
    NSCAssert(false, @"should never happen");
}

static inline CGFloat progressOfSegmentWithinTotalProgress(CGFloat a, CGFloat b, CGFloat t) {
    return MIN(MAX(0.0, (t - a)/(b - a)), 1.0);
}

//! Newton-Raphson 방식을 이용한 베지어 패스와 직선과의 교점을 구한다.
static CGPoint bezierAxisIntersection(GenieCurveSegment curve, GenieAxis axis, CGFloat axisPos) {
    CGPoint controlPoint1, controlPoint2;
    if (axis == GenieAxisX) {
        controlPoint1 = CGPointMake((curve.aPoint.x + curve.bPoint.x) / 2.0, curve.aPoint.y);
        controlPoint2 = CGPointMake((curve.aPoint.x + curve.bPoint.x) / 2.0, curve.bPoint.y);
    } else {
        controlPoint1 = CGPointMake(curve.aPoint.x, (curve.aPoint.y + curve.bPoint.y) / 2.0);
        controlPoint2 = CGPointMake(curve.bPoint.x, (curve.aPoint.y + curve.bPoint.y) / 2.0);
    }
//! 아래 주석으로도 충분하다. Newton-Raphson 방식도 이용해보기 위해서 Newton-Raphson을 써봤다.
//! 방법론적으로 주석의 처리방식이 모든 면에서 우월하다.
//    double time[3];
//    if (axis != GenieAxisX) {
//        MGRCubicBezierEquation(curve.aPoint.y, controlPoint1.y, controlPoint2.y, curve.bPoint.y, axisPos, time);
//        time[0] = MAX(MIN(time[0], 1.0), 0.0);
//        double xPos = MGRCubicBezierFun(curve.aPoint.x, controlPoint1.x, controlPoint2.x, curve.bPoint.x, time[0]);
//        return CGPointMake(xPos, axisPos);
//    } else {
//        MGRCubicBezierEquation(curve.aPoint.x, controlPoint1.x, controlPoint2.x, curve.bPoint.x, axisPos, time);
//        time[0] = MAX(MIN(time[0], 1.0), 0.0);
//        double yPos = MGRCubicBezierFun(curve.aPoint.y, controlPoint1.y, controlPoint2.y, curve.bPoint.y, time[0]);
//        return CGPointMake(axisPos, yPos);
//    }

    //! 첫 번째 근사치 - 곡선을 선분처럼 취급해서 Newton-Raphson 방법(도함수 이용)을 적용하기 위한 초기 근삿값을 잡는다.
    //! Screen Shot을 참고하자.
    //! 카르다노 방정식(3차 방정식의 일반해 구하기)은 너무 길다.
    double t = 0.0;
    if (axis == GenieAxisX) {
        t = (axisPos - curve.aPoint.x) / (curve.bPoint.x - curve.aPoint.x);
    } else {
        t = (axisPos - curve.aPoint.y) / (curve.bPoint.y - curve.aPoint.y);
    }
    
    const int kIterations = 3; // 3번만 반복하자.
    for (int i = 0; i < kIterations; i++) {
        double nt = 1.0 - t;
        double f = 0.0;
        if (axis == GenieAxisX) {
            f = nt*nt*nt*curve.aPoint.x + 3.0*nt*nt*t*controlPoint1.x + 3.0*nt*t*t*controlPoint2.x + t*t*t*curve.bPoint.x - axisPos;
        } else {
            f = nt*nt*nt*curve.aPoint.y + 3.0*nt*nt*t*controlPoint1.y + 3.0*nt*t*t*controlPoint2.y + t*t*t*curve.bPoint.y - axisPos;
        }
        
        double df = 0.0f;
        if (axis == GenieAxisX) {
            df = -3.0*(curve.aPoint.x*nt*nt + controlPoint1.x*(-3.0*t*t + 4.0*t - 1.0) + t*(3.0*controlPoint2.x*t - 2.0*controlPoint2.x - curve.bPoint.x*t));
        } else {
            df = -3.0*(curve.aPoint.y*nt*nt + controlPoint1.y*(-3.0*t*t + 4.0*t - 1.0) + t*(3.0*controlPoint2.y*t - 2.0*controlPoint2.y - curve.bPoint.y*t));
        }

        t = t - (f / df);
    }
    
    //! 뉴튼 랩손 방식은 미세한 오차가 발생할 수 있다. 카르다노 방식은 정확하지만, 컴퓨터 floating 오차는 역시 피할 수 없다.
    t = MIN(MAX(t, 0.0), 1.0);
    if (ABS(t - 1.0) <= DBL_EPSILON) {
        t = 1.0f;
    } else if (ABS(t - 0.0) <= DBL_EPSILON) {
        t = 0.0f;
    }
    
    double nt = 1.0 - t;
    double intersection;
    if (axis == GenieAxisX) {
        intersection = nt*nt*nt*curve.aPoint.y + 3.0*nt*nt*t*controlPoint1.y + 3.0*nt*t*t*controlPoint2.y + t*t*t*curve.bPoint.y;
    } else {
        intersection = nt*nt*nt*curve.aPoint.x + 3.0*nt*nt*t*controlPoint1.x + 3.0*nt*t*t*controlPoint2.x + t*t*t*curve.bPoint.x;
    }
        
    if (axis == GenieAxisX) {
        return CGPointMake(axisPos, intersection);
    } else {
        return CGPointMake(intersection, axisPos);
    }
}

static inline NSString * edgeDescription(GenieRectEdge edge) {
    if (edge == GenieRectEdgeTop) {
        return @"top";
    } else if (edge == GenieRectEdgeBottom) {
        return @"bottom";
    } else if (edge == GenieRectEdgeRight) {
        return @"right";
    } else { // BCRectEdgeLeft
        return @"left";
    }
}

@end


//! bezierAxisIntersection 함수에서 제외시킴. 발생을 안함.
//if (axis == GenieAxisX) {
//    NSCAssert((axisPos >= curve.aPoint.x && axisPos <= curve.bPoint.x) || (axisPos >= curve.bPoint.x && axisPos <= curve.aPoint.x), @"거짓이다.");
//} else {
//    NSCAssert((axisPos >= curve.aPoint.y && axisPos <= curve.bPoint.y) || (axisPos >= curve.bPoint.y && axisPos <= curve.aPoint.y), @"거짓이다.");
//}

//static const int GenieTrapezoidWinding[4][4] = {
//    [GenieRectEdgeTop]    = {0,1,2,3},
//    [GenieRectEdgeLeft]   = {2,0,3,1},
//    [GenieRectEdgeBottom] = {3,2,1,0},
//    [GenieRectEdgeRight]  = {1,3,0,2},
//};
