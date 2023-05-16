//
//  MGURulerView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGURulerView.h"
#import "MGURulerView+DrawIndicator.h"
#import "UIView+Extension.h"
@import GraphicsKit;

@interface MGURulerView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL notify;
@property (nonatomic, assign) CGFloat disPlayValue;
@property (nonatomic, assign) BOOL fingerSound;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView; // 그냥 판대기이다. 혹시나해서 컨테이너로 쓸 수도 있으므로.
@property (nonatomic, strong) UIView *scrollRealContentView;
@property (nonatomic, strong) UIView *centerNiddleContainer;

@property (nonatomic, strong) NSLayoutConstraint *scrollRealContentViewWidthLayoutConstraint;
//@property (nonatomic, assign) BOOL allowDrawing;
//@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) CGRect previousRect;

@property (nonatomic, strong) MGURulerViewConfig *config;
@property (nonatomic, assign) MGURulerViewIndicatorType indicatorType;

@property (nonatomic, strong) NSLayoutConstraint *scrollViewCenterYConstraint; // upper style 적용을 위해.

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tripleTapRecognizer;
@end

@implementation MGURulerView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(CGRectZero, self.bounds) == NO &&
        CGRectEqualToRect(_previousRect, self.bounds) == NO) {
        _previousRect = self.bounds;
        if (self.config.upperStyle == YES) {
            //! 특정 기계(SE2) 특정 상황(Alert에 붙일 때)에서 버그가 발생하여 부득이하게 반올림했다.
            self.scrollViewCenterYConstraint.constant = - round(self.bounds.size.height * (1.0 /8.0));
        }
        [self drawRuler];
        //! 최초 값 설정을 위해.
        [self goToValue:_disPlayValue animated:NO notify:NO];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            if (CGRectEqualToRect(CGRectZero, self.bounds) == NO ) {
                [self drawRuler];
            }
        }];
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                 initialValue:(CGFloat)initialValue
                indicatorType:(MGURulerViewIndicatorType)indicatorType
                       config:(MGURulerViewConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        _disPlayValue = initialValue; // 최초 값으로 사용한다.
        _indicatorType = indicatorType;
        _config = config;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGURulerView *self) { // addSubView가 안되어도 호출된다.
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self->_notify = YES;     // offset이 변경되면 델리게이트에게 알림을 준다.
    self->_weightMode = self.config.weightMode;
    self->_soundOn = YES;
    self->_hasRubberEffect = YES;
       
    self->_scrollView            = [UIScrollView new];
    self->_scrollContentView     = [UIView new];
    self->_scrollRealContentView = [UIView new];
    self->_centerNiddleContainer = [UIView new];
    self.centerNiddleContainer.clipsToBounds = YES;
    self.centerNiddleContainer.layer.masksToBounds = YES; // 자른다.
       
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.scrollRealContentView];
    [self addSubview:self.centerNiddleContainer];

    [self.scrollView mgrPinSizeToSuperviewSize];
    [self.scrollView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    self->_scrollViewCenterYConstraint = [self.scrollView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    self.scrollViewCenterYConstraint.active = YES;
    // [self.scrollView mgrPinEdgesToSuperviewEdges];
    [self.scrollContentView mgrPinEdgesToSuperviewEdges]; //! 높이와 너비를 또 정해줘야한다!!!
    [self.scrollContentView.heightAnchor constraintEqualToAnchor:self.scrollView.heightAnchor].active = YES;
    NSLayoutConstraint *constraint =
    [self.scrollContentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor];
    constraint.priority = UILayoutPriorityDefaultLow; // 늘어나거나 줄어야한다.
    constraint.active = YES;
       
    [self.scrollRealContentView mgrPinEdgesToSuperviewEdges];
    self.scrollRealContentViewWidthLayoutConstraint = [self.scrollRealContentView.widthAnchor constraintEqualToConstant:414.0];
    self.scrollRealContentViewWidthLayoutConstraint.active = YES;
       
    self.centerNiddleContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.centerNiddleContainer.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.centerNiddleContainer.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5].active = YES;
    [self.centerNiddleContainer.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:1.0 / 15.0].active = YES;
    [self.centerNiddleContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
       
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // safe area에 영향을 받지 않는다.
    self.scrollView.scrollsToTop = NO;  // status bar를 탭했을 때, 스크롤을 가장 위로 올리는지 여부
    self.scrollView.pagingEnabled = NO;
    self.scrollContentView.userInteractionEnabled = NO;
    self.centerNiddleContainer.userInteractionEnabled = NO;
       
    self.scrollView.backgroundColor = UIColor.clearColor;
    self.scrollContentView.backgroundColor = UIColor.clearColor;
    self.scrollRealContentView.backgroundColor = UIColor.clearColor;
    self.centerNiddleContainer.backgroundColor = UIColor.clearColor;
       
    self->_tripleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTap:)];
    self.tripleTapRecognizer.numberOfTapsRequired = 3;
   //    tripleTapRecognizer.delaysTouchesBegan = YES;
    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
   //    doubleTapRecognizer.delaysTouchesBegan = YES;
   //    [self.doubleTapRecognizer requireGestureRecognizerToFail:self.tripleTapRecognizer]; // 이것은 델리게이트로 구현함.
    self.tripleTapRecognizer.delegate = self;
    self.doubleTapRecognizer.delegate = self;
    [self addGestureRecognizer:self.doubleTapRecognizer];
    [self addGestureRecognizer:self.tripleTapRecognizer];
    self.doubleTapMove = YES;
    self.tripleTapMove = NO;
    self.doubleTapSpace = 200;
    self.tripleTapSpace = 300;
}

