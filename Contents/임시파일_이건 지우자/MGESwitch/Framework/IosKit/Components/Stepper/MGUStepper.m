//
//  MGUStepper.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUStepper.h"
@import BaseKit;
@import GraphicsKit;
#import "MGUStepperAnimationDecoView.h"

typedef NS_ENUM(NSUInteger, MGUStepperState) {
    MGUStepperStateStable= 1,
    MGUStepperStateShouldIncrease,
    MGUStepperStateShouldDecrease
};

typedef NS_ENUM(NSUInteger, MGUStepperLabelPanState) {
    MGUStepperLabelPanStateStable= 1,
    MGUStepperLabelPanStateHitRightEdge,
    MGUStepperLabelPanStateHitLeftEdge
};

typedef NS_ENUM(NSUInteger, MGUStepperCurrentTouchPostion) {
    MGUStepperCurrentTouchPostionLeft = 1,
    MGUStepperCurrentTouchPostionRight
};

//! 각 세그먼트의 최소의 폭은 64.0으로 확보한다.
static CGFloat const kMinimumButtonWidth = 47.0f;

@interface MGUStepper ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray <UIView *>*separators;
@property (nonatomic, strong) MGUStepperAnimationDecoView *leftPushAnimationView;
@property (nonatomic, strong) MGUStepperAnimationDecoView *rightPushAnimationView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong, nullable, readonly) NSString *formattedValue; // @dynamic

//! stepperState의 세터가 값 변경 및 타이머를 작동시킨다. 매우 조심해야한다. 함부러 호출하면 안된다.
@property (nonatomic, assign) MGUStepperState stepperState; // 디폴트 StepperStateStable
@property (nonatomic, assign) MGUStepperLabelPanState panState; // 디폴트 LabelPanStateStable // 이게 필요하다. 팬에서 계속 Timer 만들 수 있다.

@property (nonatomic, assign) CGFloat labelSlideLength; //  디폴트 5.0f; 가운데서 얼마나 움직이게 할 것인가.
@property (nonatomic, assign) NSTimeInterval labelSlideDuration; //  디폴트 0.1;

@property (nonatomic, assign) MGUStepperCurrentTouchPostion currentTouchPostion; //  left
@property (nonatomic, assign) BOOL labelGesture; //  left

@property (nonatomic, nullable) MGUStepperConfiguration *configuration; // 설정에 해당하는 객체이다.
@property (nonatomic, strong) MGEAccelerationTimer *accelerationTimer;

@end

@implementation MGUStepper
@dynamic fullColor;
@dynamic formattedValue;
@dynamic impactColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled { //! 가운데, 라벨을 제외한 나머지들을 enable 시킬 것인지 결정. 가운데 라벨은 enable로 
    [super setEnabled:enabled];
    if (enabled == YES) {
        [self straightenOutObjectState];
    } else {
        self.leftButton.enabled = NO;
        self.rightButton.enabled = NO;
    }
    
    if (self.label.enabled == NO) {
        self.label.enabled = YES;
    }
}

