//
//  NSHapticFeedbackManager+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-20
//  ----------------------------------------------------------------------
//
/*!
 * @class      NSHapticFeedbackManager 클래스의 카테고리. UIKit의 UIFeedbackGenerator 클래스 카테고리와 비슷한 카테고리.
 * @abstract   <NSHapticFeedbackPerformer> 프로토콜과 같이 쓴다.
 * @discussion NSAlignmentFeedbackFilter 클래스(<NSAlignmentFeedbackToken> 프로토콜과 같이 쓴다.)도 있다.
 */

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHapticFeedbackManager (Extension)

/**
 * @brief NSSwitch가 제스처로 왔다 갔다 할때, 트랙패드에서 발생하는 임팩트 피드백과 같은 피드백을 발생시켜준다.
 * @param pattern NSHapticFeedbackPatternGeneric, NSHapticFeedbackPatternAlignment, NSHapticFeedbackPatternLevelChange
 * @param performanceTime NSHapticFeedbackPerformanceTimeDefault, NSHapticFeedbackPerformanceTimeNow, NSHapticFeedbackPerformanceTimeDrawCompleted
 * @discussion 우선 알고 있는 것은 여기 까지이다.
 * @remark ...
 * @code
        [NSHapticFeedbackManager performFeedbackPattern:NSHapticFeedbackPatternGeneric
                                        performanceTime:NSHapticFeedbackPerformanceTimeNow];
 * @endcode
*/
+ (void)mgrPerformFeedbackPattern:(NSHapticFeedbackPattern)pattern
                  performanceTime:(NSHapticFeedbackPerformanceTime)performanceTime;

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-04-20 : 라이브러리 정리됨
https://developer.apple.com/documentation/appkit/nshapticfeedbackmanager?language=objc
https://stackoverflow.com/questions/64355289/forcetouch-control-the-amplitude-of-the-feedback
*/