- (void)drawRuler {
    self.layer.mask = nil;
    for (CALayer *layer in self.centerNiddleContainer.layer.sublayers.reverseObjectEnumerator) {
#if DEBUG && TARGET_OS_SIMULATOR
        NSLog(@"centerNiddle.layer removeFromSuperlayer 호출!");
#endif
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.scrollRealContentView.layer.sublayers.reverseObjectEnumerator) {
#if DEBUG && TARGET_OS_SIMULATOR
        NSLog(@"scrollRealContentView.layer removeFromSuperlayer 호출!");
#endif
        [layer removeFromSuperlayer];
    }
    for (UILabel *label in self.scrollRealContentView.subviews.reverseObjectEnumerator) {
#if DEBUG && TARGET_OS_SIMULATOR
        NSLog(@"scrollRealContentView removeFromSuperview 호출!");
#endif
        [label removeFromSuperview];
    }
    
    self.scrollRealContentViewWidthLayoutConstraint.constant = [self realContentWidth];
    
    [self drawIndicator];
    [self drawNiddle];
    
    self.layer.mask = ({
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.contentsScale = UIScreen.mainScreen.scale;
        maskLayer.frame = self.layer.bounds;
        UIColor *bothEndColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        maskLayer.colors = @[(id)[bothEndColor CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[bothEndColor CGColor]];
        maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
        maskLayer.startPoint = CGPointMake(0.0, 0.5);
        maskLayer.endPoint = CGPointMake(1.0, 0.5);
        maskLayer;
    });
}

- (void)drawIndicator { // - drawRuler에서만 호출된다.
    if (self.indicatorType == MGURulerViewIndicatorBallHeadType) {
        [self drawBallHeadIndicator];
    } else if (self.indicatorType == MGURulerViewIndicatorWheelHeadType) {
        [self drawWheelHeadIndicator];
    } else if (self.indicatorType == MGURulerViewIndicatorLineType) {
        [self drawLineIndicator];
    }
    return;
}

- (void)drawNiddle { // - drawRuler에서만 호출된다.
    CAShapeLayer *littleNiddleLayer = [CAShapeLayer layer];
    CAShapeLayer *mediumNiddleLayer = [CAShapeLayer layer];
    CAShapeLayer *longNiddleLayer = [CAShapeLayer layer];
    littleNiddleLayer.frame = self.scrollRealContentView.layer.bounds;
    mediumNiddleLayer.frame = self.scrollRealContentView.layer.bounds;
    longNiddleLayer.frame = self.scrollRealContentView.layer.bounds;
    [self.scrollRealContentView.layer addSublayer:littleNiddleLayer];
    [self.scrollRealContentView.layer addSublayer:mediumNiddleLayer];
    [self.scrollRealContentView.layer addSublayer:longNiddleLayer];
    
    littleNiddleLayer.contentsScale = UIScreen.mainScreen.scale;
    mediumNiddleLayer.contentsScale = UIScreen.mainScreen.scale;
    longNiddleLayer.contentsScale = UIScreen.mainScreen.scale;
    littleNiddleLayer.strokeColor = self.config.littleNiddleColor.CGColor;
    mediumNiddleLayer.strokeColor = self.config.mediumNiddleColor.CGColor;
    longNiddleLayer.strokeColor = self.config.longNiddleColor.CGColor;
    littleNiddleLayer.lineWidth = self.config.littleNiddleWidth;
    mediumNiddleLayer.lineWidth = self.config.mediumNiddleWidth;
    longNiddleLayer.lineWidth = self.config.longNiddleWidth;
    littleNiddleLayer.lineCap = kCALineCapRound;
    mediumNiddleLayer.lineCap = kCALineCapRound;
    longNiddleLayer.lineCap = kCALineCapRound;
    
    UIBezierPath *littleNiddlePath = [UIBezierPath bezierPath];
    UIBezierPath *mediumNiddlePath = [UIBezierPath bezierPath];
    UIBezierPath *longNiddlePath = [UIBezierPath bezierPath];
    
    if (self.config.showHorizontalLine == YES) {
        CGPoint centerStartLine = CGPointMake(self.scrollView.frame.size.width / 2.0f,
                                              self.scrollView.frame.size.height / 2.0f);
        CGPoint centerEndLine   = CGPointMake([self realContentWidth] - centerStartLine.x, centerStartLine.y);
        [littleNiddlePath moveToPoint:centerStartLine];
        [littleNiddlePath addLineToPoint:centerEndLine];
    }
    
    NSInteger totalNiddleCount = self.numberOfNiddle;
    for (NSInteger i = 0; i < totalNiddleCount; i++ ) {
        if (i % 10 == 0) {
            [longNiddlePath moveToPoint:[self verticalNiddleStartPointAtIndex:i]];
            [longNiddlePath addLineToPoint:[self verticalNiddleEndPointAtIndex:i]];
            UILabel *label = [self numLabelAtIndex:i];
            [self.scrollRealContentView addSubview:label];
        } else if (i % 10 == 5) {
            [mediumNiddlePath moveToPoint:[self verticalNiddleStartPointAtIndex:i]];
            [mediumNiddlePath addLineToPoint:[self verticalNiddleEndPointAtIndex:i]];
        } else {
            [littleNiddlePath moveToPoint:[self verticalNiddleStartPointAtIndex:i]];
            [littleNiddlePath addLineToPoint:[self verticalNiddleEndPointAtIndex:i]];
        }
    }
    
    littleNiddleLayer.path = littleNiddlePath.CGPath;
    mediumNiddleLayer.path = mediumNiddlePath.CGPath;
    longNiddleLayer.path = longNiddlePath.CGPath;
}


#pragma mark - 세터 & 게터
- (CGFloat)pointInOneNiddleSpace { // 바늘 한 칸당 포인트. folat 값이다.
    return self.scrollView.frame.size.width / 30.f;
}

//! TODO: Kg, LB에 따라 다르게 해야한다. 지금은 Kg에 맞춰서 만들어보자.
- (NSInteger)maxValue {
    if (_weightMode == MGURulerViewWeightModeKG) {
        return 200;
    } else {
        return 441;
    }
    //
    // 200 Kg = 440.924524 파운드(lb)
}

- (CGFloat)offsetXForValue:(CGFloat)value { // 값에 대한 offset을 계산해준다. 단위는 0.1 단위이다. 반올림으로 계산한다.
    CGFloat val = round(value * 10.0) / 10.0;  // 63.4567 -> 63.5
    NSInteger count = (NSInteger)(val * 10.0); // 총 몇칸을 움직이는지
    CGFloat targetOffset = count * [self pointInOneNiddleSpace];
    return MAX(MIN([self maxContentOffsetX], targetOffset), 0.0);
}

- (CGFloat)maxContentOffsetX { // minContentOffset은 당연히 0이다.
    return (self.numberOfNiddleSpace * self.pointInOneNiddleSpace);
}

- (CGFloat)realValue { // 실제 offset에 의하여 계산된 value이다.
    CGFloat offsetX = self.scrollView.contentOffset.x;
    return (offsetX / [self pointInOneNiddleSpace]) * 0.1; // 0.1은 바늘 한 칸의 단위이다. 0.1 kg
}

- (void)setDisPlayValue:(CGFloat)disPlayValue {
    //! Rubber Effect 시작.
    //! Rubber Effect를 여기서 호출 시키는 것이 더 자연스러웠다.
    CGRect bounds = self.scrollContentView.bounds;
    CGFloat xOffset = self.scrollView.contentOffset.x;
    if (self.scrollView.tracking == NO || xOffset < 0.0 || xOffset > [self maxContentOffsetX]) {
        if (bounds.origin.x != 0.0) {
            bounds.origin.x = 0.0;
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.1
                                                                  delay:0.0
                                                                options:UIViewAnimationOptionCurveLinear
                                                             animations:^{
                self.scrollContentView.bounds = bounds;
            } completion:nil];
        }
    } else {
        CGFloat pointInOneNiddleSpace = [self pointInOneNiddleSpace];
        CGFloat modValue = fmod(xOffset, pointInOneNiddleSpace);
        CGFloat ratio = modValue / pointInOneNiddleSpace;
        
        // MGREaseInOutSpecial(CGFloat density, CGFloat currentTime) - density가 커지면 커질수록 세진다. 2.0이면 2차함수이다.
        CGFloat result = (MGEEaseInOutSpecial(10.0, ratio) - ratio) * pointInOneNiddleSpace;
        bounds.origin.x = result;
        
        if (_disPlayValue != disPlayValue) {
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.1
                                                                  delay:0.0
                                                                options:UIViewAnimationOptionCurveLinear
                                                             animations:^{
                self.scrollContentView.bounds = bounds;
            } completion:nil];
        } else {
            self.scrollContentView.bounds = bounds;
        }
    }
    //! Rubber Effect 끝.
    
    if (_disPlayValue != disPlayValue) {
        CGFloat oldDisPlayValue = _disPlayValue;
        _disPlayValue = disPlayValue;
        
        if(self.notify == NO) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(rulerViewDidScroll:currentDisplayValue:)]) {
            [self.delegate rulerViewDidScroll:self currentDisplayValue:[self disPlayValue]];
        }
        if (self.soundOn == YES && self.fingerSound == YES) {
            if (self.scrollView.tracking == YES) {
                if (self.normalSoundPlayBlock != nil) {
                    self.normalSoundPlayBlock();
                }
            } else if (floor(oldDisPlayValue) != floor(disPlayValue)) {
                if (self.normalSoundPlayBlock != nil) {
                    self.normalSoundPlayBlock();
                }
            }
        }
    }
}

