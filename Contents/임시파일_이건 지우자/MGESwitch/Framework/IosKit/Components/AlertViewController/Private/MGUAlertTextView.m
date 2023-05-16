//
//  MGUAlertTextView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertTextView.h"

@interface MGUAlertTextView ()
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@end

@implementation MGUAlertTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.heightConstraint = [self.heightAnchor constraintEqualToConstant:0.0f];
        self.heightConstraint.priority = UILayoutPriorityDefaultHigh; // 750
        self.heightConstraint.active = YES;

        self.textContainerInset = UIEdgeInsetsZero;
    }

    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updateHeightConstraint];
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    CGRect newBounds = bounds;

    [super setBounds:bounds];

    if (CGSizeEqualToSize(oldBounds.size, newBounds.size) == NO) {
        [self updateHeightConstraint];
    }
}


#pragma mark - 지원(private)

- (void)updateHeightConstraint {
    self.heightConstraint.constant = [self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)].height;
}

@end
