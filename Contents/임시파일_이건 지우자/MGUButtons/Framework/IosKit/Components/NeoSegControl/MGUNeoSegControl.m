//
//  MGUNeoSegControl.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUNeoSegControl_Internal.h"
#import "MGUNeoSegConfiguration.h"
#import "MGUNeoSeg.h"
#import "MGUNeoSegIndicator.h"
#import "UIView+Extension.h"
#import "UIFeedbackGenerator+Extension.h"
@import GraphicsKit;

CGFloat MGUNeoSegControlMinimumScale = 0.94999999999999996;
CGFloat MGUNeoSegControlHalfShinkRatio = (1 - 0.94999999999999996) / 2.0; // 세로로 줄어든 양에 대한 반.

// nomal, selected, normal Highlighted, selected Shrink
/* MGUNeoSegControl_Internal.h 존재함.
@interface MGUNeoSegControl ()
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@property (nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) UIView *fullContainerView;
@property (nonatomic) NSArray<UIView *> *segmentBackUpViews;
@property (nonatomic) UIView *separatorContainerView;
@property (nonatomic) NSArray<UIView *> *separatorViews;
@property (nonatomic) MGUNeoSegIndicator *segmentIndicator;
@property (nonatomic) UIStackView *segmentsStackView;
@property (nonatomic) NSArray<MGUNeoSeg *> *segments;
@property (nonatomic) BOOL beginTrackingOnIndicator;
@property (nonatomic) NSInteger currentTouchIndex;

- (void)adjustGradient:(MGUNeoSegConfiguration *)config; // configuration이 적용할 수 있도록.
@end
 */

@implementation MGUNeoSegControl
@dynamic numberOfSegments;
@dynamic indicator; // 외부 클래스에서 indicator에 접근해서 꾸미고 싶을 때, 사용한다.

- (instancetype)init {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"Title1"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"Title2"];
    return [self initWithTitles:@[model1, model2] selecedtitle:nil configuration:nil];
}