- (NSInteger)numberOfNiddle { // 바늘의 갯수
    return (self.maxValue * 10) + 1;
}

- (NSInteger)numberOfNiddleSpace { // 바늘과 바늘 사이가 만드는 칸의 갯수
    return (self.maxValue * 10);
}

- (NSInteger)numberOfNumberLabel { // 라벨의 갯수 0을 포함하므로 maxValue보다 1개 많다.
    return self.maxValue + 1;
}

- (CGFloat)realContentWidth {
    return (self.numberOfNiddleSpace * self.pointInOneNiddleSpace) + self.scrollView.frame.size.width;
}

- (CGFloat)longNiddleLength {
    return self.scrollView.frame.size.height / 2.0;
}
- (CGFloat)middleNiddleLength {
    return self.longNiddleLength / 2.0;
}
- (CGFloat)shortNiddleLength {
    return self.middleNiddleLength / 2.0;
}

- (CGPoint)verticalNiddleStartPointAtIndex:(NSInteger)index {
    CGFloat pointX = (self.scrollView.frame.size.width / 2.0) + (index * self.pointInOneNiddleSpace);
    CGFloat pointY;
    if ((index % 10) == 0) { //! long
        pointY = self.scrollView.frame.size.height * self.config.longNiddleVerticalPositionStart;
    } else if ((index % 5) == 0) { //! middle
        pointY = self.scrollView.frame.size.height * self.config.mediumNiddleVerticalPositionStart;
    } else { //! little
        pointY = self.scrollView.frame.size.height * self.config.littleNiddleVerticalPositionStart;
    }
    return CGPointMake(pointX, pointY);
}

