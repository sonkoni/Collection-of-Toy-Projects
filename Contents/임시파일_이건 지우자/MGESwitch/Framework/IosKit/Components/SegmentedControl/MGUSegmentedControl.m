//
//  MGUSegmentedControl.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSegmentedControl.h"
#import "MGUSegmentConfiguration.h"
#import "MGUSegment.h"
#import "MGUSegmentIndicator.h"
#import "MGUSegmentTextRenderView.h"

@interface MGUSegmentedControl ()
@property (nonatomic) MGUSegmentIndicator *selectedSegmentIndicator;
@property (nonatomic) NSArray<MGUSegment *> *segments;
@end

@implementation MGUSegmentedControl
@dynamic configuration;
@dynamic borderWidth;
@dynamic borderColor;
@dynamic numberOfSegments;
@dynamic segmentIndicatorBackgroundColor;
@dynamic segmentIndicatorGradientTopColor;
@dynamic segmentIndicatorGradientBottomColor;
@dynamic segmentIndicatorBorderColor;
@dynamic segmentIndicatorBorderWidth;
@dynamic drawsSegmentIndicatorGradientBackground;

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)init {
    return [self initWithTitles:@[@"Title1", @"Title2"] selecedtitle:nil configuration:nil];
}

//! 직접 호출금지.
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}
//! 직접 호출금지.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

//! 인수로 주어진 size에 가장 적합한 size를 계산하고 반환하도록 뷰에 요청한다. Api:UIKit/UIView/- sizeThatFits: 참고.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxSegmentWidth = 0.0f;
    for (MGUSegment *segment in self.segments) {
        CGFloat segmentWidth = [segment sizeThatFits:size].width; // MGUSegment도 sizeThatFits:을 재정의하였다.
        if (segmentWidth > maxSegmentWidth) {
            maxSegmentWidth = segmentWidth;
        }
    }
    return CGSizeMake(maxSegmentWidth * self.segments.count, 32.0f);
    //
    // 이 메서드의 디폴트의 구현은, view의 기존의 size를 돌려준다.
    // 이 메서드는, 리시버의 사이즈를 변경하지 않는다.
    // MGUSegment도 sizeThatFits:을 재정의하였으며, MGUSegment의 sizeThatFits: 에서는 MGUSegmentTextRenderView의 sizeThatFits:을 호출한다.
    // 결과적으로 가장 큰 MGUSegmentTextRenderView의 크기에 1.4 배가 된 width를 단윈 width 로 사용한다.
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

//! 서브뷰의 autoresizing 및 constraint 기반 behavior가 원하는 behavior을 제공하지 않는 경우에만 이 메서드를 재정의해야한다. 이 메서드의 구현을 통해 서브뷰의 프레임 rectangle을 직접 설정할 수 있다. 본 메서드를 직접 호출해서는 안된다. setNeedsLayout을 이용하라.
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat segmentWidth  = CGRectGetWidth(self.frame) / self.segments.count;
    CGFloat segmentHeight = CGRectGetHeight(self.frame);
    
    for (int i = 0; i < self.segments.count; i++) {
        MGUSegment *segment = self.segments[i];
        segment.frame = CGRectMake(segmentWidth * i, 0.0f, segmentWidth, segmentHeight);
        
        if (self.selectedSegmentIndex == i) {
            segment.titleLabel.selectedTextDrawingRect = segment.titleLabel.bounds;
        }
        
        segment.titleLabel.font              = self.titleFont;
        segment.titleLabel.selectedFont      = self.selectedTitleFont;
        
        segment.titleLabel.textColor         = self.titleTextColor;
        segment.titleLabel.selectedTextColor = self.selectedTitleTextColor;
    }
    
    self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:self.segments[self.selectedSegmentIndex]];
    //
    // layoutSubviews는 drawRect: 보다 먼저 때려진다.
    // 그러나 layoutSubviews는 drawRect: 를 호출하지는 않는다. 마찬가지로 drawRect:는 layoutSubviews를 호출하지 않는다.
    // layoutSubviews <- setNeedsLayout 이고, drawRect: <- setNeedsDisplay
    // 오토레이아웃을 변경하거나 추가하면 호출되며 intrinsicContentSize를 호출하고, 그 다음 -> layoutSubviews를 호출한다.
    // setNeedsLayout은 intrinsicContentSize를 호출하지는 않고 바로 layoutSubviews를 호출한다.
}

