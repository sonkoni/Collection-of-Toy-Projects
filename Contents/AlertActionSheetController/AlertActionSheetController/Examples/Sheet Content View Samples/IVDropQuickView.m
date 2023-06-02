//
//  IVDropQuickView.m
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2020/12/23.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

@import AudioKit;
@import IosKit;
#import "IVDropQuickView.h"
#import "IVDropQuickStepperView.h"

@interface IVDropQuickModel ()
@end
@implementation IVDropQuickModel
- (instancetype)initWithQuickType:(IVDropQuickType)quickType
                            value:(CGFloat)value
                         maxValue:(CGFloat)maxValue
                            title:(NSString *)title
                         unitName:(NSString *)unitName {
    self = [super init];
    if (self) {
        _quickType = quickType;
        _value = value;
        _maxValue = maxValue;
        _title = title;
        _unitName = unitName;
    }
    return self;
}
@end


@interface IVDropQuickView () <MGURulerViewDelegate, MGUNumKeyboardDelegate, UITextFieldDelegate>
@property (nonatomic, strong) IVDropQuickModel *quickModel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) IVDropQuickDisplay *forgeQuickDisplay;
@property (nonatomic, strong) UIView *contentsContainer;
@property (nonatomic, strong, nullable) MGURulerView *rulerView;
@property (nonatomic, strong, nullable) MGUNeoSegControl *segmentedControl;
@property (nonatomic, strong, nullable) MGUNumKeyboard *keyboard;
@property (nonatomic, strong, nullable) IVDropQuickStepperView *quickStepperView;
@property (nonatomic, strong) UITextField *privateTextField;
@property (nonatomic, strong) MGOSoundRuler *rulerSound;
@property (nonatomic, strong) MGOSoundKeyboard *keyboardSound;
@end

@implementation IVDropQuickView

#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame quickModel:(IVDropQuickModel *)quickModel {
    self = [super initWithFrame:frame];
    if (self) {
        _quickModel = quickModel;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(IVDropQuickView *self) {
    self->_rulerSound = [MGOSound rulerSound];
    self->_keyboardSound = [MGOSound keyBoardSound];
    // self->_rulerSound = [[MGOSoundRuler alloc] initWithBundle:nil];
    // self->_keyboardSound = [[MGOSoundKeyboard alloc] initWithBundle:nil];
    
    self->_stackView = [UIStackView new];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.distribution = UIStackViewDistributionFill;
    self.stackView.alignment =  UIStackViewAlignmentFill;
    self.stackView.spacing = 0.0;
    [self addSubview:self.stackView];
    [self.stackView mgrPinEdgesToSuperviewEdges];
    self->_privateTextField = [UITextField new];
    self.privateTextField.delegate = self;
    
    [self setupQuickDisplayView];
    
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.57 alpha:1.0]
                          darkModeColor:[UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:1.0]
                  darkElevatedModeColor:nil];
    [self.stackView addArrangedSubview:separatorView];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [separatorView.heightAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;

    self->_contentsContainer = [UIView new];
    self.contentsContainer.backgroundColor = [UIColor clearColor];
    self.contentsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *layoutConstraint = [self.contentsContainer.heightAnchor constraintEqualToConstant:0.0];
    layoutConstraint.priority = UILayoutPriorityDefaultLow; // 250 - 무언가를 담고 있는 컨테이너 뷰의 heightAnchor는 0.0 & 250
    layoutConstraint.active = YES;
    layoutConstraint = [self.contentsContainer.widthAnchor constraintEqualToAnchor:self.contentsContainer.heightAnchor multiplier:2.9];
    layoutConstraint.priority = UILayoutPriorityDefaultHigh;
    layoutConstraint.active = YES;
    [self.stackView addArrangedSubview:self.contentsContainer];
    [self setupContentView];
}

- (void)setupQuickDisplayView {
    _forgeQuickDisplay = [[IVDropQuickDisplay alloc] initWithFrame:CGRectZero
                                                          quickModel:self.quickModel];
    [self.stackView addArrangedSubview:self.forgeQuickDisplay];
    self.forgeQuickDisplay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.forgeQuickDisplay.heightAnchor constraintEqualToConstant:56.0].active = YES;
}