//! 인수로 주어진 size에 가장 적합한 size를 계산하고 반환하도록 뷰에 요청한다. Api:UIKit/UIView/- sizeThatFits: 참고.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxSegmentWidth = 0.0f;
    for (MGUNeoSeg *segment in self.segments) {
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    [self.fullContainerView layoutIfNeeded]; // 컨테이너로 싸버렸으므로, 반응이 조금 느릴 수 있기 때문이다.
    
    //! FIXME: 스페이싱은 조금 더 다듬어야하마.
    CGRect separatorFrame =
    CGRectMake(0.0, 0.0, 1.0, self.bounds.size.height * self.configuration.separatorHeightRatio);
    NSInteger totalCount = self.segments.count;
    CGFloat unitWidth = (self.bounds.size.width / totalCount);
    
    for (NSInteger i = 0; i < totalCount - 1; i++) {
        CGPoint center = CGPointMake(unitWidth * (i + 1), self.bounds.size.height / 2.0);
        UIView *view = self.separatorViews[i];
        view.frame = separatorFrame;
        view.center = center;
    }

    for (int i = 0; i < self.segments.count; i++) {
        MGUNeoSeg *segment = self.segments[i];
        if (self.selectedSegmentIndex == i) {
            [segment setSegmentState:MGUNeoSegStateIndicator];
        } else {
            [segment setSegmentState:MGUNeoSegStateNoIndicator];
        }
    }
    
    self.layer.cornerRadius = self.configuration.cornerRadiusPercent * (self.frame.size.height / 2.0);
    self.gradientLayer.cornerRadius = self.layer.cornerRadius;
    if (self.configuration.indicatorCornerRadiusAlwaysZero == YES) {
        self.segmentIndicator.cornerRadius = 0.0f;
    } else {
        self.segmentIndicator.cornerRadius =
        self.layer.cornerRadius * ((self.frame.size.height - (self.configuration.segmentIndicatorInset * 2)) / self.frame.size.height);
    }
    
    self.segmentIndicator.frame = [self indicatorFrameAtIndex:self.selectedSegmentIndex];
    [self hideAndShowSeparatorsAtIndex:self.selectedSegmentIndex];
    //
    // layoutSubviews는 drawRect: 보다 먼저 때려진다.
    // 그러나 layoutSubviews는 drawRect: 를 호출하지는 않는다. 마찬가지로 drawRect:는 layoutSubviews를 호출하지 않는다.
    // layoutSubviews <- setNeedsLayout 이고, drawRect: <- setNeedsDisplay
    // 오토레이아웃을 변경하거나 추가하면 호출되며 intrinsicContentSize를 호출하고, 그 다음 -> layoutSubviews를 호출한다.
    // setNeedsLayout은 intrinsicContentSize를 호출하지는 않고 바로 layoutSubviews를 호출한다.
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger nowTouchIndex = [self indexOfSegmentCloseToTouchPoint:touchPoint];

    NSInteger selectedSegmentIndex = self.selectedSegmentIndex;
    if (nowTouchIndex == selectedSegmentIndex) {
        _beginTrackingOnIndicator = YES;
        CGRect frame = [self indicatorMinimumScaleFrameAtIndex:nowTouchIndex];
        [self.segmentIndicator shrink:YES frame:frame];
        
        MGUNeoSeg *segment = self.segments[self.selectedSegmentIndex];
        segment.shrink = YES;
        [self hideAndShowSeparatorsAtIndex:nowTouchIndex];
    } else {
        _beginTrackingOnIndicator = NO;
        MGUNeoSeg *segment = self.segments[nowTouchIndex];
        segment.highlight = YES;
    }

    self.currentTouchIndex = nowTouchIndex;
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger nowTouchIndex = [self indexOfSegmentCloseToTouchPoint:touchPoint];
    
    if (nowTouchIndex == self.currentTouchIndex ) {
        return [super continueTrackingWithTouch:touch withEvent:event];
    }
    
    if (self.beginTrackingOnIndicator == YES) { // 터치의 시작이 인디케이터일때...
        [self.segmentIndicator moveToFrame:[self indicatorMinimumScaleFrameAtIndex:nowTouchIndex] animated:YES];
        [self.segments enumerateObjectsUsingBlock:^(MGUNeoSeg *segment, NSUInteger idx, BOOL *stop) {
            if (idx != nowTouchIndex) {
                segment.shrink = NO;
                segment.segmentState = MGUNeoSegStateNoIndicator;
            } else {
                segment.shrink = YES;
                segment.segmentState = MGUNeoSegStateIndicator;
            }
        }];
        [self sendActionsForControlEvents:UIControlEventTouchDragInside]; // 추적하고 싶을 때가 있을 것이다. self.currentTouchIndex로 찾아라.
        [self hideAndShowSeparatorsAtIndex:nowTouchIndex];
        [self impactOccurred]; // <- 이동한다.
    } else {
        [self.segments enumerateObjectsUsingBlock:^(MGUNeoSeg *segment, NSUInteger idx, BOOL *stop) {
            if (idx != nowTouchIndex) {
                segment.highlight = NO;
            } else if (nowTouchIndex ==  self.selectedSegmentIndex) {
                segment.highlight = NO;
            } else {
                segment.highlight = YES;
            }
        }];
        
    }

    self.currentTouchIndex = nowTouchIndex;
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];

    CGPoint touchPoint = [touch locationInView:self];
    NSInteger nowTouchIndex = [self indexOfSegmentCloseToTouchPoint:touchPoint];
    if (self.beginTrackingOnIndicator == YES) { // 터치의 시작이 인디케이터일때...
        [self touchUpState:nowTouchIndex];
        [self setSelectedSegmentIndex:nowTouchIndex animated:YES];
    } else {
        [self touchUpState:nowTouchIndex];
        if (nowTouchIndex != self.selectedSegmentIndex) {
            [self setSelectedSegmentIndex:nowTouchIndex animated:YES];
            [self impactOccurred]; // <- 이동한다.
        }
    }
    [self hideAndShowSeparatorsAtIndex:nowTouchIndex];
    //[self hideAndShowSeparatorsAtIndex:NSNotFound];
    return;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self endTrackingWithTouch:nil withEvent:event];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            self.configuration = self.configuration; // - activeConfigurationForSegmentedControl call
        }];
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithTitles:(NSArray <MGUNeoSegModel *>*)segmentModels
                  selecedtitle:(NSString * _Nullable)selecedtitle
                 configuration:(MGUNeoSegConfiguration * _Nullable)configuration {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (configuration != nil) {
            _configuration = configuration;
        } else {
            _configuration = [MGUNeoSegConfiguration defaultConfiguration];
        }
        [self commonInit];
        NSMutableArray *mutableSegmentsArr = [NSMutableArray array];
        NSMutableArray *mutableSeparatorsArr = [NSMutableArray array];
        
        NSInteger count = segmentModels.count;
        for (NSInteger i = 0; i < count; i++) {
            MGUNeoSegModel *segmentModel = segmentModels[i];
            MGUNeoSeg *segment = [[MGUNeoSeg alloc] initWithSegmentModel:segmentModel
                                                                    config:self.configuration];
            
            [self.segmentsStackView addArrangedSubview:segment];
            [mutableSegmentsArr addObject:segment];
            
            if (i != 0) {
                UIView *separatorView = [UIView new];
                [self.separatorContainerView addSubview:separatorView];
                separatorView.backgroundColor = self.configuration.separatorColor;
                [mutableSeparatorsArr addObject:separatorView];
            }
        }
        
        self.separatorViews = [NSArray arrayWithArray:mutableSeparatorsArr];
        
        self.segments = [NSArray arrayWithArray:mutableSegmentsArr];
        
        if (selecedtitle == nil) {
            [self setSelectedSegmentIndex:0];
        } else {
            for(int i = 0; i < segmentModels.count; i++) {
                if( [segmentModels[i].title isEqualToString:selecedtitle] ){
                    [self setSelectedSegmentIndex:i];
                }
            }
        }
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor     = self.configuration.backgroundColor;
    self.layer.borderColor   = self.configuration.borderColor.CGColor;
    self.layer.borderWidth   = self.configuration.borderWidth;
    self.layer.masksToBounds = YES;
    
    self.opaque = NO;
    
    _impactOff = YES;
    _impactFeedbackStyle = UIImpactFeedbackStyleMedium;
    _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:_impactFeedbackStyle];
    
    _gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0.5,0.0);
    self.gradientLayer.endPoint   = CGPointMake(0.5,1.0);
    self.gradientLayer.type       = kCAGradientLayerAxial;
    self.gradientLayer.frame      = self.layer.bounds;
    self.gradientLayer.masksToBounds = YES;
    [self.layer addSublayer:self.gradientLayer];
    [self adjustGradient:self.configuration];
    
    _fullContainerView = [UIView new];
    self.fullContainerView.userInteractionEnabled = NO; // 여기서 막아버린다.
    self.fullContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.fullContainerView];
    [self.fullContainerView mgrPinEdgesToSuperviewEdges];
  
    _separatorContainerView = [UIView new];
    self.separatorContainerView.backgroundColor = [UIColor clearColor];
    [self.fullContainerView addSubview:self.separatorContainerView];
    [self.separatorContainerView mgrPinEdgesToSuperviewEdges];
    
    self.segmentIndicator = [[MGUNeoSegIndicator alloc] initWithFrame:CGRectZero config:self.configuration];
    [self.fullContainerView addSubview:self.segmentIndicator];
    
    _segmentsStackView = [UIStackView new];
    self.segmentsStackView.axis = UILayoutConstraintAxisHorizontal; // 언제나 항상 이 값이다.
    self.segmentsStackView.spacing = self.configuration.interItemSpacing;
    self.segmentsStackView.distribution = UIStackViewDistributionFillEqually; // 세그먼트를 동일하게 분배한다.
    self.segmentsStackView.alignment = UIStackViewAlignmentFill; // 위 아래로 꽉 채운다.
    [self.fullContainerView addSubview:self.segmentsStackView];
    [self.segmentsStackView mgrPinEdgesToSuperviewEdges];
}

