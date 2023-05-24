//
//  MaiCellX.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/24.
//

@import IosKit;
#import "CollectionViewEmailCell.h"

@interface CollectionViewEmailCell ()
//! 닙으로 초기화함.
@property (nonatomic, strong) IBOutlet UIView *topLevelContainer; // 닙으로부터 불러온다. 가장 큰 덩어리. 이것을 붙인다. top level 이므로 strong

@end

@implementation CollectionViewEmailCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ___commonInit];
    }
    return self;
}

//- (instancetype)initWithCoder:(NSCoder *)coder {
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self ___commonInit];
//    }
//    return self;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark - 생성 & 소멸
- (void)___commonInit {
    self.backgroundColor = UIColor.whiteColor;    
    [self setupNIBObject];
    [self setupIndicatorView];
    
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [UIColor separatorColor];
    [self addSubview:separatorView];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [separatorView.heightAnchor constraintEqualToConstant:0.5].active = YES;
    [separatorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [separatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [separatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:24.0].active = YES;
}

- (void)setupNIBObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    [bundle loadNibNamed:[NSString stringWithFormat:@"%@_", NSStringFromClass([CollectionViewEmailCell class])]
                   owner:self
                 options:nil]; //! 반환되는 배열이 존재한다.
    [self.swipeableContentView addSubview:self.topLevelContainer];
    self.topLevelContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topLevelContainer.leadingAnchor constraintEqualToAnchor:self.swipeableContentView.layoutMarginsGuide.leadingAnchor constant:24.0].active = YES;
    [self.topLevelContainer.trailingAnchor constraintEqualToAnchor:self.swipeableContentView.layoutMarginsGuide.trailingAnchor constant:-8.0].active = YES;
    [self.topLevelContainer.topAnchor constraintEqualToAnchor:self.swipeableContentView.topAnchor constant:8.0].active = YES;
    [self.swipeableContentView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.topLevelContainer.bottomAnchor constant:8.0].active = YES;
}

- (void)setupIndicatorView {
    _unread = NO;
    _indicatorView = [IndicatorView new];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.color = self.tintColor;
    self.indicatorView.backgroundColor = [UIColor clearColor];
    [self.swipeableContentView addSubview:self.indicatorView];

    CGFloat size = 12.0;
    [self.indicatorView.widthAnchor constraintEqualToConstant:size].active = YES;
    [self.indicatorView.heightAnchor constraintEqualToAnchor:self.indicatorView.widthAnchor].active = YES;
    [self.indicatorView.centerXAnchor constraintEqualToAnchor:self.fromLabel.leftAnchor constant:-16.0].active = YES;
    [self.indicatorView.centerYAnchor constraintEqualToAnchor:self.fromLabel.centerYAnchor].active = YES;
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

- (void)setUnread:(BOOL)unread {
    _unread = unread;
    self.indicatorView.transform = unread ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.001, 0.001);
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
