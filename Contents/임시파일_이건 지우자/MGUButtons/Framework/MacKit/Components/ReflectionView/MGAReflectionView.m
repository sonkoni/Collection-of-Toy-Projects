//
//  MGAReflectionView.m
//
//  Created by Kwan Hyun Son on 2020/07/30.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGAReflectionView.h"
#import "MGAImageView.h"
#import "NSView+Extension.h"
#import "MGALayerBackedView.h"
#import <QuartzCore/QuartzCore.h>

static void *MGAReflectionViewKVOContext = &MGAReflectionViewKVOContext;

@interface MGAReflectionView ()
@property (nonatomic, weak) MGAImageView *originalImageView;
@property (nonatomic, strong) MGALayerBackedView *containerView;
@property (nonatomic, strong) MGAImageView *imageView;
@property (nonatomic, strong) CAGradientLayer *gradientMaskLayer;
@end

@implementation MGAReflectionView
@dynamic image;
@dynamic contentMode;
@dynamic alpha;

- (void)dealloc {
    [self removeObserver];
}

- (NSView *)hitTest:(NSPoint)point {
    return nil; // userInteractionEnabled -- NO
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame alpha:1.0 location:1.0 originalImageView:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layout {
    [super layout];
    self.containerView.frame = self.bounds;
    [self.containerView mgrSetAnchorPoint:CGPointMake(0.5, 0.5)];
    self.containerView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 1.0, 0.0, 0.0); // 뒤집기.
    self.imageView.frame = self.containerView.bounds;
    self.gradientMaskLayer.frame = self.containerView.layer.bounds;
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                        alpha:(CGFloat)alpha
                     location:(CGFloat)location
            originalImageView:(MGAImageView * _Nullable)originalImageView {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
        self.containerView.layer.opacity = alpha;
        [self updateGradientLocation:location];
        [self setOriginalImageView:originalImageView]; // 세터로 접근해야한다.
    }
    return self;
}

static void CommonInit(MGAReflectionView *self) {
    self->_containerView = [MGALayerBackedView new];
    self->_imageView = [MGAImageView new];
    self->_gradientMaskLayer = [CAGradientLayer layer];
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.imageView];
    self.containerView.layer.mask = self.gradientMaskLayer;

    self.containerView.frame = self.bounds;
    [self.containerView mgrSetAnchorPoint:CGPointMake(0.5, 0.5)];
    self.imageView.frame = self.containerView.bounds;
    self.gradientMaskLayer.frame = self.containerView.layer.bounds;
    self.containerView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 1.0, 0.0, 0.0); // 뒤집기.
    self.imageView.contentMode = kCAGravityResize;
    [self maskLayerSetUpConfiguration];
}

- (void)maskLayerSetUpConfiguration {
    //! 뒤집힌다는 것을 유념하자.
    self.gradientMaskLayer.type = kCAGradientLayerAxial;
    self.gradientMaskLayer.colors = @[(id)[[NSColor colorWithWhite:0.0 alpha:0.0] CGColor],
                                      (id)[[NSColor colorWithWhite:0.0 alpha:0.0] CGColor],
                                      (id)[[NSColor redColor] CGColor]];
    self.gradientMaskLayer.locations = @[@(0.0), @(0.0), @(1.0)]; // 초기 셋팅이다.
    
    self.gradientMaskLayer.startPoint = CGPointMake(0.5, 1.0);
    self.gradientMaskLayer.endPoint = CGPointMake(0.5, 0.0);
}


#pragma mark - 세터 & 게터
- (void)setImage:(NSImage *)image {
    self.imageView.image = image;
}

- (NSImage *)image {
    return self.imageView.image;
}

- (void)setContentMode:(CALayerContentsGravity)contentMode {
    self.imageView.contentMode = contentMode;
}

- (CALayerContentsGravity)contentMode {
    return self.imageView.contentMode;
}

- (void)setOriginalImageView:(MGAImageView *)originalImageView {
    if (_originalImageView != nil) {
        [self removeObserver];
    }
    _originalImageView = originalImageView;
    if (originalImageView) {
        [self registerObserver:originalImageView];
    }
}

- (CGFloat)alpha {
    return self.containerView.layer.opacity;
}

- (void)setAlpha:(CGFloat)alpha {
    self.containerView.layer.opacity = alpha;
}


#pragma mark - 컨트롤
//! 1.0 이면 전체적으로 Reflection이 적용된다. 0.0이면 Reflection이 아예 보이지 않을 것이다.
- (void)updateGradientLocation:(CGFloat)value {
    value = MAX(MIN(1.0, value), 0.0);
    value = 1.0 - value;
    self.gradientMaskLayer.locations = @[@(0.0), @(value), @(1.0)];
}


#pragma mark - KVO 옵저빙 메서드.
// MARK: 내가 만든 편의 메서드
- (void)registerObserver:(MGAImageView *)imageView {
    [imageView addObserver:self
                forKeyPath:@"image"
                   options:(NSKeyValueObservingOptionInitial |NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                   context:MGAReflectionViewKVOContext];
    [imageView addObserver:self
                forKeyPath:@"contentMode"
                   options:(NSKeyValueObservingOptionInitial |NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                   context:MGAReflectionViewKVOContext];
}

// MARK: Override
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (context == MGAReflectionViewKVOContext) {
        if ([keyPath isEqualToString:@"image"]) {
            [self setImage:self.originalImageView.image];
        } else if ([keyPath isEqualToString:@"contentMode"]) {
            [self setContentMode:self.originalImageView.contentMode];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// MARK: 내가 만든 편의 메서드
- (void)removeObserver {
    if (self.originalImageView) {
        [self.originalImageView removeObserver:self forKeyPath:@"image" context:MGAReflectionViewKVOContext];
        [self.originalImageView removeObserver:self forKeyPath:@"contentMode" context:MGAReflectionViewKVOContext];
    }
}
@end
