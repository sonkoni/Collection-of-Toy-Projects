//
//  MGECircularSectorMaskLayer.m
//
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGECircularSectorMaskLayer.h"

@interface MGECircularSectorMaskLayer ()
@end

@implementation MGECircularSectorMaskLayer
@dynamic startRadian;
@dynamic endRadian;
@dynamic rectForOutOval;
@dynamic rectForInOval;
@dynamic borderColor; // 이것을 사용하지 못하게한다.


// 어떤 속성이 애니메이션화 가능한지 정의
// 초기화될때. 자신의 모든 프라퍼티를 여기에 넣어서 자동으로 검사한다.
// key는 자신의 모든 프라퍼티가 검사된다. 사용유무와 관계없다.
// [CABasicAnimation animationWithKeyPath:@"U"]; 이렇게 조정하고 싶은 키가 있다면,
// 반드시 needsDisplayForKey:가 YES여야한다. 기존에 없는 속성을 사용하려면, 이러한 다듬음이 필요하다.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"startRadian"] ||
        [key isEqualToString:@"endRadian"] ||
        [key isEqualToString:@"rectForOutOval"] ||
        [key isEqualToString:@"rectForInOval"] ||
        [key isEqualToString:@"clockWise"] ||
        [key isEqualToString:@"axisDirection"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

// 최초에 들어온다.
- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        [self _commonInit];
    }
    return self;
}

// 프리젠테이션 레이어를 생성하는데 이용된다.
// 프리젠테이션 레이어란, 현재 애니메이션 진행 중일때, 화면상에 나타나는 자신의 솔직한 값을 알려준다.
// 애니메이션이 작동하면 들어온다.
- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[MGECircularSectorMaskLayer class]]) {
            MGECircularSectorMaskLayer *maskLayer = (MGECircularSectorMaskLayer *)layer;
            self.contentsScale = MGE_MAINSCREEN_SCALE;
            self.needsDisplayOnBoundsChange = YES;
            self.startRadian = maskLayer.startRadian;
            self.endRadian = maskLayer.endRadian;
            self.rectForOutOval = maskLayer.rectForOutOval;
            self.rectForInOval = maskLayer.rectForInOval;
            self.clockWise = maskLayer.clockWise;
            self.axisDirection = maskLayer.axisDirection;
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // self.needsDisplayOnBoundsChange = YES; 이거랑 같은 효과를 내기 위해.
}

//! 암묵적 애니메이션을 발생시켜준다.
- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"startRadian"] ||
        [event isEqualToString:@"endRadian"] ||
        [event isEqualToString:@"rectForOutOval"] ||
        [event isEqualToString:@"rectForInOval"]) {

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        if (self.presentationLayer != nil) {
            animation.fromValue = [self.presentationLayer valueForKey:event];
        }
        return animation;
    }

    return [super actionForKey:event];
}

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    // 원하는 클립 패스를 그리고 패스를 컨텍스트에 더한 후, CGContextClip을 하면 잘린다. 이후 부터는 잘린 면에서 노는 것이다.
    // 우선 도넛 모양으로 자른다.
    CGMutablePathRef clipPath = CGPathCreateMutable();
    {
        CGPathAddEllipseInRect(clipPath, NULL, self.rectForOutOval);
        CGPathAddEllipseInRect(clipPath, NULL, self.rectForInOval);
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, clipPath);
        CGContextClosePath(ctx);
        CGContextEOClip(ctx);
    }
    CGPathRelease(clipPath);
    
    CGContextSaveGState(ctx); // <- Save
    {
        CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        CGFloat length =  MAX(self.bounds.size.width, self.bounds.size.height) * 2.0; // radius로 사용하자.
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat startRadian = [self reviseRadian:self.startRadian];
        CGFloat endRadian = [self reviseRadian:self.endRadian];
        CGPathAddArc(path,
                     NULL,
                     center.x,
                     center.y,
                     length,
                     startRadian,
                     endRadian,
                     !self.clockWise);
        CGPathAddLineToPoint(path, NULL, center.x, center.y);
        CGPathCloseSubpath(path);
        
        CGContextSetLineWidth(ctx, 0.0);
        CGContextSetFillColorWithColor(ctx, MGEColor.blackColor.CGColor);
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, path);
        CGContextFillPath(ctx);
        CGPathRelease(path);
    }
    CGContextRestoreGState(ctx);  // <- Restore
}


#pragma mark - 생성 & 소멸
- (void)_commonInit {
    self.needsDisplayOnBoundsChange = YES;
    self.cornerRadius = 0.0;
    self.borderWidth = 0.0;
    [super setBorderColor:MGEColor.clearColor.CGColor];
    self.startRadian = 0.0;
    self.endRadian = M_PI * 2.0;
    self.rectForOutOval = self.bounds;
    self.rectForInOval = CGRectZero;
    _clockWise = YES;
    _axisDirection = MGRCircularSectorMaskAxisDirectionEast;
    //    self.opaque = NO; // Important, otherwise you will get a black rectangle
}


#pragma mark - Private Helpr
- (CGFloat)reviseRadian:(CGFloat)original {
    if (self.axisDirection == MGRCircularSectorMaskAxisDirectionNorthInverse) {
        if (original == 0.0) {
            return -M_PI_2;
        } else if (original == M_PI * 2.0) {
            return -M_PI_2 - (M_PI * 2.0);
        } else {
            return -M_PI_2 - original;
        }
    } else if (self.axisDirection == MGRCircularSectorMaskAxisDirectionNorth) {
        if (original == 0.0) {
            return -M_PI_2;
        } else if (original == M_PI * 2.0) {
            return -M_PI_2 + (M_PI * 2.0);
        } else {
            return -M_PI_2 + original;
        }
    } else if (self.axisDirection == MGRCircularSectorMaskAxisDirectionWestInverse) {
        if (original == 0.0) {
            return M_PI;
        } else if (original == M_PI * 2.0) {
            return M_PI - (M_PI * 2.0);
        } else {
            return M_PI - original;
        }
    } else if (self.axisDirection == MGRCircularSectorMaskAxisDirectionWest) {
        if (original == 0.0) {
            return M_PI;
        } else if (original == M_PI * 2.0) {
            return M_PI + (M_PI * 2.0);
        } else {
            return M_PI + original;
        }
    } else if (self.axisDirection == MGRCircularSectorMaskAxisDirectionSouthInverse) {
        if (original == 0.0) {
            return M_PI_2;
        } else if (original == M_PI * 2.0) {
            return M_PI_2 - (M_PI * 2.0);
        } else {
            return M_PI_2 - original;
        }
    } else if (self.axisDirection == MGRCircularSectorMaskAxisDirectionSouth) {
        if (original == 0.0) {
            return M_PI_2;
        } else if (original == M_PI * 2.0) {
            return M_PI_2 + (M_PI * 2.0);
        } else {
            return M_PI_2 + original;
        }
    } else {
        return original;
    }
}


@end