- (void)adjustGradient:(MGUNeoSegConfiguration *)config {
    self.gradientLayer.colors = @[(__bridge id)[config.gradientTopColor CGColor],
                                  (__bridge id)[config.gradientBottomColor CGColor]];
    if (config.drawsGradientBackground == NO) {
        self.gradientLayer.hidden = YES;
    } else {
        self.gradientLayer.hidden = NO;
    }
}


#pragma mark - 세터 & 게터
- (void)setConfiguration:(MGUNeoSegConfiguration *)configuration {
    if (configuration != nil) {
        _configuration = configuration;
    } else {
        _configuration = [MGUNeoSegConfiguration defaultConfiguration];
    }
    
    [_configuration activeConfigurationForSegmentedControl:self];
}

- (NSUInteger)numberOfSegments {
    return self.segments.count;
}

//! 실제로 이 메서드는 외부, 프로그래머에 의해서만 호출된다. 강제로 옮기는 경우에만 호출. 이 클래스 내부에서는 호출되지 않는다.
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    [self setSelectedSegmentIndex:selectedSegmentIndex animated:NO];
}

- (void)setImpactFeedbackStyle:(UIImpactFeedbackStyle)impactFeedbackStyle {
    if (_impactFeedbackStyle != impactFeedbackStyle) {
        _impactFeedbackStyle = impactFeedbackStyle;
        self.impactFeedbackGenerator = nil;
        _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:_impactFeedbackStyle];
    }
}

