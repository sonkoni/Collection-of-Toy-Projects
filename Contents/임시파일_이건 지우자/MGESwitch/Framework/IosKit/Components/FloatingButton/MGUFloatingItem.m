
//
//  JJActionItem.m
//  MGRFloatingActionButton
//
//  Created by Kwan Hyun Son on 15/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUFloatingItem.h"
#import "UIApplication+Extension.h"

@interface MGUFloatingItem ()
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *>*dynamicConstraints;
@property (nonatomic, strong, readonly) NSArray <NSLayoutConstraint *>*imageSizeConstraints; // @dynamic
@property (nonatomic, strong, readonly) NSArray <NSLayoutConstraint *>*titleSpacingConstraints; // @dynamic
@end

@implementation MGUFloatingItem
@synthesize highlightedButtonColor = _highlightedButtonColor;
@dynamic buttonImage;
@dynamic buttonImageColor;
@dynamic imageSizeConstraints;
@dynamic titleSpacingConstraints;

//===== LayerProperties Dynamic =======
@dynamic shadowColor;
@dynamic shadowOffset;
@dynamic shadowOpacity;
@dynamic shadowRadius;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.imageView tintColorDidChange];
}

- (void)updateConstraints {
    [self updateDynamicConstraints];
    [super updateConstraints];
}

