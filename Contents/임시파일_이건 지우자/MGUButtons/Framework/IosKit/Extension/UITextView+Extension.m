//
//  UITextView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (CGRect)mgrTextBoundingBox {
    UIEdgeInsets textInsets = self.textContainerInset;
    textInsets.left = textInsets.left + self.textContainer.lineFragmentPadding;
    textInsets.right = textInsets.right + self.textContainer.lineFragmentPadding;
    return UIEdgeInsetsInsetRect(self.bounds, textInsets);
}

@end
