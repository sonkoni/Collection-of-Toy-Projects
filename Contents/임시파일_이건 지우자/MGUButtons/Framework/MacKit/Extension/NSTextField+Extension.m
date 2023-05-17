//
//  NSTextField+Label.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/03/09.
//

#import "NSTextField+Extension.h"

BOOL MGRSierraOrLater(void) {
    static BOOL result = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){ 10, 12, 0 }];
    });
    return result;
}

@implementation NSTextField (Label)

+ (instancetype)mgrWrappingLabelWithString:(NSString *)stringValue {
    if (MGRSierraOrLater() == YES) {
        return [self wrappingLabelWithString:stringValue];
    }
    NSParameterAssert(stringValue);
    NSTextField *label = [NSTextField mgrNewBaseLabelWithoutTitle];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.selectable = YES;
    [label setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [label setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    label.stringValue = stringValue;
    label.preferredMaxLayoutWidth = 0;
    [label sizeToFit];
    return label;
}


// 251.000000 750.000000 750.000000 750.000000
+ (instancetype)mgrLabelWithString:(NSString *)stringValue {
    if (MGRSierraOrLater() == YES) {
        return [self labelWithString:stringValue];
    }
    NSParameterAssert(stringValue);
    NSTextField *label = [NSTextField mgrNewBaseLabelWithoutTitle];
    label.lineBreakMode = NSLineBreakByClipping;
    label.selectable = NO;
    [label setContentHuggingPriority:(NSLayoutPriorityDefaultLow + 1) forOrientation:NSLayoutConstraintOrientationHorizontal];
    [label setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    label.stringValue = stringValue;
    [label sizeToFit];
    return label;
}

//250.000000 750.000000 250.000000 750.000000
+ (instancetype)mgrLabelWithAttributedString:(NSAttributedString *)attributedStringValue  {
    if (MGRSierraOrLater() == YES) {
        return [self labelWithAttributedString:attributedStringValue];
    }
    NSParameterAssert(attributedStringValue);
    NSTextField *label = [NSTextField mgrNewBaseLabelWithoutTitle];
//    label.lineBreakMode : NSParagraphStyle attribute 을 통해.
    label.selectable = NO;
    [label setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [label setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [label setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    label.attributedStringValue = attributedStringValue;
    [label sizeToFit];
    return label;
}


#pragma mark - Private API
+ (instancetype)mgrNewBaseLabelWithoutTitle {
    NSTextField *label = [[self alloc] initWithFrame:CGRectZero];
    label.textColor = [NSColor labelColor];
    label.font = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:label.controlSize]];
    label.alignment = NSTextAlignmentNatural;
    label.baseWritingDirection = NSWritingDirectionNatural;
    label.userInterfaceLayoutDirection = NSApp.userInterfaceLayoutDirection;
    label.enabled = YES;
    label.bezeled = NO;
    label.bordered = NO;
    label.drawsBackground = NO;
    label.continuous = NO;
    label.editable = NO;
    return label;
}

@end


