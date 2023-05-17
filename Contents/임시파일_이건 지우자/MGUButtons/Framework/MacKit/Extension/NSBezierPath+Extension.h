//
//  NSBezierPath+Extension.h
//
//  Created by Kwan Hyun Son on 2022/04/01.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBezierPath (Extension)

/**
 * @brief NSBezierPath 객체에서 CGPath 구조체 포인터(CGPathRef)를 반환한다.
 * @discussion 수동릴리즈가 필요하다. 컨벤션: new, alloc, copy, mutableCopy로 시작한다. By Advanced Memory Management Programming Guide
 * @remark NSBezierPath를 바로 CGPath * 로 바꾸는 메서드가 없다. UIKit은 프라퍼티를 제공한다. This method works only in OS X v10.2 and later.
 * @code
        CGPathRef quartzPath = [starPath newMgrCGPath];
        layer.path = quartzPath;
        CGPathRelease(quartzPath); // 반드시 수동 릴리즈 해야한다.
 * @endcode
 * @return CGPath 구조체 포인터(CGPathRef)
*/
- (CGPathRef _Nullable)newMgrCGPath;
// 메서드에서 만약 CGImageRef를 반환한다면, 정적 분석기(단축키:⇧⌘B)에서 경고가 뜬다.(메모리 누수경고) 이럴 때에는 naming 규칙상 new, alloc, copy, mutableCopy 로 시작하면, 경고를 없앨 수 있다. Advanced Memory Management Programming Guide 즉, 사용하는 측에서 릴리즈 할 것이라는 것을 알려주는 것이다.

//! UIBezierPath의 - (CGPathRef)CGPath; 와 동일하다. CFAutorelease()로 감싸진 CGPathRef가 반환된다.
//! 저장하고 싶다면, CGPathRetain(result) 를 해야한다.
- (CGPathRef _Nullable)mgrCGPath;

/**
 * @brief + bezierPathWithRoundedRect:cornerRadius: + bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:의 장점을 모아서 만들었다.
 * @param rect 그려야할 rect
 * @param corners 어느 코너를 그릴 것인가에 대한 '옵션'
 * @param cornerRadius 코너 라디어스
 * @discussion 기본 메서드가 지랄 같은 버그가 존재해서 내가 만들었다. 가로 세로 중 작은 길이의 1/2가 되지 않았는되도 그냥 반으로 라디어스를 때리는 버그가 존재함.
 * @remark 애플 기본메서드가 버그가 존재하여 만들었다.
 * @code
    UIBezierPath *path = [UIBezierPath mgrBezierPathWithRoundedRect:rect
                                                  byRoundingCorners:kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner
                                                       cornerRadius:15.0];
 
 * @endcode
 * @return 원하는 방향에 주어진 라디어스를 적용한 Rounded Rect Path를 반환한다.
*/
+ (instancetype)mgrBezierPathWithRoundedRect:(CGRect)rect
                           byRoundingCorners:(CACornerMask)corners
                                cornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
