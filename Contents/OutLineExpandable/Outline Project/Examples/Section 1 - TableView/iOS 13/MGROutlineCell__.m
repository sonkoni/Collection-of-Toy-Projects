//
//  MGROutlineCell.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/09/02.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGROutlineCell.h"
#import "UIColor+MGRIosKit.h"
#import "UIView+MGRIosKit.h"

@interface UIImage (XXX)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage (XXX)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    CGFloat radians = degrees * M_PI / 180.0;

    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    CGSize rotatedSize = CGRectIntegral(rotatedViewBox.frame).size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);

    CGContextRotateCTM(bitmap, radians);

    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2 , self.size.width, self.size.height), self.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end


@interface MGROutlineCell ()

//! 다음은 Lazy
@property (nonatomic, readonly) UIImage *chevron; // lazy
@property (nonatomic, readonly) UIImage *highlightedChevron; // lazy
@property (nonatomic, readonly) UIImage *circleFill; // lazy
@property (nonatomic, readonly) UIImage *highlightedCircleFill; // lazy
@property (nonatomic, strong) UIColor *cornflowerBlue;
@end

@implementation MGROutlineCell
@synthesize chevron = _chevron;
@synthesize highlightedChevron = _highlightedChevron;
@synthesize circleFill = _circleFill;
@synthesize highlightedCircleFill = _highlightedCircleFill;

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
    _expanded = NO;
    _group = NO;
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

- (UIImage *)chevron {
    if (_chevron == nil) {
        BOOL rtl = self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
        NSString *chevron = rtl ? @"chevron.left.circle.fill" : @"chevron.right.circle.fill";
        UIImage *image = [UIImage systemImageNamed:chevron];
        _chevron = [image imageWithTintColor:[self cornflowerBlue]
                               renderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _chevron;
}

- (UIImage *)highlightedChevron {
    if (_highlightedChevron == nil) {
        BOOL rtl = self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
        NSString *chevron = rtl ? @"chevron.left.circle.fill" : @"chevron.right.circle.fill";
        UIImage *image = [UIImage systemImageNamed:chevron];
        _highlightedChevron = [image imageWithTintColor:[UIColor grayColor]
                                          renderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _highlightedChevron;
}

- (UIImage *)circleFill {
    if (_circleFill == nil) {
        NSString *circleFill = @"circle.fill";
        UIImage *image = [UIImage systemImageNamed:circleFill];
        _circleFill = [image imageWithTintColor:[self cornflowerBlue]
                               renderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _circleFill;
}

- (UIImage *)highlightedCircleFill {
    if (_highlightedCircleFill == nil) {
        NSString *circleFill = @"circle.fill";
        UIImage *image = [UIImage systemImageNamed:circleFill];
        _highlightedCircleFill = [image imageWithTintColor:[UIColor grayColor]
                               renderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _highlightedCircleFill;
}


#pragma mark - Action
- (void)configureChevron {
    BOOL rtl = self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;

    BOOL highlighted = self.isHighlighted || self.isSelected;
    CGFloat rtlMultiplier = rtl ? -1.0 : 1.0;
    CGAffineTransform rotationTransform = self.expanded ? CGAffineTransformMakeRotation(rtlMultiplier * M_PI / 2) : CGAffineTransformIdentity;

    UIListContentConfiguration *contentConfiguration = ((UIListContentConfiguration *)self.contentConfiguration != nil) ?
        (UIListContentConfiguration *)self.contentConfiguration : [self defaultContentConfiguration];
    
    UIColor *tintColor = (highlighted == NO) ? [self cornflowerBlue]: [UIColor grayColor];
    UIImage *chevron = (highlighted == NO) ? [self chevron]: [self highlightedChevron];
    UIImage *circleFill = (highlighted == NO) ? [self circleFill]: [self highlightedCircleFill];
    
    if (@available(iOS 14, *)) {
        NSArray <UIImageView *>*imageViews = [self mgrRecurrenceAllSubviewsOfType:[UIImageView class]];
        if (self.isGroup == YES) {
//            for (UIImageView *imageView in imageViews) {
//                imageView.image = [self chevron];
//                imageView.highlightedImage = [self highlightedChevron];
//                imageView.tintColor = tintColor;
//                imageView.transform = rotationTransform;
//            }
//            contentConfiguration.image = chevron;
            contentConfiguration.image = [UIImage systemImageNamed:@"chevron.right.circle.fill"];
            
        } else {
//            for (UIImageView *imageView in imageViews) {
//                imageView.image = [self circleFill];
//                imageView.highlightedImage = [self highlightedCircleFill];
//                imageView.tintColor = tintColor;
//                imageView.transform = CGAffineTransformIdentity;
//            }
//            contentConfiguration.image = circleFill;
            contentConfiguration.image = [UIImage systemImageNamed:@"circle.fill"];
        }
//        contentConfiguration.imageProperties.tintColor = tintColor;
        self.contentConfiguration = contentConfiguration;
    } else {
        if (self.isGroup == YES) {
            self.imageView.image = [self chevron];
            self.imageView.highlightedImage = [self highlightedChevron];
            self.imageView.transform = rotationTransform;
        } else {
            self.imageView.image = [self circleFill];
            self.imageView.highlightedImage = [self highlightedCircleFill];
            self.imageView.transform = CGAffineTransformIdentity;
        }
        self.imageView.tintColor = tintColor;
    }
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }

//! Avoid calling this method directly. Instead, use setNeedsUpdateConfiguration to request an update.
- (void)updateConfigurationUsingState:(UICellConfigurationState *)state {
    [super updateConfigurationUsingState:state];
    
    UIListContentConfiguration *contentConfiguration = ((UIListContentConfiguration *)self.contentConfiguration != nil) ?
        (UIListContentConfiguration *)self.contentConfiguration : [self defaultContentConfiguration];
    
    UIListContentConfiguration *contentConfig = [contentConfiguration updatedConfigurationForState:state];
//
//    contentConfig.text = @"Hello World";
//    contentConfig.image = [UIImage systemImageNamed:@"bell"];

//    UIBackgroundConfiguration *backgroundConfig = [[self backgroundConfiguration] updatedConfigurationForState:state];
//    backgroundConfig.backgroundColor = [UIColor purpleColor];

    if (state.isHighlighted || state.isSelected) {
//        backgroundConfig.backgroundColor = [UIColor orangeColor];
//        contentConfig.textProperties.color = [UIColor redColor];
//        contentConfig.imageProperties.tintColor = [UIColor yellowColor];
        contentConfig.imageProperties.tintColor = [UIColor redColor];
        NSLog(@"?????");
    } else {
        contentConfig.imageProperties.tintColor = [UIColor greenColor];
    }
    
    self.contentConfiguration = contentConfig;
//    self.backgroundConfiguration = backgroundConfig;
}

@end





//
//            contentConfiguration.text = outlineItem.contentItem.title;
//            contentConfiguration.textProperties.font =
//            [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//            cell.contentConfiguration = contentConfiguration;
////            cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
