//
//  MGUNeoSeg.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUNeoSeg.h"
#import "MGUNeoSegConfiguration.h"
#import "MGUNeoSegModel.h"
#import "MGUImageDownloader.h"
#import "UIView+AutoLayout.h"

extern CGFloat MGUNeoSegControlMinimumScale;
extern CGFloat MGUNeoSegControlHalfShinkRatio;

static CGFloat const kMinimumSegmentWidth = 64.0f; //! 각 세그먼트의 최소의 폭은 64.0으로 확보한다.

@interface MGUNeoSeg ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) MGUNeoSegModel *model;
@property (nonatomic, strong) MGUImageDownloader *imageDownload; // lazy
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *templateImage;
@end

@implementation MGUNeoSeg

//! 인수로 주어진 size에 가장 적합한 size를 계산하고 반환하도록 뷰에 요청한다. Api:UIKit/UIView/- sizeThatFits: 참고.
- (CGSize)sizeThatFits:(CGSize)size {
    //CGSize sizeThatFits = [self.titleView sizeThatFits:size];
    CGSize sizeThatFits = [self.titleLabel sizeThatFits:size];
    return CGSizeMake(MAX(sizeThatFits.width * 1.4f, kMinimumSegmentWidth), sizeThatFits.height);
    //
    // 이 메서드의 디폴트의 구현은, view의 기존의 size를 돌려준다.
    // 이 메서드는, 리시버의 사이즈를 변경하지 않는다.
    // MGUSegmentTextRenderView의 sizeThatFits:를 이용한며, 본 메서드는 MGUSegmentedControl의 sizeThatFits: 메서드에서 이용된다.
}

- (NSString *)accessibilityLabel {
    return self.titleLabel.text;
    //return self.titleView.text;
    //
    // voice over 같은 앱에게 self(세그먼트)에게 버턴의 이름을 알려준다.
    // 버튼이나 스위치 같은 정보를 포함해서는 안된다. 이것은 self.accessibilityTraits = super.accessibilityTraits | UIAccessibilityTraitButton; 으로 알려준다.
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithSegmentModel:(MGUNeoSegModel *)model
                              config:(MGUNeoSegConfiguration *)config {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    if (self) {
        _model = model;
        
        // 다른 앱(voice over 같은)에서의 접근성을 의미한다. 시각 장애인에게 self 객체가 버튼이라는 것을 알려준다.
        self.isAccessibilityElement = YES;
        //The accessibility element should be treated as a button.
        self.accessibilityTraits = super.accessibilityTraits | UIAccessibilityTraitButton;
        self.userInteractionEnabled = NO; // userInteractionEnabled을 NO로 하는 이유는 인디케이터가 밑에 있기 때문이다.
        // 전체 세그먼트 컨트롤 바로 위에 인디케이터가 존재하고 그 위 세그먼트들과 각 라벨이 존재한다.
        
        _stackViewAxis = config.segmentContentsAxis;
        _stackViewSpacing = config.segmentContentsSpacing;
        
        //! 아래 7개는 - setSegmentState: 에서 설정되며, control의 - layoutSubView에서 적용될 것이다.
        _font                 = config.titleFont;
        _selectedFont         = config.selectedTitleFont;
        _titleColor            = config.titleColor;
        _selectedTitleColor    = config.selectedTitleColor;
        _imageTintColor         = config.imageTintColor;
        _selectedImageTintColor = config.selectedImageTintColor;
        _isSelectedTextGlowON = config.isSelectedTextGlowON;
        
        
        _containerView = [UIView new];
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
        [self.containerView mgrPinEdgesToSuperviewCustomMargins:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];

        _stackView = self.stackView = [[UIStackView alloc] init];
        self.stackView.axis = config.segmentContentsAxis;
        self.stackView.spacing = config.segmentContentsSpacing;
        self.stackView.distribution = UIStackViewDistributionFill;
        self.stackView.alignment = UIStackViewAlignmentCenter;
        [self.containerView addSubview:self.stackView];
        [self.stackView mgrPinCenterToSuperviewCenterWithInner]; // 센터를 수퍼뷰에 맞추면서 수퍼뷰보다는 width height 이하.
        
        _imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.stackView addArrangedSubview:self.imageView];
        [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.heightAnchor].active = YES;
        _imageViewHeightLayoutConstraint =
        [self.imageView.heightAnchor constraintEqualToConstant:config.imageViewSize];
        //! 현재 self size.height 0.0이므로 높이 15.0을 잡지 못해 AutoLayout 버그 메시지가 나온다. 최초 frame size를 50.0 50.0으로 주자.
        self.imageViewHeightLayoutConstraint.active = YES;
        
        _titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.layer.shadowColor = self.selectedTitleColor.CGColor;
        self.titleLabel.layer.shadowRadius = 1.0f;
        self.titleLabel.layer.shadowOpacity = 0.0; // 이걸로 키자.
        self.titleLabel.layer.shadowOffset = CGSizeZero;
        [self.stackView addArrangedSubview:self.titleLabel];
        [self initializeTitle];
        [self initializeImage:(MGUNeoSegConfiguration *)config];

    }
    return self;
}

