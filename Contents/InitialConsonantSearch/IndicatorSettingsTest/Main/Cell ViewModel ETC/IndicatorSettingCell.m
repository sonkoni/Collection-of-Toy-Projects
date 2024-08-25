//
//  IndicatorSettingCell.m
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/10/23.
//

#import <IosKit/IosKit.h>
#import "IndicatorSettingCell.h"
#import "Defines.h"

@interface IndicatorSettingCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UIButton *pmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *indentImageView;
@property (weak, nonatomic) IBOutlet UILabel *searchCategoryLabel;
@property (nonatomic, strong) UILabel *favoriteCategoryLabel;
@end

@interface IndicatorSettingCell (Extension)
- (void)setupSelectionBtn;
- (void)setupSettingBtn;
- (void)setupFavBtn;
- (void)setupPlusBtn;
- (void)setupMinusBtn;
- (void)setupIndentBtn;
- (void)setupCategoryLabel:(UILabel *)label;
@end

@implementation IndicatorSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.selectionBtn != nil) {
        self.selectionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.selectionBtn.titleLabel.minimumScaleFactor = 0.5;
        self.selectionBtn.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        // self.selectionBtn.userInteractionEnabled = NO;
        // self.selectionBtn.translatesAutoresizingMaskIntoConstraints = NO;
        // NSLayoutConstraint *constraint = [self.selectionBtn.heightAnchor constraintEqualToConstant:44.0]; // 키움: 55.0
        // constraint.priority = UILayoutPriorityDefaultHigh;
        // constraint.active = YES;
        [self.selectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    CommonInit(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIndentationLevel:(NSInteger)indentationLevel {
    [super setIndentationLevel:indentationLevel];
    self.separatorInset = UIEdgeInsetsMake(0.0, 16.0 * indentationLevel, 0.0, 0.0);
}

#pragma mark - 생성 & 소멸

static void CommonInit(IndicatorSettingCell *self) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSection] == YES) {
        [self setupSectionMode];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubPlus] == YES) {
        [self setupSubPlus];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubMinus] == YES) {
        [self setupSubMinus];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubNormal] == YES) {
        [self setupSubNormal];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDRegion] == YES) {
        [self setupRegion];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavorite] == YES) {
        [self setupFavorite];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavoriteSub] == YES) {
        [self setupFavoriteSub];
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSearch] == YES) {
        [self setupSearch];
    }

    [CATransaction commit];
}

- (void)setupSectionMode {
    self.countLabel.font = [UIFont monospacedSystemFontOfSize:14.0 weight:UIFontWeightRegular]; // monospacedDigitSystemFontOfSize
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.minimumScaleFactor = 0.5;
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    self.disclosureImageView.image = [Defines imageNamed:DefinesImageNameChevronForward
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setupSubPlus {
    [self setupSelectionBtn];
    [self setupSettingBtn];
    [self setupFavBtn];
    [self setupPlusBtn];
}

- (void)setupSubMinus {
    [self.favBtn setImage:nil forState:UIControlStateNormal];
    [self.favBtn setImage:nil forState:UIControlStateSelected];
    [self setupIndentBtn];
    [self setupSelectionBtn];
    [self setupSettingBtn];
    [self setupMinusBtn];
}

- (void)setupSubNormal {
    [self setupSelectionBtn];
    [self setupSettingBtn];
    [self setupFavBtn];
}

- (void)setupRegion {
    [self setupSelectionBtn];
    [self setupSettingBtn];
    [self setupFavBtn];
}

- (void)setupFavorite {
    [self setupSelectionBtn];
    [self setupSettingBtn];
    [self setupFavBtn];
}

- (void)setupFavoriteSub {
    [self.favBtn setImage:nil forState:UIControlStateNormal];
    [self.favBtn setImage:nil forState:UIControlStateSelected];
    [self setupIndentBtn];
    [self setupSelectionBtn];
    [self setupSettingBtn];
}

- (void)setupSearch {
    [self setupCategoryLabel:self.searchCategoryLabel];
    self.selectionBtn.userInteractionEnabled = NO;
    [self.selectionBtn setImage:nil forState:UIControlStateNormal];
    [self.selectionBtn setImage:nil forState:UIControlStateSelected];
}

#pragma mark - 세터 & 게터

- (void)setData:(DTOIndicatorSetting *)data {
    _data = data;
    [self adjustOutlineData];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    NSString *title = [DTOIndicatorSetting prettyName:data.title];
    [self.selectionBtn setTitle:title forState:UIControlStateNormal];
    
    if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSection] == YES) {
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubPlus] == YES ||
               [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubMinus] == YES ||
               [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubNormal] == YES ||
               [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDRegion] == YES ||
               [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavorite] == YES ||
               [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavoriteSub] == YES) {
        self.selectionBtn.selected = data.selected;
        if (data.selected == YES) {
            self.settingBtn.alpha = 1.0;
            self.settingBtn.userInteractionEnabled = YES;
        } else {
            self.settingBtn.alpha = 0.0;
            self.settingBtn.userInteractionEnabled = NO;
        }
        
        if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubPlus] == YES ||
            [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSubNormal] == YES ||
            [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDRegion] == YES ||
            [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavorite] == YES) {
            self.favBtn.selected = data.favorite;
            if (self.favBtn.isSelected == YES) {
                self.favBtn.imageView.tintColor = [UIColor systemYellowColor];
                self.favBtn.tintColor = [UIColor systemYellowColor];
            } else {
                self.favBtn.imageView.tintColor = [UIColor lightGrayColor];
                self.favBtn.tintColor = [UIColor lightGrayColor];
            }
        }
        
        if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavorite] == YES ||
            [self.reuseIdentifier isEqualToString:IndicatorSettingCellIDFavoriteSub] == YES) {
            [self applyCategoryLabel:self.favoriteCategoryLabel];
        }
    } else if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSearch] == YES) {
        [self applyCategoryLabel:self.searchCategoryLabel];
    }
    
    [CATransaction commit];
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSection] == YES) {
        [self configureChevron];
    }
}

