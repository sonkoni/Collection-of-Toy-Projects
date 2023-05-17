//
//  CAGradientLayer+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "CAGradientLayer+Extension.h"

@implementation CAGradientLayer (Create)

- (void)mgrGradientLayer:(CAGradientLayerType)gradientLayerType
              startPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
                  colors:(NSArray *)colors
               locations:(NSArray<NSNumber *> *)locations {
    self.type = gradientLayerType;
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.colors = colors;
    self.locations = locations;
}

- (void)mgrAxialVerticalGradientLayerWithColors:(NSArray <MGEColor *>*)colors {
    self.type = kCAGradientLayerAxial;
    self.startPoint = CGPointMake(0.5, 0.0);
    self.endPoint = CGPointMake(0.5, 1.0);
    NSMutableArray *colorArr = [NSMutableArray array];
    for (MGEColor *color in colors) {
        id cgColor = (__bridge id)color.CGColor;
        [colorArr addObject:cgColor];
    }
    self.colors = colorArr.copy;
}

- (void)mgrAxialHorizontalGradientLayerWithColors:(NSArray <MGEColor *>*)colors {
    self.type = kCAGradientLayerAxial;
    self.startPoint = CGPointMake(0.0, 0.5);
    self.endPoint = CGPointMake(1.0, 0.5);
    NSMutableArray *colorArr = [NSMutableArray array];
    for (MGEColor *color in colors) {
        id cgColor = (__bridge id)color.CGColor;
        [colorArr addObject:cgColor];
    }
    self.colors = colorArr.copy;
}

- (void)mgrConicGradientLayerWithColors:(NSArray <MGEColor *>*)colors {
    self.type = kCAGradientLayerConic;
    self.startPoint = CGPointMake(0.5, 0.5);
    self.endPoint = CGPointMake(0.5, 0.0); // startPoint에서 endPoint까지 일직선을 긋고 시계방향으로 색을 채운다.
    NSMutableArray *colorArr = [NSMutableArray array];
    for (MGEColor *color in colors) {
        id cgColor = (__bridge id)color.CGColor;
        [colorArr addObject:cgColor];
    }
    self.colors = colorArr.copy;
}

- (void)mgrRadialGradientLayerWithColors:(NSArray <MGEColor *>*)colors {  // 가운데서 퍼짐.
    self.type = kCAGradientLayerRadial;
    self.startPoint = CGPointMake(0.5, 0.5);
    self.endPoint = CGPointMake(1.0, 1.0);   // 원을 포함하는 직사각형의 꼭지점 좌표(4개 중 1개)
    NSMutableArray *colorArr = [NSMutableArray array];
    for (MGEColor *color in colors) {
        id cgColor = (__bridge id)color.CGColor;
        [colorArr addObject:cgColor];
    }
    self.colors = colorArr.copy;
}

- (void)mgrFaintlyAtBothEnds {
    MGEColor *bothEndColor = [MGEColor colorWithWhite:0.0 alpha:0.0];
    self.colors = @[(id)[bothEndColor CGColor],
                         (id)[[MGEColor blackColor] CGColor],
                         (id)[[MGEColor blackColor] CGColor],
                         (id)[bothEndColor CGColor]];
    self.locations = @[@0.0, @0.33, @0.66, @1.0];
    self.startPoint = CGPointMake(0.0, 0.5);
    self.endPoint = CGPointMake(1.0, 0.5);
}

//#endif

@end