- (CGPoint)verticalNiddleEndPointAtIndex:(NSInteger)index {
    CGPoint point = [self verticalNiddleStartPointAtIndex:index];
    if ((index % 10) == 0) { //! long
        point.y = self.scrollView.frame.size.height * self.config.longNiddleVerticalPositionEnd;
    } else if ((index % 5) == 0) { //! middle
        point.y = self.scrollView.frame.size.height * self.config.mediumNiddleVerticalPositionEnd;
    } else { //! little
        point.y = self.scrollView.frame.size.height * self.config.littleNiddleVerticalPositionEnd;
    }
    
    return point;
}

- (UILabel *)numLabelAtIndex:(NSInteger)index { // 10 단위로 호출된다.
    CGSize labelSize = CGSizeMake(self.scrollView.frame.size.height * (3.0 / 5.0), self.scrollView.frame.size.height / 5.0);
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGPointZero, labelSize}];
    
    CGPoint center = [self verticalNiddleStartPointAtIndex:index];
    center.y = self.scrollView.frame.size.height * (7.0 / 8.0);
    label.center = center;
    label.font = [self.config.font fontWithSize:label.bounds.size.height * self.config.labelSize];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.tag = index / 10;
    label.text = [NSString stringWithFormat:@"%ld.0", (long)label.tag];
    label.textColor = self.config.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


