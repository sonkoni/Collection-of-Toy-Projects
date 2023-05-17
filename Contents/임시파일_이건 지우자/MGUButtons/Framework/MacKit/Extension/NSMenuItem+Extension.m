//
//  NSMenuItem+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSMenuItem+Extension.h"

@implementation NSMenuItem (Extension)

- (void)mgrSetTitleColor:(NSColor *)color {
    if (self.title == nil && self.attributedTitle.string == nil) {
        return;
    }
    NSString *title = self.title;
    if (title == nil) {
        title = self.attributedTitle.string;
    }
    
    self.attributedTitle =
    [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : color}];
}

@end