- (void)dealloc {
#if DEBUG
    NSLog(@"MGUStepper Dealloc");
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize intrinsicContentSize = self.configuration.intrinsicContentSize;
    if (CGSizeEqualToSize(intrinsicContentSize, CGSizeZero) != YES) {
        return intrinsicContentSize;
    } else {
        if (self.stepperLabelType == MGUStepperLabelTypeHidden) {
            return CGSizeMake(kMinimumButtonWidth * 2.0 + self.separatorWidth, 32.0);
        } else {
            CGFloat width = ((kMinimumButtonWidth + self.separatorWidth) * 2.0) / (1.0 - self.labelWidthRatio);
            return CGSizeMake(width, 32.0);
        }
    }
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.frame = self.bounds;
    CGFloat buttonWidth;
    if (self.stepperLabelType != MGUStepperLabelTypeHidden) { // ShowFixed || ShowDraggable
        CGFloat labelWidth =  self.bounds.size.width * self.labelWidthRatio;
        buttonWidth = ((self.bounds.size.width - labelWidth) / 2.0) - self.separatorWidth;
        self.label.frame = CGRectMake(buttonWidth + self.separatorWidth, 0.0, labelWidth, self.bounds.size.height);
    } else { // MGUStepperLabelTypeHidden
        buttonWidth = (self.bounds.size.width - self.separatorWidth) / 2.0; // separator 굵기 1.0
    }

    self.leftButton.frame = CGRectMake(0.0, 0.0, buttonWidth, self.bounds.size.height);
    self.rightButton.frame = CGRectMake(self.bounds.size.width - buttonWidth, 0.0, buttonWidth, self.bounds.size.height);
    
    self.leftPushAnimationView.frame  = self.leftButton.frame;
    self.rightPushAnimationView.frame  = self.rightButton.frame;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIView *separator = self.separators[i];
        separator.frame = CGRectMake(0.0, 0.0, self.separatorWidth, self.bounds.size.height * self.separatorHeightRatio);
        separator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        if (i == 0) {
            separator.center = CGPointMake(self.leftButton.frame.size.width + 0.5, separator.center.y);
        } else if (i == 2) {
            separator.center =
            CGPointMake(self.leftButton.frame.size.width + self.label.frame.size.width + 1.5, separator.center.y);
        }
    }
    
    if (self.stepperLabelType == MGUStepperLabelTypeHidden) { // 가운데 하나만 존재
        self.separators.firstObject.hidden = YES;
        self.separators[1].hidden = NO;
        self.separators.lastObject.hidden = YES;
    } else { // 양쪽에 두개 존재.
        self.separators.firstObject.hidden = NO;
        self.separators[1].hidden = YES;
        self.separators.lastObject.hidden = NO;
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint locationPoint = [touch locationInView:self];
    
    if (self.stepperLabelType == MGUStepperLabelTypeShowDraggable &&
        CGRectContainsPoint(self.label.frame, locationPoint) == YES) {
        self.labelGesture = YES;
        return [super beginTrackingWithTouch:touch withEvent:event];
    }
    
    self.labelGesture = NO;
    self.currentTouchPostion = [self calculateTouchPostion:locationPoint.x];
    
    if (self.currentTouchPostion == MGUStepperCurrentTouchPostionLeft) {
        if (self.value != self.minimumValue) {
            [self touchDown:self.leftButton];
        }
    } else {
        if (self.value != self.maximumValue) {
            [self touchDown:self.rightButton];
        }
    }
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.labelGesture == YES) {
        [self handleLabelPanGestureTouch:touch withEvent:event];
        return [super continueTrackingWithTouch:touch withEvent:event];
    }
    MGUStepperCurrentTouchPostion currentTouchPostion = [self calculateTouchPostion:[touch locationInView:self].x];
    if (currentTouchPostion != self.currentTouchPostion) {
        if (currentTouchPostion == MGUStepperCurrentTouchPostionRight) {
            [self reset:self.leftButton];
            [self touchDown:self.rightButton];
        } else {
            [self reset:self.rightButton];
            [self touchDown:self.leftButton];
        }
        self.currentTouchPostion = currentTouchPostion;
    }
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self reset:nil];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self endTrackingWithTouch:nil withEvent:event];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame configuration:(MGUStepperConfiguration * _Nullable)configuration {
    _configuration = configuration;
    return [self initWithFrame:frame];
}

- (instancetype)initWithConfiguration:(MGUStepperConfiguration * _Nullable)configuration {
    return [self initWithFrame:CGRectZero configuration:configuration];
}

