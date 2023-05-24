//
//  SharedUtil.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/04/23.
//

@import BaseKit;
@import IosKit;
#import "SharedUtil.h"

@implementation IndicatorView

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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.color set];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path fill];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    _color = [UIColor clearColor];
}


#pragma mark - 세터 & 게터
- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

@end

NSString * _Nullable ActionDescriptorTitleForDisplayMode(ActionDescriptor descriptor, ButtonDisplayMode displayMode) {
    if (displayMode == imageOnly) {
        return nil;
    }
    
    if (descriptor == ActionDescriptorRead) {
        return @"Read";
    } else if (descriptor == ActionDescriptorUnread) {
        return @"Unread";
    } else if (descriptor == ActionDescriptorMore) {
        return @"More";
    } else if (descriptor == ActionDescriptorFlag) {
        return @"Flag";
    } else if (descriptor == ActionDescriptorTrash) {
        return @"Trash";
    } else {
        NSCAssert(FALSE, @"잘못된 ActionDescriptor 값");
        return nil;
    }
}


UIImage * _Nullable ActionDescriptorImageForStyle(ActionDescriptor descriptor,
                                                  ButtonStyle style,
                                                  ButtonDisplayMode displayMode) {
    
    if (displayMode == titleOnly) {
        return nil;
    }
    
    NSString *name;
    if (descriptor == ActionDescriptorRead) {
        name = @"Read";
    } else if (descriptor == ActionDescriptorUnread) {
        name = @"Unread";
    } else if (descriptor == ActionDescriptorMore) {
        name = @"More";
    } else if (descriptor == ActionDescriptorFlag) {
        name = @"Flag";
    } else if (descriptor == ActionDescriptorTrash) {
        name = @"Trash";
    } else {
        NSCAssert(FALSE, @"잘못된 ActionDescriptor 값");
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 130000 // Deployment Target 이 13.0이다. 기계가 13 이상부터 다 들어온다.
    if (descriptor == ActionDescriptorRead) {
        name = @"envelope.open.fill";
    } else if (descriptor == ActionDescriptorUnread) {
        name = @"envelope.badge.fill";
    } else if (descriptor == ActionDescriptorMore) {
        name = @"ellipsis.circle.fill";
    } else if (descriptor == ActionDescriptorFlag) {
        name = @"flag.fill";
    } else if (descriptor == ActionDescriptorTrash) {
        name = @"trash.fill";
    } else {
        NSCAssert(FALSE, @"잘못된 ActionDescriptor 값");
    }

    if (style == backgroundColor) {
        UIImageSymbolConfiguration *config =
            [UIImageSymbolConfiguration configurationWithPointSize:23.0
                                                            weight:UIImageSymbolWeightRegular];
        UIImage *image = [UIImage systemImageNamed:name withConfiguration:config];
        image = [image mgrImageWithColor:[UIColor whiteColor]];
        return [image imageWithTintColor:[UIColor whiteColor]
                           renderingMode:UIImageRenderingModeAlwaysOriginal];
        
    } else {
        UIImageSymbolConfiguration *config =
            [UIImageSymbolConfiguration configurationWithPointSize:22.0
                                                            weight:UIImageSymbolWeightRegular];
        
        UIImage *image = [UIImage systemImageNamed:name withConfiguration:config];
        image = [image mgrImageWithColor:[UIColor whiteColor]];
        image = [image imageWithTintColor:[UIColor whiteColor]
                            renderingMode:UIImageRenderingModeAlwaysOriginal];
        return ActionDescriptorCircularIconWith(descriptor,
                                                ActionDescriptorColorForStyle(descriptor, style),
                                                CGSizeMake(50.0, 50.0),
                                                image);
    }
#else
    if (@available(iOS 13, *)) {
        if (descriptor == ActionDescriptorRead) {
            name = @"envelope.open.fill";
        } else if (descriptor == ActionDescriptorUnread) {
            name = @"envelope.badge.fill";
        } else if (descriptor == ActionDescriptorMore) {
            name = @"ellipsis.circle.fill";
        } else if (descriptor == ActionDescriptorFlag) {
            name = @"flag.fill";
        } else if (descriptor == ActionDescriptorTrash) {
            name = @"trash.fill";
        } else {
            NSCAssert(FALSE, @"잘못된 ActionDescriptor 값");
        }

        if (style == backgroundColor) {
            UIImageSymbolConfiguration *config =
                [UIImageSymbolConfiguration configurationWithPointSize:23.0
                                                                weight:UIImageSymbolWeightRegular];
            UIImage *image = [UIImage systemImageNamed:name withConfiguration:config];
            return [image imageWithTintColor:[UIColor whiteColor]
                               renderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            UIImageSymbolConfiguration *config =
                [UIImageSymbolConfiguration configurationWithPointSize:22.0
                                                                weight:UIImageSymbolWeightRegular];
            
            UIImage *image = [UIImage systemImageNamed:name withConfiguration:config];
            image = [image imageWithTintColor:[UIColor whiteColor]
                                renderingMode:UIImageRenderingModeAlwaysOriginal];
            
            return ActionDescriptorCircularIconWith(descriptor,
                                                    ActionDescriptorColorForStyle(descriptor, style),
                                                    CGSizeMake(50.0, 50.0),
                                                    image);
        }
    } else {
        if (style == backgroundColor) {
            return [UIImage imageNamed:name];
        } else {
            return [UIImage imageNamed:[NSString stringWithFormat:@"%@-circle", name]];
        }
    }
#endif
}

UIImage * _Nullable ActionDescriptorCircularIconWith(ActionDescriptor descriptor,
                                                     UIColor *color,
                                                     CGSize size,
                                                     UIImage * _Nullable icon) {
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    
    [color setFill];
    UIRectFill(rect);
        
    if (icon != nil) {
        CGRect iconRect = CGRectMake((rect.size.width - icon.size.width) / 2.0,
                                     (rect.size.height - icon.size.height) / 2.0,
                                     icon.size.width,
                                     icon.size.height);
        
        [icon drawInRect:iconRect blendMode:kCGBlendModeNormal alpha:1.0];
    }

    MGR_DEFER {
        UIGraphicsEndImageContext();
    };
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

UIColor * ActionDescriptorColorForStyle(ActionDescriptor descriptor,
                                        ButtonStyle style) {

    if (descriptor == ActionDescriptorRead || descriptor == ActionDescriptorUnread) {
        return [UIColor systemBlueColor];
    } else if (descriptor == ActionDescriptorMore) {
        UITraitCollection *currentTraitCollection = [UITraitCollection currentTraitCollection];
        if (currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor systemGrayColor];
        }
        return (style == backgroundColor)? [UIColor systemGray3Color] : [UIColor systemGray2Color];
    } else if (descriptor == ActionDescriptorFlag) {
        return [UIColor systemOrangeColor];
    } else if (descriptor == ActionDescriptorTrash) {
        return [UIColor systemRedColor];
    } else {
        NSCAssert(FALSE, @"뭔가 잘못됬어.");
        return [UIColor redColor];
    }
}
