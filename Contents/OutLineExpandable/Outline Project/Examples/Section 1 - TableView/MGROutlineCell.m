//
//  MGROutlineCell.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/09/02.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import IosKit;

#import "MGROutlineCell.h"

@interface MGROutlineCell ()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, nullable) NSLayoutConstraint *indentContraint;
@property (nonatomic, strong) UIColor *cornflowerBlue;
@end

@implementation MGROutlineCell
@synthesize imageView = _imageView; // 반드시 넣어줘야한다. 재정의에 해당하므로.

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self configureChevron];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self configureChevron];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self configureChevron];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self configureChevron];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    _label = [UILabel new];
    _containerView = [UIView new];
    _imageView = [UIImageView new];
    _expanded = NO;
    _group = NO;
    self.indentationLevel = 0;
    self.indentationWidth = 20.0;
    
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.imageView];

    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.containerView];

    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.label.adjustsFontForContentSizeCategory = YES; // + preferredFontForTextStyle: 또는 + preferredFontForTextStyle:compatibleWithTraitCollection: 또는 UIFontMetrics에서 만들어진 font만이 adjustsFontForContentSizeCategory에 적용을 받을 수 있다.
    [self.containerView addSubview:self.label];

    _indentContraint = [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                                                        constant:self.indentationLevel * self.indentationWidth];
    self.indentContraint.active = YES;
    
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    
    [self.imageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:15.0].active = YES;
    [self.imageView.heightAnchor constraintEqualToConstant:25.0].active = YES;
    [self.imageView.widthAnchor constraintEqualToConstant:25.0].active = YES;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor].active = YES;
    
    [self.label.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:15.0].active = YES;
    [self.label.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
    [self.label.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;
    [self.label.topAnchor constraintEqualToAnchor:self.containerView.topAnchor ].active = YES;
    
    _cornflowerBlue = [UIColor colorWithDisplayP3Red:100.0 / 255.0 green:149.0 / 255.0 blue:237.0 / 255.0 alpha:1.0];
    [self configureChevron];
}


#pragma mark - 세터 & 게터
- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    [self configureChevron];
}

- (void)setGroup:(BOOL)group {
    _group = group;
    [self configureChevron];
}

- (void)setIndentationLevel:(NSInteger)indentLevel {
    [super setIndentationLevel:indentLevel];
    self.indentContraint.constant = self.indentationWidth * indentLevel;
}

- (void)setIndentationWidth:(CGFloat)indentationWidth {
    [super setIndentationWidth:indentationWidth];
    self.indentContraint.constant = indentationWidth * self.indentationLevel;
}


#pragma mark - Action
- (void)configureChevron {
    BOOL rtl = self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
       
    NSString *chevron = rtl ? @"chevron.left.circle.fill" : @"chevron.right.circle.fill";
    NSString *circleFill = @"circle.fill";
    BOOL highlighted = self.isHighlighted || self.isSelected;

    if (self.isGroup == YES) {
        NSString *imageName = chevron;
        UIImage *image = [UIImage systemImageNamed:imageName];
        self.imageView.image = image;
        CGFloat rtlMultiplier = rtl ? -1.0 : 1.0;
        
        CGAffineTransform rotationTransform = self.expanded ?
        CGAffineTransformMakeRotation(rtlMultiplier * M_PI / 2) : CGAffineTransformIdentity;
        self.imageView.transform = rotationTransform;
    } else {
        NSString *imageName = circleFill;
        UIImage *image = [UIImage systemImageNamed:imageName];
        self.imageView.image = image;
        self.imageView.transform = CGAffineTransformIdentity;
    }

    self.imageView.tintColor = highlighted ? [UIColor grayColor] : [self cornflowerBlue];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }

@end