static void CommonInit(MGUStepper *self) {
    if (self.configuration == nil) {
        self.configuration = [MGUStepperConfiguration defaultConfiguration];
    }
    
    self->_value = self.configuration.value;
    self->_minimumValue = self.configuration.minimumValue;
    self->_maximumValue = self.configuration.maximumValue;
    self->_stepValue = self.configuration.stepValue;
    self->_showIntegerIfDoubleIsInteger = self.configuration.showIntegerIfDoubleIsInteger;
    
    self->_cornerRadius  = self.configuration.cornerRadius;
    self->_borderWidth = self.configuration.borderWidth;
    self->_borderColor = self.configuration.borderColor;
    self->_limitHitAnimationColor = self.configuration.limitHitAnimationColor;
    
    self->_separatorColor = self.configuration.separatorColor;
    self->_separatorWidth = self.configuration.separatorWidth;
    self->_separatorHeightRatio = self.configuration.separatorHeightRatio;
    
    self->_autorepeat = self.configuration.autorepeat;
    self->_leftNormalImage = self.configuration.leftNormalImage;
    self->_leftDisabledImage = self.configuration.leftDisabledImage;
    self->_rightNormalImage = self.configuration.rightNormalImage;
    self->_rightDisabledImage = self.configuration.rightDisabledImage;
    
    self->_buttonsContensColor = self.configuration.buttonsContensColor;
    self->_buttonsBackgroundColor = self.configuration.buttonsBackgroundColor;
    self->_buttonsFont = self.configuration.buttonsFont;
    
    self->_stepperLabelType = self.configuration.stepperLabelType;
    self->_isStaticLabelTitle = self.configuration.isStaticLabelTitle;
    self->_labelTextColor = self.configuration.labelTextColor;
    self->_labelBackgroundColor = self.configuration.labelBackgroundColor;
    self->_labelFont = self.configuration.labelFont;
    self->_labelWidthRatio = self.configuration.labelWidthRatio;
    self->_labelCornerRadius = self.configuration.labelWidthRatio;
    self->_labelSlideLength = 5.0f;
    self->_labelSlideDuration = 0.1;
    
    self->_stepperState = MGUStepperStateStable;
    self->_panState = MGUStepperLabelPanStateStable;
    
    self->_items = self.configuration.items;
    
    //! backgroundColor fullColor로 연동된다. <- IB 에 연동이 잘되지 않아서 따로 더 만들었다.
    
    self.backgroundColor = self.configuration.fullColor;
    self.layer.cornerRadius = self.configuration.cornerRadius;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.clipsToBounds = YES;
    
    self->_formatter = [NSNumberFormatter new];
    [self setupNumberFormatter]; // 여러번 호출될 수 있다.
    
    [self initializeContainerView]; //! container view가 userInteractionEnabled NO이다.
    [self initializeSeparators];
    [self initializePushAnimationViews];
    [self initializeButtons];
    [self initializeLabel];
    [self.containerView addSubview:self.leftPushAnimationView];
    [self.containerView addSubview:self.rightPushAnimationView];
    [self.containerView addSubview:self.leftButton];
    [self.containerView addSubview:self.rightButton];
    [self.containerView addSubview:self.label];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reset:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [self straightenOutObjectState];
    
    //! Static Analyze 가 알려주지 않는다. 조심하자.
    __weak __typeof(self)weakSelf = self;
    self->_accelerationTimer = [MGEAccelerationTimer accelerationTimerWithUpdateBlock:^{
        __strong __typeof(weakSelf) self = weakSelf;
         [self updateValue];
        if (self.value == self.maximumValue || self.value == self.minimumValue) {
            [self.accelerationTimer invalidate];
        }
    }];

}

- (void)initializeContainerView {
    _containerView = [UIView new];
    self.containerView.frame = self.bounds;
    self.containerView.userInteractionEnabled = NO; //! 이게 중요하다.
    self.containerView.clipsToBounds = YES;
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = self.cornerRadius;
    [self addSubview:self.containerView];
}

- (void)initializePushAnimationViews {
    _leftPushAnimationView = [MGUStepperAnimationDecoView new];
    _rightPushAnimationView = [MGUStepperAnimationDecoView new];
    for (MGUStepperAnimationDecoView *view in @[self.leftPushAnimationView, self.rightPushAnimationView]) {
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.backgroundColor = [UIColor clearColor].CGColor;
        view.cornerRadius = self.cornerRadius;
        view.impactColor = self.configuration.impactColor;
    }
}