#pragma mark - 컨트롤
- (void)refreshDisplayValue {
    CGFloat disPlayValue = [self realValue];
    if (disPlayValue <= 0.0) {
        [self setDisPlayValue:0.0];
    } else if (disPlayValue >= (CGFloat)[self maxValue]) {
        [self setDisPlayValue:(CGFloat)[self maxValue]];
    } else {
        [self setDisPlayValue:(round(disPlayValue * 10.0) / 10.0)]; // 소숫점 두 째자리에서 반올림하여 첫 째자리까지 표현한다.
    }
}

- (void)moveToLeft {
    _notify = YES;
    if (self.scrollView.contentOffset.x <= 0.0) {
        return;
    } else if (self.scrollView.contentOffset.x - [self pointInOneNiddleSpace] < 0.0) {
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
        return;
    }
    
    CGFloat targetOffsetX = self.scrollView.contentOffset.x - [self pointInOneNiddleSpace];
    targetOffsetX = targetOffsetX / self.pointInOneNiddleSpace;
    targetOffsetX = round(targetOffsetX); // 반올림 함수를 써서 가까운 곳에 붙게 하자.
    targetOffsetX = targetOffsetX * self.pointInOneNiddleSpace;

    [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0.0) animated:NO];
}

- (void)moveToRight {
    _notify = YES;
    if (self.scrollView.contentOffset.x >= [self maxContentOffsetX]) {
        return;
    }
    if (self.scrollView.contentOffset.x + [self pointInOneNiddleSpace] > [self maxContentOffsetX]) {
        [self.scrollView setContentOffset:CGPointMake([self maxContentOffsetX], 0.0) animated:NO];
        return;
    }
    
    CGFloat targetOffsetX = self.scrollView.contentOffset.x + [self pointInOneNiddleSpace];
    targetOffsetX = targetOffsetX / self.pointInOneNiddleSpace;
    targetOffsetX = round(targetOffsetX); // 반올림 함수를 써서 가까운 곳에 붙게 하자.
    targetOffsetX = targetOffsetX * self.pointInOneNiddleSpace;

    [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0.0) animated:NO];
}

- (void)moveFarToLeft {
    [self moveToLeftSpaces:100];
}

- (void)moveFarToRight {
    [self moveToRightSpaces:100];
}

- (void)moveToLeftSpaces:(NSUInteger)spaces {
    _notify = YES;
    if (self.scrollView.contentOffset.x <= 0.0) {
        return;
    }
    if (self.soundOn == YES) {
        self.fingerSound = NO;
        if (self.skipSoundPlayBlock != nil) {
            self.skipSoundPlayBlock();
        }
    }
    if (self.scrollView.contentOffset.x - spaces * [self pointInOneNiddleSpace] < 0.0) {
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        return;
    }
    
    CGFloat targetOffsetX = self.scrollView.contentOffset.x - spaces * [self pointInOneNiddleSpace];
    targetOffsetX = targetOffsetX / self.pointInOneNiddleSpace;
    targetOffsetX = round(targetOffsetX); // 반올림 함수를 써서 가까운 곳에 붙게 하자.
    targetOffsetX = targetOffsetX * self.pointInOneNiddleSpace;

    [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0.0) animated:YES];
}

