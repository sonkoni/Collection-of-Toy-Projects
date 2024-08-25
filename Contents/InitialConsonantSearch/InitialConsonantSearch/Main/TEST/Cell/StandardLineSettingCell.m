//
//  StandardLineSettingCell.m
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/18.
//

#import "StandardLineSettingCell.h"
#import <IosKit/IosKit.h>

@interface StandardLineSettingCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectionBtn; // 단순한 라벨일 뿐이다. 하나 제외.
@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@property (weak, nonatomic) IBOutlet MGUBrightnessBorderButton *colorBtn;
@property (weak, nonatomic) IBOutlet UIButton *ratioButton;
@property (weak, nonatomic) IBOutlet MGUDropdownButton *dropButton;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UIButton *textInputButton;

@end

@implementation StandardLineSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.selectionBtn != nil) {
        self.selectionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.selectionBtn.titleLabel.minimumScaleFactor = 0.5;

        self.selectionBtn.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        self.selectionBtn.userInteractionEnabled = NO;
        self.selectionBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [self.selectionBtn.heightAnchor constraintEqualToConstant:44.0]; // 키움: 55.0
        constraint.priority = UILayoutPriorityDefaultHigh;
        constraint.active = YES;
        [self.selectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    CommonInit(self);
}

#pragma mark - 생성 & 소멸

static void CommonInit(StandardLineSettingCell *self) {
    self.contentContainer.backgroundColor = [UIColor clearColor];
    
    /// Top tableView
    if ([self.reuseIdentifier isEqualToString:StandardLineCellIDToggleDrop] == YES) {
        [self setupToggleDropMode];
    } else if ([self.reuseIdentifier isEqualToString:StandardLineCellIDToggle] == YES) {
        [self setupToggleMode];
    }
    
    /// Bottom tableView
    if ([self.reuseIdentifier isEqualToString:StandardLineCellIDNormal] == YES) {
        [self setupNormalMode];
    } else if ([self.reuseIdentifier isEqualToString:StandardLineCellIDUser] == YES) {
        [self setupUserMode];
    }
}

- (void)setupToggleDropMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.defaultBackgroundColor = [UIColor whiteColor];
    self.dropButton.disabledBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    self.dropButton.cellClass = [MGUTextDropdownCell class];
    self.dropButton.dropdownData = @[@"Left", @"Center", @"Right"];
    self.dropButton.selectedIndex = 0;
    self.dropButton.placeHolderTextAlignment = NSTextAlignmentCenter;
    self.dropButton.textAlignment = NSTextAlignmentLeft;
}

- (void)setupToggleMode {}

- (void)setupNormalMode {
    [self setupSelectionBtn];
    [self setupDropdownBtn];
}