- (void)drawRect:(CGRect)rect {
    if (self.drawsGradientBackground) {
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[(__bridge id)[self.gradientTopColor CGColor],
                                 (__bridge id)[self.gradientBottomColor CGColor]];
    } else {
        self.layer.backgroundColor = [self.backgroundColor CGColor];
    }
    //
    // 아래는 디폴트 값이다. 그래디언트를 그릴 때에는 디폴트 값을 그대로 사용할 것이다.
    // gradientLayer.startPoint = CGPointMake(0.5,0.0);
    // gradientLayer.endPoint   = CGPointMake(0.5,1.0);
    // gradientLayer.type       = kCAGradientLayerAxial;
    // gradientLayer.frame      = rect;
    // 자신이 어딘가에 붙고 프레임이 zero가 아닐때, 발동된다.
    // setNeedsDisplay 메서드는 drawRect:를 강제로 호출한다.
    // layoutSubviews ~ setNeedsLayout 이고, drawRect: ~ setNeedsDisplay
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles {
    self = [self initWithTitles:titles selecedtitle:nil configuration:nil];
    return self;
}

- (instancetype)initWithTitles:(NSArray <NSString *>*)titles
                  selecedtitle:(NSString *)selecedtitle {
    self = [self initWithTitles:titles selecedtitle:nil configuration:nil];
    return self;
}

- (instancetype)initWithTitles:(NSArray <NSString *>*)titles
                 configuration:(MGUSegmentConfiguration * _Nullable)configuration {
    self = [self initWithTitles:titles selecedtitle:nil configuration:configuration];
    return self;
}

- (instancetype)initWithTitles:(NSArray <NSString *>*)titles
                  selecedtitle:(NSString * _Nullable)selecedtitle
                 configuration:(MGUSegmentConfiguration * _Nullable)configuration {
    
    self = [self initWithFrame:CGRectZero];
    if (self) {
        NSMutableArray *mutableSegmentsArr = [NSMutableArray array];
        
        for (NSString *segmentTitle in titles) {
            
            MGUSegment *segment = [[MGUSegment alloc] initWithTitle:segmentTitle];
            [self addSubview:segment];
            [mutableSegmentsArr addObject:segment];
        }
        
        self.segments = [NSArray arrayWithArray:mutableSegmentsArr];
        
        if (selecedtitle == nil) {
            [self setSelectedSegmentIndex:0];
        } else {
            for(int i = 0; i < titles.count; i++) {
                if( [titles[i] isEqualToString:selecedtitle] ){
                    [self setSelectedSegmentIndex:i];
                }
            }
        }
        
        if ( (configuration != nil) && (configuration != [MGUSegmentConfiguration defaultConfiguration]) ) {
            self.configuration = configuration;
        }
    }
    return self;
}

static void CommonInit(MGUSegmentedControl *self) {
    MGUSegmentConfiguration *configuration = [MGUSegmentConfiguration defaultConfiguration];
    self->_selectedTitleTextColor  = configuration.selectedTitleTextColor;
    self->_titleTextColor          = configuration.titleTextColor;
    
    self->_titleFont               = configuration.titleFont;
    self->_selectedTitleFont       = configuration.selectedTitleFont;
    
    self->_gradientTopColor        = configuration.gradientTopColor;
    self->_gradientBottomColor     = configuration.gradientBottomColor;
    
    self->_segmentIndicatorInset   = configuration.segmentIndicatorInset;
    self->_isSelectedTextGlowON    = configuration.isSelectedTextGlowON;
    self->_alignment               = configuration.alignment;
    self->_drawsGradientBackground = configuration.drawsGradientBackground;
    
    self->_segmentIndicatorAnimationDuration = configuration.segmentIndicatorAnimationDuration;
    self->_usesSpringAnimations              = configuration.usesSpringAnimations;
    self->_springAnimationDampingRatio       = configuration.springAnimationDampingRatio;
    self->_cornerRadiusPercent               = configuration.cornerRadiusPercent;
    
    self.backgroundColor     = configuration.backgroundColor;
    self.layer.borderColor   = configuration.borderColor.CGColor;
    self.layer.borderWidth   = configuration.borderWidth;
    self.layer.masksToBounds = YES;
    
    self.opaque = NO;
    
    self.selectedSegmentIndicator = [[MGUSegmentIndicator alloc] initWithFrame:CGRectZero];
    self.drawsSegmentIndicatorGradientBackground = NO;  // 위의 segmentIndicator를 그래디언트가 아닌 단색을 쓰겠다는 뜻이다.
    [self addSubview:self.selectedSegmentIndicator];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(panGestureRecognized:)];
    panGestureRecognizer.maximumNumberOfTouches  = 1;
    [self.selectedSegmentIndicator addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tapGestureRecognized:)];
    tapGestureRecognizer.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark - 세터 & 게터