- (void)moveToRightSpaces:(NSUInteger)spaces {
    _notify = YES;
    if (self.scrollView.contentOffset.x >= [self maxContentOffsetX]) {
        return;
    }
    if (self.soundOn == YES) {
        self.fingerSound = NO;
        if (self.skipSoundPlayBlock != nil) {
            self.skipSoundPlayBlock();
        }
    }

    if (self.scrollView.contentOffset.x + spaces * [self pointInOneNiddleSpace] > [self maxContentOffsetX]) {
        [self.scrollView setContentOffset:CGPointMake([self maxContentOffsetX], 0.0) animated:YES];
        return;
    }
    
    CGFloat targetOffsetX = self.scrollView.contentOffset.x + spaces * [self pointInOneNiddleSpace];
    targetOffsetX = targetOffsetX / self.pointInOneNiddleSpace;
    targetOffsetX = round(targetOffsetX); // 반올림 함수를 써서 가까운 곳에 붙게 하자.
    targetOffsetX = targetOffsetX * self.pointInOneNiddleSpace;
    [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0.0) animated:YES];
}

- (void)goToValue:(CGFloat)value animated:(BOOL)animated notify:(BOOL)notify {
    CGFloat targetOffsetX = [self offsetXForValue:value];
    self.notify = notify;
    if (animated == YES) {
        [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0.0) animated:YES];
    } else if (animated == NO) {
        [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0.0) animated:NO];
    }
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.fingerSound = YES;
    self.notify = YES;
}

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView { // 조금이라도 움직일 때마다 호출된다.
     [self refreshDisplayValue];
     /** 최초에는 Rubber Effect를 여기에서 호출했지만, 실제로 만들어보니, - refreshDisplayValue - setDisPlayValue: 에서 호출되는게 더 자연스러웠음.
     if (self.hasRubberEffect == YES) {
         [self rubberEffect];
     }
      */
 }

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView // 손가락이 떨어질 때, 앞으로 멈춰질 오프셋을 예측하여 알려준다.
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    *targetContentOffset = [self targetOffsetFromProposedOffset:*targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate { // 손가락이 떨이질때 호출.
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"scrollViewDidEndDragging: willDecelerate: %d", decelerate);
#endif
    if(decelerate == NO){ // 터치로 스크롤이 멈출때(decelerate == NO), 즉 손을 때는 시점에서 스크롤 뷰가 움직이지 않을 때.
        scrollView.contentOffset = [self targetOffsetFromProposedOffset:scrollView.contentOffset];
    } else { // 스와이프로 밀어서 손가락이 떨어지고 스스로 굴러 갈때(decelerate == YES)
    }
}

