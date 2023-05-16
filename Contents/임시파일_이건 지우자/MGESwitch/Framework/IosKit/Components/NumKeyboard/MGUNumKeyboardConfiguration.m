//
//  MGUNumKeyboardConfiguration.m
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 23/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUNumKeyboardConfiguration.h"
#import "MGUNumKeyboardButton.h"
#import "UIColor+Extension.h"

MGUNumKeyboardButtonKey const MGUNumKeyboardButtonZeroKey  = @"0";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonOneKey   = @"1";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonTwoKey   = @"2";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonThreeKey = @"3";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonFourKey  = @"4";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonFiveKey  = @"5";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonSixKey   = @"6";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonSevenKey = @"7";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonEightKey = @"8";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonNineKey  = @"9";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonDecimalPointKey  = @"decimalPoint";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonSpecialKey       = @"special";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonDoneKey          = @"done";
MGUNumKeyboardButtonKey const MGUNumKeyboardButtonBackspaceKey     = @"backspace";


@interface MGUNumKeyboardConfiguration ()
/** Number Button Color & Decimal Button Color **/
@property (nonatomic) UIColor *numButtonBackgroundColor;            // Enable - Normal
@property (nonatomic) UIColor *numButtonContentsColor;              // Enable - Normal

@property (nonatomic) UIColor *highlightedNumButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic) UIColor *highlightedNumButtonContentsColor;   // Enable - Highlighted

@property (nonatomic) UIColor *disabledNumButtonBackgroundColor;    // Disabled
@property (nonatomic) UIColor *disabledNumButtonContentsColor;      // Disabled

/** Special Button Color **/
@property (nonatomic) UIColor *specialButtonBackgroundColor;            // Enable - Normal
@property (nonatomic) UIColor *specialButtonContentsColor;              // Enable - Normal

@property (nonatomic) UIColor *highlightedSpecialButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic) UIColor *highlightedSpecialButtonContentsColor;   // Enable - Highlighted

@property (nonatomic) UIColor *disabledSpecialButtonBackgroundColor;    // Disabled
@property (nonatomic) UIColor *disabledSpecialButtonContentsColor;      // Disabled

/** Delete Button Color **/
@property (nonatomic) UIColor *deleteButtonBackgroundColor;            // Enable - Normal
@property (nonatomic) UIColor *deleteButtonContentsColor;              // Enable - Normal

@property (nonatomic) UIColor *highlightedDeleteButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic) UIColor *highlightedDeleteButtonContentsColor;   // Enable - Highlighted

@property (nonatomic) UIColor *disabledDeleteButtonBackgroundColor;    // Disabled
@property (nonatomic) UIColor *disabledDeleteButtonContentsColor;      // Disabled

/** Done Button Color **/
@property (nonatomic) UIColor *doneButtonBackgroundColor;            // Enable - Normal
@property (nonatomic) UIColor *doneButtonContentsColor;              // Enable - Normal

@property (nonatomic) UIColor *highlightedDoneButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic) UIColor *highlightedDoneButtonContentsColor;   // Enable - Highlighted

@property (nonatomic) UIColor *disabledDoneButtonBackgroundColor;    // Disabled
@property (nonatomic) UIColor *disabledDoneButtonContentsColor;      // Disabled

/** Button Shadow Color **/
@property (nonatomic) UIColor *buttonShadowColor;                  // Button Shadow

/** Border Border Color **/
@property (nonatomic) UIColor *borderColor;                        // border

/** Separator Views Color **/
@property (nonatomic) UIColor *separatorViewsColor;                // border

/** Special Button Contents **/
@property (nonatomic, nullable) UIImage *specialButtonImage;
@property (nonatomic, nullable) NSString *specialButtonTitle;
/** Delete Button Contents **/
@property (nonatomic, nullable) UIImage *deleteButtonImage;
@property (nonatomic, nullable) NSString *deleteButtonTitle;
/** Done Button Contents **/
@property (nonatomic, nullable) UIImage *doneButtonImage;
@property (nonatomic, nullable) NSString *doneButtonTitle;
/** Decimal Button Contents **/
@property (nonatomic, nullable) NSString *decimalSeparatorString; // 기본적으로 keyboard가 알아서 하지만, 여기서 설정해주면 이걸씀.
/** UIImageSymbolConfiguration **/
@property (nonatomic, nullable) UIImageSymbolConfiguration *imageSymbolConfiguration;
/** Font **/
@property (nonatomic, strong) UIFont *numberDecimalFont;
@property (nonatomic, strong) UIFont *characterFont;
//
// Number Button 과 Decimal Button 은 같은 색을 사용한다.
// Delete Button 과 Special Button 은 같은 색을 사용한다.
// contents Color는 text 또는 image 색을 의미한다.
@end

