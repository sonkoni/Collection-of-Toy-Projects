//
//  IndicatorSettingDetailCell.m
//  StockLineTEST
//
//  Created by Kwan Hyun Son on 10/24/23.
//

#import <IosKit/IosKit.h>
#import "IndicatorSettingDetailCell.h"


@interface IndicatorSettingDetailCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectionBtn; // 단순한 라벨일 뿐이다. 하나 제외.
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet MGUStepper *stepper;
@property (weak, nonatomic) IBOutlet MGUBrightnessBorderButton *colorBtn;
@property (weak, nonatomic) IBOutlet MGUDropdownButton *dropButton;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropButtonWidthConstraint;
//@property (weak, nonatomic) IBOutlet UIButton *boldButton;
//@property (weak, nonatomic) IBOutlet UIButton *textInputButton;
@end

@implementation IndicatorSettingDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.selectionBtn != nil) {
        self.selectionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.selectionBtn.titleLabel.minimumScaleFactor = 0.5;
        
        self.selectionBtn.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        self.selectionBtn.userInteractionEnabled = NO; // Label 형태로 사용. color fill 버튼 제외
        self.selectionBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [self.selectionBtn.heightAnchor constraintEqualToConstant:44.0]; // 키움: 55.0
        constraint.priority = UILayoutPriorityDefaultHigh;
        constraint.active = YES;
        [self.selectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    CommonInit(self);
}

#pragma mark - 생성 & 소멸

static void CommonInit(IndicatorSettingDetailCell *self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentContainer.backgroundColor = [UIColor clearColor];
    if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDescription] == YES) {
        [self setupDescriptionMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDToggle] == YES) {
        //        [self setupColorMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDColor] == YES) {
        [self setupColorMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDrop] == YES) {
        [self setupDropMode];
        //        [self setupToggleMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropLineStyle] == YES) {
        [self setupDropLineStyleMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropLineWidth] == YES) {
        [self setupDropLineWidthMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropFillExpression] == YES) {
        [self setupDropFillExpressionMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropFillType] == YES) {
        [self setupDropFillTypeMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDStepper] == YES) {
        [self setupStepperMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDToggleDrop] == YES) {
        [self setupDropMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDetailSetting] == YES) {
//        [self setupDropFillTypeMode];
    } else {
        
    }
}

- (void)setupColorMode {
    self.colorBtn.backgroundColor = [UIColor systemMintColor];
    self.colorBtn.layer.cornerRadius = 4.0;
}

- (void)setupDropMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGUTextDropdownCell class];
    self.dropButton.dropdownData = @[@"목업0", @"목업1", @"목업2"];
    self.dropButton.selectedIndex = 1;
    self.dropButton.placeHolderTextAlignment = NSTextAlignmentCenter;
    self.dropButton.textAlignment = NSTextAlignmentRight;
}

- (void)setupDropLineStyleMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGULineDashDropdownCell class];
    self.dropButton.dropdownData = @[@(0), @(1), @(2), @(3), @(4)];
    self.dropButton.selectedIndex = 0;
}

- (void)setupDropLineWidthMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGULineWidthDropdownCell class];
    self.dropButton.dropdownData = @[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)];
    self.dropButton.selectedIndex = 0;
}

- (void)setupDropFillExpressionMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGUImageDropdownCell class];
    self.dropButton.dropdownData = @[[UIImage imageNamed:@"stockfill.rect.stretch"], [UIImage imageNamed:@"stockfill.oval"], [UIImage imageNamed:@"stockfill.rect"]];
    self.dropButton.selectedIndex = 0;
}

- (void)setupDropFillTypeMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGUFillTypeDropdownCell class];
    self.dropButton.dropdownData = @[@"영역채움", MGUDropdownCellFillTypeHorizontal, MGUDropdownCellFillTypeVerical, MGUDropdownCellFillTypeDiagonalCounterClockwise, MGUDropdownCellFillTypeDiagonalClockwise, MGUDropdownCellFillTypeCross, MGUDropdownCellFillTypeX, MGUDropdownCellFillTypeEmpty];
    self.dropButton.selectedIndex = 0;
}

- (void)setupStepperMode {
    self.stepper.maximumValue = 5.0;
    self.stepper.labelWidthRatio = 1.0 / 3.0;
    self.stepper.stepperLabelType = MGUStepperLabelTypeShowFixed;
    self.stepper.buttonsBackgroundColor = [UIColor clearColor];
    self.stepper.labelFont = [UIFont fontWithName:@"AvenirNext-Bold" size:20.0];
    //self.stepper.leftNormalImage = Defines.imageNamed(.stepperMinus, renderingMode: .alwaysTemplate)
    //self.stepper.rightNormalImage = Defines.imageNamed(.stepperPlus, renderingMode: .alwaysTemplate)
    self.stepper.labelBackgroundColor = [UIColor clearColor];
    self.stepper.fullColor = [UIColor tertiarySystemFillColor];
    self.stepper.separatorColor = [UIColor quaternaryLabelColor];
    self.stepper.buttonsContensColor = [UIColor labelColor];
    self.stepper.labelTextColor = [UIColor labelColor];
}

- (void)setupDescriptionMode {
    if (@available(iOS 14, *)) {
        UIListContentConfiguration *content = [self defaultContentConfiguration];
        content.textProperties.numberOfLines = 0;
        self.contentConfiguration = content;
    } else {
        self.textLabel.numberOfLines = 0;
    }
}

#pragma mark - 세터 & 게터

- (void)setData:(DTOIndicatorDetailSetting *)model {
    _data = model;
    [self.selectionBtn setTitle:model.title forState:UIControlStateNormal];
    
    if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDescription] == YES) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.headIndent = 14;
        NSDictionary *attributes = @{ NSParagraphStyleAttributeName : style };
        NSAttributedString *richText = [[NSAttributedString alloc] initWithString:model.title
                                                                       attributes:attributes];
        if (@available(iOS 14, *)) {
            UIListContentConfiguration *content = [self defaultContentConfiguration];
            content.attributedText = richText;
            self.contentConfiguration = content;
        } else {
            self.textLabel.attributedText = richText;
        }
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDToggle] == YES) {
        self.toggleSwitch.on = model.isToggleOn;
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDColor] == YES) {
        self.colorBtn.backgroundColor = model.color;
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDrop] == YES) {
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropLineStyle] == YES) {
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropLineWidth] == YES) {
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropFillExpression] == YES) {
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingDetailIDDropFillType] == YES) {
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else {
        
    }
    
}


@end