- (void)setConfiguration:(MGUSegmentConfiguration *)configuration {
    if (configuration != nil) {
        [self applyConfiguration:configuration];
    }
}

- (NSUInteger)numberOfSegments {
    return self.segments.count;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.layer.backgroundColor = [backgroundColor CGColor];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithCGColor:self.layer.backgroundColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadiusPercent:(CGFloat)cornerRadiusPercent {
    _cornerRadiusPercent = cornerRadiusPercent;
    
    self.layer.cornerRadius                    = cornerRadiusPercent * (self.frame.size.height / 2.0);
    self.selectedSegmentIndicator.cornerRadius = self.layer.cornerRadius *
                                                ((self.frame.size.height - (self.segmentIndicatorInset * 2)) / self.frame.size.height);
}

- (void)setDrawsSegmentIndicatorGradientBackground:(BOOL)drawsSegmentIndicatorGradientBackground {
    self.selectedSegmentIndicator.drawsGradientBackground = drawsSegmentIndicatorGradientBackground;
}

- (BOOL)drawsSegmentIndicatorGradientBackground {
    return self.selectedSegmentIndicator.drawsGradientBackground;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self setCornerRadiusPercent:self.cornerRadiusPercent];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setCornerRadiusPercent:self.cornerRadiusPercent];
}

- (void)setSegmentIndicatorBackgroundColor:(UIColor *)segmentIndicatorBackgroundColor {
    self.selectedSegmentIndicator.backgroundColor = segmentIndicatorBackgroundColor;
}

- (UIColor *)segmentIndicatorBackgroundColor {
    return self.selectedSegmentIndicator.backgroundColor;
}

- (void)setSegmentIndicatorInset:(CGFloat)segmentIndicatorInset {
    _segmentIndicatorInset = segmentIndicatorInset;
    self.selectedSegmentIndicator.cornerRadius = self.layer.cornerRadius *
                                                ((self.frame.size.height - (self.segmentIndicatorInset * 2)) / self.frame.size.height);
    [self setNeedsLayout];
}

- (void)setSegmentIndicatorGradientTopColor:(UIColor *)segmentIndicatorGradientTopColor {
    self.selectedSegmentIndicator.gradientTopColor = segmentIndicatorGradientTopColor;
}

- (UIColor *)segmentIndicatorGradientTopColor {
    return self.selectedSegmentIndicator.gradientTopColor;
}

- (void)setSegmentIndicatorGradientBottomColor:(UIColor *)segmentIndicatorGradientBottomColor {
    self.selectedSegmentIndicator.gradientBottomColor = segmentIndicatorGradientBottomColor;
}

- (UIColor *)segmentIndicatorGradientBottomColor {
    return self.selectedSegmentIndicator.gradientBottomColor;
}

- (void)setSegmentIndicatorBorderColor:(UIColor *)segmentIndicatorBorderColor {
    self.selectedSegmentIndicator.borderColor = segmentIndicatorBorderColor;
}

- (UIColor *)segmentIndicatorBorderColor {
    return self.selectedSegmentIndicator.borderColor;
}

- (void)setSegmentIndicatorBorderWidth:(CGFloat)segmentIndicatorBorderWidth {
    self.selectedSegmentIndicator.borderWidth = segmentIndicatorBorderWidth;
}

- (CGFloat)segmentIndicatorBorderWidth {
    return self.selectedSegmentIndicator.borderWidth;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self setNeedsLayout];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    [self setNeedsLayout];
}

- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont {
    _selectedTitleFont = selectedTitleFont;
    [self setNeedsLayout];
}

