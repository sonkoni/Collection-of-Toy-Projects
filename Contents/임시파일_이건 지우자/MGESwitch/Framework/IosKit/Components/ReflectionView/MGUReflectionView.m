//
//  MGUReflectionView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUReflectionView.h"
#import "MGUVisualEffectView.h"

static void *MGUReflectionViewKVOContext = &MGUReflectionViewKVOContext;

@interface MGUReflectionView ()
@property (nonatomic, weak) UIImageView *originalImageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MGUVisualEffectView *visualEffectView;
@property (nonatomic, strong) CAGradientLayer *gradientMaskLayer;
@end

@implementation MGUReflectionView
@dynamic image;
@dynamic contentMode;

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame alpha:1.0 location:1.0 intensity:0.5 originalImageView:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
    self.imageView.frame = self.containerView.bounds;
    if (self.visualEffectView) {
        self.visualEffectView.frame = self.imageView.bounds;
    }
    self.gradientMaskLayer.frame = self.containerView.layer.bounds;
}

- (void)dealloc {
    [self removeObserver];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                        alpha:(CGFloat)alpha
                     location:(CGFloat)location
                    intensity:(CGFloat)intensity
            originalImageView:(UIImageView * _Nullable)originalImageView {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
        [self updateIntensity:intensity];
        self.alpha = alpha;
        [self updateGradientLocation:location];
        [self setOriginalImageView:originalImageView]; // 세터로 접근해야한다.
    }
    return self;
}

static void CommonInit(MGUReflectionView *self) {
    self->_containerView = [UIView new];
    self->_imageView = [UIImageView new];
    self->_gradientMaskLayer = [CAGradientLayer layer];
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.imageView];
    self.containerView.layer.mask = self.gradientMaskLayer;

    self.containerView.frame = self.bounds;
    self.imageView.frame = self.containerView.bounds;
    self.gradientMaskLayer.frame = self.containerView.layer.bounds;
    self.containerView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 1.0, 0.0, 0.0); // 뒤집기.
    
    self.backgroundColor = UIColor.clearColor;
    self.containerView.backgroundColor = UIColor.clearColor;
    self.userInteractionEnabled = NO;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self maskLayerSetUpConfiguration];
}

- (void)maskLayerSetUpConfiguration {
    //! 뒤집힌다는 것을 유념하자.
    self.gradientMaskLayer.type = kCAGradientLayerAxial;
    self.gradientMaskLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor],
                                      (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor],
                                      (id)[[UIColor redColor] CGColor]];
    self.gradientMaskLayer.locations = @[@(0.0), @(0.0), @(1.0)]; // 초기 셋팅이다.
    self.gradientMaskLayer.startPoint = CGPointMake(0.5, 0.0);
    self.gradientMaskLayer.endPoint = CGPointMake(0.5, 1.0);
}


#pragma mark - 세터 & 게터
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    self.imageView.contentMode = contentMode;
}

- (UIViewContentMode)contentMode {
    return self.imageView.contentMode;
}

- (void)setOriginalImageView:(UIImageView *)originalImageView {
    if (_originalImageView) {
        [self removeObserver];
    }
    _originalImageView = originalImageView;
    if (originalImageView) {
        [self registerObserver:originalImageView];
    }
}


#pragma mark - 컨트롤
//! 1.0 이면 전체적으로 Reflection이 적용된다. 0.0이면 Reflection이 아예 보이지 않을 것이다.
- (void)updateGradientLocation:(CGFloat)value {
    value = MAX(MIN(1.0, value), 0.0);
    value = 1.0 - value;
    self.gradientMaskLayer.locations = @[@(0.0), @(value), @(1.0)];
}

//! 0.0 ~ 1.0 까지 값을 받는다. 0.0이면 블러가 0.0이다.
- (void)updateIntensity:(CGFloat)intensity {
    if (_visualEffectView) {
        [self.visualEffectView removeFromSuperview];
        self.visualEffectView = nil;
    }
    
    if (intensity == 0.0) {
        return;
    }
    NSLog(@"콜렉션뷰에서는 이 메서드를 호출해서는 안된다.");
    intensity = MAX(MIN(1.0, intensity), 0.0);
    intensity = intensity / 10.0;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[MGUVisualEffectView alloc] initWithEffect:blurEffect intensity:intensity];
    [self.imageView addSubview:self.visualEffectView];
    self.visualEffectView.frame = self.imageView.bounds;
    //! intensity 0.05정도가 적당한듯하다.
    //! intensity 1.0은 너무 강하므로 입력되는 1.0 => 0.1로 대응하게 만들었다.
}


#pragma mark - KVO 옵저빙 메서드.
// MARK: 내가 만든 편의 메서드
- (void)registerObserver:(UIImageView *)imageView {
    [imageView addObserver:self
                forKeyPath:@"image"
                   options:(NSKeyValueObservingOptionInitial |NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                   context:MGUReflectionViewKVOContext];
    [imageView addObserver:self
                forKeyPath:@"contentMode"
                   options:(NSKeyValueObservingOptionInitial |NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                   context:MGUReflectionViewKVOContext];
}

// MARK: Override
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (context == MGUReflectionViewKVOContext) {
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
        [self.originalImageView removeObserver:self forKeyPath:@"image" context:MGUReflectionViewKVOContext];
        [self.originalImageView removeObserver:self forKeyPath:@"contentMode" context:MGUReflectionViewKVOContext];
    }
}
@end
