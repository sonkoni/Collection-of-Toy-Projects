//
//  MGAPopover.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-23
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/48594212/how-to-open-a-nspopover-at-a-distance-from-the-system-bar
// https://stackoverflow.com/questions/47286310/nspopover-and-adding-spacing-with-nsstatusitem

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGAPopover
 @abstract      특정 뷰에서 어느정도 거리가 띄어진 Popover를 만들기 위해 서브클래싱을 했다.
 @discussion    NSPopover 의 source view 외부로 끝이 나올 수 없는 성질 때문에 이렇게 만들었다.
 @code
        기존의 NSPopover에서는 아래와 같은 트릭을 쓸수도 있지만, 문제는 superview가 더 크지 않을때 발생한다.
        __kindof NSView *view = segmentedControl.superview;
        [self.popover showRelativeToRect:CGRectInset(view.bounds, 4.0, 4.0) // 살짝 아래로 풍선을 배치하고 싶다.
                                  ofView:view
                           preferredEdge:NSMinYEdge];
 
 
         다음과 같이 사용하면 된다.
         if (self.popover == nil) {
             self.popover = [MGAPopover new];
         }
         if (self.popover.isShown == NO) {
             self.popover.contentViewController = [PopoverController new];
             self.popover.behavior = NSPopoverBehaviorTransient;
             self.popover.delegate = self;
             self.popover.animates = YES;
             [self.popover showRelativeToRect:CGRectInset(segmentedControl.bounds, -13.0, -13.0) // 음수가 가능하게 만들었음.
                                       ofView:segmentedControl
                                preferredEdge:NSMinYEdge];
         }
 @endcode
*/
@interface MGAPopover : NSPopover

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