- (void)setSelectedTitleTextColor:(UIColor *)selectedTitleTextColor {
    _selectedTitleTextColor = selectedTitleTextColor;
    [self setNeedsLayout];
}

- (void)setIsSelectedTextGlowON:(BOOL)isSelectedTextGlowON {
    _isSelectedTextGlowON = isSelectedTextGlowON;
    for(MGUSegment * segment in self.segments) {
        segment.titleLabel.isSelectedTextGlowON = isSelectedTextGlowON;
    }
}

- (void)setAlignment:(NSTextAlignment)alignment {
    if(_alignment != alignment) {
        _alignment = alignment;
        for (MGUSegment *segment in  self.segments) {
            segment.titleLabel.alignment = alignment;
        }
        [self setNeedsDisplay];
    }
}

//! 실제로 이 메서드는 외부, 프로그래머에 의해서만 호출된다. 강제로 옮기는 경우에만 호출. 이 클래스 내부에서는 호출되지 않는다.
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    [self setSelectedSegmentIndex:selectedSegmentIndex animated:NO];
}


#pragma mark - 컨트롤
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    MGUSegment *newSegment = [[MGUSegment alloc] initWithTitle:title];
    [self addSubview:newSegment];
    
    NSMutableArray *mutableSegments = [NSMutableArray arrayWithArray:self.segments];
    [mutableSegments insertObject:newSegment atIndex:index];
    self.segments = [NSArray arrayWithArray:mutableSegments];
    [self setNeedsLayout];
}

- (void)removeSegmentAtIndex:(NSUInteger)index {
    MGUSegment *segment = self.segments[index];
    [segment removeFromSuperview];
    
    NSMutableArray *mutableSegments = [NSMutableArray arrayWithArray:self.segments];
    [mutableSegments removeObjectAtIndex:index];
    self.segments = [NSArray arrayWithArray:mutableSegments];
    
    [self setNeedsLayout];
}

- (void)removeAllSegments {
    for (MGUSegment *segment in self.segments) {
        [segment removeFromSuperview];
    }
    
    self.segments = [NSArray array];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    MGUSegment *segment = self.segments[index];
    segment.titleLabel.text = title;
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    MGUSegment *segment = self.segments[index];
    return segment.titleLabel.text;
}

- (NSString *)titleForSelectedSegmentIndex {
    return [self titleForSegmentAtIndex:self.selectedSegmentIndex];
}

//! panGestureRecognizer 인디케이터에 붙어있다.
- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view.superview];

    // selectedSegmentIndicator가 덮고 있는 세그먼트 스타일 지정
    [self.segments enumerateObjectsUsingBlock:^(MGUSegment *segment, NSUInteger index, BOOL *stop) {
        CGRect intersectionRect = CGRectIntersection(segment.frame, self.selectedSegmentIndicator.frame);
        segment.titleLabel.selectedTextDrawingRect = [segment convertRect:intersectionRect fromView:segment.superview];
    }];
    
    CGFloat xDiff = translation.x; // 현재 터치와 이전 터치 간의 수평 위치 차이를 찾는다.
    CGRect newSegmentIndicatorFrame = self.selectedSegmentIndicator.frame; // 인디케이터가 컨트롤의 경계를 벗어나지 않는지 확인 (어느 정도 허용할 것인가)
    newSegmentIndicatorFrame.origin.x = newSegmentIndicatorFrame.origin.x + xDiff;
    
    BOOL permitMoving = CGRectContainsRect( CGRectInset(self.bounds,
                                                        self.segmentIndicatorInset-CGRectGetWidth(self.selectedSegmentIndicator.bounds)/2.0, 0),
                                           newSegmentIndicatorFrame );
    CGFloat selectedSegmentIndicatorCenterX;
    if ( permitMoving ) {
        selectedSegmentIndicatorCenterX = self.selectedSegmentIndicator.center.x + xDiff;
    } else if ( self.selectedSegmentIndicator.center.x < CGRectGetMidX(self.bounds) ) {
        selectedSegmentIndicatorCenterX = self.segmentIndicatorInset;
    } else {
        selectedSegmentIndicatorCenterX = CGRectGetMaxX(self.bounds)-self.segmentIndicatorInset;
    }

    self.selectedSegmentIndicator.center = CGPointMake(selectedSegmentIndicatorCenterX, self.selectedSegmentIndicator.center.y);

    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:panGestureRecognizer.view.superview]; // 움직인 위치를 초기화 0, 0 시킨다.
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        /// 끝에서 멈춰버리는 현상을 없애기 위해서 추가적으로 작업했다. 센터 점이 딱 끝에(특히 오른쪽) 걸리면 돌아가야할 곳을 못찾을 수 있다.
        if(self.selectedSegmentIndicator.center.x >= CGRectGetMaxX(self.bounds)) {
            [self setSelectedSegmentIndex:self.segments.count-1 animated:YES];
        } else if ( self.selectedSegmentIndicator.center.x <= 0 ) {
            [self setSelectedSegmentIndex:0 animated:YES];
        }
        
        __weak __typeof(self)weakSelf = self;
        [self.segments enumerateObjectsUsingBlock:^(MGUSegment *segment, NSUInteger index, BOOL *stop) {
            __strong __typeof(weakSelf)self = weakSelf;
            if (CGRectContainsPoint(segment.frame, self.selectedSegmentIndicator.center)) {
                [self setSelectedSegmentIndex:index animated:YES];
            }
        }];
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint location = [tapGestureRecognizer locationInView:self];
    
    __weak __typeof(self)weakSelf = self;
    [self.segments enumerateObjectsUsingBlock:^(MGUSegment *segment, NSUInteger index, BOOL *stop) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (CGRectContainsPoint(segment.frame, location)) {
            if (index != self.selectedSegmentIndex) {
                [self setSelectedSegmentIndex:index animated:YES];
            }
        }
    }];
}