- (UIView *)indicator {
    return self.segmentIndicator;
}


#pragma mark - 컨트롤 메서드
- (void)insertSegmentWithModel:(MGUNeoSegModel *)segmentModel  // 기존의 control에 세그먼트를 추가적으로 삽입할 때 호
                       atIndex:(NSUInteger)index {
    MGUNeoSeg *newSegment = [MGUNeoSeg segmentWithSegmentModel:segmentModel config:self.configuration];
    [self.segmentsStackView insertArrangedSubview:newSegment atIndex:index];
    NSMutableArray *mutableSegments = [NSMutableArray arrayWithArray:self.segments];
    [mutableSegments insertObject:newSegment atIndex:index];
    self.segments = [NSArray arrayWithArray:mutableSegments];
    
    if (self.segments.count > 1) {
        NSMutableArray *mutableSeparatorsArr = [NSMutableArray arrayWithArray:self.separatorViews];
        UIView *separatorView = [UIView new];
        [self.separatorContainerView addSubview:separatorView];
        [mutableSeparatorsArr addObject:separatorView];
        self.separatorViews = [NSArray arrayWithArray:mutableSeparatorsArr];
    }
    
    [self setNeedsLayout];
}

- (void)removeSegmentAtIndex:(NSUInteger)index {
    MGUNeoSeg *segment = self.segments[index];
    [segment removeFromSuperview];
    
    NSMutableArray *mutableSegments = [NSMutableArray arrayWithArray:self.segments];
    [mutableSegments removeObjectAtIndex:index];
    self.segments = [NSArray arrayWithArray:mutableSegments];
    
    if (self.separatorViews.count > 0) {
        UIView *separatorView = self.separatorViews[index];
        [separatorView removeFromSuperview];
        NSMutableArray *mutableSeparatorsArr = [NSMutableArray arrayWithArray:self.separatorViews];
        [mutableSeparatorsArr removeObjectAtIndex:index];
        self.separatorViews = [NSArray arrayWithArray:mutableSeparatorsArr];
    }
    
    [self setNeedsLayout];
}

- (void)removeAllSegments {
    for (MGUNeoSeg *segment in self.segments) {
        [segment removeFromSuperview];
    }
    
    self.segments = [NSArray array];
    
    for (UIView *view in self.separatorViews) {
        [view removeFromSuperview];
    }
    
    self.separatorViews = [NSArray array];
    [self setNeedsLayout];
}

- (void)setModel:(MGUNeoSegModel *)segmentModel AtIndex:(NSUInteger)index {
    [self removeSegmentAtIndex:index];
    [self insertSegmentWithModel:segmentModel atIndex:index];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    MGUNeoSeg *segment = self.segments[index];
    return segment.titleLabel.text;
}

- (NSString *)titleForSelectedSegmentIndex {
    return [self titleForSegmentAtIndex:self.selectedSegmentIndex];
}

- (UIImage *)segmentImageForSegmentAtIndex:(NSUInteger)index {
    MGUNeoSeg *segment = self.segments[index];
    return segment.imageView.image;
}

