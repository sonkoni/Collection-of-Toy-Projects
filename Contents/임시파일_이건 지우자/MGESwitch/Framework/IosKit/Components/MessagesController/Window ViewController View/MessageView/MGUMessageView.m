//
//  MessageView.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/20.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
#import "UIColor+Extension.h"
#import "MGUMessageView.h"
#import "MGUMessagesController.h"


@interface MGUMessageView ()
@property (nonatomic, strong, nullable) NSString *customIdentifier;
@end

@implementation MGUMessageView
@dynamic identifier;

+ (MGUMessageView *)loadMessageViewNibNamed:(MGUMessageViewLayout)nibName
                                   owner:(id _Nullable)owner
                                 options:(NSDictionary<UINibOptionsKey, id> * _Nullable)options {
    if (owner == nil) {
        owner = [NSNull null];
    }
    
    NSBundle *bundle = [NSBundle mgrIosRes];
    if (bundle == nil) {
        NSCAssert(FALSE, @"[NSBundle mgrIosRes]이 발견되지 않았다.");
    }
    
    return [bundle loadNibNamed:nibName owner:owner options:options].lastObject;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // Only accept touches within the background view. Anything outside of the
    // background view's bounds should be transparent and does not need to receive
    // touches. This helps with tap dismissal when using `MGUMessagesDimMode.gray` and `MGUMessagesDimMode.color`.
    return (self.backgroundView == self)? [super pointInside:point withEvent:event]
    : [self.backgroundView pointInside:[self convertPoint:point toView:self.backgroundView] withEvent:event];
}

