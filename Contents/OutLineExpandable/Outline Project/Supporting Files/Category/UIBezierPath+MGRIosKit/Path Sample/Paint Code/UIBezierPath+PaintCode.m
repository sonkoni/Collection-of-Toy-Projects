//
//  UIBezierPath+TransformerSwitchView.m
//  DropTransform
//
//  Created by Kwan Hyun Son on 2020/11/25.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIBezierPath+PaintCode.h"
#import "UIBezierPath+Transform.h"

@implementation UIBezierPath (PaintCode)


#pragma mark - Play and Stop Bezier
+ (UIBezierPath *)playButtonPathWithFrameSize:(CGSize)frameSize {
    //! 140.0 X 140.0 기준으로 만들어짐.
    CGSize paintSize = CGSizeMake(140.0, 140.0);
    UIBezierPath* playPath = [UIBezierPath bezierPath];
    //! 반시계 방향.
    [playPath moveToPoint: CGPointMake(55.81, 97)];
    [playPath addCurveToPoint: CGPointMake(59.43, 95.76) controlPoint1: CGPointMake(57.08, 97) controlPoint2: CGPointMake(58.16, 96.49)];
    [playPath addLineToPoint: CGPointMake(77.94, 85.01)];
    [playPath addLineToPoint: CGPointMake(96.44, 74.26)];
    [playPath addCurveToPoint: CGPointMake(100, 69.98) controlPoint1: CGPointMake(99.08, 72.7) controlPoint2: CGPointMake(100, 71.67)];
    [playPath addCurveToPoint: CGPointMake(96.44, 65.74) controlPoint1: CGPointMake(100, 68.29) controlPoint2: CGPointMake(99.08, 67.27)];
    [playPath addLineToPoint: CGPointMake(59.43, 44.21)];
    [playPath addCurveToPoint: CGPointMake(55.81, 43) controlPoint1: CGPointMake(58.16, 43.48) controlPoint2: CGPointMake(57.08, 43)];
    [playPath addCurveToPoint: CGPointMake(52, 47.56) controlPoint1: CGPointMake(53.46, 43) controlPoint2: CGPointMake(52, 44.79)];
    [playPath addLineToPoint: CGPointMake(52, 92.41)];
    [playPath addCurveToPoint: CGPointMake(55.81, 97) controlPoint1: CGPointMake(52, 95.18) controlPoint2: CGPointMake(53.46, 97)];
    [playPath closePath];
    
    [playPath mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
    return playPath;
}

+ (UIBezierPath *)stopButtonPathWithFrameSize:(CGSize)frameSize {
    //! 140.0 X 140.0 기준으로 만들어짐.
    CGSize paintSize = CGSizeMake(140.0, 140.0);
    UIBezierPath* stopPath = [UIBezierPath bezierPath];
    //! 반시계 방향.
    [stopPath moveToPoint: CGPointMake(85.81, 94)];
    [stopPath addCurveToPoint: CGPointMake(94, 85.92) controlPoint1: CGPointMake(91.29, 94) controlPoint2: CGPointMake(94, 91.29)];
    [stopPath addLineToPoint: CGPointMake(94, 54.08)];
    [stopPath addCurveToPoint: CGPointMake(85.81, 46) controlPoint1: CGPointMake(94, 48.71) controlPoint2: CGPointMake(91.29, 46)];
    [stopPath addLineToPoint: CGPointMake(54.19, 46)];
    [stopPath addCurveToPoint: CGPointMake(46, 54.08) controlPoint1: CGPointMake(48.74, 46) controlPoint2: CGPointMake(46, 48.69)];
    [stopPath addLineToPoint: CGPointMake(46, 85.92)];
    [stopPath addCurveToPoint: CGPointMake(54.19, 94) controlPoint1: CGPointMake(46, 91.31) controlPoint2: CGPointMake(48.74, 94)];
    [stopPath addLineToPoint: CGPointMake(85.81, 94)];
    [stopPath closePath];
    
    [stopPath mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
    return stopPath;
}

+ (UIBezierPath *)dropShapePathWithFrameSize:(CGSize)frameSize {
    //! 140.0 X 140.0 기준으로 만들어짐.
    CGSize paintSize = CGSizeMake(140.0, 140.0);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    //! 반시계 방향.
    [bezierPath moveToPoint: CGPointMake(67.27, 37.38)];
    [bezierPath addLineToPoint: CGPointMake(51.41, 54.88)];
    [bezierPath addCurveToPoint: CGPointMake(43, 75) controlPoint1: CGPointMake(45.03, 62.59) controlPoint2: CGPointMake(43, 69.22)];
    [bezierPath addCurveToPoint: CGPointMake(44.84, 84.95) controlPoint1: CGPointMake(43, 78.65) controlPoint2: CGPointMake(43.79, 81.99)];
    [bezierPath addCurveToPoint: CGPointMake(70, 99.72) controlPoint1: CGPointMake(47.58, 92.61) controlPoint2: CGPointMake(57.42, 99.72)];
    [bezierPath addCurveToPoint: CGPointMake(95.16, 84.95) controlPoint1: CGPointMake(82.58, 99.72) controlPoint2: CGPointMake(92.42, 92.61)];
    [bezierPath addCurveToPoint: CGPointMake(97, 75) controlPoint1: CGPointMake(96.21, 81.99) controlPoint2: CGPointMake(97, 78.65)];
    [bezierPath addCurveToPoint: CGPointMake(88.59, 54.88) controlPoint1: CGPointMake(97, 69.22) controlPoint2: CGPointMake(94.96, 62.59)];
    [bezierPath addLineToPoint: CGPointMake(72.73, 37.38)];
    [bezierPath addCurveToPoint: CGPointMake(67.27, 37.38) controlPoint1: CGPointMake(71.1, 35.73) controlPoint2: CGPointMake(68.91, 35.73)];
    [bezierPath closePath];
    
    [bezierPath mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
    return bezierPath;
}

//! TEST
//+ (UIBezierPath *)netFlixPlay1PathWithFrameSize:(CGSize)frameSize {
//    //! 100.0 X 100.0 기준으로 만들어짐.
//    CGSize paintSize = CGSizeMake(100.0, 100.0);
//    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint: CGPointMake(20, 20)];
//    [bezierPath addLineToPoint: CGPointMake(51, 36)];
//    [bezierPath addLineToPoint: CGPointMake(51, 64)];
//    [bezierPath addLineToPoint: CGPointMake(20, 80)];
//    [bezierPath addLineToPoint: CGPointMake(20, 20)];
//    [bezierPath closePath];
//    [bezierPath mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
//    return bezierPath;
//}
//
//+ (UIBezierPath *)netFlixPlay2PathWithFrameSize:(CGSize)frameSize {
//    //! 100.0 X 100.0 기준으로 만들어짐.
//    CGSize paintSize = CGSizeMake(100.0, 100.0);
//    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
//    [bezier2Path moveToPoint: CGPointMake(50, 35.5)];
//    [bezier2Path addLineToPoint: CGPointMake(80, 50)];
//    [bezier2Path addLineToPoint: CGPointMake(50, 64.5)];
//    [bezier2Path addLineToPoint: CGPointMake(50, 35.5)];
//    [bezier2Path closePath];
//    [bezier2Path mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
//    return bezier2Path;
//}
//
//+ (UIBezierPath *)netFlixPause1PathWithFrameSize:(CGSize)frameSize {
//    //! 100.0 X 100.0 기준으로 만들어짐.
//    CGSize paintSize = CGSizeMake(100.0, 100.0);
//    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(20, 20, 20, 60)];
//    [rectanglePath mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
//    return rectanglePath;
//}
//
//+ (UIBezierPath *)netFlixPause2PathWithFrameSize:(CGSize)frameSize {
//    //! 100.0 X 100.0 기준으로 만들어짐.
//    CGSize paintSize = CGSizeMake(100.0, 100.0);
//    UIBezierPath *rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(60, 20, 20, 60)];
//    [rectangle2Path mgrApplyTransformFromPaintSize:paintSize toFrameSize:frameSize];
//    return rectangle2Path;
//}

@end
