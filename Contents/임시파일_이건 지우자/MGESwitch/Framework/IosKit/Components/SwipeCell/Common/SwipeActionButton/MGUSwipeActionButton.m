//
//  MGUSwipeActionButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUFavoriteSwitch.h"
#import "MGUSwipeActionButton.h"
#import "MGUSwipeAction.h"

@interface MGUSwipeActionButton ()
@property (nonatomic, assign, readonly) CGFloat imageHeight;
@property (nonatomic, assign, readonly) CGRect alignmentRect; // contentRect에서 height가 조정된 rect
@property (nonatomic, assign, readonly) CGFloat currentSpacing;
@property (nonatomic, strong) UILabel *titleLabel; // lazy
@property (nonatomic, strong) NSString *currentTitle;
@property (nonatomic, strong) UIImageView *imageView; // lazy
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIView *imageViewContainer;
@property (nonatomic, strong) MGUFavoriteSwitch *favoriteSwitch;
@end


@implementation MGUSwipeActionButton
@dynamic imageHeight;
@dynamic alignmentRect;
@dynamic currentSpacing;
@dynamic currentTitle;

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.shouldHighlight == YES) {
        self.backgroundColor = (highlighted == YES) ? self.highlightedBackgroundColor : UIColor.clearColor;
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric,
                      self.contentEdgeInsets.top + self.alignmentRect.size.height + self.contentEdgeInsets.bottom);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageViewContainer.frame = [self imageRectForContentRect:self.contentRect];
    self.titleLabel.frame = [self titleRectForContentRect:self.contentRect];
    self.imageView.frame = self.imageViewContainer.bounds;
    
    CGFloat length = MAX(self.imageViewContainer.bounds.size.width, self.imageViewContainer.bounds.size.height);
    CGRect frame = MGERectCenteredInRectSize(self.imageViewContainer.bounds, CGSizeMake(length, length));
    self.favoriteSwitch.frame = CGRectIntegral(frame);
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithAction:(MGUSwipeAction *)action {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        CommonInit(self);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        if (action.textColor == nil) {
            self.tintColor = [UIColor whiteColor];
        } else {
            self.tintColor = action.textColor;
        }
        
        UIColor *highlightedTextColor = action.highlightedTextColor;
        if (highlightedTextColor == nil) {
            highlightedTextColor = self.tintColor;
        }
        
        self.highlightedBackgroundColor = action.highlightedBackgroundColor;
        if (self.highlightedBackgroundColor == nil) {
            self.highlightedBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        }
        
        
        self.titleLabel.font = action.font;
        if (self.titleLabel.font == nil) {
            self.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        }
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        
        self.accessibilityLabel = action.accessibilityLabel;
        
        [self.titleLabel setText:action.title];
        [self.titleLabel setTextColor:self.tintColor];
        [self.titleLabel setHighlightedTextColor:highlightedTextColor];
        
        if (action.image != nil) {
            [self.imageView setImage:action.image];
            [self.imageView setHighlightedImage:action.highlightedImage != nil ? action.highlightedImage : action.image];
            
            _favoriteSwitch = [MGUFavoriteSwitch new];
            self.favoriteSwitch.mainImage = action.image;
            self.favoriteSwitch.secondaryOnImage = action.image;
            self.favoriteSwitch.imageColorOn = self.tintColor;
            self.favoriteSwitch.imageColorOff = self.tintColor;
            self.favoriteSwitch.rippleColor = self.tintColor;
            self.favoriteSwitch.sparkColor = self.tintColor;
            self.favoriteSwitch.contentsSize = MGUFavoriteSwitchContentsSizeFull;
            self.favoriteSwitch.sparkMode = MGUFavoriteSwitchSparkModeline;
            [self.imageViewContainer addSubview:self.favoriteSwitch];
            //! 결국은 갑춰버린다.
            self.imageView.hidden = YES;
        }
    }
    return self;
}

