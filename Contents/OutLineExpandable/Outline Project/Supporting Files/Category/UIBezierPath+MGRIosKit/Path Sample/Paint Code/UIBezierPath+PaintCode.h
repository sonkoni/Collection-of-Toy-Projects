//
//  UIBezierPath+TransformerSwitchView.h
//  DropTransform
//
//  Created by Kwan Hyun Son on 2020/11/25.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (PaintCode)

/**
* Paint Code로 그려진 UIBezierPath를 원하는 rect사이즈로 만들어 반환한다.
* @param frameSize 최종적으로 코드가 삽입될 레이어의 사이즈이다.
* @discussion 우선은 정사각형을 가정한다. start point, end point 수정했음.
*/
+ (UIBezierPath *)playButtonPathWithFrameSize:(CGSize)frameSize;
+ (UIBezierPath *)stopButtonPathWithFrameSize:(CGSize)frameSize;
+ (UIBezierPath *)dropShapePathWithFrameSize:(CGSize)frameSize;

//! TEST
//+ (UIBezierPath *)netFlixPlay1PathWithFrameSize:(CGSize)frameSize;
//+ (UIBezierPath *)netFlixPlay2PathWithFrameSize:(CGSize)frameSize;
//+ (UIBezierPath *)netFlixPause1PathWithFrameSize:(CGSize)frameSize;
//+ (UIBezierPath *)netFlixPause2PathWithFrameSize:(CGSize)frameSize;
@end

NS_ASSUME_NONNULL_END
