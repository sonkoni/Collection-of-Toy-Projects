//
//  MGRFavoriteButton.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 15/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUFavoriteSwitch.h"
#import "MGUFavSwitchRippleLayer.h"
#import "MGUFavSwitchSparkLayer.h"
#import "MGUFavSwitchImgeLayer.h"
@import GraphicsKit;

@interface MGUFavoriteSwitch ()

@property (nonatomic, strong) CALayer *containerLayer;
@property (nonatomic, strong) MGUFavSwitchRippleLayer *rippleLayer;
@property (nonatomic, strong) MGUFavSwitchSparkLayer *sparkLayer;
@property (nonatomic, strong) MGUFavSwitchImgeLayer *imageLayer;
@property (nonatomic, assign, readonly) CATransform3D contensFrameTransform;

@property (nonatomic, assign) BOOL allowDrawing;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL selected_internal;

@end

@implementation MGUFavoriteSwitch
@dynamic contensFrameTransform;
@dynamic useRandomColorOnShineMode;
@dynamic useFlashOnShineMode;

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame
                     imageType:MGUFavoriteSwitchImageTypeNone
                   colorConfig:[MGUFavoriteSwitchColorConfiguration default]];
}

- (instancetype)initWithCoder:(NSCoder *)coder { //! NS_DESIGNATED_INITIALIZER
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
        MGUFavoriteSwitchColorConfiguration *colorConfig = [MGUFavoriteSwitchColorConfiguration default];
        [colorConfig applyConfiguration:self];
        self.mainImage = [UIImage new];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.frame, frame) == NO) {
        self.allowDrawing = YES;
    }
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    if (CGRectEqualToRect(self.bounds, bounds) == NO) {
        self.allowDrawing = YES;
    }
    [super setBounds:bounds];
}

- (BOOL)isSelected {
    return _selected_internal;
}

- (void)setSelected:(BOOL)selected {
    if (_selected_internal != selected) {
        [self setSelected:selected animated:NO notify:NO];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(CGRectZero, self.bounds) == NO ) {
        if (self.allowDrawing == YES || self.isFirst == YES) {
            self.isFirst = NO;
            self.allowDrawing = NO;
            self.containerLayer.transform = CATransform3DIdentity;
            self.containerLayer.frame = MGERectSquareByFittingRect(self.layer.bounds);
            [self createLayersImage]; //! <- 여기에서만 호출되며, 상당히 길다.
            self.containerLayer.transform = self.contensFrameTransform;
        }
    }
}

#pragma mark - 생성 & 소멸
 //! NS_DESIGNATED_INITIALIZER
- (instancetype)initWithFrame:(CGRect)frame
                    imageType:(MGUFavoriteSwitchImageType)imageType
                  colorConfig:(MGUFavoriteSwitchColorConfiguration *)colorConfig {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        if (colorConfig == nil) {
            colorConfig = [MGUFavoriteSwitchColorConfiguration default];
        }
        [colorConfig applyConfiguration:self];
        
        NSArray <UIImage *>*images = MGUFavoriteSwitchImage(imageType);
        self.mainImage = images.firstObject;
        if (images.count == 2) {
            self.secondaryOnImage = images.lastObject;
        }
    }
    return self;
    
}

- (void)commonInit {
    _containerLayer = [CALayer layer];
    self.containerLayer.contentsScale = self.layer.contentsScale;
    self.containerLayer.masksToBounds = NO;
    [self.layer addSublayer:self.containerLayer];
    
    _sparkMode = MGUFavoriteSwitchSparkModeline;
    _selected_internal = NO;
    _allowDrawing = NO;
    _isFirst = YES;
    _contentsSize = MGUFavoriteSwitchContentsSizeDefault; // Size34th, SizeFull

    _rippleLayer = [MGUFavSwitchRippleLayer layer];
    _sparkLayer  = [MGUFavSwitchSparkLayer layer];
    _imageLayer  = [MGUFavSwitchImgeLayer layer];

    self.duration = 1.0f; // 여기서 setter로 설정해야한다.

    [self addTarget:self action:@selector(showHighlight:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(showHighlight:) forControlEvents:UIControlEventTouchDragEnter];

    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(showUnHighlight:) forControlEvents:UIControlEventTouchCancel];
    
    [self addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 세터 & 게터
//! 이미지를 설정(set method 호출)하면, - _createLayersImage: 메서드가 호출된다.
- (void)setMainImage:(UIImage *)mainImage {
    _mainImage = mainImage;
    self.allowDrawing = YES;
    [self setNeedsLayout];
}

- (void)setSecondaryOnImage:(UIImage *)secondaryOnImage {
    _secondaryOnImage = secondaryOnImage;
    self.allowDrawing = YES;
    [self setNeedsLayout];
}

//! sizse를 설정하면, - _createLayersImage: 메서드가 호출된다.
- (void)setContentsSize:(MGUFavoriteSwitchContentsSize)contentsSize {
    _contentsSize = contentsSize;
    self.allowDrawing = YES;
    [self setNeedsLayout];
}

- (CATransform3D)contensFrameTransform {
    if (self.contentsSize == MGUFavoriteSwitchContentsSizeDefault) {
        return CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1.0);
    } else if (self.contentsSize == MGUFavoriteSwitchContentsSize34th) {
        return CATransform3DScale(CATransform3DIdentity, (3.0f / 4.0f), (3.0f / 4.0f), 1.0);
    } else {
        return CATransform3DIdentity;
    }
}

- (void)setImageColorOn:(UIColor *)imageColorOn {
    _imageColorOn = imageColorOn;
    self.imageLayer.imageColorOn = imageColorOn;
    if (self.isSelected) {
        if (self.secondaryOnImage == nil) {
            self.imageLayer.backgroundColor = self.imageColorOn.CGColor;
        } else {
            self.imageLayer.backgroundColor = UIColor.clearColor.CGColor;
        }
    }
}

- (void)setImageColorOff:(UIColor *)imageColorOff {
    _imageColorOff = imageColorOff;
    self.imageLayer.imageColorOff = imageColorOff;
    if (!self.isSelected) {
        if (self.secondaryOnImage == nil) {
            self.imageLayer.backgroundColor = self.imageColorOff.CGColor;
        } else {
            self.imageLayer.backgroundColor = UIColor.clearColor.CGColor;
        }
    }
}

- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
    self.rippleLayer.backgroundColor = rippleColor.CGColor;
}