@implementation MGUNumKeyboardConfiguration


#pragma mark - Apply Configuration
- (void)activeConfigurationForButtons:(NSDictionary <NSString *, MGUNumKeyboardButton *>*)buttons
                       separatorViews:(NSArray <UIView *>*)separatorViews {
    for (NSUInteger number = 0; number <= 10; number++) {
        MGUNumKeyboardButton *numberButton;
        if (number == 10) {
            numberButton = buttons[MGUNumKeyboardButtonDecimalPointKey];
        } else {
            numberButton = buttons[@(number).stringValue];
        }
        numberButton.buttonBackgroundColor = self.numButtonBackgroundColor;
        numberButton.buttonContentsColor   = self.numButtonContentsColor;
        numberButton.highlightedButtonBackgroundColor = self.highlightedNumButtonBackgroundColor;
        numberButton.highlightedButtonContentsColor   = self.highlightedNumButtonContentsColor;
        
        numberButton.disabledButtonBackgroundColor    = self.disabledNumButtonBackgroundColor;
        numberButton.disabledButtonContentsColor      = self.disabledNumButtonContentsColor;
        numberButton.buttonShadowColor = self.buttonShadowColor;
        numberButton.borderColor = self.borderColor;
        
        numberButton.titleLabel.font = self.numberDecimalFont;
        [numberButton updateButtonAppearance];
    }
    
    MGUNumKeyboardButton *decimalPointButtton = buttons[MGUNumKeyboardButtonDecimalPointKey];
    decimalPointButtton.titleLabel.font = self.numberDecimalFont;
    if (self.decimalSeparatorString != nil) {
        [decimalPointButtton setTitle:self.decimalSeparatorString forState:UIControlStateNormal];
    }
    [decimalPointButtton updateButtonAppearance];
    
    MGUNumKeyboardButton *doneButtton = buttons[MGUNumKeyboardButtonDoneKey];
    doneButtton.buttonBackgroundColor = self.doneButtonBackgroundColor;
    doneButtton.buttonContentsColor   = self.doneButtonContentsColor;
    doneButtton.highlightedButtonBackgroundColor = self.highlightedDoneButtonBackgroundColor;
    doneButtton.highlightedButtonContentsColor   = self.highlightedDoneButtonContentsColor;
    doneButtton.disabledButtonBackgroundColor    = self.disabledDoneButtonBackgroundColor;
    doneButtton.disabledButtonContentsColor      = self.disabledDoneButtonContentsColor;
    doneButtton.buttonShadowColor = self.buttonShadowColor;
    doneButtton.borderColor = self.borderColor;
    if (self.doneButtonImage != nil) {
        self.doneButtonImage =
        [self.doneButtonImage imageByApplyingSymbolConfiguration:self.imageSymbolConfiguration];
        [doneButtton setImage:self.doneButtonImage forState:UIControlStateNormal];
    } else {
        [doneButtton setTitle:self.doneButtonTitle forState:UIControlStateNormal];
        doneButtton.titleLabel.font = self.characterFont;
    }
    [doneButtton updateButtonAppearance];
    
    MGUNumKeyboardButton *backspaceButtton = buttons[MGUNumKeyboardButtonBackspaceKey];
    backspaceButtton.buttonBackgroundColor = self.deleteButtonBackgroundColor;
    backspaceButtton.buttonContentsColor   = self.deleteButtonContentsColor;
    backspaceButtton.highlightedButtonBackgroundColor = self.highlightedDeleteButtonBackgroundColor;
    backspaceButtton.highlightedButtonContentsColor   = self.highlightedDeleteButtonContentsColor;
    backspaceButtton.disabledButtonBackgroundColor    = self.disabledDeleteButtonBackgroundColor;
    backspaceButtton.disabledButtonContentsColor      = self.disabledDeleteButtonContentsColor;
    backspaceButtton.buttonShadowColor = self.buttonShadowColor;
    backspaceButtton.borderColor = self.borderColor;
    if (self.deleteButtonImage != nil) {
        self.deleteButtonImage =
        [self.deleteButtonImage imageByApplyingSymbolConfiguration:self.imageSymbolConfiguration];
        [backspaceButtton setImage:self.deleteButtonImage forState:UIControlStateNormal];
    } else {
        [backspaceButtton setTitle:self.doneButtonTitle forState:UIControlStateNormal];
        backspaceButtton.titleLabel.font = self.characterFont;
    }
    [backspaceButtton updateButtonAppearance];
    
    MGUNumKeyboardButton *specialButtton = buttons[MGUNumKeyboardButtonSpecialKey];
    specialButtton.buttonBackgroundColor = self.specialButtonBackgroundColor;
    specialButtton.buttonContentsColor   = self.specialButtonContentsColor;
    specialButtton.highlightedButtonBackgroundColor = self.highlightedSpecialButtonBackgroundColor;
    specialButtton.highlightedButtonContentsColor   = self.highlightedSpecialButtonContentsColor;
    specialButtton.disabledButtonBackgroundColor    = self.disabledSpecialButtonBackgroundColor;
    specialButtton.disabledButtonContentsColor      = self.disabledSpecialButtonContentsColor;
    specialButtton.buttonShadowColor = self.buttonShadowColor;
    specialButtton.borderColor = self.borderColor;
    if (self.specialButtonImage != nil) {
        self.specialButtonImage =
        [self.specialButtonImage imageByApplyingSymbolConfiguration:self.imageSymbolConfiguration];
        [specialButtton setImage:self.specialButtonImage forState:UIControlStateNormal];
    } else {
        [specialButtton setTitle:self.specialButtonTitle forState:UIControlStateNormal];
        specialButtton.titleLabel.font = self.characterFont;
    }
    [specialButtton updateButtonAppearance];
    
    for (UIView *view in separatorViews) {
        view.backgroundColor = self.separatorViewsColor;
    }
}


