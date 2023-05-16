//
//  CALayer+AutoLayout.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-27
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/1378931/how-do-i-update-a-constraint-on-my-calayer
// https://stackoverflow.com/questions/51393106/using-caconstraints-with-nsview-layers

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN
#if TARGET_OS_OSX
@interface CALayer (AutoLayout)

/**
 다음과 같은 메시지가 뜬다면, superlayer가 백업레이어이다. 오토레이아웃이 먹게 하고 싶다면, wantsLayer = YES 시키고, layer 내가 만들어서 꽂아주면된다.
 Its illegal to set the layout manager of an AppKit provided layer. Use -[NSView setLayer:] or over-ride -[NSView makeBackingLayer] to provide your own layer before setting the layout manager. Break on -[_NSViewBackingLayer setLayoutManager:] to debug.
 */
- (void)mgrPinEdgesToSuperlayerEdgesDisableActions:(BOOL)isDisableActions;
- (void)mgrPinEdgesToSuperlayerCustomMargins:(NSEdgeInsets)customMargins disableActions:(BOOL)isDisableActions; // 인셋만큼 파고든다.

- (void)mgrPinCenterToSuperlayerCenterDisableActions:(BOOL)isDisableActions; // super layer의 센터에 맞춘다.
- (void)mgrPinCenterToSuperlayerCenterWithFixSize:(CGSize)size disableActions:(BOOL)isDisableActions;  // super layer의 센터에 맞추고, 주어진 사이즈로
@end
#endif
NS_ASSUME_NONNULL_END

/* ----------------------------------------------------------------------
 * 2022-04-27 : 라이브러리 정리됨
 */