- (void)setSparkColor:(UIColor *)sparkColor {
    _sparkColor = sparkColor;
    self.sparkLayer.sparkColor = sparkColor;
}

- (void)setSparkColor2:(UIColor *)sparkColor2 {
    _sparkColor2 = sparkColor2;
    self.sparkLayer.sparkColor2 = sparkColor2;
}

- (void)setDuration:(CGFloat)duration {
    _duration = duration;
    self.rippleLayer.timeDuration = duration;
    self.sparkLayer.timeDuration  = duration;
    self.imageLayer.timeDuration  = duration;
}

- (void)setSparkMode:(MGUFavoriteSwitchSparkMode)sparkMode {
    _sparkMode = sparkMode;
    self.sparkLayer.sparkMode = sparkMode;
    self.allowDrawing = YES;
    [self setNeedsLayout];
}

//--- 연결 프라퍼티 only dynamic ---//
- (BOOL)useFlashOnShineMode {
    return self.sparkLayer.useFlashOnShineMode;
}

- (void)setUseFlashOnShineMode:(BOOL)useFlashOnShineMode {
    self.sparkLayer.useFlashOnShineMode = useFlashOnShineMode;
}

- (BOOL)useRandomColorOnShineMode {
    return self.sparkLayer.useRandomColorOnShineMode;
}

- (void)setUseRandomColorOnShineMode:(BOOL)useRandomColorOnShineMode {
    self.sparkLayer.useRandomColorOnShineMode = useRandomColorOnShineMode;
}


#pragma mark - 컨트롤
//! Target Action
- (void)showHighlight:(MGUFavoriteSwitch *)sender {
    self.layer.opacity = 0.4;
}

- (void)showUnHighlight:(MGUFavoriteSwitch *)sender {
    self.layer.opacity = 1.0;
}

- (void)didTouchUpInside:(id)sender {
    [self setSelected:!_selected_internal animated:YES notify:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated notify:(BOOL)notify {
    if (selected != _selected_internal) {
        _selected_internal = selected;
        [super setSelected:selected];
        
        if (selected == NO) {
            [self deselect]; // deselect는 딱히 애니메이션이 없다.
        } else {
            [self selectWithAnimated:animated];
        }
        
        if (notify == YES) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


#pragma mark - Private
- (void)selectWithAnimated:(BOOL)animated {
    self.imageLayer.selected = YES;
    // self.imageLayer.backgroundColor = self.imageColorOn.CGColor;
    if (animated == YES) {
        [CATransaction begin];
        [self.imageLayer startImgeAnimation];
        
        [self.rippleLayer startRippleAnimation];
        
        if (self.sparkMode == MGUFavoriteSwitchSparkModeShine) {
            __weak __typeof(self)weakSelf = self;
            self.rippleLayer.completionBlock = ^{
                __strong __typeof(weakSelf) self = weakSelf;
                [self.sparkLayer startSparkAnimation];
            };
        } else {
            [self.sparkLayer startSparkAnimation];
        }
        
        [CATransaction commit];
    } else {
        [self removeAnimations];
    }
}

- (void)deselect {
    self.imageLayer.selected = NO;
    //self.imageLayer.backgroundColor = self.imageColorOff.CGColor;
    [self removeAnimations];
}

- (void)removeAnimations {
    [self.rippleLayer stopRippleAnimation];
    [self.sparkLayer stopSparkAnimation];
    [self.imageLayer stopImgeAnimation];
}

- (void)createLayersImage {
    for (CALayer *layer in self.containerLayer.sublayers.reverseObjectEnumerator) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer.transform = CATransform3DIdentity;
        [CATransaction commit];
        [layer removeFromSuperlayer];
    }
    self.containerLayer.sublayers = nil; //UIButton을 쓰면 안된다. UIButton에서는 size가 변경되면, _UILabelLayer가 생성되버린다.
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.rippleLayer.transform = CATransform3DIdentity;
    self.sparkLayer.transform = CATransform3DIdentity;
    self.imageLayer.transform = CATransform3DIdentity;
    [CATransaction commit];
    
    self.rippleLayer.frame  = self.layer.bounds;
    self.sparkLayer.frame   = self.layer.bounds;
    self.imageLayer.frame   = self.layer.bounds;
    
    [self.containerLayer addSublayer:self.rippleLayer];
    [self.containerLayer addSublayer:self.sparkLayer];
    [self.containerLayer addSublayer:self.imageLayer];
    
    //[self.imageLayer setupImgeLayerAnimationWith:self.image];
    [self.imageLayer setupImgeLayerAnimationWith:self.mainImage image:self.secondaryOnImage];
    [self.rippleLayer setupRippleLayerAnimation];
    [self.sparkLayer setupSparkLayerAnimation];
}

@end