#pragma mark - init
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.specialButtonTitle = @"Res";
    self.doneButtonTitle = @"Done";
//    self.deleteButtonTitle = @"Delete";
    self.imageSymbolConfiguration =
    [UIImageSymbolConfiguration configurationWithPointSize:20.0
                                                    weight:UIImageSymbolWeightBold
                                                     scale:UIImageSymbolScaleLarge];
    self.deleteButtonImage = [UIImage systemImageNamed:@"delete.left.fill"];
    
    self.numberDecimalFont = [UIFont systemFontOfSize:28.0f weight:UIFontWeightLight];
    self.characterFont = [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular];
}


#pragma mark - Configuration List
+ (MGUNumKeyboardConfiguration *)defaultConfiguration {
    MGUNumKeyboardConfiguration * config =  [[MGUNumKeyboardConfiguration alloc] initPrivate];
    
    /** Number Button Color & Decimal Button Color **/
    config.numButtonBackgroundColor = [UIColor mgrColorWithLightModeColor:UIColor.whiteColor
                                                            darkModeColor:[UIColor colorWithWhite:0.365 alpha:1.0]
                                                    darkElevatedModeColor:nil];
    config.numButtonContentsColor = [UIColor mgrColorWithLightModeColor:UIColor.blackColor
                                                          darkModeColor:UIColor.whiteColor
                                                  darkElevatedModeColor:nil];
    
    config.highlightedNumButtonBackgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0.672 green:0.686 blue:0.738 alpha:1.0]
                          darkModeColor:[UIColor colorWithWhite:0.220 alpha:1.0]
                  darkElevatedModeColor:nil];
    
    config.highlightedNumButtonContentsColor = config.numButtonContentsColor;
    config.disabledNumButtonBackgroundColor = [UIColor colorWithRed:0.678f green:0.701f blue:0.735f alpha:1];
    config.disabledNumButtonContentsColor = [UIColor colorWithRed:0.458f green:0.478f blue:0.499f alpha:1];
    
    /** Special Button Color **/
    config.specialButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.specialButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedSpecialButtonBackgroundColor = config.numButtonBackgroundColor;
    config.highlightedSpecialButtonContentsColor   = config.deleteButtonContentsColor;
    config.disabledSpecialButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledSpecialButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Delete Button Color **/
    config.deleteButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.deleteButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedDeleteButtonBackgroundColor = config.numButtonBackgroundColor;
    config.highlightedDeleteButtonContentsColor   = config.deleteButtonContentsColor;
    config.disabledDeleteButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDeleteButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Done Button Color **/
    config.doneButtonBackgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0 green:0.478f blue:1 alpha:1]
                          darkModeColor:[UIColor colorWithRed:0.039 green:0.518 blue:1.0 alpha:1.0]
                  darkElevatedModeColor:nil];
    
    config.doneButtonContentsColor   = UIColor.whiteColor;
    config.highlightedDoneButtonBackgroundColor = config.numButtonBackgroundColor;
    config.highlightedDoneButtonContentsColor   = config.numButtonContentsColor;
    config.disabledDoneButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDoneButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Button Shadow Color **/
    config.buttonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    
    /** Border Color **/
    config.borderColor = UIColor.blackColor;
    return config;
}

