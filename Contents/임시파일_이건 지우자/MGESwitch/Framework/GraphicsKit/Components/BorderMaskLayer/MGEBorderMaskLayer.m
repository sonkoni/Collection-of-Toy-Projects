//
//  MGEBorderMaskLayer.m
//
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGEBorderMaskLayer.h"

@interface MGEBorderMaskLayer ()
@property (nonatomic, assign) CGFloat radius; // Animatable. cornerRadius를 대신하는 프라퍼티이다. 애니메이션을 먹이려면 어쩔 수 없다.
@property (nonatomic, assign) CGFloat width;  // Animatable. borderWidth를 대신하는 프라퍼티이다. 애니메이션을 먹이려면 어쩔 수 없다.
@end

@implementation MGEBorderMaskLayer
@dynamic cornerRadius; // radius 를 대신 사용할 것이다.
@dynamic borderWidth; // width 를 대신 사용할 것이다.
@dynamic radius;
@dynamic width;
@dynamic borderInset;
@dynamic borderColor;

// 어떤 속성이 애니메이션화 가능한지 정의
// 초기화될때. 자신의 모든 프라퍼티를 여기에 넣어서 자동으로 검사한다.
// key는 자신의 모든 프라퍼티가 검사된다. 사용유무와 관계없다.
// [CABasicAnimation animationWithKeyPath:@"U"]; 이렇게 조정하고 싶은 키가 있다면,
// 반드시 needsDisplayForKey:가 YES여야한다. 기존에 없는 속성을 사용하려면, 이러한 다듬음이 필요하다.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"radius"] ||
        [key isEqualToString:@"width"] ||
        [key isEqualToString:@"borderInset"]) {
        return YES;
    }
    
    if ([key isEqualToString:@"borderWidth"] ||
        [key isEqualToString:@"cornerRadius"] || // 이건 지워도 될듯.
        [key isEqualToString:@"frame"]) {
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
        if ([layer isKindOfClass:[MGEBorderMaskLayer class]]) {
            MGEBorderMaskLayer *maskLayer = (MGEBorderMaskLayer *)layer;
            self.contentsScale = MGE_MAINSCREEN_SCALE;
            self.needsDisplayOnBoundsChange = YES;
            self.borderInset = maskLayer.borderInset;
            self.radius = maskLayer.radius;
            self.width = maskLayer.width;
        }
        
        if ([layer isKindOfClass:[CALayer class]]) {
            self.cornerRadius = ((CALayer *)layer).cornerRadius;
            self.borderWidth = ((CALayer *)layer).borderWidth;
            self.frame = ((CALayer *)layer).frame;
            self.maskedCorners = ((CALayer *)layer).maskedCorners;
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
    if ([event isEqualToString:@"radius"] ||
        [event isEqualToString:@"width"] ||
        [event isEqualToString:@"borderInset"]) {

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        if (self.presentationLayer != nil) {
            animation.fromValue = [self.presentationLayer valueForKey:event];
        }
        return animation;
    }

    return [super actionForKey:event];
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
    CAPropertyAnimation *animation = (CAPropertyAnimation *)anim;
    if ([animation isKindOfClass:[CAPropertyAnimation class]] == YES &&
        [animation.keyPath isEqualToString:@"cornerRadius"] == YES) {
        animation.keyPath = @"radius";
        [self addAnimation:animation forKey:key];
    } else if ([animation isKindOfClass:[CAPropertyAnimation class]] == YES &&
               [animation.keyPath isEqualToString:@"borderWidth"] == YES) {
        animation.keyPath = @"width";
        [self addAnimation:animation forKey:key];
    } else {
        [super addAnimation:anim forKey:key];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    CGFloat radius = MAX(0.0, self.radius);
    CGFloat firstRadius = MAX(0.0, radius - self.borderInset);
    CGFloat secondRadius = MAX(0.0, radius - self.width);
    CGRect firstRect = CGRectInset(self.bounds, self.borderInset, self.borderInset);
    CGRect secondRect = CGRectInset(self.bounds, self.width, self.width);
    if (secondRect.size.width < 0.0 || secondRect.size.height < 0.0) {
        secondRect = CGRectMake(secondRect.origin.x, secondRect.origin.y, 0.0, 0.0);
    }
    
    CGPathRef path1 = CGPathCreateWithRoundedRect(firstRect, firstRadius, firstRadius, NULL);
    CGPathRef path2 = CGPathCreateWithRoundedRect(secondRect, secondRadius, secondRadius, NULL);
    CGMutablePathRef path = CGPathCreateMutableCopy(path1);
    CGPathAddPath(path, NULL, path2);

    CGContextSaveGState(ctx); // <- Save
    {
        CGContextSetLineWidth(ctx, 0.0);
        CGContextSetFillColorWithColor(ctx, MGEColor.blackColor.CGColor);
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, path);
        CGContextEOFillPath(ctx); // CGContextFillPath(ctx); 차집합인듯. Even - Odd
        
        CGPathRelease(path);
        CGPathRelease(path2);
        CGPathRelease(path1);
    }
    CGContextRestoreGState(ctx);  // <- Restore
}


#pragma mark - 생성 & 소멸
- (void)_commonInit {
    self.needsDisplayOnBoundsChange = YES;
    self.cornerRadius = 0.0;
    self.borderWidth = 0.0;
    [super setBorderColor:MGEColor.clearColor.CGColor];
    self.radius = 0.0;
    self.width = 0.0;
    self.borderInset = 0.0;
//    self.opaque = NO; // Important, otherwise you will get a black rectangle
}


#pragma mark - 세터 & 게터
- (CGFloat)cornerRadius {
    return self.radius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self setRadius:cornerRadius];
    [self setNeedsDisplay];
}

- (CGFloat)borderWidth {
    return self.width;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self setWidth:borderWidth];
    [self setNeedsDisplay];
}

@end

