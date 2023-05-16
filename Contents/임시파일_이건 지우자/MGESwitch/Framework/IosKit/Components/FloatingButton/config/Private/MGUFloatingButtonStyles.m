//
//  MGUFloatingButtonStyles.m
//  MGRFloatingActionButton
//
//  Created by Kwan Hyun Son on 15/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUFloatingButtonStyles.h"

@interface MGUFloatingButtonStyles ()
@end
@implementation MGUFloatingButtonStyles
@dynamic plusImage;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 & 소멸 메서드
+ (instancetype)shared {
    static MGUFloatingButtonStyles *sharedMyManager = nil;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[MGUFloatingButtonStyles alloc] init];
    });
    return sharedMyManager;
}

- (void)commonInit {
    _defaultButtonColor            = [UIColor colorWithHue:0.31f saturation:0.37f brightness:0.76f alpha:1.00f];
    _defaultHighlightedButtonColor = [UIColor colorWithHue:0.31f saturation:0.37f brightness:0.66f alpha:1.00f];
    _defaultButtonImageColor       = UIColor.whiteColor;
    _defaultShadowColor            = UIColor.blackColor;
    _defaultOverlayColor           = [UIColor colorWithWhite:0.0 alpha:0.5];
    //
    // 물론 self.actionButton.buttonImage = [UIImage imageNamed:@"MGUFloatingButtonDots"]; 이렇게 설정도 가능하다.
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 & 게터 메서드
- (UIImage *)plusImage {
    UIBezierPath *path = [self plusShapePath];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(24.0, 24.0), NO, 0); // BEGIN
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [UIColor.blackColor setFill]; // 흰색이 아닌 알파가 1.0인 아무칼라나 상관 없다.
    [path fill];
    
    CGContextRestoreGState(context);
    
    UIImage *madeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); // END
    
    madeImage = [madeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // Tint Color를 먹일 수 있게
    
    return madeImage;
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드

- (UIBezierPath *)plusShapePath {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.5, 11.0)];
    [bezierPath addLineToPoint:CGPointMake(13.0, 11.0)];
    [bezierPath addLineToPoint:CGPointMake(13.0, 1.5)];
    [bezierPath addCurveToPoint:CGPointMake(12.5, 1.0)
                  controlPoint1:CGPointMake(13.0, 1.22)
                  controlPoint2:CGPointMake(12.78, 1.0)];
    [bezierPath addLineToPoint:CGPointMake(11.5, 1.0)];
    [bezierPath addCurveToPoint:CGPointMake(11.0, 1.5)
                  controlPoint1:CGPointMake(11.22, 1.0)
                  controlPoint2:CGPointMake(11.0, 1.22)];
    [bezierPath addLineToPoint:CGPointMake(11.0, 11.0)];
    [bezierPath addLineToPoint:CGPointMake(1.5, 11.0)];
    [bezierPath addCurveToPoint:CGPointMake(1.0, 11.5)
                  controlPoint1:CGPointMake(1.22, 11.0)
                  controlPoint2:CGPointMake(1.0, 11.22)];
    [bezierPath addLineToPoint:CGPointMake(1.0, 12.5)];
    [bezierPath addCurveToPoint:CGPointMake(1.5, 13.0)
                  controlPoint1:CGPointMake(1.0, 12.78)
                  controlPoint2:CGPointMake(1.22, 13.0)];
    [bezierPath addLineToPoint:CGPointMake(11.0, 13.0)];
    [bezierPath addLineToPoint:CGPointMake(11.0, 22.5)];
    [bezierPath addCurveToPoint:CGPointMake(11.5, 23.0)
                  controlPoint1:CGPointMake(11.0, 22.78)
                  controlPoint2:CGPointMake(11.22, 23.0)];
    [bezierPath addLineToPoint:CGPointMake(12.5, 23.0)];
    [bezierPath addCurveToPoint:CGPointMake(13.0, 22.5)
                  controlPoint1:CGPointMake(12.78, 23.0)
                  controlPoint2:CGPointMake(13.0, 22.78)];
    [bezierPath addLineToPoint:CGPointMake(13.0, 13.0)];
    [bezierPath addLineToPoint:CGPointMake(22.5, 13.0)];
    [bezierPath addCurveToPoint:CGPointMake(23.0, 12.5)
                  controlPoint1:CGPointMake(22.78, 13.0)
                  controlPoint2:CGPointMake(23.0, 12.78)];
    [bezierPath addLineToPoint:CGPointMake(23.0, 11.5)];
    [bezierPath addCurveToPoint:CGPointMake(22.5, 11.0)
                  controlPoint1:CGPointMake(23.0, 11.22)
                  controlPoint2:CGPointMake(22.78, 11.0)];
    [bezierPath closePath];
    return bezierPath;
}

@end