+ (MGUNumKeyboardConfiguration *)forgeConfiguration {
    MGUNumKeyboardConfiguration * config =  [[MGUNumKeyboardConfiguration alloc] initPrivate];
    
    /** Number Button Color & Decimal Button Color **/
    config.numButtonBackgroundColor = [UIColor mgrColorWithLightModeColor:UIColor.whiteColor
                                                            darkModeColor:[UIColor colorWithWhite:137.0/255.0 alpha:1.0]
                                                    darkElevatedModeColor:nil];
    
    config.numButtonContentsColor = [UIColor mgrColorWithLightModeColor:UIColor.blackColor
                                                          darkModeColor:UIColor.whiteColor
                                                  darkElevatedModeColor:nil];
    
    config.highlightedNumButtonBackgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:172.0/255.0 green:175.0/255.0 blue:185.0/255.0 alpha:1]
                          darkModeColor:[UIColor colorWithWhite:96.0/255.0 alpha:1.0]
                  darkElevatedModeColor:nil];
    
    config.highlightedNumButtonContentsColor = config.numButtonContentsColor;
    config.disabledNumButtonBackgroundColor = [UIColor colorWithRed:0.678f green:0.701f blue:0.735f alpha:1];
    config.disabledNumButtonContentsColor = [UIColor colorWithRed:0.458f green:0.478f blue:0.499f alpha:1];
    
    /** Special Button Color **/
    config.specialButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.specialButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedSpecialButtonBackgroundColor = config.numButtonBackgroundColor;
    config.highlightedSpecialButtonContentsColor   = config.deleteButtonContentsColor;
    config.disabledSpecialButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledSpecialButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Delete Button Color **/
    config.deleteButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.deleteButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedDeleteButtonBackgroundColor = config.numButtonBackgroundColor;
    config.highlightedDeleteButtonContentsColor   = config.deleteButtonContentsColor;
    config.disabledDeleteButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDeleteButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Done Button Color **/
    config.doneButtonBackgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:26.0/255.0 green:152.0/255.0 blue:215.0/255.0 alpha:1]
                          darkModeColor:[UIColor colorWithRed:28.0/255.0 green:162.0/255.0 blue:230.0/255.0 alpha:1.0]
                  darkElevatedModeColor:nil];
    
    config.doneButtonContentsColor   = UIColor.whiteColor;
    config.highlightedDoneButtonBackgroundColor = config.numButtonBackgroundColor;
    config.highlightedDoneButtonContentsColor   = config.numButtonContentsColor;
    config.disabledDoneButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDoneButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Button Shadow Color **/
    config.buttonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    
    /** Border Color **/
    config.borderColor = [UIColor clearColor];
    config.imageSymbolConfiguration =
    [UIImageSymbolConfiguration configurationWithPointSize:20.0
                                                    weight:UIImageSymbolWeightLight
                                                     scale:UIImageSymbolScaleLarge];
    config.deleteButtonImage = [UIImage systemImageNamed:@"delete.left"];
    config.doneButtonImage = [UIImage systemImageNamed:@"return"];
    config.specialButtonImage = [UIImage systemImageNamed:@"escape"];
    config.decimalSeparatorString = @"•";
    return config;
}