- (UILabel *)favoriteCategoryLabel {
    if (_favoriteCategoryLabel == nil) {
        _favoriteCategoryLabel = [UILabel new];
        [self setupCategoryLabel:_favoriteCategoryLabel];
        _favoriteCategoryLabel.userInteractionEnabled = NO; // 디폴트
        [self.selectionBtn addSubview:_favoriteCategoryLabel];
        [_favoriteCategoryLabel mgrPinFixSize:CGSizeMake(28.0, 12.0)];
        [_favoriteCategoryLabel.centerYAnchor constraintEqualToAnchor:self.selectionBtn.centerYAnchor].active = YES;
        [_favoriteCategoryLabel.leadingAnchor constraintEqualToAnchor:self.selectionBtn.leadingAnchor constant:30.0].active = YES;
    }
    
    return _favoriteCategoryLabel;
}

#pragma mark - Private

- (void)adjustOutlineData {
    MGROutlineItem <DTOIndicatorSetting *>*outlineItem = self.data.outlineItem;
    self.expanded = outlineItem.isExpanded;
    self.indentationLevel = outlineItem.indentationLevel;
    if ([self.reuseIdentifier isEqualToString:IndicatorSettingCellIDSection] == YES) {
        NSArray <MGROutlineItem <DTOIndicatorSetting *>*>*recurrenceAllSubitems = outlineItem.recurrenceAllSubitems;
        NSArray <MGROutlineItem <DTOIndicatorSetting *>*>*recurrenceAllActiveSubitems = 
        [recurrenceAllSubitems mgrFilter:^BOOL(MGROutlineItem <DTOIndicatorSetting *>*obj) {
            return obj.contentItem.selected;
        }];
        NSInteger activeCount = recurrenceAllActiveSubitems.count;
        if (activeCount > 0) {
            self.countLabel.alpha = 1.0;
            self.countLabel.text = [NSString stringWithFormat:@"(%ld)", activeCount];
        } else {
            self.countLabel.alpha = 0.0;
        }
    }
}

- (void)configureChevron {
    // chevron.forward
    BOOL rtl = self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    CGFloat rtlMultiplier = rtl ? -1.0 : 1.0;
    CGAffineTransform rotationTransform = self.expanded ? CGAffineTransformMakeRotation(rtlMultiplier * M_PI_2) : CGAffineTransformIdentity;
    self.disclosureImageView.transform = rotationTransform;
}

