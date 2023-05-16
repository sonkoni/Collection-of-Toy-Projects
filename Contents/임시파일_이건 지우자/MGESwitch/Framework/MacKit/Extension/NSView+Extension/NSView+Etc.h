//  NSView+Etc.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-18
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (Etc)

//! 가짜로 만든(NSVisualEffectView) 툴바(타이틀)에 붙는 라인뷰를 의미한다. 툴바에 붙일 때에는 바깥으로 삐져나오는 위치로 붙이는 것이 일반적이다.
//! 문제는 Clips to bounds가 안된다는 것이다. wantsDefaultClipping(readonly)를 재정의하면 되지만, 버그 때문에 작동하지 않는다.
//! 더 넓은 컨테이너를 준비해야할듯하다.
//! @warning 그냥 라인뷰로 쓰는 것이 나을 듯 하다. 가짜로 만든 툴바는 그냥 NSVisualEffectView에 shadow를 때리기로 결정했다.
+ (NSView *)mgrHorizontalLineViewWithBottomShadow;
+ (NSView *)mgrHorizontalLineViewWithTopShadow;
+ (NSView *)mgrVerticalLineViewWithLeadingShadow;
+ (NSView *)mgrVerticalLineViewWithTrailingShadow;

- (void)mgrInsertSubview:(nonnull NSView *)view aboveSubview:(nonnull NSView *)siblingSubview;
- (void)mgrInsertSubview:(nonnull NSView *)view belowSubview:(nonnull NSView *)siblingSubview;
- (void)mgrInsertSubview:(nonnull NSView *)view atIndex:(NSInteger)index;

//! 사용해서는 안될 듯. 이것은 디버깅용이다. 메모리 상태의 뷰를 카피한다. 예전에는 사용했지만, 지금은 금지된듯.
//! https://developer.apple.com/forums/thread/681266
//! https://stackoverflow.com/questions/67776944/nssecurecoding-writing-uiview-to-disk
- (__kindof NSView *)mgrCopyView;

// https://stackoverflow.com/questions/50787694/how-to-update-nsview-layer-position-and-anchor-point-for-transform-simultaneousl
- (void)mgrSetAnchorPoint:(CGPoint)anchorPoint;

//! 위키 - Api:AppKit/NSView/wantsLayer
- (void)mgrMakeHostingLayer; // layer-backed 뷰가 아닌 layer-hosting 뷰이다.

@end

NS_ASSUME_NONNULL_END
