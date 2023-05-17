//
//  MGEInvertStrokeMaskLayer.m
//
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGEInvertStrokeMaskLayer.h"

@interface MGEInvertStrokeMaskLayer ()
@end

@implementation MGEInvertStrokeMaskLayer
@dynamic path;
@dynamic fillColor;
@dynamic strokeColor;
@dynamic lineWidth;

// 어떤 속성이 애니메이션화 가능한지 정의
// 초기화될때. 자신의 모든 프라퍼티를 여기에 넣어서 자동으로 검사한다.
// key는 자신의 모든 프라퍼티가 검사된다. 사용유무와 관계없다.
// [CABasicAnimation animationWithKeyPath:@"U"]; 이렇게 조정하고 싶은 키가 있다면,
// 반드시 needsDisplayForKey:가 YES여야한다. 기존에 없는 속성을 사용하려면, 이러한 다듬음이 필요하다.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"path"] ||
        [key isEqualToString:@"fillColor"] ||
        [key isEqualToString:@"strokeColor"] ||
        [key isEqualToString:@"lineWidth"]) {
        return YES;
    }

    return [super needsDisplayForKey:key];
}


+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:@"lineWidth"] == YES) {
        return @(1.0);
    } else {
        return [super defaultValueForKey:key];
    }
}

// 최초에 들어온다.
- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        CommonInit(self);
    }
    return self;
}

// 프리젠테이션 레이어를 생성하는데 이용된다.
// 프리젠테이션 레이어란, 현재 애니메이션 진행 중일때, 화면상에 나타나는 자신의 솔직한 값을 알려준다.
// 애니메이션이 작동하면 들어온다.
- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[MGEInvertStrokeMaskLayer class]]) {
            MGEInvertStrokeMaskLayer *maskLayer = (MGEInvertStrokeMaskLayer *)layer;
            self.contentsScale = MGE_MAINSCREEN_SCALE;
            self.needsDisplayOnBoundsChange = YES;
            self.path = maskLayer.path;
            self.fillColor = maskLayer.fillColor;
            self.strokeColor = maskLayer.strokeColor;
            self.lineWidth = maskLayer.lineWidth;
            self.lineJoin = maskLayer.lineJoin;
            self.lineCap = maskLayer.lineCap;
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // self.needsDisplayOnBoundsChange = YES; 이거랑 같은 효과를 내기 위해.
}

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    CGContextSetGrayFillColor(ctx, 0.0, 1.0);
    CGContextFillRect(ctx, self.bounds);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
    if(self.strokeColor != NULL) {
        CGContextSetStrokeColorWithColor(ctx, self.strokeColor);
    }
    if(self.fillColor != NULL) {
        CGContextSetFillColorWithColor(ctx, self.fillColor);
    }
    CGContextSetLineCap(ctx, self.lineCap);
    CGContextSetLineJoin(ctx, self.lineJoin);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddPath(ctx, self.path);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGEInvertStrokeMaskLayer *self) {
    self.strokeColor = [MGEColor clearColor].CGColor;
    self.fillColor = [MGEColor orangeColor].CGColor;
    self.lineCap = kCGLineCapRound;
    self.lineJoin = kCGLineJoinRound;
    self.opaque = NO; // Important, otherwise you will get a black rectangle
}

#pragma mark - 세터 & 게터
- (void)setLineCap:(CGLineCap)lineCap {
    if (_lineCap != lineCap) {
        _lineCap = lineCap;
        [self setNeedsDisplay];
    }
}

- (void)setLineJoin:(CGLineJoin)lineJoin {
    if (_lineJoin != lineJoin) {
        _lineJoin = lineJoin;
        [self setNeedsDisplay];
    }
}

@end
