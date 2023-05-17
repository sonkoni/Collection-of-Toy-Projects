//
//  MGEInnerShadowLayer.m
//
//  Created by Kwan Hyun Son on 2020/11/25.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGEInnerShadowLayer.h"

@implementation MGEInnerShadowLayer
@dynamic innerShadowColor;
@dynamic innerShadowOffset;
@dynamic innerShadowBlurRadius;
@dynamic path;

- (instancetype)init {
    self = [super init];
    if (self) {
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
        CommonInit(self);
        if ([layer isKindOfClass:[MGEInnerShadowLayer class]]) {
            MGEInnerShadowLayer *innerShadowLayer = (MGEInnerShadowLayer *)layer;
            self.innerShadowColor = innerShadowLayer.innerShadowColor;
            self.innerShadowOffset = innerShadowLayer.innerShadowOffset;
            self.innerShadowBlurRadius = innerShadowLayer.innerShadowBlurRadius;
            self.path = innerShadowLayer.path;
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
    CGPathRef withPath = NULL;
    if (self.path == NULL) {
        withPath = CGPathCreateWithRoundedRect(self.bounds, self.cornerRadius, self.cornerRadius, NULL);
    } else {
        withPath = CGPathCreateCopy(self.path);
    }
    
    [self drawInnerShadowInContext:ctx
                          withPath:withPath
                       shadowColor:self.innerShadowColor
                            offset:self.innerShadowOffset
                        blurRadius:self.innerShadowBlurRadius];
    CGPathRelease(withPath);
}

// 어떤 속성이 애니메이션화 가능한지 정의
// 초기화될때. 자신의 모든 프라퍼티를 여기에 넣어서 자동으로 검사한다.
// key는 자신의 모든 프라퍼티가 검사된다. 사용유무와 관계없다.
// [CABasicAnimation animationWithKeyPath:@"U"]; 이렇게 조정하고 싶은 키가 있다면,
// 반드시 needsDisplayForKey:가 YES여야한다. 기존에 없는 속성을 사용하려면, 이러한 다듬음이 필요하다.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"innerShadowColor"] ||
        [key isEqualToString:@"innerShadowOffset"] ||
        [key isEqualToString:@"innerShadowBlurRadius"] ||
        [key isEqualToString:@"path"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithInnerShadowColor:(CGColorRef)innerShadowColor
                       innerShadowOffset:(CGSize)innerShadowOffset
                   innerShadowBlurRadius:(CGFloat)innerShadowBlurRadius {
    self = [self init];
    if (self) {
        self.innerShadowColor = innerShadowColor;
        self.innerShadowOffset = innerShadowOffset;
        self.innerShadowBlurRadius = innerShadowBlurRadius;
    }
    return self;
}

static void CommonInit(MGEInnerShadowLayer *self) {
    //! 아래 세개는 그래픽 퀄리티 올리는 코드이다.
    self.contentsScale = MGE_MAINSCREEN_SCALE;
    self.rasterizationScale = MGE_MAINSCREEN_SCALE;
    self.shouldRasterize = YES;
#if TARGET_OS_IPHONE
    self.innerShadowColor = UIColor.blueColor.CGColor;
#else
    self.innerShadowColor = NSColor.blueColor.CGColor;
#endif
    self.innerShadowOffset = CGSizeMake(3.0, 3.0);
    self.innerShadowBlurRadius = 3.0;
    self.path = NULL;
}


#pragma mark - Private
- (void)drawInnerShadowInContext:(CGContextRef)context
                        withPath:(CGPathRef)path
                     shadowColor:(CGColorRef)shadowColor
                          offset:(CGSize)offset
                      blurRadius:(CGFloat)blurRadius {
    //! 시작
    CGContextSaveGState(context);
    
    CGContextAddPath(context, path); // 구역 제한 설정을 위한 path 추가.
    CGContextClip(context);          // 구역 제한 설정.
        
    CGColorRef opaqueShadowColor = CGColorCreateCopyWithAlpha(shadowColor, 1.0); // 알파를 제외한 쌩칼라 추출.
    
    CGContextSetAlpha(context, CGColorGetAlpha(shadowColor)); // 컨텍스트에 알파값 설정
    
    // 불투명한 backgrounds에서 사용하려면 전체 메소드를
    // CGContextBeginTransparencyLayer 및 CGContextEndTransparencyLayer 함수로 래핑해야한다.
    // 즉, 일시적으로 배경을 투명하게 만든 공간으로 변화시켜야한다.
    // 이러한 함수를 이용하여 싸버리면 정상적으로 합성되기 전에 임시 투명 공간에서 드로잉이 수행된다.
    // 이렇게하지 않으면, 우리가 그리는 background가 투명하지 않을 경우 알파 반전(inversion) 트릭이 작동하지 않는다.
    // 즉, 트릭을 사용하려면 일시적으로 background를 투명하게 만들어서 드로잉해야한다.
    CGContextBeginTransparencyLayer(context, NULL);
    {
        //! CGContextSetShadowWithColor 에서 색은 마스크로 쓰이므로 alpha 1.0 에 해당하는 아무 칼라나 가능하다.
        //! 이 칼라가 아닌 부분을 그림자로 쓸 것이고, CGContextSetShadowWithColor의 색은 최종적으로는 이 layer의 bounds
        //! 밖에 존재하여 보이지 않을 것이다.
        //! 그림자가 아닌 부분을 그림자로 그린 후, kCGBlendModeSourceOut로 반전하여 반전된 alpha를 갖는 그림자 영역을 얻는다.
        CGContextSetShadowWithColor(context, offset, blurRadius, opaqueShadowColor); // 색은 마스크.
        // 반전시켜서 윗줄에서 그려진 그림자의 외부 영역을 마스크로 만든다.
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        // 보여질 그림자의 색은 여기에서 결정된다. 즉, CGContextSetShadowWithColor에서 바깥 영역을 마스크로 하여 그림자로 쓴다.
        CGContextSetFillColorWithColor(context, opaqueShadowColor); // fill color를 그림자로 사용하겠다.
        
        /** 테스트 코드.
        CGAffineTransform testTransform = CGAffineTransformMakeScale(0.6, 0.6);
        path = CGPathCreateCopyByTransformingPath(path, &testTransform);
        */
        CGContextAddPath(context, path); // 영역을 설정한다. 위에서 set했던 모든 것은 이제부터 작동한다.
        CGContextFillPath(context); // 모든 색은 여기에서 채워진다. 설정한 영역에 색을 채운다.
    }
    CGContextEndTransparencyLayer(context);
    
    //! 끝
    CGContextRestoreGState(context);
    //! 마지막 정리 - 메모리 해제.
    CGColorRelease(opaqueShadowColor);
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(FALSE, @"- initWithCoder: 사용금지.");
    return nil;
}

@end

//! 돌아가는 원리가 궁금하다면
//! CGContextSetShadowWithColor(context, offset, blurRadius, opaqueShadowColor); 의
//! opaqueShadowColor 색을 red 설정하고,
//! CGContextSetFillColorWithColor(context, opaqueShadowColor); 의 opaqueShadowColor색을
//! blue로 설정하고 아래의 테스트 코드를 풀어주면 확인할 수 있다.
/** 테스트 코드. <- 이 주석을 풀어라.
CGAffineTransform testTransform = CGAffineTransformMakeScale(0.6, 0.6);
path = CGPathCreateCopyByTransformingPath(path, &testTransform);
*/