- (void)initializeSeparators {
    _separators = @[[UIView new], [UIView new], [UIView new]];
    for (UIView *view in self.separators) {
        view.backgroundColor = self.separatorColor;
        [self.containerView addSubview:view];
    }
}

- (void)initializeButtons {
    _leftButton = [UIButton new];
//    self.leftButton.adjustsImageWhenHighlighted = NO;
    self.leftButton.backgroundColor = self.buttonsBackgroundColor;
    self.leftButton.tintColor = self.buttonsContensColor;
    [self.leftButton setImage:self.leftNormalImage forState:UIControlStateNormal];
    [self.leftButton setImage:self.leftDisabledImage forState:UIControlStateDisabled];
    
    _rightButton = [UIButton new];
//    self.rightButton.adjustsImageWhenHighlighted = NO;
    self.rightButton.backgroundColor = self.buttonsBackgroundColor;
    self.rightButton.tintColor = self.buttonsContensColor;
    [self.rightButton setImage:self.rightNormalImage forState:UIControlStateNormal];
    [self.rightButton setImage:self.rightDisabledImage forState:UIControlStateDisabled];
}

- (void)initializeLabel {
    _label = [UILabel new];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = self.formattedValue;
    self.label.textColor = self.labelTextColor;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.minimumScaleFactor = 0.5;
    self.label.backgroundColor = self.labelBackgroundColor;
    self.label.font = self.labelFont;
    self.label.layer.cornerRadius = self.labelCornerRadius;
    self.label.layer.masksToBounds = YES;
    self.label.layer.borderColor = self.borderColor.CGColor;
}


#pragma mark - 세터 & 게터
- (void)setValue:(CGFloat)value {
    if (_value != value) {
        _value = MIN(self.maximumValue, MAX(self.minimumValue, value));
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self straightenOutObjectState];
    }
    
    self.label.text = self.formattedValue;
}

- (NSString *)formattedValue {
    if (self.isStaticLabelTitle == YES) {
        return self.items.firstObject;
    }
    
    BOOL isInteger = (MGRCalculateNumberOfDecimalPlaces(self.value) == 0) ? YES : NO;
    // 아이템을 가지고 있다면, 스탭 단위로 표현할 것이다. 일반적인 경우가 아니다. 숫자 대신, 특정한 문자열을 보여주는 것이다.
    if (isInteger && self.stepValue == 1.0 && self.items.count > 0) {
        return self.items[(NSInteger)(self.value)];
    } else {
        return [self.formatter stringFromNumber:@(self.value)];
    }
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
    self.value = MIN(self.maximumValue, MAX(self.minimumValue, self.value)); // 조정된 minimum이 현재 value보다 크면 다시 설정
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    self.value = MIN(self.maximumValue, MAX(self.minimumValue, self.value)); // 조정된 maxmum이 현재 value보다 작으면 다시 설정
}

- (void)setStepValue:(CGFloat)stepValue {
    _stepValue = stepValue;
    [self setupNumberFormatter];
}

- (void)setShowIntegerIfDoubleIsInteger:(BOOL)showIntegerIfDoubleIsInteger {
    _showIntegerIfDoubleIsInteger = showIntegerIfDoubleIsInteger;
    [self setupNumberFormatter];
}

- (void)setLeftNormalImage:(UIImage *)leftNormalImage {
    _leftNormalImage = leftNormalImage;
    [self.leftButton setImage:leftNormalImage forState:UIControlStateNormal];
}

- (void)setLeftDisabledImage:(UIImage *)leftDisabledImage {
    _leftDisabledImage = leftDisabledImage;
    [self.leftButton setImage:leftDisabledImage forState:UIControlStateNormal];
}

