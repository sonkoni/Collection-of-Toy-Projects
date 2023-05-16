//
//  MGUFlowIndicatorSupplementaryView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFlowIndicatorSupplementaryView.h"
#import "MGUFlowCell.h"
#import "UIView+AutoLayout.h"

@interface MGUFlowIndicatorSupplementaryView ()
@property (nonatomic, strong, nullable) NSLayoutConstraint *layoutConstraintWidth; // indicatorView의 width
@property (nonatomic, strong, nullable) NSLayoutConstraint *layoutConstraintHeight; // indicatorView의 height
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation MGUFlowIndicatorSupplementaryView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGSizeEqualToSize(self.indicatorSize, CGSizeZero) == YES) {
        CGFloat length = MAX(self.bounds.size.width, self.bounds.size.height);
        self.layoutConstraintWidth.constant = length;
    }
}

#pragma mark - 생성 & 소멸
static void CommonInit(MGUFlowIndicatorSupplementaryView *self) {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self->_elementKindFold = MGUFlowElementKindFoldLeading;
    self->_indicatorColor = [UIColor blackColor];
    self->_indicatorSize = CGSizeZero;
    self->_indicatorView = [UIView new];
    [self.contentView addSubview:self.indicatorView];
    [self.indicatorView mgrPinCenterToSuperviewCenter];
    
    self->_layoutConstraintWidth = [self.indicatorView.widthAnchor constraintEqualToConstant:300.0];
    self.layoutConstraintWidth.active = YES;
    self->_layoutConstraintHeight = [self.indicatorView.heightAnchor constraintEqualToConstant:5.0];
    self.layoutConstraintHeight.active = YES;
    self.indicatorView.layer.cornerRadius = 2.5;
    
    self.contentView.layer.shadowColor = [UIColor clearColor].CGColor;
}


#pragma mark - 세터 & 게터
- (void)setIndicatorSize:(CGSize)indicatorSize {
    _indicatorSize = indicatorSize;
    if (CGSizeEqualToSize(indicatorSize, CGSizeZero) == NO) {
        self.layoutConstraintWidth.constant = indicatorSize.width;
        self.layoutConstraintHeight.constant = indicatorSize.height;
        self.indicatorView.layer.cornerRadius = MIN(indicatorSize.width, indicatorSize.height) / 2.0;
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

@end