+ (MGUNumKeyboardConfiguration *)blueConfiguration {
    MGUNumKeyboardConfiguration * config =  [[MGUNumKeyboardConfiguration alloc] initPrivate];
    
    /** Number Button Color & Decimal Button Color & Special Button Color **/
    config.numButtonBackgroundColor = UIColor.clearColor;
    config.numButtonContentsColor = UIColor.whiteColor;
    config.highlightedNumButtonBackgroundColor = [UIColor colorWithRed:13.0/255.0 green:68.0/255.0 blue:146.0/255.0 alpha:1.0];
    config.highlightedNumButtonContentsColor = config.numButtonContentsColor;
    config.disabledNumButtonBackgroundColor = [UIColor colorWithRed:0.678f green:0.701f blue:0.735f alpha:1];
    config.disabledNumButtonContentsColor = [UIColor colorWithRed:0.458f green:0.478f blue:0.499f alpha:1];
    
    /** Special Button Color **/
    config.specialButtonBackgroundColor = config.numButtonBackgroundColor;
    config.specialButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedSpecialButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.highlightedSpecialButtonContentsColor   = config.highlightedNumButtonContentsColor;
    config.disabledSpecialButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledSpecialButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Delete Button Color **/
    config.deleteButtonBackgroundColor = config.numButtonBackgroundColor;
    config.deleteButtonContentsColor   = [UIColor colorWithRed:255.0/255.0 green:110.0/255.0 blue:71.0/255.0 alpha:1.0];
    config.highlightedDeleteButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.highlightedDeleteButtonContentsColor   = UIColor.greenColor;
    config.disabledDeleteButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDeleteButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Done Button Color **/
    config.doneButtonBackgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0 green:0.478f blue:1 alpha:1]
                          darkModeColor:[UIColor colorWithRed:0.039 green:0.518 blue:1.0 alpha:1.0]
                  darkElevatedModeColor:nil];
    config.doneButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedDoneButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.highlightedDoneButtonContentsColor   = config.numButtonContentsColor;
    config.disabledDoneButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDoneButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Button Shadow Color **/
    config.buttonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    
    /** Border Shadow Color **/
    config.borderColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    return config;
}

+ (MGUNumKeyboardConfiguration *)darkBlueConfiguration {
    MGUNumKeyboardConfiguration * config =  [[MGUNumKeyboardConfiguration alloc] initPrivate];
    
    /** Number Button Color & Decimal Button Color & Special Button Color **/
    config.numButtonBackgroundColor = [UIColor colorWithRed:12.0/255.0 green:68.0/255.0 blue:146.0/255.0 alpha:1.0];
    config.numButtonContentsColor = UIColor.whiteColor;
    config.highlightedNumButtonBackgroundColor = [UIColor colorWithRed:62.0/255.0 green:128.0/255.0 blue:220.0/255.0 alpha:1.0];
    config.highlightedNumButtonContentsColor = config.numButtonContentsColor;
    config.disabledNumButtonBackgroundColor = [UIColor colorWithRed:0.678f green:0.701f blue:0.735f alpha:1];
    config.disabledNumButtonContentsColor = [UIColor colorWithRed:0.458f green:0.478f blue:0.499f alpha:1];
    
    /** Special Button Color **/
    config.specialButtonBackgroundColor = config.numButtonBackgroundColor;
    config.specialButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedSpecialButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.highlightedSpecialButtonContentsColor   = config.highlightedNumButtonContentsColor;
    config.disabledSpecialButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledSpecialButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Delete Button Color **/
    config.deleteButtonBackgroundColor = config.numButtonBackgroundColor;
    config.deleteButtonContentsColor   = [UIColor colorWithRed:255.0/255.0 green:110.0/255.0 blue:71.0/255.0 alpha:1.0];
    config.highlightedDeleteButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.highlightedDeleteButtonContentsColor   = UIColor.greenColor;
    config.disabledDeleteButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDeleteButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Done Button Color **/
    config.doneButtonBackgroundColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:1.0/255.0 alpha:1.0];
    config.doneButtonContentsColor   = config.numButtonContentsColor;
    config.highlightedDoneButtonBackgroundColor = config.highlightedNumButtonBackgroundColor;
    config.highlightedDoneButtonContentsColor   = config.numButtonContentsColor;
    config.disabledDoneButtonBackgroundColor = config.disabledNumButtonBackgroundColor;
    config.disabledDoneButtonContentsColor   = config.disabledNumButtonContentsColor;
    
    /** Button Shadow Color **/
    config.buttonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    
    /** Border Shadow Color **/
    config.borderColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    
    config.separatorViewsColor = [UIColor colorWithRed:5.0/255.0 green:30.0/255.0 blue:64.0/255.0 alpha:1.0];
    return config;
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)init {
    NSAssert(FALSE, @"- init 사용금지.");
    return nil;
}

+ (instancetype)new {
    NSAssert(FALSE, @"+ new 사용금지.");
    return nil;
}
@end