- (void)setRightNormalImage:(UIImage *)rightNormalImage {
    _rightNormalImage = rightNormalImage;
    [self.rightButton setImage:rightNormalImage forState:UIControlStateNormal];
}

- (void)setRightDisabledImage:(UIImage *)rightDisabledImage {
    _rightDisabledImage = rightDisabledImage;
    [self.rightButton setImage:rightDisabledImage forState:UIControlStateNormal];
}

- (void)setButtonsContensColor:(UIColor *)buttonsContensColor {
    _buttonsContensColor = buttonsContensColor;
    for (UIButton * button in @[self.leftButton, self.rightButton]) {
        [button setTitleColor:buttonsContensColor forState:UIControlStateNormal];
        button.tintColor = buttonsContensColor;
    }
}

- (void)setButtonsBackgroundColor:(UIColor *)buttonsBackgroundColor {
    _buttonsBackgroundColor = buttonsBackgroundColor;
    for (UIButton * button in @[self.leftButton, self.rightButton]) {
        button.backgroundColor = self.buttonsBackgroundColor;
    }
}

- (void)setButtonsFont:(UIFont *)buttonsFont {
    _buttonsFont = buttonsFont;
    for (UIButton * button in @[self.leftButton, self.rightButton]) {
        button.titleLabel.font = buttonsFont;
    }
}

- (void)setLabelTextColor:(UIColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    self.label.textColor = labelTextColor;
}

- (void)setLabelBackgroundColor:(UIColor *)labelBackgroundColor {
    _labelBackgroundColor = labelBackgroundColor;
    self.label.backgroundColor = labelBackgroundColor;
}

- (void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    self.label.font = labelFont;
}

- (void)setLabelCornerRadius:(CGFloat)labelCornerRadius {
    _labelCornerRadius = labelCornerRadius;
    self.label.layer.cornerRadius = labelCornerRadius;
}

- (void)setLabelWidthRatio:(CGFloat)labelWidthWeight {
    _labelWidthRatio = MIN(1.0, MAX(0.0, labelWidthWeight));
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.leftPushAnimationView.cornerRadius = cornerRadius;
    self.rightPushAnimationView.cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
    self.label.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.label.layer.borderColor = borderColor.CGColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    for (UIView *view in self.separators) {
        view.backgroundColor = separatorColor;
    }
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;
    [self setNeedsLayout];
}

- (void)setSeparatorHeightRatio:(CGFloat)separatorHeightRatio {
    _separatorHeightRatio = MIN(MAX(separatorHeightRatio, 0.0), 1.0);
    [self setNeedsLayout];
}

//! 값 변경 및 타이머를 작동시킨다! 절대로 함부러 호출해서는 안된다.
- (void)setStepperState:(MGUStepperState)stepperState {
    _stepperState = stepperState;
    if (self.stepperState != MGUStepperStateStable) {
        [self updateValue]; // 값이 변경된다.
        if (self.autorepeat == YES) {
            [self.accelerationTimer startAccelerationTimer];
        }
    } else {
        [self.accelerationTimer invalidate];
    }
}

- (void)setItems:(NSMutableArray<NSString *> *)items {
    _items = items;
    self.label.text = self.formattedValue;
}

- (UIColor *)impactColor {
    return self.leftPushAnimationView.impactColor;
}

- (void)setImpactColor:(UIColor *)impactColor {
    self.leftPushAnimationView.impactColor = impactColor;
    self.rightPushAnimationView.impactColor = impactColor;
}

- (UIColor *)fullColor {
    return self.backgroundColor;
}

- (void)setFullColor:(UIColor *)fullColor {
    self.backgroundColor = fullColor;
}

- (void)setStepperLabelType:(MGUStepperLabelType)stepperLabelType {
    if (_stepperLabelType != stepperLabelType) {
        //! 총 6가지 경우의 수
        if (stepperLabelType == MGUStepperLabelTypeHidden) { // show(A,B) -> hidden:2가지 경우
            [self.label removeFromSuperview];
            self.label = nil;
        } else { //! 여기서는 4가지. (?) ==> show 가는 경우 4가지.
            if (_stepperLabelType == MGUStepperLabelTypeHidden)  {
                [self initializeLabel];
                [self.containerView addSubview:self.label];
            }
        }
        _stepperLabelType = stepperLabelType;
        [self setNeedsLayout];
    }
}


