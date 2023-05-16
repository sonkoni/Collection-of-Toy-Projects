//
//  MGURulerView+DrawIndicator.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import "MGURulerView.h"

NS_ASSUME_NONNULL_BEGIN

// 가운데 Indicator를 그려주는 메서드를 Extension으로 분리했다.
@interface MGURulerView (DrawIndicator)

- (void)drawBallHeadIndicator;
- (void)drawWheelHeadIndicator;
- (void)drawLineIndicator;

@end

NS_ASSUME_NONNULL_END
