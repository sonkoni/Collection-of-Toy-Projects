//
//  MailCell.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/04/23.
//

#import "EmailCell.h"

@implementation EmailCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupIndicatorView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)commonInit {
    _indicatorView = [IndicatorView new];
    _unread = NO;
}

- (void)setUnread:(BOOL)unread {
    _unread = unread;
    self.indicatorView.transform = unread ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.001, 0.001);
}

- (void)setupIndicatorView {
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.color = self.tintColor;
    self.indicatorView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.indicatorView];

    CGFloat size = 12.0;
    [self.indicatorView.widthAnchor constraintEqualToConstant:size].active = YES;
    [self.indicatorView.heightAnchor constraintEqualToAnchor:self.indicatorView.widthAnchor].active = YES;
    [self.indicatorView.centerXAnchor constraintEqualToAnchor:self.fromLabel.leftAnchor constant:-16.0].active = YES;
    [self.indicatorView.centerYAnchor constraintEqualToAnchor:self.fromLabel.centerYAnchor].active = YES;
}

- (void)setUnread:(BOOL)unread animated:(BOOL)animated {
    void (^closure)(void) = ^{
        self.unread = unread;
    };

    if (animated == YES) {
        UIViewPropertyAnimator *localAnimator = self.animator;
        [localAnimator stopAnimation:YES];

        if (unread == YES) {
            localAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:1.0 dampingRatio:0.4 animations:nil];
        } else {
            localAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3 dampingRatio:1.0 animations:nil];
        }
        
        [localAnimator addAnimations:closure];
        [localAnimator startAnimation];
        self.animator = localAnimator;
    } else {
        closure();
    }
}

@end
