//
//  ChartSettingCell.m
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/09/01.
//

#import "LineSettingCell.h"
#import "GeometricShapesView.h"

@interface LineSettingCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectionBtn; // 단순한 라벨일 뿐이다. 하나 제외.
@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@property (weak, nonatomic) IBOutlet MGUBrightnessBorderButton *colorBtn;
@property (weak, nonatomic) IBOutlet UIButton *boldButton;
@property (weak, nonatomic) IBOutlet MGUDropdownButton *dropButton;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UIButton *textInputButton;

@property (weak, nonatomic) IBOutlet GeometricShapesView *geometricShapesView;
@end

@implementation LineSettingCell

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

static void CommonInit(LineSettingCell *self) {
    self.contentContainer.backgroundColor = [UIColor clearColor];
    if ([self.reuseIdentifier isEqualToString:LineSettingCellIDColorFill] == YES) {
        [self setupColorFillMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDColor] == YES) {
        [self setupColorMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDColorDrop] == YES) {
        [self setupColorDropMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDToggle] == YES) {
        [self setupToggleMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDTextInput] == YES) {
        [self setupTextInputMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDDrop] == YES) {
        [self setupDropMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDFont] == YES) {
        [self setupFontMode];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDGeometricShapes] == YES) {
        [self setupGeometricShapesMode];
    } else {
        
    }
}

- (void)setupColorFillMode { // 좌측 타이틀 체크 + 칼라버튼
    self.colorBtn.backgroundColor = [UIColor systemMintColor];
    self.colorBtn.layer.cornerRadius = 4.0;
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

- (void)setupColorMode {
    self.colorBtn.backgroundColor = [UIColor systemMintColor];
    self.colorBtn.layer.cornerRadius = 4.0;
}

- (void)setupColorDropMode {
    self.colorBtn.backgroundColor = [UIColor systemMintColor];
    self.colorBtn.layer.cornerRadius = 4.0;
    self.dropButton.backgroundColor = [UIColor clearColor];
    
    self.dropButton.cellClass = [MGULineWidthDropdownCell class];
    self.dropButton.dropdownData = @[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)];
    self.dropButton.selectedIndex = 0;
}

- (void)setupToggleMode {
}

- (void)setupTextInputMode {
    self.textInputButton.backgroundColor = [UIColor whiteColor];
    self.textInputButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textInputButton.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.textInputButton.layer.cornerRadius = 5.0;
    [self.textInputButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.textInputButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.textInputButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.textInputButton.titleLabel.minimumScaleFactor = 0.5;
}

- (void)setupDropMode {
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGUTextDropdownCell class];
    self.dropButton.dropdownData = @[@"목업0", @"목업1", @"목업2"];
    self.dropButton.selectedIndex = 1;
    self.dropButton.placeHolderTextAlignment = NSTextAlignmentCenter;
    self.dropButton.textAlignment = NSTextAlignmentRight;
}

- (void)setupFontMode {
    self.boldButton.backgroundColor = [UIColor clearColor];
    self.boldButton.layer.cornerRadius = 4.0; // 4.0
    self.dropButton.backgroundColor = [UIColor clearColor];
    self.dropButton.cellClass = [MGUTextDropdownCell class];
    NSMutableArray <NSString *>*dropdownData = @[].mutableCopy;
    for (int i = 10; i <= 50; i++) {
        NSString *title = [NSString stringWithFormat:@"%d", i];
        [dropdownData addObject:title];
    }
    self.dropButton.dropdownData = dropdownData;
    self.dropButton.layer.cornerRadius = 4.0;
    self.dropButton.selectedIndex = 7;
    self.dropButton.placeHolderTextAlignment = NSTextAlignmentCenter;
    self.dropButton.textAlignment = NSTextAlignmentCenter;
}

- (void)setupGeometricShapesMode {
}

#pragma mark - Setter & Getter

- (void)setData:(DTOLineSetting *)model {
    _data = model;
    [self.selectionBtn setTitle:model.title forState:UIControlStateNormal];
    
    if ([self.reuseIdentifier isEqualToString:LineSettingCellIDColorFill] == YES) {
        self.colorBtn.backgroundColor = model.color;
        if (self.selectionBtn.isSelected != model.selected) {
            self.selectionBtn.selected = model.selected;
        }
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDColor] == YES) {
        self.colorBtn.backgroundColor = model.color;
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDColorDrop] == YES) {
        self.colorBtn.backgroundColor = model.color;
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDToggle] == YES) {
        self.toggleSwitch.on = model.isToggleOn;
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDTextInput] == YES) {
        [self.textInputButton setTitle:model.textInputBtnTitle forState:UIControlStateNormal];
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDDrop] == YES) {
        if (model.dropBtnTitles != nil && model.dropBtnTitles.count > 0) {
            self.dropButton.dropdownData = model.dropBtnTitles;
        }
        self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDFont] == YES) {
        if (self.boldButton.isSelected != model.isBold) {
            self.boldButton.selected = model.isBold;
        }
        if (self.dropButton.selectedIndex != model.dropBtnSelectedIndex) {
            self.dropButton.selectedIndex = model.dropBtnSelectedIndex;
        }
    } else if ([self.reuseIdentifier isEqualToString:LineSettingCellIDGeometricShapes] == YES) {
        self.geometricShapesView.geometricShapesType = self.data.geometricShapesType;
        self.geometricShapesView.borderColor = self.data.geometricShapesBorderColor;
        self.geometricShapesView.borderWidth = self.data.geometricShapesBorderWidth;
        self.geometricShapesView.backColor = self.data.geometricShapesBackColor;
    }
}

#pragma mark - Actions

@end