- (void)setupContentView {
    //! FIXME: 이거 테스트...
    if (self.quickModel.quickType == IVDropQuickTypeDose ||
        self.quickModel.quickType == IVDropQuickTypeMedication ||
        self.quickModel.quickType == IVDropQuickTypeBagVol) {
        _keyboard =
        [[MGUNumKeyboard alloc] initWithFrame:CGRectZero
                                       locale:nil
                                   layoutType:MGUNumKeyboardLayoutTypeLowHeightStyle2
                                configuration:[MGUNumKeyboardConfiguration forgeConfiguration]];
        
        self.keyboard.normalSoundPlayBlock = [self.keyboardSound playSoundKeyPress];
        self.keyboard.deleteSoundPlayBlock = [self.keyboardSound playSoundKeyDelete];
        self.keyboard.delegate = self;
        self.keyboard.allowsDoneButton = YES; //! LowHeightStyle에서는 아무런 효과가 없다.
        self.keyboard.roundedButtonShape = YES;
        
        self.keyboard.keyInput = self.privateTextField; // self.textField.inputView = keyboardX; 이렇게 설정 금지.
        self.privateTextField.userInteractionEnabled = NO;
        //! self.textField.alpha = 0.0f; <- 이렇게 실전에서는 처리할 것이다.
        self.keyboard.soundOn = YES;
        [self.privateTextField addTarget:self
                                  action:@selector(textFieldDidChange:)
                        forControlEvents:UIControlEventEditingChanged];
        [self.contentsContainer addSubview:self.keyboard];
        [self.keyboard mgrPinEdgesToSuperviewEdges];
        
    } else if (self.quickModel.quickType == IVDropQuickTypeWeight) {
        MGURulerViewConfig *rulerViewConfig = [MGURulerViewConfig forgeConfigWithWeightMode:MGURulerViewWeightModeKG];
        _rulerView = [[MGURulerView alloc] initWithFrame:CGRectZero
                                            initialValue:self.quickModel.value
                                           indicatorType:MGURulerViewIndicatorLineType
                                                  config:rulerViewConfig];
        self.rulerView.normalSoundPlayBlock = [self.rulerSound playSoundTickHaptic];
        self.rulerView.skipSoundPlayBlock = [self.rulerSound playSoundRolling];
        self.rulerView.delegate = self;
        self.rulerView.soundOn = YES;
        [self.contentsContainer addSubview:self.rulerView];
        [self.rulerView mgrPinEdgesToSuperviewEdges];
    } else if (self.quickModel.quickType == IVDropQuickTypeChamber) {
        NSString *selecedtitle;
        if (self.quickModel.value == 10.0) {
            selecedtitle = @"10";
        } else if (self.quickModel.value == 15.0) {
            selecedtitle = @"15";
        } else if (self.quickModel.value == 20.0) {
            selecedtitle = @"20";
        } else {
            selecedtitle = @"60";
        }

        MGUNeoSegConfiguration *config = [MGUNeoSegConfiguration forgeConfiguration];
        config.backgroundColor = [UIColor clearColor];
        _segmentedControl =
        [[MGUNeoSegControl alloc] initWithTitles:[self dropTitleAndImageModels]
                                       selecedtitle:selecedtitle
                                      configuration:config];
        [self.contentsContainer addSubview:self.segmentedControl];
        [self.segmentedControl mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(300.0, 80.0)];
        [self.segmentedControl addTarget:self action:@selector(valueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    } else if (self.quickModel.quickType == IVDropQuickTypeTime) {
        _quickStepperView = [[IVDropQuickStepperView alloc] initWithCurrentValue:self.quickModel.value
                                                                        maxValue:self.quickModel.maxValue];
        
        [self.quickStepperView addTarget:self
                                  action:@selector(stepperValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
        [self.contentsContainer addSubview:self.quickStepperView];
        [self.quickStepperView mgrPinEdgesToSuperviewEdges];
    }
    
}

//! Stepper
- (void)stepperValueChanged:(IVDropQuickStepperView *)sender {
    self.quickModel.value = sender.currentValue;
    NSInteger minuteValue = (NSInteger)sender.currentValue;
    minuteValue = MIN(MAX(minuteValue, 0), self.quickModel.maxValue); // 0 분  24시간까지.
    NSInteger hour = minuteValue / 60;
    NSInteger min = minuteValue % 60;
    NSString *firstText;
    NSString *secondText;
    if (minuteValue >= 60) { // 시분 둘 다 나오는 경우.
        firstText = [NSString stringWithFormat:@"%d", (int)hour];
        secondText = [NSString stringWithFormat:@"%d", (int)min];
    } else { // 분만 나올경우.
        firstText = [NSString stringWithFormat:@"%d", (int)min];
    }
    
    [self.forgeQuickDisplay setFirstValueString:firstText
                              secondValueString:secondText];
}


#pragma mark - <MGURulerViewDelegate>
- (void)rulerViewDidScroll:(MGURulerView *)rulerView currentDisplayValue:(CGFloat)currentDisplayValue {
    self.quickModel.value = currentDisplayValue;
    [self.forgeQuickDisplay setFirstValueString:[NSString stringWithFormat:@"%.1f", currentDisplayValue]
                              secondValueString:nil];
}


#pragma mark === UITextField - UIControlEventEditingChanged ===
- (void)textFieldDidChange:(UITextField *)sender {
    NSRange subRange = [sender.text rangeOfString:@"."];
    if(subRange.location != NSNotFound) { // 존재한다면
        NSArray <NSString *>*strArr = [sender.text componentsSeparatedByString:@"."];
        NSString *floatString = strArr.lastObject;
        
        if (floatString.length >= 3) {
            NSNumberFormatter *formatter = NSNumberFormatter.new;
            formatter.numberStyle = NSNumberFormatterNoStyle;
            formatter.roundingMode = NSNumberFormatterRoundFloor;
            formatter.maximumFractionDigits = 2;
            formatter.minimumFractionDigits = 2;
            NSString *cutNumString = [formatter stringFromNumber:@(sender.text.doubleValue)];
            sender.text = cutNumString;
        }
    } else { // 정수에서(.가 없을 때) 맥시멈 초과가 발생할 수 있다.
        NSInteger number = sender.text.integerValue;
        if (number >= 100000000) { // 1억
            number = number / 10; // 다시 원점으로 돌린다.
            sender.text = [NSString stringWithFormat:@"%ld", (long)number];
        }
    }
    
    //! Display View를 갱신한다.
    self.quickModel.value = [sender.text doubleValue];
    [self.forgeQuickDisplay setFirstValueString:[self transformString:sender.text] secondValueString:nil];
    //[self.forgeQuickDisplay setSourceValue:self.quickModel.value];
    
    
    //! FIXME: 임시 잠근다.
    /////////self.textLabel.text = [self transformString:sender.text];
    
//    NSNumberFormatter *formatter = NSNumberFormatter.new;
//    formatter.numberStyle = kCFNumberFormatterNoStyle;
//    formatter.roundingMode = kCFNumberFormatterRoundFloor;
//    formatter.maximumIntegerDigits = 8;
//    formatter.minimumIntegerDigits = 1;
//    formatter.maximumFractionDigits = 2;
//    formatter.minimumFractionDigits = 2;
//    formatter.allowsFloats = YES;
    //formatter.alwaysShowsDecimalSeparator  = YES;
//    NSString *cutNumString = [formatter stringFromNumber:@(sender.text.doubleValue)];
//    NSLog(@"가공 :{%@}", cutNumString);
//    sender.text = cutNumString;
    
}

- (NSString *)transformString:(NSString *)str {
    NSNumberFormatter *formatter = NSNumberFormatter.new;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSRange subRange = [str rangeOfString:@"."];
    if(subRange.location != NSNotFound) { // 존재한다면
        formatter.alwaysShowsDecimalSeparator  = YES;
        NSString *floatStr = [str componentsSeparatedByString:@"."].lastObject;
        if (floatStr.length == 0) {
            formatter.minimumFractionDigits = 0;
        } else if (floatStr.length == 1) {
            formatter.minimumFractionDigits = 1;
        } else if (floatStr.length == 2) {
            formatter.minimumFractionDigits = 2;
        }
        
    } else {
        formatter.alwaysShowsDecimalSeparator  = NO;
    }
    formatter.maximumFractionDigits = 2;
    return [formatter stringFromNumber:@(str.doubleValue)];
}


#pragma mark - <MGUNumKeyboardDelegate>
//! 구현 자체를 안하면 YES를 반환하는 것과 동일한 효과이다. 딱히 구현할 필요가 없다.
- (BOOL)numberKeyboard:(MGUNumKeyboard *)numberKeyboard shouldInsertText:(NSString *)text {return YES;}
- (BOOL)numberKeyboardShouldReturn:(MGUNumKeyboard *)numberKeyboard  {return YES;}
- (BOOL)numberKeyboardShouldDeleteBackward:(MGUNumKeyboard *)numberKeyboard  {return YES;}


#pragma mark - <UITextFieldDelegate> 메서드
//! keyboard에서 retrun을 했을 때, 일어나는 반응을 컨트롤한다!!!
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    //
    // <UITextFieldDelegate> 메서드에 해당하는 것으로 delegate 설정을 반드시 해야한다!! 자꾸 까먹는듯.
}

- (void)valueChanged:(MGUNeoSegControl *)sender {
    NSLog(@"세그먼트 밸류가 바뀌었다. %lu", (unsigned long)sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex == 0) {
        self.quickModel.value = 10.0;
    } else if (sender.selectedSegmentIndex == 1) {
        self.quickModel.value = 15.0;
    } else if (sender.selectedSegmentIndex == 2) {
        self.quickModel.value = 20.0;
    } else {
        self.quickModel.value = 60.0;
    }
    
    NSString *valueString = [NSString stringWithFormat:@"%d", (int)self.quickModel.value];
    [self.forgeQuickDisplay setFirstValueString:valueString secondValueString:nil];
}


#pragma mark - Helper
- (NSArray <MGUNeoSegModel *>*)dropTitleAndImageModels {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"10" imageName:@"chamber_drop_10_size"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"15" imageName:@"chamber_drop_15_size"];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:@"20" imageName:@"chamber_drop_20_size"];
    MGUNeoSegModel *model4 = [MGUNeoSegModel segmentModelWithTitle:@"60" imageName:@"chamber_drop_60_size"];
    return @[model1, model2, model3, model4];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
    NSCAssert(FALSE, @"- initWithCoder: 사용금지.");
    return nil;
}
@end
