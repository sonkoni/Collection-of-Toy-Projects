//
//  MGAStepper.m
//  MGAStepperExample
//
//  Created by Kwan Hyun Son on 2022/11/02.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAStepper.h"
@import BaseKit;
@import GraphicsKit;
#import "MGAStepperAnimationDecoView.h"
#import "MGALayerHostingView.h"
#import "MGALabel+Extension.h"
#import "NSBox+Extension.h"
#import "MGAButton.h"

typedef NS_ENUM(NSUInteger, MGAStepperState) {
    MGAStepperStateStable= 1,
    MGAStepperStateShouldIncrease,
    MGAStepperStateShouldDecrease
};

typedef NS_ENUM(NSUInteger, MGAStepperLabelPanState) {
    MGAStepperLabelPanStateStable= 1,
    MGAStepperLabelPanStateHitRightEdge,
    MGAStepperLabelPanStateHitLeftEdge
};

typedef NS_ENUM(NSUInteger, MGAStepperCurrentTouchPostion) {
    MGAStepperCurrentTouchPostionLeft = 1,
    MGAStepperCurrentTouchPostionRight
};

//! 각 세그먼트의 최소의 폭은 64.0으로 확보한다.
static CGFloat const kMinimumButtonWidth = 47.0f;

@interface MGAStepper ()
@property (nonatomic, strong) MGALayerHostingView *containerView;
@property (nonatomic, strong) NSArray <NSBox *>*separators;
@property (nonatomic, strong) MGAStepperAnimationDecoView *leftPushAnimationView;
@property (nonatomic, strong) MGAStepperAnimationDecoView *rightPushAnimationView;
@property (nonatomic, strong) MGAButton *leftButton;
@property (nonatomic, strong) MGAButton *rightButton;
@property (nonatomic, strong) MGALabel *label;

@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong, nullable, readonly) NSString *formattedValue; // @dynamic

//! stepperState의 세터가 값 변경 및 타이머를 작동시킨다. 매우 조심해야한다. 함부러 호출하면 안된다.
@property (nonatomic, assign) MGAStepperState stepperState; // 디폴트 StepperStateStable
@property (nonatomic, assign) MGAStepperLabelPanState panState; // 디폴트 LabelPanStateStable // 이게 필요하다. 팬에서 계속 Timer 만들 수 있다.

@property (nonatomic, assign) CGFloat labelSlideLength; //  디폴트 5.0f; 가운데서 얼마나 움직이게 할 것인가.
@property (nonatomic, assign) NSTimeInterval labelSlideDuration; //  디폴트 0.1;

@property (nonatomic, assign) MGAStepperCurrentTouchPostion currentTouchPostion; //  left
@property (nonatomic, assign) BOOL labelGesture; //  left

@property (nonatomic, nullable) MGAStepperConfiguration *configuration; // 설정에 해당하는 객체이다.
@property (nonatomic, strong) MGEAccelerationTimer *accelerationTimer;
@property (nonatomic, strong) MGEDisplayLink *displayLink;
@property (nonatomic, assign) CGPoint previousLocation; // 드래깅할 때 쓴다.
@end

@implementation MGAStepper
@dynamic fullColor;
@dynamic formattedValue;
@dynamic impactColor;
@synthesize formatter = _formatter;