- (UIImage *)segmentImageForSelectedSegmentIndex {
    return [self segmentImageForSegmentAtIndex:self.selectedSegmentIndex];
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
    [self justMoveIndicatorToSegmentAtIndex:index animated:animated];
    if(_selectedSegmentIndex != index) {
        self.segments[_selectedSegmentIndex].selected = NO;
        self.segments[index].selected = YES;
        _selectedSegmentIndex = index;
        if (animated == YES) { //! 애니메이션 없이 설정했다는 것은 프로그래머가 UIControlEventValueChanged 알림 없이 몰래 옮기겠다는 의도이다.
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)justMoveIndicatorToSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated {

    [self.segments enumerateObjectsUsingBlock:^(MGUNeoSeg *segment, NSUInteger idx, BOOL *stop) {
        if (index == idx) {
            segment.segmentState = MGUNeoSegStateIndicator;
        } else {
            segment.segmentState = MGUNeoSegStateNoIndicator;
        }
    }];

    [self hideAndShowSeparatorsAtIndex:index];
    [self.segmentIndicator moveToFrame:[self indicatorFrameAtIndex:index] animated:animated];
}

//! 터치로 인해서만 임팩트가 오게 한다.
- (void)impactOccurred {
    if (self.impactOff == NO) {
        [self.impactFeedbackGenerator mgrImpactOccurred];
    }
}


#pragma mark - 지원 메서드
//! 인수로 던져지는 segment는 선택된 혹은 선택될 segment이다.
- (CGRect)indicatorFrameAtIndex:(NSInteger)index {
    NSInteger count = self.segments.count;
    CGFloat spacing = self.configuration.interItemSpacing;
    CGFloat baseWidth = (self.bounds.size.width + spacing * (1 - count )) / count;
    CGRect baseRect = CGRectMake(0.0, 0.0, baseWidth, self.bounds.size.height);
    baseRect.origin.x = (baseWidth + spacing) * index;
    
    CGRect indicatorFrameRect =
    CGRectMake(CGRectGetMinX(baseRect)   + self.configuration.segmentIndicatorInset,
               CGRectGetMinY(baseRect)   + self.configuration.segmentIndicatorInset,
               CGRectGetWidth(baseRect)  - (2.0f * self.configuration.segmentIndicatorInset),
               CGRectGetHeight(baseRect) - (2.0f * self.configuration.segmentIndicatorInset));
    return indicatorFrameRect;

    
}

- (CGRect)indicatorMinimumScaleFrameAtIndex:(NSInteger)index {
    
    NSInteger lastIndex = self.segments.count - 1;
    
    CGRect originalIndicatorFrame = [self indicatorFrameAtIndex:index];
    CGRect minimumIndicatorFrame = MGERectPercent(originalIndicatorFrame, MGUNeoSegControlMinimumScale, MGUNeoSegControlMinimumScale);
    
    if (index != 0 && index != lastIndex) {
        return minimumIndicatorFrame;
    }
    
    CGPoint center = MGERectGetCenter(minimumIndicatorFrame);
    CGFloat bottom = originalIndicatorFrame.size.height * MGUNeoSegControlHalfShinkRatio; // 아래에서 줄어든 길이
    CGFloat side = originalIndicatorFrame.size.width * MGUNeoSegControlHalfShinkRatio; // 옆에서 줄어든 길이
    CGFloat shiftValue = ABS(side - bottom);

    if (index == 0) {
        return MGERectAroundCenter(CGPointMake(center.x - shiftValue, center.y), minimumIndicatorFrame.size);
    } else { // last index
        return MGERectAroundCenter(CGPointMake(center.x + shiftValue, center.y), minimumIndicatorFrame.size);
    }

}


#pragma mark - 터치에서 사용되는 지원 메서드
//! 현재 터치 포인트에서 가장 가까운 segment의 index를 찾아준다.
- (NSInteger)indexOfSegmentCloseToTouchPoint:(CGPoint)touchPoint {
    NSArray <MGUNeoSeg *>*segments = self.segments;
    segments = [segments sortedArrayUsingComparator:^NSComparisonResult(MGUNeoSeg *segment1, MGUNeoSeg *segment2) {
        CGSize size = segment1.bounds.size;
        CGPoint point1 = [segment1 convertPoint:CGPointMake(size.width/2.0, size.height/2.0) toView:self];
        size = segment2.bounds.size;
        CGPoint point2 = [segment2 convertPoint:CGPointMake(size.width/2.0, size.height/2.0) toView:self];
        if (ABS(point1.x - touchPoint.x) < ABS(point2.x - touchPoint.x)) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    return [self.segments indexOfObject:segments.firstObject];
}

- (void)touchUpState:(NSInteger)index {
    CGRect frame = [self indicatorFrameAtIndex:index];
    [self.segmentIndicator shrink:NO frame:frame];
    for (MGUNeoSeg *segment in self.segments) {
        segment.shrink = NO;
        segment.highlight = NO;
    }
}

- (void)hideAndShowSeparatorsAtIndex:(NSInteger)index { // index가 NSNotFound이면 모두 보여준다.
    NSInteger count = self.separatorViews.count;
    for (NSInteger i = 0; i < count; i++) {
        UIView *separatorView = self.separatorViews[i];
        if (i == index - 1 || i == index) {
            separatorView.alpha = 0.0;
        } else {
            CATransition *transition = [CATransition animation];
            [transition setType:kCATransitionFade];
            [transition setDuration:0.3f];
            [separatorView.layer addAnimation:transition forKey:nil];
            separatorView.alpha = 1.0;
        }
    }
}


#pragma mark - UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(FALSE, @"- initWithFrame: 사용금지.");
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(FALSE, @"- initWithCoder: 사용금지.");
    return nil;
}

@end