- (void)setupUserMode {
    [self setupSelectionBtn];
    [self setupDropdownBtn];
    
    self.textField.autocorrectionType  = UITextAutocorrectionTypeNo;
    self.textField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textField.returnKeyType = UIReturnKeyDone;
    
    self.ratioButton.backgroundColor = [UIColor clearColor];
    self.ratioButton.layer.cornerRadius = 4.0; // 4.0
    
    self.textInputButton.backgroundColor = [UIColor whiteColor];
    self.textInputButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textInputButton.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.textInputButton.layer.cornerRadius = 5.0;
    [self.textInputButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.textInputButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.textInputButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.textInputButton.titleLabel.minimumScaleFactor = 0.5;
}

/// Helper
- (void)setupSelectionBtn {
    self.selectionBtn.userInteractionEnabled = YES; // Label 형태로 사용. color fill 버튼 제외
    if (@available(iOS 13, *)) {
        if (@available(iOS 15, *)) {
            UIButtonConfiguration *configuration = self.selectionBtn.configuration;
            if (configuration != nil) {
                configuration.baseBackgroundColor = [UIColor clearColor];
                self.selectionBtn.configuration = configuration;
            }
        }
        // UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleMedium];
        // selectedImage = [UIImage systemImageNamed:@"checkmark.circle.fill" withConfiguration:config];
        // normalImage = [UIImage systemImageNamed:@"checkmark.circle" withConfiguration:config];
    } else {
        self.selectionBtn.imageView.contentMode = UIViewContentModeCenter;
        UIColor *tintColor = [UIColor colorWithRed:15.0/255.0 green:40.0/255.0 blue:71.0/255.0 alpha:1.0];
        self.selectionBtn.tintColor = tintColor;
        self.selectionBtn.imageView.tintColor = tintColor;
        // NSBundle *designTimeBundle = [NSBundle bundleForClass:[self classForCoder]];
        // selectedImage = [UIImage imageNamed:@"checkmark.circle.fill"
        //                                     inBundle:designTimeBundle
        //                compatibleWithTraitCollection:nil];
        // selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        // normalImage = [UIImage imageNamed:@"uncheckmark.circle"
        //                                   inBundle:designTimeBundle
        //              compatibleWithTraitCollection:nil];
        // normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    NSBundle *designTimeBundle = [NSBundle bundleForClass:[self classForCoder]];
    UIImage *selectedImage = [UIImage imageNamed:@"checkmark.circle.fill"
                                        inBundle:designTimeBundle
                   compatibleWithTraitCollection:nil];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *normalImage = [UIImage imageNamed:@"uncheckmark.circle"
                                      inBundle:designTimeBundle
                 compatibleWithTraitCollection:nil];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.selectionBtn setImage:selectedImage forState:UIControlStateSelected];
    [self.selectionBtn setImage:normalImage forState:UIControlStateNormal];
    [self.selectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.selectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)setupDropdownBtn {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGULineWidthDropdownCell class];
    self.dropButton.dropdownData = @[@(-12), @(0), @(1), @(2) , @(3), @(4), @(5)];
    self.dropButton.selectedIndex = 0;
//    self.dropButton.placeHolderTextAlignment = NSTextAlignmentCenter;
//    self.dropButton.textAlignment = NSTextAlignmentLeft;
}


#pragma mark - 세터 & 게터

- (void)setData:(DTOStandardLineSetting *)model {
    _data = model;
    [self.selectionBtn setTitle:model.title forState:UIControlStateNormal];
    if ([self.reuseIdentifier isEqualToString:StandardLineCellIDToggleDrop] == YES) {
        NSLog(@"==> %ld %ld %@", self.dropButton.selectedIndex, model.dropBtnSelectedIndex, model);
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
        
        if (self.toggleSwitch.isOn != model.isToggleOn) {
            self.toggleSwitch.on = model.isToggleOn;
        }
        if (self.dropButton.isEnabled != !model.dropBtnHidden) {
            self.dropButton.enabled = !model.dropBtnHidden;
        }
        //
        // hidden에서 disable로 바뀌었다.
        // if (self.dropButton.isHidden != model.dropBtnHidden) {
        //     self.dropButton.hidden = model.dropBtnHidden;
        // }
    } else if ([self.reuseIdentifier isEqualToString:StandardLineCellIDToggle] == YES) {
        if (self.toggleSwitch.isOn != model.isToggleOn) {
            self.toggleSwitch.on = model.isToggleOn;
        }
    } else if ([self.reuseIdentifier isEqualToString:StandardLineCellIDNormal] == YES) {
        if (self.selectionBtn.isSelected != model.selected) {
            self.selectionBtn.selected = model.selected;
        }
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
        self.colorBtn.backgroundColor = model.color;
    } else if ([self.reuseIdentifier isEqualToString:StandardLineCellIDUser] == YES) {
        if (self.selectionBtn.isSelected != model.selected) {
            self.selectionBtn.selected = model.selected;
        }
        if (self.ratioButton.isSelected != model.isRatio) {
            self.ratioButton.selected = model.isRatio;
        }
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
        self.colorBtn.backgroundColor = model.color;
        [self.textInputButton setTitle:model.textInputBtnTitle forState:UIControlStateNormal];
        self.textField.placeholder = model.textFieldPlaceHolderTitle;
        self.textField.text = model.textFieldTitle;
    }
}

#pragma mark - Actions

- (IBAction)switchValueChanged:(UISwitch *)sender {
    self.data.toggleOn = sender.isOn;
    self.data = self.data;
}

@end