- (void)setButton:(UIButton *)button {
    UIButton *oldValue = _button;
    _button = button;
    
    if (oldValue != nil) {
        [oldValue removeTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (button != nil) {
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonTapped:(UIButton *)sender {
    if (self.buttonTapHandler != nil) {
        self.buttonTapHandler(sender);
    }
}

#pragma mark - <MGUMessagesIdentifiable>
- (NSString *)identifier {
    if (self.customIdentifier != nil) {
        return self.customIdentifier;
    } else {
        return [NSString stringWithFormat:@"MGUMessageView:title=%@, body=%@", self.titleLabel.text, self.bodyLabel.text];
    }
}

- (void)setIdentifier:(NSString *)identifier {
    self.customIdentifier = identifier;
}

#pragma mark - <MGUMessagesAccessibleMessage>
- (NSString * _Nullable)accessibilityMessage {
    NSMutableArray <NSString *>*components = @[].mutableCopy;
    if (self.accessibilityPrefix != nil) {
        [components addObject:self.accessibilityPrefix];
    }
    if (self.titleLabel.text != nil) {
        [components addObject:self.titleLabel.text];
    }
    if (self.bodyLabel.text != nil) {
        [components addObject:self.bodyLabel.text];
    }
    if (components.count <= 0) {
        return nil;
    }
  
    return [components componentsJoinedByString:@", "];
}

- (NSObject * _Nullable)accessibilityElement {
    return self.backgroundView;
}

- (NSMutableArray * _Nullable)additionalAccessibilityElements {
    NSMutableArray *elements = [NSMutableArray array];
    
    void (^__block getAccessibleSubviews)(UIView *);
    
    __weak __block __typeof(getAccessibleSubviews) weakGetAccessibleSubviews = getAccessibleSubviews = ^(UIView *view) {
        for (UIView *subview in view.subviews) {
            if (subview.isAccessibilityElement == YES) {
                [elements addObject:subview];
            } else {
                // Only doing this for non-accessible `subviews`, which avoids
                // including button labels, etc.
                weakGetAccessibleSubviews(subview);
            }
        }
    };

    getAccessibleSubviews(self.backgroundView);
    return elements;
}


#pragma mark - Action
- (void)configureIconWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    NSMutableArray <UIView *>*views = @[].mutableCopy;
    if (self.iconImageView != nil) {
        [views addObject:self.iconImageView];
    }
    
    if (self.iconLabel != nil) {
        [views addObject:self.iconLabel];
    }
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray <NSLayoutConstraint *>*constraints = @[[view.heightAnchor constraintEqualToConstant:size.height],
                                                       [view.widthAnchor constraintEqualToConstant:size.width]];
        
        constraints[0].priority = 999.0;
        constraints[1].priority = 999.0;
        [view addConstraints:constraints];
        if (MGEIntegerIsNull(contentMode) == NO) {
            view.contentMode = contentMode;
        }
    }];
}

- (void)configureTheme:(MGUMessagesTheme)theme iconStyle:(MGUMessagesIconStyle)iconStyle {
    
    UIImage *iconImage = makeImageWithStyleAndTheme(iconStyle, theme);
    UIColor *backgroundColor;
    UIColor *foregroundColor;
    UIColor *defaultBackgroundColor;
    if (theme == MGUMessagesThemeInfo) {
        defaultBackgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    } else if (theme == MGUMessagesThemeSuccess) {
        defaultBackgroundColor = [UIColor colorWithRed:97.0/255.0 green:161.0/255.0 blue:23.0/255.0 alpha:1.0];
    } else if (theme == MGUMessagesThemeWarning) {
        defaultBackgroundColor = [UIColor colorWithRed:246.0/255.0 green:197.0/255.0 blue:44.0/255.0 alpha:1.0];
    } else if (theme == MGUMessagesThemeError) {
        defaultBackgroundColor = [UIColor colorWithRed:249.0/255.0 green:66.0/255.0 blue:47.0/255.0 alpha:1.0];
    } else { // 딱 4개 밖에 없으므로 안들어온다.
        defaultBackgroundColor = [UIColor colorWithRed:249.0/255.0 green:66.0/255.0 blue:47.0/255.0 alpha:1.0];
    }
    
    
    if (theme == MGUMessagesThemeInfo) {
        backgroundColor = [UIColor mgrColorWithLightModeColor:defaultBackgroundColor
                                                darkModeColor:[UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0]
                                        darkElevatedModeColor:nil];
        
        foregroundColor = [UIColor labelColor];
    } else if (theme == MGUMessagesThemeSuccess) {
        backgroundColor = [UIColor mgrColorWithLightModeColor:defaultBackgroundColor
                                                darkModeColor:[UIColor colorWithRed:55/255.0 green:122/255.0 blue:0/255.0 alpha:1.0]
                                        darkElevatedModeColor:nil];
        foregroundColor = [UIColor whiteColor];
    } else if (theme == MGUMessagesThemeWarning) {
        backgroundColor = [UIColor mgrColorWithLightModeColor:defaultBackgroundColor
                                                darkModeColor:[UIColor colorWithRed:239/255.0 green:184/255.0 blue:10/255.0 alpha:1.0]
                                        darkElevatedModeColor:nil];
        foregroundColor = [UIColor whiteColor];
    } else if (theme == MGUMessagesThemeError) {
        backgroundColor = [UIColor mgrColorWithLightModeColor:defaultBackgroundColor
                                                darkModeColor:[UIColor colorWithRed:195/255.0 green:12/255.0 blue:12/255.0 alpha:1.0]
                                        darkElevatedModeColor:nil];
        foregroundColor = [UIColor whiteColor];
    } else { // 딱 4개 밖에 없으므로 안들어온다.
        backgroundColor = [UIColor mgrColorWithLightModeColor:defaultBackgroundColor
                                                darkModeColor:[UIColor colorWithRed:195/255.0 green:12/255.0 blue:12/255.0 alpha:1.0]
                                        darkElevatedModeColor:nil];
        foregroundColor = [UIColor whiteColor];
    }
    
    [self configureThemeBackgroundColor:backgroundColor
                        foregroundColor:foregroundColor
                              iconImage:iconImage
                               iconText:nil];
}

- (void)configureThemeBackgroundColor:(UIColor *)backgroundColor
                      foregroundColor:(UIColor *)foregroundColor
                            iconImage:(UIImage * _Nullable)iconImage
                             iconText:(NSString * _Nullable)iconText {
    self.iconImageView.image = iconImage;
    self.iconLabel.text = iconText;
    self.iconImageView.tintColor = foregroundColor;
    UIView *backgroundView = (self.backgroundView != nil)? self.backgroundView : self;
    backgroundView.backgroundColor = backgroundColor;
    self.iconLabel.textColor = foregroundColor;
    self.titleLabel.textColor = foregroundColor;
    self.bodyLabel.textColor = foregroundColor;
    self.button.backgroundColor = foregroundColor;
    self.button.tintColor = backgroundColor;
    self.button.contentEdgeInsets = UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0);
    self.button.layer.cornerRadius = 5.0;
    self.iconImageView.hidden = self.iconImageView.image == nil;
    self.iconLabel.hidden = self.iconLabel.text == nil;
}

- (void)configureContentTitle:(NSString * _Nullable)title
                         body:(NSString * _Nullable)body
                    iconImage:(UIImage * _Nullable)iconImage
                     iconText:(NSString * _Nullable)iconText
                  buttonImage:(UIImage * _Nullable)buttonImage
                  buttonTitle:(NSString * _Nullable)buttonTitle
             buttonTapHandler:(void(^_Nullable)(UIButton *button))buttonTapHandler {
    self.titleLabel.text = title;
    self.bodyLabel.text = body;
    self.iconImageView.image = iconImage;
    self.iconLabel.text = iconText;
    [self.button setImage:buttonImage forState:UIControlStateNormal];
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
    self.buttonTapHandler = buttonTapHandler;
    self.iconImageView.hidden = self.iconImageView.image == nil;
    self.iconLabel.hidden = self.iconLabel.text == nil;
}


@end