#pragma mark - Public Action
- (void)setAllContensEnabled:(BOOL)enabled { // 가운데 라벨까지 enable 여부를 결정할 수 있다.
    [self setEnabled:enabled];
    if (enabled == YES) {
        self.label.enabled = YES;
    } else {
        self.label.enabled = NO;
    }
}

- (void)updateValue {
    if (self.stepperState == MGUStepperStateShouldIncrease) {
        self.value = MIN(self.maximumValue, MAX(self.minimumValue, self.value + self.stepValue));
    } else if (self.stepperState == MGUStepperStateShouldDecrease) {
        self.value = MIN(self.maximumValue, MAX(self.minimumValue, self.value - self.stepValue));
    }
}

- (void)setValueQuietly:(CGFloat)value {
    if (_value != value) {
        _value = MIN(self.maximumValue, MAX(self.minimumValue, value));
        [self straightenOutObjectState];
    }
    self.label.text = self.formattedValue;
}

#pragma mark - NumberFormatter Setting : 최초 및 원하는 스탭퍼의 옵션에 따라 여러번 호출된다.
- (void)setupNumberFormatter {
    int digits = MGRCalculateNumberOfDecimalPlaces(self.stepValue);
    self.formatter.minimumIntegerDigits = 1;
    self.formatter.minimumFractionDigits = self.showIntegerIfDoubleIsInteger ? 0 : digits;
    self.formatter.maximumFractionDigits = digits;
}


#pragma mark - Action
- (void)touchDown:(UIButton *)sender {
    [self.accelerationTimer invalidate];  // 타이머가 존재한다면 날려버린다.
    if (sender == self.leftButton) {
        [self.leftPushAnimationView highlightingAnimation];
        if (self.value == self.minimumValue) { // 한계에 도달했을 때.
            [self animateLimitHitIfNeeded];
        } else {
            self.stepperState = MGUStepperStateShouldDecrease; // 여기서 값이 입력된다. 연타도 여기서 예약된다.
            [self animateSlide:self.leftButton];
        }
    } else {
        [self.rightPushAnimationView highlightingAnimation];
        if (self.value == self.maximumValue) { // 한계에 도달했을 때.
            [self animateLimitHitIfNeeded];
        } else {
            self.stepperState = MGUStepperStateShouldIncrease; // 여기서 값이 입력된다. 연타도 여기서 예약된다.
            [self animateSlide:self.rightButton];
        }
    }
}

- (void)reset:(id)sender { // 호출하는 객체가 다양한다. NSNotification *
    [self.accelerationTimer invalidate];
    self.stepperState = MGUStepperStateStable;
    self.panState = MGUStepperLabelPanStateStable;
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.labelSlideDuration
                                                          delay:0.0
                                                        options:UIViewAnimationOptionCurveLinear
                                                     animations:^{
        self.label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        self.rightButton.backgroundColor = self.buttonsBackgroundColor;
        self.leftButton.backgroundColor = self.buttonsBackgroundColor;
    } completion:nil];
    [self touchUpAnimation:nil];
}

- (void)touchUpAnimation:(UIButton *)sender {
    for (MGUStepperAnimationDecoView *view in @[self.leftPushAnimationView, self.rightPushAnimationView]) {
        [view unHighlightingAnimation];
    }
}