- (BOOL)isFlipped {
    return YES;
}

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
    NSLog(@"MGAStepper Dealloc");
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize intrinsicContentSize = self.configuration.intrinsicContentSize;
    if (CGSizeEqualToSize(intrinsicContentSize, CGSizeZero) != YES) {
        return intrinsicContentSize;
    } else {
        if (self.stepperLabelType == MGAStepperLabelTypeHidden) {
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

- (void)layout {
    [super layout];
    self.containerView.frame = self.bounds;
    CGFloat buttonWidth;
    if (self.stepperLabelType != MGAStepperLabelTypeHidden) { // ShowFixed || ShowDraggable
        CGFloat labelWidth =  self.bounds.size.width * self.labelWidthRatio;
        buttonWidth = ((self.bounds.size.width - labelWidth) / 2.0) - self.separatorWidth;
        self.label.frame = CGRectMake(buttonWidth + self.separatorWidth, 0.0, labelWidth, self.bounds.size.height);
    } else { // MGAStepperLabelTypeHidden
        buttonWidth = (self.bounds.size.width - self.separatorWidth) / 2.0; // separator 굵기 1.0
    }
    
    self.leftButton.frame = CGRectMake(0.0, 0.0, buttonWidth, self.bounds.size.height);
    self.rightButton.frame = CGRectMake(self.bounds.size.width - buttonWidth, 0.0, buttonWidth, self.bounds.size.height);
    
    self.leftPushAnimationView.frame  = self.leftButton.frame;
    self.rightPushAnimationView.frame  = self.rightButton.frame;
    
    for (NSInteger i = 0; i < 3; i++) {
        NSBox *separator = self.separators[i];
        CGSize size = CGSizeMake(self.separatorWidth, self.bounds.size.height * self.separatorHeightRatio);
        CGPoint center = CGPointZero;
        if (i == 0) {
            center = CGPointMake(self.leftButton.frame.size.width + 0.5,
                                 CGRectGetMidY(self.bounds));
        } else if (i == 2) {
            center = CGPointMake(self.leftButton.frame.size.width + self.label.frame.size.width + 1.5,
                                 CGRectGetMidY(self.bounds));
        } else {
            center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        }
        separator.frame = MGERectAroundCenter(center, size);
    }
    
    if (self.stepperLabelType == MGAStepperLabelTypeHidden) { // 가운데 하나만 존재
        self.separators.firstObject.hidden = YES;
        self.separators[1].hidden = NO;
        self.separators.lastObject.hidden = YES;
    } else { // 양쪽에 두개 존재.
        self.separators.firstObject.hidden = NO;
        self.separators[1].hidden = YES;
        self.separators.lastObject.hidden = NO;
    }
    
}

#pragma mark -- OVERRIDE - NSResponder - Responding to Mouse Events
- (BOOL)acceptsFirstResponder {
    return [NSApp isFullKeyboardAccessEnabled];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled == YES) {
        CGPoint locationPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        self.previousLocation = locationPoint;
        if (self.stepperLabelType == MGAStepperLabelTypeShowDraggable &&
            CGRectContainsPoint(self.label.frame, locationPoint) == YES) {
            self.labelGesture = YES;
            return;
        }
        
        self.labelGesture = NO;
        self.currentTouchPostion = [self calculateTouchPostion:locationPoint.x];
        
        if (self.currentTouchPostion == MGAStepperCurrentTouchPostionLeft) {
            if (self.value != self.minimumValue) {
                [self touchDown:self.leftButton];
            }
        } else {
            if (self.value != self.maximumValue) {
                [self touchDown:self.rightButton];
            }
        }
        return;
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (self.isEnabled == YES) {
        CGPoint preLocation = self.previousLocation;
        CGPoint currentLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        self.previousLocation = currentLocation;
        if (self.labelGesture == YES) {
            [self handleLabelPanGesture:preLocation currentLocation:currentLocation];
            return;
        }
        MGAStepperCurrentTouchPostion currentTouchPostion = [self calculateTouchPostion:currentLocation.x];
        if (currentTouchPostion != self.currentTouchPostion) {
            if (currentTouchPostion == MGAStepperCurrentTouchPostionRight) {
                [self reset:self.leftButton];
                [self touchDown:self.rightButton];
            } else {
                [self reset:self.rightButton];
                [self touchDown:self.leftButton];
            }
            self.currentTouchPostion = currentTouchPostion;
        }
        return;
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self reset:nil];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame configuration:(MGAStepperConfiguration * _Nullable)configuration {
    _configuration = configuration;
    return [self initWithFrame:frame];
}

- (instancetype)initWithConfiguration:(MGAStepperConfiguration * _Nullable)configuration {
    return [self initWithFrame:CGRectZero configuration:configuration];
}

static void CommonInit(MGAStepper *self) {
    if (self.configuration == nil) {
        self.configuration = [MGAStepperConfiguration defaultConfiguration];
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
    
    self->_stepperState = MGAStepperStateStable;
    self->_panState = MGAStepperLabelPanStateStable;
    
    self->_items = self.configuration.items;
    
    //! backgroundColor fullColor로 연동된다. <- IB 에 연동이 잘되지 않아서 따로 더 만들었다.
    self.layer = [CALayer layer];
    self.wantsLayer = YES;
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.layer.backgroundColor = self.configuration.fullColor.CGColor;
    self.layer.cornerRadius = self.configuration.cornerRadius;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.masksToBounds = YES;
    
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
                                                 name:NSApplicationWillResignActiveNotification
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
    _containerView = [MGALayerHostingView new];
    self.containerView.frame = self.bounds;
    self.containerView.userInteractionEnabled = NO;
    self.containerView.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = self.cornerRadius;
    [self addSubview:self.containerView];
}

- (void)initializePushAnimationViews {
    _leftPushAnimationView = [MGAStepperAnimationDecoView new];
    _rightPushAnimationView = [MGAStepperAnimationDecoView new];
    for (MGAStepperAnimationDecoView *view in @[self.leftPushAnimationView, self.rightPushAnimationView]) {
        view.layer.masksToBounds = YES;
        view.layer.backgroundColor = [NSColor clearColor].CGColor;
        view.cornerRadius = self.cornerRadius;
        view.impactColor = self.configuration.impactColor;
    }
}

- (void)initializeSeparators {
    _separators = @[[NSBox new], [NSBox new], [NSBox new]];
    for (NSBox *view in self.separators) {
        [view mgrBackgroundColor:self.separatorColor
                     borderColor:[NSColor clearColor]
                     borderWidth:0.0
                    cornerRadius:0.0];
        [self.containerView addSubview:view];
    }
}

- (void)initializeButtons {
    _leftButton = [MGAButton new];
    //    self.leftButton.adjustsImageWhenHighlighted = NO;
    //    self.leftButton.bezelColor = self.buttonsBackgroundColor;
    //    [self.leftButton setImage:self.leftNormalImage];
    //    [self.leftButton setImage:self.leftDisabledImage forState:UIControlStateDisabled];
    self.leftButton.bordered = NO;
    self.leftButton.backgroundColor = self.buttonsBackgroundColor;
    self.leftButton.contentTintColor = self.buttonsContensColor;
    [self.leftButton setNormalImage:self.leftNormalImage];
    [self.leftButton setDisableImage:self.leftDisabledImage];
    
    _rightButton = [MGAButton new];
    //    self.rightButton.adjustsImageWhenHighlighted = NO;
    //    self.rightButton.bezelColor = self.buttonsBackgroundColor;
    self.rightButton.bordered = NO;
    self.rightButton.backgroundColor = self.buttonsBackgroundColor;
    self.rightButton.contentTintColor = self.buttonsContensColor;
    [self.rightButton setNormalImage:self.rightNormalImage];
    [self.rightButton setDisableImage:self.rightDisabledImage];
}

- (void)initializeLabel {
    _label = [MGALabel mgrVerticallyCenterLabelWithString:@""];
    self.label.alignment = NSTextAlignmentCenter;
    self.label.stringValue = self.formattedValue;
    self.label.textColor = self.labelTextColor;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.minimumScaleFactor = 0.5;
    self.label.layer.backgroundColor = self.labelBackgroundColor.CGColor; // VerticallyCenter 이걸 이용해야한다.
    self.label.font = self.labelFont;
    self.label.layer.cornerRadius = self.labelCornerRadius;
    self.label.layer.masksToBounds = YES;
    self.label.layer.borderColor = self.borderColor.CGColor;
}


#pragma mark - 세터 & 게터
- (void)setValue:(CGFloat)value {
    if (_value != value) {
        _value = MIN(self.maximumValue, MAX(self.minimumValue, value));
        [self invokeTargetAction];
        [self straightenOutObjectState];
    }
    
    self.label.stringValue = self.formattedValue;
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

- (void)setLeftNormalImage:(NSImage *)leftNormalImage {
    _leftNormalImage = leftNormalImage;
    [self.leftButton setNormalImage:leftNormalImage];
}

- (void)setLeftDisabledImage:(NSImage *)leftDisabledImage {
    _leftDisabledImage = leftDisabledImage;
    [self.leftButton setDisableImage:leftDisabledImage];
}

- (void)setRightNormalImage:(NSImage *)rightNormalImage {
    _rightNormalImage = rightNormalImage;
    [self.rightButton setNormalImage:rightNormalImage];
}

- (void)setRightDisabledImage:(NSImage *)rightDisabledImage {
    _rightDisabledImage = rightDisabledImage;
    [self.rightButton setDisableImage:rightDisabledImage];
}

- (void)setButtonsContensColor:(NSColor *)buttonsContensColor {
    _buttonsContensColor = buttonsContensColor;
    for (MGAButton *button in @[self.leftButton, self.rightButton]) {
        button.contentTintColor = buttonsContensColor;
    }
}

- (void)setButtonsBackgroundColor:(NSColor *)buttonsBackgroundColor {
    _buttonsBackgroundColor = buttonsBackgroundColor;
    for (MGAButton *button in @[self.leftButton, self.rightButton]) {
        button.bordered = NO;
        button.backgroundColor = self.buttonsBackgroundColor;
    }
}

- (void)setButtonsFont:(NSFont *)buttonsFont {
    _buttonsFont = buttonsFont;
    for (NSButton * button in @[self.leftButton, self.rightButton]) {
        button.font = buttonsFont;
    }
}

- (void)setLabelTextColor:(NSColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    self.label.textColor = labelTextColor;
}

- (void)setLabelBackgroundColor:(NSColor *)labelBackgroundColor {
    _labelBackgroundColor = labelBackgroundColor;
    self.label.layer.backgroundColor = labelBackgroundColor.CGColor;
}

- (void)setLabelFont:(NSFont *)labelFont {
    _labelFont = labelFont;
    self.label.font = labelFont;
}

- (void)setLabelCornerRadius:(CGFloat)labelCornerRadius {
    _labelCornerRadius = labelCornerRadius;
    self.label.layer.cornerRadius = labelCornerRadius;
}

- (void)setLabelWidthRatio:(CGFloat)labelWidthWeight {
    _labelWidthRatio = MIN(1.0, MAX(0.0, labelWidthWeight));
    [self setNeedsLayout:YES];
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

- (void)setBorderColor:(NSColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    self.label.layer.borderColor = borderColor.CGColor;
}

- (void)setSeparatorColor:(NSColor *)separatorColor {
    _separatorColor = separatorColor;
    for (NSBox *view in self.separators) {
        view.fillColor = separatorColor;
    }
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;
    [self setNeedsLayout:YES];
}

- (void)setSeparatorHeightRatio:(CGFloat)separatorHeightRatio {
    _separatorHeightRatio = MIN(MAX(separatorHeightRatio, 0.0), 1.0);
    [self setNeedsLayout:YES];
}

//! 값 변경 및 타이머를 작동시킨다! 절대로 함부러 호출해서는 안된다.
- (void)setStepperState:(MGAStepperState)stepperState {
    _stepperState = stepperState;
    if (self.stepperState != MGAStepperStateStable) {
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
    self.label.stringValue = self.formattedValue;
}

- (NSColor *)impactColor {
    return self.leftPushAnimationView.impactColor;
}

- (void)setImpactColor:(NSColor *)impactColor {
    self.leftPushAnimationView.impactColor = impactColor;
    self.rightPushAnimationView.impactColor = impactColor;
}

- (NSColor *)fullColor {
    return [NSColor colorWithCGColor:self.layer.backgroundColor];
}

- (void)setFullColor:(NSColor *)fullColor {
    self.layer.backgroundColor = fullColor.CGColor;
}

- (void)setStepperLabelType:(MGAStepperLabelType)stepperLabelType {
    if (_stepperLabelType != stepperLabelType) {
        //! 총 6가지 경우의 수
        if (stepperLabelType == MGAStepperLabelTypeHidden) { // show(A,B) -> hidden:2가지 경우
            [self.label removeFromSuperview];
            self.label = nil;
        } else { //! 여기서는 4가지. (?) ==> show 가는 경우 4가지.
            if (_stepperLabelType == MGAStepperLabelTypeHidden)  {
                [self initializeLabel];
                [self.containerView addSubview:self.label];
            }
        }
        _stepperLabelType = stepperLabelType;
        [self setNeedsLayout:YES];
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
    if (self.stepperState == MGAStepperStateShouldIncrease) {
        self.value = MIN(self.maximumValue, MAX(self.minimumValue, self.value + self.stepValue));
    } else if (self.stepperState == MGAStepperStateShouldDecrease) {
        self.value = MIN(self.maximumValue, MAX(self.minimumValue, self.value - self.stepValue));
    }
}

- (void)setValueQuietly:(CGFloat)value {
    if (_value != value) {
        _value = MIN(self.maximumValue, MAX(self.minimumValue, value));
        [self straightenOutObjectState];
    }
    self.label.stringValue = self.formattedValue;
}

#pragma mark - NumberFormatter Setting : 최초 및 원하는 스탭퍼의 옵션에 따라 여러번 호출된다.
- (void)setupNumberFormatter {
    int digits = MGRCalculateNumberOfDecimalPlaces(self.stepValue);
    self.formatter.minimumIntegerDigits = 1;
    self.formatter.minimumFractionDigits = self.showIntegerIfDoubleIsInteger ? 0 : digits;
    self.formatter.maximumFractionDigits = digits;
}


#pragma mark - Action
- (void)touchDown:(NSButton *)sender {
    [self.accelerationTimer invalidate];  // 타이머가 존재한다면 날려버린다.
    if (sender == self.leftButton) {
        [self.leftPushAnimationView highlightingAnimation];
        if (self.value == self.minimumValue) { // 한계에 도달했을 때.
            [self animateLimitHitIfNeeded];
        } else {
            self.stepperState = MGAStepperStateShouldDecrease; // 여기서 값이 입력된다. 연타도 여기서 예약된다.
            [self animateSlide:self.leftButton];
        }
    } else {
        [self.rightPushAnimationView highlightingAnimation];
        if (self.value == self.maximumValue) { // 한계에 도달했을 때.
            [self animateLimitHitIfNeeded];
        } else {
            self.stepperState = MGAStepperStateShouldIncrease; // 여기서 값이 입력된다. 연타도 여기서 예약된다.
            [self animateSlide:self.rightButton];
        }
    }
}

- (void)reset:(id)sender { // 호출하는 객체가 다양한다. NSNotification *
    [self.accelerationTimer invalidate];
    self.stepperState = MGAStepperStateStable;
    self.panState = MGAStepperLabelPanStateStable;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGRect frame = MGERectAroundCenter(center, self.label.frame.size);
    CGRect originalFrame = self.label.frame;
    NSColor *originalLeftButtonBackgroundColor = self.leftButton.backgroundColor;
    NSColor *originalRightButtonBackgroundColor = self.rightButton.backgroundColor;
    
    if (self.displayLink != nil) { [self.displayLink invalidate]; self.displayLink = nil; }
    self.displayLink =
    [MGEDisplayLink displayLinkWithDuration:self.labelSlideDuration
                         easingFunctionType:MGEEasingFunctionTypeEaseLinear
                              progressBlock:^(CGFloat progress) {
        self.label.frame = MGELerpRect(progress, originalFrame, frame);
        CGColorRef leftColor = MGELerpCreateColor(progress,
                                                  originalLeftButtonBackgroundColor.CGColor,
                                                  self.buttonsBackgroundColor.CGColor);
        CGColorRef rightColor = MGELerpCreateColor(progress,
                                                   originalRightButtonBackgroundColor.CGColor,
                                                   self.buttonsBackgroundColor.CGColor);
        self.leftButton.backgroundColor = [NSColor colorWithCGColor:leftColor];
        self.rightButton.backgroundColor = [NSColor colorWithCGColor:rightColor];
        CGColorRelease(leftColor);
        CGColorRelease(rightColor);
    } completionBlock:^{}];
    [self.displayLink startAnimationWithStartProgress:0.0];
    [self touchUpAnimation:nil];
}

- (void)touchUpAnimation:(NSButton *)sender {
    for (MGAStepperAnimationDecoView *view in @[self.leftPushAnimationView, self.rightPushAnimationView]) {
        [view unHighlightingAnimation];
    }
}

#pragma mark - Actions
- (void)invokeTargetAction { //! Target Action을 보낸다.
    if (self.action != NULL) {
        BOOL success = [NSApp sendAction:self.action to:self.target from:self];
#if DEBUG
        if (success == YES) {
            NSLog(@"액션 보내기 성공");
        } else {
            NSLog(@"액션 보내기 실패");
        }
#endif
    }
}


#pragma mark - Animations : 슬라이드를 왼쪽 또는 오른쪽으로 움직인다. 한계치에 도달한 경우 버튼의 색을 변경시킨다.
- (void)animateSlide:(NSButton *)button {
    if (self.stepperLabelType != MGAStepperLabelTypeShowDraggable) {
        return;
    }
    CGRect originalFrame = self.label.frame;
    CGRect frame = self.label.frame;
    if (button == self.leftButton) { //! 왼쪽으로 움직일때.
        frame.origin.x = frame.origin.x - self.labelSlideLength;
    } else { //! 오른쪽으로 움직일때.
        frame.origin.x = frame.origin.x + self.labelSlideLength;
    }
    
    //    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
    //        context.duration = self.labelSlideDuration;
    //        self.label.animator.frame = frame;
    //    } completionHandler:^{
    //        self.label.frame = frame;
    //    }];
    if (self.displayLink != nil) { [self.displayLink invalidate]; self.displayLink = nil; }
    self.displayLink =
    [MGEDisplayLink displayLinkWithDuration:self.labelSlideDuration
                         easingFunctionType:MGEEasingFunctionTypeEaseLinear
                              progressBlock:^(CGFloat progress) {
        self.label.frame = MGELerpRect(progress, originalFrame, frame);
    } completionBlock:^{}];
    [self.displayLink startAnimationWithStartProgress:0.0];
}

- (void)animateLimitHitIfNeeded {
    NSButton *button = nil;
    if (self.value == self.minimumValue) {
        button = self.leftButton;
    } else if (self.value == self.maximumValue) {
        button = self.rightButton;
    } else { // min 도 아니고 max 도 아니면, 그냥 나가...
        return;
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context){
        context.duration = 0.1;
        self.label.layer.backgroundColor = self.limitHitAnimationColor.CGColor;
    } completionHandler:^{
        self.label.layer.backgroundColor = self.limitHitAnimationColor.CGColor;
    }];
}


#pragma mark - Helper
//! Touch position이 왼쪽인지 오른쪽인지 찾아준다.
- (MGAStepperCurrentTouchPostion)calculateTouchPostion:(CGFloat)x {
    if (x <= (self.frame.size.width / 2.0)) {
        return MGAStepperCurrentTouchPostionLeft;
    } else {
        return MGAStepperCurrentTouchPostionRight;
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

- (void)handleLabelPanGesture:(CGPoint)preLocation currentLocation:(CGPoint)currentLocation {
    CGPoint translation = CGPointMake(currentLocation.x - preLocation.x,
                                      currentLocation.y - preLocation.y);

    CGFloat maxCenterX = CGRectGetMidX(self.bounds) + self.labelSlideLength;
    CGFloat minCenterX = CGRectGetMidX(self.bounds) - self.labelSlideLength;
    
    CGFloat x = CGRectGetMidX(self.label.frame) + translation.x;
    x = MAX(MIN(x, maxCenterX), minCenterX);
    CGPoint center = CGPointMake(x, CGRectGetMidY(self.label.frame));
    self.label.frame = MGERectAroundCenter(center, self.label.frame.size);

    if (center.x == maxCenterX) {
        if (self.panState != MGAStepperLabelPanStateHitRightEdge) { //! 반복적으로 stepperState 를 설정해서는 안된다.
            [self.accelerationTimer invalidate];
            self.stepperState = MGAStepperStateShouldIncrease;
            self.panState = MGAStepperLabelPanStateHitRightEdge;
        }
        [self animateLimitHitIfNeeded];
    } else if (center.x == minCenterX) { //! 반복적으로 stepperState 를 설정해서는 안된다.
        if (self.panState != MGAStepperLabelPanStateHitLeftEdge) {
            [self.accelerationTimer invalidate];
            self.stepperState = MGAStepperStateShouldDecrease;
            self.panState = MGAStepperLabelPanStateHitLeftEdge;
        }
        [self animateLimitHitIfNeeded];
    } else {
        self.panState = MGAStepperLabelPanStateStable;
        self.stepperState = MGAStepperStateStable;
        [self.accelerationTimer invalidate];
        self.rightButton.backgroundColor = self.buttonsBackgroundColor;
        self.leftButton.backgroundColor = self.buttonsBackgroundColor;
    }
}

//- (void)handleLabelPanGestureTouch:(NSTouch *)touch withEvent:(NSEvent *)event {
//    CGPoint prelocationPoint = self.previousLocation;
////    CGPoint PrelocationPoint = [touch previousLocationInView:self];
//    CGPoint locationPoint = [touch locationInView:self];
//    CGPoint translation = CGPointMake(locationPoint.x - prelocationPoint.x, locationPoint.y - PrelocationPoint.y);
//
//    CGFloat maxCenterX = CGRectGetMidX(self.bounds) + self.labelSlideLength;
//    CGFloat minCenterX = CGRectGetMidX(self.bounds) - self.labelSlideLength;
//
//    CGFloat x = CGRectGetMidX(self.label.frame) + translation.x;
//    x = MAX(MIN(x, maxCenterX), minCenterX);
//    CGPoint center = CGPointMake(x, CGRectGetMidY(self.label.frame));
//    self.label.frame = MGERectAroundCenter(center, self.label.frame.size);
//
//    if (center.x == maxCenterX) {
//        if (self.panState != MGAStepperLabelPanStateHitRightEdge) { //! 반복적으로 stepperState 를 설정해서는 안된다.
//            [self.accelerationTimer invalidate];
//            self.stepperState = MGAStepperStateShouldIncrease;
//            self.panState = MGAStepperLabelPanStateHitRightEdge;
//        }
//        [self animateLimitHitIfNeeded];
//    } else if (center.x == minCenterX) { //! 반복적으로 stepperState 를 설정해서는 안된다.
//        if (self.panState != MGAStepperLabelPanStateHitLeftEdge) {
//            [self.accelerationTimer invalidate];
//            self.stepperState = MGAStepperStateShouldDecrease;
//            self.panState = MGAStepperLabelPanStateHitLeftEdge;
//        }
//        [self animateLimitHitIfNeeded];
//    } else {
//        self.panState = MGAStepperLabelPanStateStable;
//        self.stepperState = MGAStepperStateStable;
//        [self.accelerationTimer invalidate];
//        self.rightButton.backgroundColor = self.buttonsBackgroundColor;
//        self.leftButton.backgroundColor = self.buttonsBackgroundColor;
//    }
//}

@end
