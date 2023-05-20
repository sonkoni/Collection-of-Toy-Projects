//
//  MMTGaugeView.m
//  DialControl
//
//  Created by Kwan Hyun Son on 20/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MMTGaugeView.h"
@import GraphicsKit;

@interface MMTGaugeView ()
@property (nonatomic, assign) CGRect previousBounds; // layout subView 에서 이걸 통해 새로 그릴지 결정해보자.
@end

@implementation MMTGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect { // [super drawRect:rect]; UIView를 직접 상속 받았으므로 호출할 필요가 없다.
// 처음에는 여기에 만들려고 했다. 그런데, background로 가면 날라가 버린다.
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.bounds, CGRectZero) == NO &&
        CGRectIsNull(self.bounds) == NO &&
        CGRectEqualToRect(self.bounds, self.previousBounds) == NO) {
        [self setupDialGaugeView];
        _previousBounds = self.bounds;
    }
}

#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.userInteractionEnabled = NO;
    _previousBounds = CGRectZero;
}

- (void)setupDialGaugeView {
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.clearColor;
    
    UIFont *regularFont = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:[self smallTextPointSize]];
    UIFont *boldFont = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:[self largeTextPointSize]];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale); //UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGContextTranslateCTM(currentContext, center.x, center.y); // 좌표 번역
    
    //! 북쪽에서부터 시계방향으로 채운다. // 12 개의 짙은 바늘. 48개의 얕은 바늘 => 총 60개의 바늘
    //! 0,5, 10 => 5의 배수는 짙은 바늘, 나머지는 옅은 바늘.
    NSInteger thickNiddleCount = 12;
    NSInteger thinNiddleCount = 48;
    NSInteger niddleCount = thickNiddleCount + thinNiddleCount;
    for(int i = 0; i < niddleCount ; i++) {
        CGFloat theta = i * (2.0 * M_PI / niddleCount);
        
        CGContextSaveGState(currentContext); // 각각의 컨텍스트 저장
        CGContextRotateCTM(currentContext, theta); // 각각의 컨텍스트 회전
        CGContextTranslateCTM(currentContext, 0.0, -[self gaugeRadius]); // 각각의 좌표 번역
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapRound; // 둥글한 선, 정확한 시작선과 끝선에서 선의 굵기의 1/2만큼 반지름으로 양방향으로 원을 만듬
        path.lineJoinStyle = kCGLineJoinRound;
        if (i % 5 != 0) { // 5의 배수가 아니라면.-> 즉, 얇은 바늘이라면
            path.lineWidth = [self thinNiddleWidth];
        } else { // 5의 배수가 들어온다.
            path.lineWidth = [self thickNiddleWidth];
        }
        
        CGPoint A = CGPointMake(0.0, -[self niddleLength] / 2.0);
        CGPoint C = CGPointMake(0.0, [self niddleLength] / 2.0);
        
        [path moveToPoint:A];
        [path addLineToPoint:C];
        [path closePath];

        
        UIColor *strokeColor;
        if (i % 5 != 0) { // 5의 배수가 아니라면.-> 즉, 얇은 바늘이라면
            strokeColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];
        } else {
            strokeColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        }
        
        [strokeColor setStroke];
        [path stroke];
                
        //!--> 숫자를 쓰자. 15의 배수와 아닌 것을 구분하자. 15의 배수는 더 굵게
        if (i % 5 == 0) { // 5의 배수라면
            CGContextTranslateCTM(currentContext, 0.0, -([self letterRadius] - [self gaugeRadius])); // 추가적인 이동.
            CGContextRotateCTM(currentContext, -theta); // 각각의 컨텍스트 회전
            int number = (60 - i) % 60;
            NSString *numberString = [NSString stringWithFormat:@"%d", number];

            UIFont *font = (i % 15 == 0) ? boldFont : regularFont;
            CGSize letterSize = [numberString sizeWithAttributes:@{NSFontAttributeName : font }];
            NSDictionary *attrs = @{NSFontAttributeName            : font,
                                    NSForegroundColorAttributeName : [UIColor blackColor]};
            [numberString drawAtPoint:CGPointMake(0.0 - letterSize.width / 2.0, 0.0 - letterSize.height / 2.0)
                       withAttributes:attrs];
        }
        CGContextRestoreGState(currentContext);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); // 하나의 이미지로 받아오기
    UIGraphicsEndImageContext(); // 이미지 컨텍스트 종류
    self.image = image;


}


#pragma mark - Helper 메서드
- (CGFloat)fullRadius { // 전체 정사각형을 내부에서 꽉 채우는 원의 반지름.
    return MIN(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f); // 어차피 정사각형이지만.
}

- (CGFloat)gaugeRadius { // 짧은 선(orange knob 포함하여)들이 모여서 이루어지는 원의 반지름 - 선들의 중심과 큰 원의 중심과의 거리.
    return [self fullRadius] * (2593.0 / 3750.0); // Gage diameter => A * (2593 / 3750) = (777.9)
//    return [self fullRadius] * 0.92f;
}

- (CGFloat)letterRadius { // 숫자들이 원형으로 이루어지는 원의 반지름 - 각 글자의 중심과 큰 원의 중심과의 거리.
    CGFloat correction = 600; // 약간 수치가 안맞아서 살짝 보정이 필요하다.
    return [self fullRadius] * ((29163.0 + correction) / 37500.0); // Letter diameter => A * (29163 / 37500) = (874.89)
}

- (CGFloat)thinNiddleWidth {
    return [self fullRadius] * (2.0 / 375.0); //    굵은 게이지 width => A * (1 / 375) = (6.0)
}

- (CGFloat)thickNiddleWidth {
    return [self fullRadius] * (4.0 / 375.0); //    굵은 게이지 width => A * (2 / 375) = (6.0)
}

- (CGFloat)niddleLength {
    return [self fullRadius] * 2.0 * (504.0 / 37500.0); // 선분의 길이 => A * (504 / 37500) = (15.12)
}

- (CGFloat)largeTextPointSize {
    return [self fullRadius] * 2.0 * (80.0 / 1125.0);
}

- (CGFloat)smallTextPointSize {
    return [self fullRadius] * 2.0 * (70.0 / 1125.0);
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }

@end
