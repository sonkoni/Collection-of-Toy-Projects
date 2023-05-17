//
//  UIView+Screenshot.h
//  NavigationStackDemo_koni
//
//  Created by Kwan Hyun Son on 28/11/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Screenshot)

- (UIImage *)mgrScreenshot;
- (UIImage *)mgrScreenshotWithInsideFrame:(CGRect)insideFrame;

- (UIImageView *)mgrRenderSnapshot;
- (CALayer *)mgrRenderSnapshotLayer;

//! special
+ (UIImageView *)mgrDefaultSliderKnob:(CGFloat)size; // 디폴트 28.0 X 28.0
@end

NS_ASSUME_NONNULL_END
//! C 함수로 만들었으며 깜빡거림이나, 객체를 빠뜨리지 않고 스크린샷을 잘 떠준다.
//! 그러나 매우 많은양의 객체를 쪼개서 스크린샷을 뜨는 경우에는 조금 느릴 수 있다.
//! 위키 : Api:UIKit/UIView/- drawViewHierarchyInRect:afterScreenUpdates:
//! 이 페이지에 나머지 추가적인 방법 3가지가 나와있다.

/***
UIView 

① 비추 - 껌뻑거림 존재
- (UIView *)resizableSnapshotViewFromRect:(CGRect)rect 
					   afterScreenUpdates:(BOOL)afterUpdates 
							withCapInsets:(UIEdgeInsets)capInsets; // 빠르다.
① 비추 - 껌뻑거림 존재
- (BOOL)drawViewHierarchyInRect:(CGRect)rect 
			 afterScreenUpdates:(BOOL)afterUpdates;             // 블러 효과를 적용하기 좋다.

③ 비추 - 껌뻑거림 존재
- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates; // 빠르다. 크기 및 인셋을 적용할 수 없다.

④ 추천 - 아무런 문제가 없다.
CALayer

- (void)renderInContext:(CGContextRef)ctx;

---------------------------------------------------------------

①
self.jjabView = [self.view.superview resizableSnapshotViewFromRect:CGRectInset(self.view.frame, 0, 0)
												afterScreenUpdates:YES
													 withCapInsets:UIEdgeInsetsZero];


②
UIGraphicsBeginImageContextWithOptions(keyWindow.bounds.size, NO, UIScreen.mainScreen.scale);
[keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:NO];
UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
return snapshotImage;

//! 특정 영역을 추출할 때.
CGFloat scale = UIScreen.mainScreen.scale;
UIGraphicsBeginImageContextWithOptions(self.fromView.bounds.size, NO, scale);
[self.fromView drawViewHierarchyInRect:self.fromView.bounds afterScreenUpdates:NO];
UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext(); // 여기까지는 풀사이즈.
CGRect rect = obj.inSideFrame;
rect = CGRectMake(rect.origin.x *scale, rect.origin.y *scale, rect.size.width *scale, rect.size.height *scale);
CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
UIImage *img = [UIImage imageWithCGImage:imageRef];
CGImageRelease(imageRef);
UIImageView *view = [UIImageView new];
view.contentMode = UIViewContentModeScaleAspectFit;
view.image = img;


③
rotationSnapshotView = [viewForCurrentInterfaceOrientation snapshotViewAfterScreenUpdates:NO];


④
- (UIImage *)takeScreenshot {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
	
	//! 만약 특정 영역만 추출하고 싶다면 아래 코드를 이용하라.
	CGFloat scale = UIScreen.mainScreen.scale;
	UIGraphicsBeginImageContextWithOptions(self.toView.bounds.size, NO, scale);
	[self.toView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext(); // 여기까지는 풀사이즈.
	CGRect rect = obj.inSideFrame;
	rect = CGRectMake(rect.origin.x *scale, rect.origin.y *scale, rect.size.width *scale, rect.size.height *scale);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
	UIImage *img = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	UIImageView *view = [UIImageView new];
	view.contentMode = UIViewContentModeScaleAspectFit;
	view.image = img;
}
**/
