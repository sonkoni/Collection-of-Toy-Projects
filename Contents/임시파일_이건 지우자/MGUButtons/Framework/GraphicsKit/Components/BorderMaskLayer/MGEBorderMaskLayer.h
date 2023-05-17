//
//  MGEBorderMaskLayer.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-11-04
//  ----------------------------------------------------------------------
//

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGEBorderMaskLayer
 @abstract      보더가 인셋을 줄 수도 있어서 만들었다. 라디어스와 borderwidth는 풀로 찾다고 가정할때의 값이다.
 @discussion    ...
*/
@interface MGEBorderMaskLayer : CALayer

@property (nonatomic, assign) CGFloat borderInset; // @dynamic Animatable.
// @property CGFloat cornerRadius;
// @property CGFloat borderWidth;

@property(nullable) CGColorRef borderColor __attribute__((unavailable("마스크로만 사용하는 클래스이다. 사용해서는 안된다.")));
@end

NS_ASSUME_NONNULL_END