#pragma mark - Animations : 슬라이드를 왼쪽 또는 오른쪽으로 움직인다. 한계치에 도달한 경우 버튼의 색을 변경시킨다.
- (void)animateSlide:(UIButton *)button {
    if (self.stepperLabelType != MGUStepperLabelTypeShowDraggable) {
        return;
    }
    CGPoint point;
    if (button == self.leftButton) { //! 왼쪽으로 움직일때.
        point = CGPointMake(self.label.center.x - self.labelSlideLength, self.label.center.y);
    } else { //! 오른쪽으로 움직일때.
        point = CGPointMake(self.label.center.x + self.labelSlideLength, self.label.center.y);
    }

    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.labelSlideDuration
                                                          delay:0.0
                                                        options:UIViewAnimationOptionCurveLinear
                                                     animations:^{
        self.label.center = point;
    } completion:nil];
}

- (void)animateLimitHitIfNeeded {
    UIButton *button = nil;
    if (self.value == self.minimumValue) {
        button = self.leftButton;
    } else if (self.value == self.maximumValue) {
        button = self.rightButton;
    } else { // min 도 아니고 max 도 아니면, 그냥 나가...
        return;
    }
    
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.1
                                                          delay:0.0
                                                        options:UIViewAnimationOptionCurveLinear
                                                     animations:^{
        button.backgroundColor = self.limitHitAnimationColor;
    } completion:nil];
}


#pragma mark - Helper
//! Touch position이 왼쪽인지 오른쪽인지 찾아준다.
- (MGUStepperCurrentTouchPostion)calculateTouchPostion:(CGFloat)x {
    if (x <= (self.frame.size.width / 2.0)) {
        return MGUStepperCurrentTouchPostionLeft;
    } else {
        return MGUStepperCurrentTouchPostionRight;
    }
}

//! 현재 value에 따른 각 객체의 상태를 정리해준다.
- (void)straightenOutObjectState {
    if (self.value == self.minimumValue) {
        self.leftButton.enabled = NO;
        self.leftButton.highlighted = NO;
        self.rightButton.enabled = YES;
        [self touchUpAnimation:self.leftButton];
    } else if (self.value == self.maximumValue) {
        self.leftButton.enabled = YES;
        self.rightButton.enabled = NO;
        self.rightButton.highlighted = NO;
        [self touchUpAnimation:self.rightButton];
    } else {
        self.leftButton.enabled = YES;
        self.rightButton.enabled = YES;
    }
}

- (void)handleLabelPanGestureTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint PrelocationPoint = [touch previousLocationInView:self];
    CGPoint locationPoint = [touch locationInView:self];
    CGPoint translation = CGPointMake(locationPoint.x - PrelocationPoint.x, locationPoint.y - PrelocationPoint.y);
    
    CGFloat maxCenterX = CGRectGetMidX(self.bounds) + self.labelSlideLength;
    CGFloat minCenterX = CGRectGetMidX(self.bounds) - self.labelSlideLength;
    CGFloat x = self.label.center.x + translation.x;
    x = MAX(MIN(x, maxCenterX), minCenterX);
    self.label.center = CGPointMake(x, self.label.center.y);

    if (self.label.center.x == maxCenterX) {
        if (self.panState != MGUStepperLabelPanStateHitRightEdge) { //! 반복적으로 stepperState 를 설정해서는 안된다.
            [self.accelerationTimer invalidate];
            self.stepperState = MGUStepperStateShouldIncrease;
            self.panState = MGUStepperLabelPanStateHitRightEdge;
        }
        [self animateLimitHitIfNeeded];
    } else if (self.label.center.x == minCenterX) { //! 반복적으로 stepperState 를 설정해서는 안된다.
        if (self.panState != MGUStepperLabelPanStateHitLeftEdge) {
            [self.accelerationTimer invalidate];
            self.stepperState = MGUStepperStateShouldDecrease;
            self.panState = MGUStepperLabelPanStateHitLeftEdge;
        }
        [self animateLimitHitIfNeeded];
    } else {
        self.panState = MGUStepperLabelPanStateStable;
        self.stepperState = MGUStepperStateStable;
        [self.accelerationTimer invalidate];
        self.rightButton.backgroundColor = self.buttonsBackgroundColor;
        self.leftButton.backgroundColor = self.buttonsBackgroundColor;
    }
}

@end
