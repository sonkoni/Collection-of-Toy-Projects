//  NSView+DrawRect.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-07
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

// - drawRect:의 내부에서만 사용될 수 있는 편의 메서드이다.
@interface NSView (DrawRect)

/*!
 * @abstract     단색으로 background 를 채우고 보더를 채운다.
 */
- (void)mgrDrawRect:(NSRect)dirtyRect
    backgroundColor:(NSColor * _Nullable)backgroundColor
       cornerRadius:(CGFloat)cornerRadius
        borderColor:(NSColor * _Nullable)borderColor
        borderWidth:(CGFloat)borderWidth;

/*!
 * @abstract     gradient으로 background 를 채우고 보더를 채운다.
 * @discussion   위에서 아래로 채우는 linear gradient이다.
 */
- (void)mgrDrawRect:(NSRect)dirtyRect
linearGradientbackColors:(NSArray <NSColor *>* _Nullable)linearGradientbackColors
       cornerRadius:(CGFloat)cornerRadius
        borderColor:(NSColor * _Nullable)borderColor
        borderWidth:(CGFloat)borderWidth;

/*!
 * @abstract     gradient으로 background 를 채우고 보더를 채운다.
 * @discussion   가운데서 바깥으로 채우는 radial gradient이다.
 */
- (void)mgrDrawRect:(NSRect)dirtyRect
radialGradientbackColors:(NSArray <NSColor *>* _Nullable)radialGradientbackColors
       cornerRadius:(CGFloat)cornerRadius
        borderColor:(NSColor * _Nullable)borderColor
        borderWidth:(CGFloat)borderWidth;

//! shadow
- (void)mgrDrawShadowPath:(NSBezierPath *)path
              shadowColor:(NSColor *)shadowColor
             shadowOffset:(CGSize)shadowOffset
         shadowBlurRadius:(CGFloat)shadowBlurRadius;

@end

NS_ASSUME_NONNULL_END

// https://stackoverflow.com/questions/9346584/draw-nsshadow-inside-a-nsview
// https://stackoverflow.com/questions/24636304/put-shadow-to-a-rectangle-drawrectcgrectrect
// https://stackoverflow.com/questions/22688948/core-graphics-how-to-draw-a-shadow-without-drawing-a-line