static void CommonInit(MGUSwipeActionButton *self) {
    self->_spacing = 8.0;
    self->_shouldHighlight = YES;
    self->_maximumImageHeight = 0.0;
    self->_verticalAlignment = MGUSwipeVerticalAlignmentCenterFirstBaseline;
    self->_contentEdgeInsets = UIEdgeInsetsZero;
    self->_imageViewContainer = [UIView new];
    self.imageViewContainer.userInteractionEnabled = NO;
    self.imageViewContainer.backgroundColor = [UIColor clearColor];
}


#pragma mark - 세터 & 게터
- (CGFloat)currentSpacing {
    if (self.currentTitle != nil &&
        [self.currentTitle isEqualToString:@""] == NO &&
        self.imageHeight > 0.0) {
        return self.spacing;
    } else {
        return 0.0;
    }
}

- (NSString *)currentTitle {
    return self.titleLabel.text;
}

- (void)setCurrentTitle:(NSString *)currentTitle {
    [self.titleLabel setText:currentTitle];
}

- (UIImage *)currentImage {
    return self.imageView.image;
}

- (void)setCurrentImage:(UIImage *)currentImage {
    [self.imageView setImage:currentImage];
}

- (CGRect)alignmentRect {
//    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGRect contentRect = self.contentRect;

    CGRect rect =
    [self titleBoundingRectWith:(self.verticalAlignment == MGUSwipeVerticalAlignmentCenterFirstBaseline)? CGRectInfinite.size : contentRect.size];
    CGFloat titleHeight = CGRectIntegral(rect).size.height;

    CGFloat totalHeight = self.imageHeight + titleHeight + self.currentSpacing;

    return MGERectCenteredInRectSize(contentRect, CGSizeMake(contentRect.size.width, totalHeight));
}

- (CGFloat)imageHeight {
    return self.currentImage == nil ? 0.0 : self.maximumImageHeight;
}

//! Lazy
- (UILabel *)titleLabel { // lazy
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)imageView { // lazy
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        [self addSubview:self.imageViewContainer];
        [self.imageViewContainer addSubview:_imageView];
    }
    return _imageView;
}


#pragma mark - Public
- (CGFloat)preferredWidth:(CGFloat)maximum {;
    CGFloat width = maximum > 0.0 ? maximum : DBL_MAX;
    CGFloat textWidth = [self titleBoundingRectWith:CGSizeMake(width, DBL_MAX)].size.width;

    CGFloat imageWidth = 0.0;

    if (self.currentImage != nil) {
        imageWidth = self.currentImage.size.width;
    }

    return MIN(width, MAX(textWidth, imageWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
}


#pragma mark - Helper - UIButton에 존재하는 메서드를 대체하기 위해 똑같이 만들었다.
//! - titleRectForContentRect:
//! - imageRectForContentRect:
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = MGERectCenteredInRect(contentRect, [self titleBoundingRectWith:contentRect.size]);
    rect.origin.y = CGRectGetMinY(self.alignmentRect) + self.imageHeight + self.currentSpacing;
    return CGRectIntegral(rect);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize size = CGSizeZero;
    if (self.currentImage != nil) {
        size = self.currentImage.size;
    }

    CGRect rect = MGERectCenteredInRectSize(contentRect, size);
    rect.origin.y = CGRectGetMinY(self.alignmentRect) + (self.imageHeight - rect.size.height) / 2.0;
    return CGRectIntegral(rect); // 이렇게 해야 origin에서의 긴 소수가 나오면서 살짝 짤리는 현상이 사라지게 된다.
}

//! - contentRectForBounds: UIButton에 존재하는 메서드를 대체하기 위해.
- (CGRect)contentRect {
    return CGRectInset(self.bounds, self.contentEdgeInsets.top, self.contentEdgeInsets.left);
}

#pragma mark - Helper
- (CGRect)titleBoundingRectWith:(CGSize)size {
    if (self.currentTitle != nil) {
        if (self.titleLabel.font != nil) {
            CGRect result = [self.currentTitle boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{ NSFontAttributeName : self.titleLabel.font }
                                                context:nil];
            return CGRectIntegral(result);
        }
    }
    return CGRectZero;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
@end