- (void)applyCategoryLabel:(UILabel *)label {
    if ([self.data.mainCategory isEqualToString:IndiSetMainCategoryIndicators]) {
        label.text = IndiSetMainCategoryIndicators;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.textColor = [UIColor darkGrayColor];
    } else if ([self.data.mainCategory isEqualToString:IndiSetMainCategorySignals]) {
        label.text = IndiSetMainCategorySignals;
        label.layer.borderColor = [UIColor systemGreenColor].CGColor;
        label.textColor = [UIColor systemGreenColor];
    } else if ([self.data.mainCategory isEqualToString:IndiSetMainCategoryPatterns]) {
        label.text = IndiSetMainCategoryPatterns;
        label.layer.borderColor = [UIColor systemYellowColor].CGColor;
        label.textColor = [UIColor systemYellowColor];
    } else if ([self.data.mainCategory isEqualToString:IndiSetMainCategoryRanges]) {
        label.text = IndiSetMainCategoryRanges;
        label.layer.borderColor = [UIColor systemBlueColor].CGColor;
        label.textColor = [UIColor systemBlueColor];
    } else if ([self.data.mainCategory isEqualToString:IndiSetMainCategoryFill]) {
        label.text = IndiSetMainCategoryFill;
        label.layer.borderColor = [UIColor systemMintColor].CGColor;
        label.textColor = [UIColor systemMintColor];
    }
}

@end

@implementation IndicatorSettingCell (Extension)

- (void)setupSelectionBtn {
    self.selectionBtn.imageView.contentMode = UIViewContentModeCenter;
    UIColor *tintColor = [UIColor colorWithRed:15.0/255.0 green:40.0/255.0 blue:71.0/255.0 alpha:1.0];
    self.selectionBtn.tintColor = tintColor;
    self.selectionBtn.imageView.tintColor = tintColor;
    UIImage *selectedImage = [Defines imageNamed:DefinesImageNameCheckmarkCircleFill
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *normalImage = [Defines imageNamed:DefinesImageNameUncheckmarkCircleOpaque
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.selectionBtn mgrSetSelectedImage:selectedImage normalImage:normalImage preventHighlight:YES];
    [self.selectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.selectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setupSettingBtn {
    self.settingBtn.imageView.contentMode = UIViewContentModeCenter;
    UIColor *tintColor = [UIColor lightGrayColor];
    self.settingBtn.tintColor = tintColor;
    self.settingBtn.imageView.tintColor = tintColor;
    UIImage *normalImage = [Defines imageNamed:DefinesImageNameGearshape
                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.settingBtn setImage:normalImage forState:UIControlStateNormal];
}

- (void)setupFavBtn {
    self.favBtn.imageView.contentMode = UIViewContentModeCenter;
    UIColor *tintColor = [UIColor lightGrayColor];
    self.favBtn.imageView.tintColor = tintColor;
    UIImage *selectedImage = [Defines imageNamed:DefinesImageNameStarFill
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *normalImage = [Defines imageNamed:DefinesImageNameStar
                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.favBtn setImage:selectedImage forState:UIControlStateSelected];
    [self.favBtn setImage:normalImage forState:UIControlStateNormal];
}

- (void)setupPlusBtn {
    self.pmBtn.imageView.contentMode = UIViewContentModeCenter;
    UIColor *tintColor = [UIColor lightGrayColor];
    self.pmBtn.tintColor = tintColor;
    self.pmBtn.imageView.tintColor = tintColor;
    UIImage *normalImage = [Defines imageNamed:DefinesImageNamePlus
                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pmBtn setImage:normalImage forState:UIControlStateNormal];
}

- (void)setupMinusBtn {
    self.pmBtn.imageView.contentMode = UIViewContentModeCenter;
    UIColor *tintColor = [UIColor lightGrayColor];
    self.pmBtn.tintColor = tintColor;
    self.pmBtn.imageView.tintColor = tintColor;
    UIImage *normalImage = [Defines imageNamed:DefinesImageNameMinus
                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pmBtn setImage:normalImage forState:UIControlStateNormal];
}

- (void)setupIndentBtn {
    self.indentImageView.contentMode = UIViewContentModeCenter;
    self.indentImageView.tintColor = [UIColor lightGrayColor];
    self.indentImageView.image = [Defines imageNamed:DefinesImageNameIndent
                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setupCategoryLabel:(UILabel *)label {
    label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    label.layer.cornerRadius = 3.0;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.text = @"지표";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:10.0];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
}

@end