+ (instancetype)segmentWithSegmentModel:(MGUNeoSegModel *)model config:(MGUNeoSegConfiguration *)config {
    return [[MGUNeoSeg alloc] initWithSegmentModel:model config:config];
}

- (void)initializeTitle {
    NSString *title = self.model.title;
    if (title != nil) {
        self.titleLabel.text = title;
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = YES;
    }
}

- (void)initializeImage:(MGUNeoSegConfiguration *)config {
    if (self.model.imageUrl != nil) {
        __weak __typeof(self)weakSelf = self;
        [self.imageDownload downloadImageUrl:self.model.imageUrl
                                completion:^(UIImage * _Nonnull image,
                                             NSURL * _Nonnull url,
                                             NSError * _Nonnull error) {
            __strong __typeof(weakSelf) self = weakSelf;
            if (image == nil) {
                return;
            }
                
            if ([self.model.imageUrl isEqual:url] == NO) {
                return;
            }
                
            self.templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            if (config.imageRenderingMode == UIImageRenderingModeAlwaysTemplate) {
                self.imageView.image = self.templateImage;
            } else {
                self.imageView.image = self.originalImage;
            }
        }];

        return;
    }
    
    NSString *imageName = self.model.imageName;
    if (imageName == nil) {
        self.imageView.hidden = YES;
    } else {
        UIImage *image = [UIImage imageNamed:imageName]; // 메인 번들을 부를 것이다.
        self.templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (image == nil) {
            self.imageView.hidden = YES;
        } else {
            if (config.imageRenderingMode == UIImageRenderingModeAlwaysTemplate) {
                self.imageView.image = self.templateImage;
            } else {
                self.imageView.image = self.originalImage;
            }
            self.imageView.hidden = NO;
        }
    }
}


#pragma mark - 세터 & 게터
- (MGUImageDownloader *)imageDownload { //! lazy
    if (_imageDownload == nil) {
        _imageDownload = [MGUImageDownloader new];
    }
    return _imageDownload;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    //! 시각 장애인에게 알려줄 수 있다.
    if (selected) {
        self.accessibilityTraits = self.accessibilityTraits | UIAccessibilityTraitSelected;
    } else {
        self.accessibilityTraits = self.accessibilityTraits & ~UIAccessibilityTraitSelected;
    }
}

- (void)setSegmentState:(MGUNeoSegState)segmentState { // control의 layoutSubviews에서 때려준다.
    _segmentState = segmentState;
    if (segmentState == MGUNeoSegStateNoIndicator) { // 평범한 상태
        self.titleLabel.textColor = self.titleColor;
        self.titleLabel.font = self.font;
        self.imageView.tintColor = self.imageTintColor;
        self.titleLabel.layer.shadowOpacity = 0.0f;
    } else {
        self.titleLabel.textColor = self.selectedTitleColor;
        self.titleLabel.font = self.selectedFont;
        self.imageView.tintColor = self.selectedImageTintColor;
        if (self.isSelectedTextGlowON == YES) {
            self.titleLabel.layer.shadowOpacity = 1.0f;
        } else {
            self.titleLabel.layer.shadowOpacity = 0.0f;
        }
    }
}

- (void)setStackViewAxis:(UILayoutConstraintAxis)stackViewAxis {
    _stackViewAxis = stackViewAxis;
    self.stackView.axis = stackViewAxis;
}