//! 내부에서의 작동을 위해 존재한다. 그러나 손가락 터치 없이 애니메이션을 주면서 움직일 수 있는 경우가 존재할 수 있으므로 public이다.
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated {
    [self moveSelectedSegmentIndicatorToSegmentAtIndex:selectedSegmentIndex animated:animated];
    //
    // animated = NO로 설정하면 data source에 알림 없이 이동가능하다.
}

//! 위 메서드를 string으로 작동하게 만들었다.
- (void)setSelectedSegmentTitle:(NSString *)selectedSegmentTitle animated:(BOOL)animated {
    for (int i = 0; i < self.segments.count; i++) {
        if ([selectedSegmentTitle isEqualToString:[self titleForSegmentAtIndex:i]]) {
            [self setSelectedSegmentIndex:i animated:animated];
            return;
        }
    }
    NSAssert(false, @"존재하지 않는 string을 고르려 했다.");
}

- (void)moveSelectedSegmentIndicatorToSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated {
    
    MGUSegment *selectedSegment = self.segments[index];
    //! indicator를 기존에 선택했던 segment로 다시 이동할 경우, segment의 폰트 스타일을 변경해서는 안된다.
    if (index != self.selectedSegmentIndex && animated == YES) {
        MGUSegment *previousSegment = self.segments[self.selectedSegmentIndex];
        
        void (^animationsBlock)(void) = ^{
            //! 구형 버전은 이것만 있으면 되는데, 신형이 더 복잡하다.
            [UIView transitionWithView:previousSegment.titleLabel
                              duration:self.segmentIndicatorAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ previousSegment.titleLabel.selectedTextDrawingRect = CGRectZero; } // 선택된 라벨의 텍스트 칼라를 없앤다.
                            completion:nil]; };
        
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.segmentIndicatorAnimationDuration
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveLinear
                                                         animations:animationsBlock
                                                         completion:nil];
        
        animationsBlock = ^{
            [UIView transitionWithView:selectedSegment.titleLabel
                              duration:self.segmentIndicatorAnimationDuration
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:nil
                            completion:nil]; };
        
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.segmentIndicatorAnimationDuration
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveLinear
                                                         animations:animationsBlock
                                                         completion:nil];
    }
    
    if (animated == YES) {
        void (^animationsBlock)(void) = ^{
            self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];
            
            [self.segments enumerateObjectsUsingBlock:^(MGUSegment *segment, NSUInteger index, BOOL *stop) {
                segment.titleLabel.selectedTextDrawingRect = CGRectZero;
            }];
            
            selectedSegment.titleLabel.selectedTextDrawingRect = selectedSegment.titleLabel.bounds;
        };
        
        if (self.usesSpringAnimations == NO) {
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.segmentIndicatorAnimationDuration
                                                                  delay:0
                                                                options:UIViewAnimationOptionCurveEaseInOut
                                                             animations:animationsBlock
                                                             completion:nil];
        } else {
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:self.segmentIndicatorAnimationDuration
                                                                                   dampingRatio:self.springAnimationDampingRatio
                                                                                     animations:animationsBlock];
            [animator startAnimation];
        }
    } else {
        self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];
        selectedSegment.titleLabel.selectedTextDrawingRect = selectedSegment.titleLabel.bounds;
    }
    
    if(_selectedSegmentIndex != index) {
        self.segments[_selectedSegmentIndex].selected = NO;
        self.segments[index].selected = YES;
        _selectedSegmentIndex = index;
        if (animated == YES) { //! 애니메이션 없이 설정했다는 것은 프로그래머가 UIControlEventValueChanged 알림 없이 몰래 옮기겠다는 의도이다.
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


#pragma mark - Helper
//! 인수로 던져지는 segment는 선택된 혹은 선택될 segment이다.
- (CGRect)indicatorFrameForSegment:(MGUSegment *)segment {
    CGRect indicatorFrameRect = CGRectMake(CGRectGetMinX(segment.frame)   + self.segmentIndicatorInset,
                                           CGRectGetMinY(segment.frame)   + self.segmentIndicatorInset,
                                           CGRectGetWidth(segment.frame)  - (2.0f * self.segmentIndicatorInset),
                                           CGRectGetHeight(segment.frame) - (2.0f * self.segmentIndicatorInset));
    
    CGPoint origin = CGPointMake(floor(indicatorFrameRect.origin.x), floor(indicatorFrameRect.origin.y));
    CGSize size    = CGSizeMake(floor(indicatorFrameRect.size.width), floor(indicatorFrameRect.size.height));

    return (CGRect){origin, size};
    //
    // 원점과 사이즈를 모두 정수로 치환한다. 그러면서, indicatorFrameRect를 포함하는 최소한의 rect를 만들어낸다.
    //! CGRectIntegral()은 동일한 사이즈임에도 불구하고 다른 사이즈를 생성할 수 있다. 이렇게 되면 bounds가 변하게 되고
    //! 의도치 않게 - layoutSubviews가 호출되어 꼬이게 된다.
}

//! configuration을 적용한다.
- (void)applyConfiguration:(MGUSegmentConfiguration *)configuration {
    self.isSelectedTextGlowON = configuration.isSelectedTextGlowON;
    self.alignment = configuration.alignment;
    
    self.titleFont = configuration.titleFont;
    self.selectedTitleFont = configuration.selectedTitleFont;
    
    self.titleTextColor = configuration.titleTextColor;
    self.selectedTitleTextColor = configuration.selectedTitleTextColor;
    
    self.borderWidth = configuration.borderWidth;
    self.borderColor = configuration.borderColor;
    
    self.segmentIndicatorBorderWidth = configuration.segmentIndicatorBorderWidth;
    self.segmentIndicatorBorderColor = configuration.segmentIndicatorBorderColor;
    
    self.segmentIndicatorAnimationDuration = configuration.segmentIndicatorAnimationDuration;
    self.usesSpringAnimations = configuration.usesSpringAnimations;
    self.springAnimationDampingRatio = configuration.springAnimationDampingRatio;
    
    self.cornerRadiusPercent = configuration.cornerRadiusPercent;
    
    /// selected segment indicator가 전체 the control의 outer edge에서 inset되는 양을 의미한다.
    self.segmentIndicatorInset = configuration.segmentIndicatorInset;
    
    self.backgroundColor        = configuration.backgroundColor;
    self.drawsGradientBackground = configuration.drawsGradientBackground;
    self.gradientTopColor = configuration.gradientTopColor;
    self.gradientBottomColor = configuration.gradientBottomColor;
    
    self.segmentIndicatorBackgroundColor = configuration.segmentIndicatorBackgroundColor;
    self.drawsSegmentIndicatorGradientBackground = configuration.drawsSegmentIndicatorGradientBackground;
    self.segmentIndicatorGradientTopColor = configuration.segmentIndicatorGradientTopColor;
    self.segmentIndicatorGradientBottomColor = configuration.segmentIndicatorGradientBottomColor;
}

@end
