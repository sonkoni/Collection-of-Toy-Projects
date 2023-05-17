//
//  UIScrollView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)
- (CGPoint)mgrMaxOffset {
    // 컨텐츠가 작을 때도 고려해야한다.
    return CGPointMake(MAX(self.contentSize.width - self.bounds.size.width + self.adjustedContentInset.right, 0.0),
                       MAX(self.contentSize.height - self.bounds.size.height + self.adjustedContentInset.bottom, 0.0));
}

- (CGPoint)mgrMinOffset {
    return CGPointMake(-self.adjustedContentInset.left, -self.adjustedContentInset.top);
}

@end