- (void)setStackViewSpacing:(CGFloat)stackViewSpacing {
    _stackViewSpacing = stackViewSpacing;
    self.stackView.spacing = stackViewSpacing;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTextColor {
    _selectedTitleColor = selectedTextColor;
    self.titleLabel.layer.shadowColor = selectedTextColor.CGColor;
}


#pragma mark - Action
- (void)setImageRenderingMode:(UIImageRenderingMode)imageRenderingMode {
    if (imageRenderingMode == UIImageRenderingModeAlwaysTemplate) {
        self.imageView.image = self.templateImage;
    } else {
        self.imageView.image = self.originalImage;
    }
}

- (void)setHighlight:(BOOL)highlight {
    if (_highlight == highlight) {
        return;
    }
    
    _highlight = highlight;
    
    
    CGFloat highlightOpacity = 0.2;
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    if (self.highlight == YES) {
        if (self.layer.presentationLayer != nil) {
            CGFloat opacity  = self.layer.presentationLayer.opacity;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.layer.opacity = opacity; //! 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
            [CATransaction commit];
            
        } else {
            opacityAnimation.fromValue = @(1.0);
        }
        
        opacityAnimation.toValue   = @(highlightOpacity);
    } else {
        if (self.layer.presentationLayer != nil) {
            CGFloat opacity  = self.layer.presentationLayer.opacity;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.layer.opacity = opacity; //! 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
            [CATransaction commit];
        } else {
            opacityAnimation.fromValue = @(highlightOpacity);
        }
        
        opacityAnimation.toValue   = @(1.0);
    }
    
    opacityAnimation.duration  = 0.3f;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    opacityAnimation.fillMode       = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    [CATransaction setCompletionBlock:^{
        self.layer.opacity = 1.0f;
    }];
    
    // key 를 반드시 동일한 걸로 입력하라. nil 안됨.
    [self.layer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [CATransaction commit];

}

- (void)setShrink:(BOOL)shrink {
    if (_shrink == shrink) {
        return;
    }
    
    _shrink = shrink;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    if (self.shrink == YES) {
        if (self.layer.presentationLayer != nil) {
            CATransform3D transform  = self.layer.presentationLayer.transform;
            scaleAnimation.fromValue = @(transform); // <- 현재 스케일에 해당한다.
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.layer.transform = transform; //! 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
            [CATransaction commit];
            
        } else {
            scaleAnimation.fromValue = @(CATransform3DIdentity);
        }
        scaleAnimation.toValue   = @([self targetShrinkTransform3D]);
    } else {
        if (self.layer.presentationLayer != nil) {
            CATransform3D transform  = self.layer.presentationLayer.transform;
            scaleAnimation.fromValue = @(transform); // <- 현재 스케일에 해당한다.
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.layer.transform = transform; //! 이렇게 잡아줘야 깜빡거림을 없앨 수 있다.
            [CATransaction commit];
        } else {
            scaleAnimation.fromValue   = @([self targetShrinkTransform3D]);
        }
        
        scaleAnimation.toValue   = @(CATransform3DIdentity);
    }
    
    scaleAnimation.duration  = 0.2f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    scaleAnimation.fillMode          = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    
    [CATransaction setCompletionBlock:^{
        self.layer.transform = CATransform3DIdentity;
    }];
    
    // key 를 반드시 동일한 걸로 입력하라. nil 안됨.
    [self.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [CATransaction commit];
}


#pragma mark - Helper
//! 제일 왼쪽에 있을 경우, 왼쪽으로 더 움직여주고, 제일 오른쪽에 있을 경우, 오른쪽으로 더 움직여준다.
- (CATransform3D)targetShrinkTransform3D {
    //! Scale을 변화시켜도 bounds는 유지된다. 이를 이용하자.
    CGFloat bottom = self.bounds.size.height * MGUNeoSegControlHalfShinkRatio; // 아래에서 줄어든 길이
    CGFloat side = self.bounds.size.width * MGUNeoSegControlHalfShinkRatio; // 옆에서 줄어든 길이
    CGFloat shiftValue = ABS(side - bottom);
    
    UIStackView *mySuperView = (UIStackView *)self.superview;
    NSArray <MGUNeoSeg *>*segments = mySuperView.arrangedSubviews;
    
    CATransform3D transform = CATransform3DIdentity;
    if (self == segments.firstObject) {
        transform = CATransform3DTranslate(CATransform3DIdentity, -shiftValue, 0.0, 0.0);
    } else if (self == segments.lastObject) {
        transform = CATransform3DTranslate(CATransform3DIdentity, +shiftValue, 0.0, 0.0);
    }
    
    return CATransform3DScale(transform, MGUNeoSegControlMinimumScale, MGUNeoSegControlMinimumScale, 1.0);
}

@end
