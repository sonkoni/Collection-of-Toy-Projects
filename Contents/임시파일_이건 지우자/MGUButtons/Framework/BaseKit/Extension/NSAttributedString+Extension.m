//
//  NSAttributedString+Extension.m
//  Label_TEST
//
//  Created by Kwan Hyun Son on 2022/02/03.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

- (NSDictionary <NSAttributedStringKey, id>*)mgrAttrs {
    return [self attributesAtIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0, self.length)];
}

#if TARGET_OS_IPHONE
- (NSMutableAttributedString *)mgrAppendImage:(UIImage *)image {
    NSMutableAttributedString *result = self.mutableCopy;
    if (image == nil) {
        return result;
    }
    // MARK: Create our NSTextAttachment.
    NSTextAttachment *imageAttachment = [NSTextAttachment new];
    imageAttachment.image = image;

    // MARK: Wrap the attachment in its own attributed string so we can append it.
    NSAttributedString *strImage = [NSAttributedString attributedStringWithAttachment:imageAttachment];
#if DEBUG
    NSLog(@"result %@", [result class]);
#endif
    [result appendAttributedString:strImage];
#if DEBUG
    NSLog(@"result %@", [result class]);
#endif
    return result;
}
#endif

@end