// - (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {}
// - (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {}
// - (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { // 스와이프로 스크롤이 돌다가 멈출때
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"scrollViewDidEndDecelerating:!");
#endif
    scrollView.contentOffset = [self targetOffsetFromProposedOffset:scrollView.contentOffset];
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.doubleTapRecognizer) {
        if (self.doubleTapMove == YES) {
            self.notify = YES;
            return YES;
        } else {
            return NO;
        }
    } else if (gestureRecognizer == self.tripleTapRecognizer) {
        if (self.tripleTapMove == YES) {
            self.notify = YES;
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.doubleTapRecognizer &&
        otherGestureRecognizer == self.tripleTapRecognizer &&
        self.tripleTapMove == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)tripleTapRecognizer {
    CGFloat pointX = [tripleTapRecognizer locationInView:self].x;
    if (CGRectGetMidX(self.bounds) < pointX) {
        [self moveToRightSpaces:self.tripleTapSpace];
    } else {
        [self moveToLeftSpaces:self.tripleTapSpace];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGFloat pointX = [tapGestureRecognizer locationInView:self].x;
    if (CGRectGetMidX(self.bounds) < pointX) {
        [self moveToRightSpaces:self.doubleTapSpace];
    } else {
        [self moveToLeftSpaces:self.doubleTapSpace];
    }
}

#pragma mark - Helper
- (CGPoint)targetOffsetFromProposedOffset:(CGPoint)proposedOffset {
    CGFloat f = proposedOffset.x;

    f = f / self.pointInOneNiddleSpace;
    f = round(f); // 반올림 함수를 써서 가까운 곳에 붙게 하자.
    f = f * self.pointInOneNiddleSpace;

    return CGPointMake(f, proposedOffset.y);
}

/** - scrollViewDidScroll:에서 호출되는 것 보다 - refreshDisplayValue - setDisPlayValue: 내부에서 구현되는 것이 더 자연스러웠다.
- (void)rubberEffect {
    CGRect bounds = self.scrollContentView.bounds;
    CGFloat xOffset = self.scrollView.contentOffset.x;
    if (self.scrollView.tracking == NO || xOffset < 0.0 || xOffset > [self maxContentOffsetX]) {
        if (bounds.origin.x != 0.0) {
            bounds.origin.x = 0.0;
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.1
                                                                  delay:0.0
                                                                options:UIViewAnimationOptionCurveLinear
                                                             animations:^{
                self.scrollContentView.bounds = bounds;
            } completion:nil];
        }
        return;
    }
    
    CGFloat pointInOneNiddleSpace = [self pointInOneNiddleSpace];
    CGFloat modValue = fmod(xOffset, pointInOneNiddleSpace);
    CGFloat ratio = modValue / pointInOneNiddleSpace;
    
    // MGREaseInOutSpecial(CGFloat density, CGFloat currentTime) - density가 커지면 커질수록 세진다. 2.0이면 2차함수이다.
    CGFloat result = (MGREaseInOutSpecial(10.0, ratio) - ratio) * pointInOneNiddleSpace; // 10차 함수.
    bounds.origin.x = result;
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.1
                                                          delay:0.0
                                                        options:UIViewAnimationOptionCurveLinear
                                                     animations:^{
        self.scrollContentView.bounds = bounds;
    } completion:nil];
    
}
*/


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }

@end

/* Ruler 뷰에 해당하는 값을 라벨에 표시할 때. '.'을 중심으로 예쁘게 정렬시키기 위해.
#pragma mark - <MGURulerViewDelegate>
- (void)rulerViewDidScroll:(MGURulerView *)rulerView currentDisplayValue:(CGFloat)currentDisplayValue {
    self.label.attributedText =
        MGURulerViewMainLabelAttrStr(currentDisplayValue,
                                     [UIFont fontWithName:@"Menlo-Bold" size:34.0],
                                     [UIColor whiteColor]);
}
*/
NSAttributedString *MGURulerViewMainLabelAttrStr(CGFloat value, UIFont *font, UIColor *color) {
    NSString *string = [NSString stringWithFormat:@"%.1f", value];
    
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attributes = @{ NSFontAttributeName : font,
                                         NSForegroundColorAttributeName : color,
                                         NSParagraphStyleAttributeName  : paragraphStyle }.mutableCopy;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                         attributes:attributes];
    NSMutableDictionary *spaceAttributes = attributes.mutableCopy;
    spaceAttributes[NSForegroundColorAttributeName] = [UIColor clearColor];
    
    NSAttributedString *emptyAtributedWhitespace = [[NSAttributedString alloc] initWithString:@"_"
                                                                                    attributes:spaceAttributes.copy];
    
    if (value >= 100.0) {
        [attributedString appendAttributedString:emptyAtributedWhitespace];
        [attributedString appendAttributedString:emptyAtributedWhitespace];
    } else if (value >= 10.0) {
        [attributedString appendAttributedString:emptyAtributedWhitespace];
    }

    return attributedString.copy;
}


//! <UIScrollViewDelegate>
//! Managing Zooming - 이 부분은 사용하지 않을 것이다.
// - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {}
// - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {}
// - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {}
// - (void)scrollViewDidZoom:(UIScrollView *)scrollView {}

//! Responding to Inset Changes - 이 부분은 사용하지 않을 것이다.
// - (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {}

//! Responding to Scrolling Animations
// - (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {}