//! 터치시 작동한다. : touchDown 일때는 인수가 YES touchUp 일때는 인수가 NO
- (void)setHighlighted:(BOOL)highlighted {
    super.highlighted = highlighted;
    if (highlighted == YES) {
        self.circleView.backgroundColor = self.highlightedButtonColor;
    } else {
        self.circleView.backgroundColor = self.buttonColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.circleView.layer.cornerRadius = self.circleView.bounds.size.width /2.0f;
    
//    CGFloat imageSizeMuliplier = 19.0 / 42.0f;
//    CGFloat imageViewWidth     = self.circleView.bounds.size.width * imageSizeMuliplier;
//    CGFloat imageViewOriginX   = (self.circleView.bounds.size.width - imageViewWidth) / 2.0;
//    self.imageView.frame       = CGRectMake(imageViewOriginX, imageViewOriginX, imageViewWidth, imageViewWidth);
}

- (NSArray <NSLayoutConstraint *>*)imageSizeConstraints {
    if (CGSizeEqualToSize(self.imageSize, CGSizeZero) == YES) {
        CGFloat multiplier = 1.0 / sqrt(2.0);
        return @[[self.imageView.widthAnchor constraintLessThanOrEqualToAnchor:self.circleView.widthAnchor
                                                                    multiplier:multiplier],
                 [self.imageView.heightAnchor constraintLessThanOrEqualToAnchor:self.circleView.heightAnchor
                                                                     multiplier:multiplier]];
    } else {
        return @[[self.imageView.widthAnchor constraintEqualToConstant:self.imageSize.width],
                 [self.imageView.heightAnchor constraintEqualToConstant:self.imageSize.height]];
    }
}

- (NSArray <NSLayoutConstraint *>*)titleSpacingConstraints {
    CGFloat horizontalSpacing = [self titleSpacingForAxis:UILayoutConstraintAxisHorizontal];
    CGFloat verticalSpacing   = [self titleSpacingForAxis:UILayoutConstraintAxisVertical];
    
    if (self.titlePosition == MGUFloatingItemTitlePositionLeading) {
//        NSLog(@"MGUFloatingItemTitlePositionLeading");
        return @[[self.circleView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                 [self.circleView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                 [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.circleView.leadingAnchor constant:-horizontalSpacing],
                 [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.circleView.centerYAnchor]];
    } else if (self.titlePosition == MGUFloatingItemTitlePositionTrailing) {
//        NSLog(@"MGUFloatingItemTitlePositionTrailing");
        return @[[self.circleView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                 [self.circleView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                 [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.circleView.trailingAnchor constant:horizontalSpacing],
                 [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.circleView.centerYAnchor]];
    } else if (self.titlePosition == MGUFloatingItemTitlePositionLeft) {
        return @[[self.circleView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                 [self.circleView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                 [self.titleLabel.rightAnchor constraintEqualToAnchor:self.circleView.leftAnchor constant:-horizontalSpacing],
                 [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.circleView.centerYAnchor]];
    } else if (self.titlePosition == MGUFloatingItemTitlePositionRight) {
        return @[[self.circleView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                 [self.circleView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                 [self.titleLabel.leftAnchor constraintEqualToAnchor:self.circleView.rightAnchor constant:horizontalSpacing],
                 [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.circleView.centerYAnchor]];
    } else if (self.titlePosition == MGUFloatingItemTitlePositionTop) {
        return @[[self.circleView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                 [self.circleView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                 [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.circleView.topAnchor constant:-verticalSpacing],
                 [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.circleView.centerXAnchor]];
    } else if (self.titlePosition == MGUFloatingItemTitlePositionBottom) {
        return @[[self.circleView.topAnchor constraintEqualToAnchor:self.topAnchor],
                 [self.circleView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                 [self.titleLabel.topAnchor constraintEqualToAnchor:self.circleView.bottomAnchor constant:verticalSpacing],
                 [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.circleView.centerXAnchor]];
    } else { // MGUFloatingItemTitlePositionHidden
        return @[[self.circleView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                 [self.circleView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]];
    }
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    _titlePosition      = MGUFloatingItemTitlePositionLeading;
    _titleSpacing       = -1.0;
    _dynamicConstraints = [NSMutableArray array];
    _imageSize = CGSizeZero;
    
    self.backgroundColor = UIColor.clearColor;
    
    self.userInteractionEnabled = YES;
    [self addSubview:self.titleLabel];
    [self addSubview:self.circleView];
    [self.circleView addSubview:self.imageView];
    
    [self createStaticConstraints];
    [self updateDynamicConstraints];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self setNeedsUpdateConstraints];
}

//! commonInit 에서만 호출되는 생성 & 소멸 메서드이다.
- (void)createStaticConstraints {
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.titleLabel setContentCompressionResistancePriority:900.0 forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:900.0 forAxis:UILayoutConstraintAxisVertical];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.circleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
    NSMutableArray <NSLayoutConstraint *>*constraints = [NSMutableArray array];
    NSLayoutConstraint *constraint;
    
    [constraints addObject:[self.imageView.centerXAnchor constraintEqualToAnchor:self.circleView.centerXAnchor]];
    [constraints addObject:[self.imageView.centerYAnchor constraintEqualToAnchor:self.circleView.centerYAnchor]];
    [constraints addObject:[self.circleView.widthAnchor constraintEqualToAnchor:self.circleView.heightAnchor]];
    
    [constraints addObject:[self.circleView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor]];
    [constraints addObject:[self.circleView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]];
    [constraints addObject:[self.circleView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor]];
    [constraints addObject:[self.circleView.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor]];    
    
    constraint = [self.circleView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    constraint.priority = UILayoutPriorityDefaultLow;
    [constraints addObject:constraint];
    constraint = [self.circleView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    constraint.priority = UILayoutPriorityDefaultLow;
    [constraints addObject:constraint];
    constraint = [self.circleView.topAnchor constraintEqualToAnchor:self.topAnchor];
    constraint.priority = UILayoutPriorityDefaultLow;
    [constraints addObject:constraint];
    constraint = [self.circleView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    constraint.priority = UILayoutPriorityDefaultLow;
    [constraints addObject:constraint];
    
    [constraints addObject:[self.titleLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor]];
    [constraints addObject:[self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor]];
    [constraints addObject:[self.titleLabel.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor]];
    [constraints addObject:[self.titleLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [self.circleView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.circleView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
}


#pragma mark - 세터 & 게터
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel                        = [UILabel new];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.numberOfLines          = 1;
        _titleLabel.font                   = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _titleLabel.textColor              = UIColor.whiteColor;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = UIColor.clearColor;
    }
    return _imageView;
}

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor =  buttonColor;
    self.circleView.backgroundColor = _buttonColor;
}

- (UIView *)circleView {
    if (_circleView == nil ) {
        _circleView = [UIView new];
        self.buttonColor = UIColor.whiteColor; // 세터로 친다
        _circleView.userInteractionEnabled = NO;
    }
    return _circleView;
}

- (void)setHighlightedButtonColor:(UIColor *)highlightedButtonColor {
    _highlightedButtonColor = highlightedButtonColor;
}

- (UIColor *)highlightedButtonColor {
    if(_highlightedButtonColor == nil) {
        _highlightedButtonColor = transHighlightedColor(self.buttonColor);
    }
    return _highlightedButtonColor;
}

- (UIImage *)buttonImage {
    return self.imageView.image;
    
}

- (void)setButtonImage:(UIImage *)buttonImage {
    self.imageView.image = buttonImage;
}

- (UIColor *)buttonImageColor {
    return self.imageView.tintColor;
}

- (void)setButtonImageColor:(UIColor *)buttonColor {
    self.imageView.tintColor = buttonColor;
}

- (void)setTitlePosition:(MGUFloatingItemTitlePosition)titlePosition {
    _titlePosition = titlePosition;
    [self setNeedsUpdateConstraints];
}

- (void)setTitleSpacing:(CGFloat)titleSpacing {
    _titleSpacing = titleSpacing;
    [self setNeedsUpdateConstraints];
}


//===== LayerProperties Dynamic =======
- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)shadowColor {
    if (self.layer.shadowColor == nil) {
        return nil;
    } else {
        return [UIColor colorWithCGColor:self.layer.shadowColor];
    }
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}


#pragma mark - 컨트롤 메서드
//! MGUFloatingItemPreparation 클래스에서만 호출되는 컨트롤 메서드이다.
- (void)scaleBy:(CGFloat)factor
   translationX:(CGFloat)translationX
   translationY:(CGFloat)translationY {
    CGAffineTransform scale       = CGAffineTransformMakeScale(factor, factor);
    CGAffineTransform translation = CGAffineTransformMakeTranslation(translationX, translationY);
    self.transform = CGAffineTransformConcat(scale, translation);
}

- (void)showLogAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.titleLabel.text
                                                                             message:@"Item tapped!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
    [alertController addAction:alertAction];
    UIViewController *rootViewController = [UIApplication mgrKeyWindow].rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)callAction {
    if (self.actionBlock != nil) {
        __weak __typeof(self) weakSelf = self;
        self.actionBlock(weakSelf);
    }
}


#pragma mark - 지원 메서드
//! updateConstraints, commonInit 메서드에서 호출되는 지원 메서드이다.
- (void)updateDynamicConstraints {
    if (self.titlePosition == MGUFloatingItemTitlePositionHidden) {
        self.titleLabel.hidden = YES;
    } else {
        self.titleLabel.hidden = NO;
    }
    
    [NSLayoutConstraint deactivateConstraints:self.dynamicConstraints];
    [self.dynamicConstraints removeAllObjects];
    [self createDynamicConstraints];
    [NSLayoutConstraint activateConstraints:self.dynamicConstraints];
    [self setNeedsLayout];
}

//! - updateDynamicConstraints만을 위한 지원 메서드이다.
- (void)createDynamicConstraints {
    [self.dynamicConstraints addObjectsFromArray:self.titleSpacingConstraints];
    [self.dynamicConstraints addObjectsFromArray:self.imageSizeConstraints];
}

//! - createDynamicConstraints만을 위한 지원 메서드이다.
- (CGFloat)titleSpacingForAxis:(UILayoutConstraintAxis)axis {
    
    NSString *text = self.titleLabel.text;
    if ( (text == nil) || ([text isEqualToString:@""] == YES) ){
        return 0.0;
    }
    
    if (self.titleSpacing > 0.0) {
        return self.titleSpacing;
    }
    
    if (axis == UILayoutConstraintAxisHorizontal) {
        return 12.0f;
    } else {
        return 4.0f;
    }
}


@end
UIColor * transHighlightedColor(UIColor *originalColor) {
    CGFloat hue, satuaration, brightness, alpha, newBrightness;
    [originalColor getHue:&hue saturation:&satuaration brightness:&brightness alpha:&alpha];
    
    if ( brightness > 0.5 ) {
        newBrightness = brightness - 0.1;
    } else {
        newBrightness = brightness + 0.1;
    }
    
    return [UIColor colorWithHue:hue saturation:satuaration brightness:newBrightness alpha:alpha];
}
