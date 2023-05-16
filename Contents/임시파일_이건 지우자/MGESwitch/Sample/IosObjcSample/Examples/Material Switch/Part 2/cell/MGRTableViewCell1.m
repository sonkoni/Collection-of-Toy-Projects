//
//  MGRTableViewCell.m
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 25/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGRTableViewCell1.h"
@import IosKit;

@interface MGRTableViewCell1 ()
@property (nonatomic, strong) MGUMaterialSwitch *materialSwitch;
@end

@implementation MGRTableViewCell1

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone; // 선택되었을 때, 회색으로 변하는 것을 막는다.
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.switchContianerView.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 & 게터 메서드

- (void)setIdentifier:(MGRTableViewCellIdentifier)identifier {
    _identifier = identifier;
    
    if (identifier == MGRDefaultIdentifier) {
        self.materialSwitch  = [self defaultStyleSwitch];
        self.mainLabel.text  = @"MGUMaterialSwitchStyleDefault:";
        self.thumbLabel.text = @"Thumb On: #244DF2  Off: #F7F7F7";
        self.trackLabel.text = @"Track   On: #7C9FF8  Off: #B4B4B4";
    } else if (identifier == MGRLightIdentifier) {
        self.materialSwitch  = [self lightStyleSwitch];
        self.mainLabel.text  = @"MGUMaterialSwitchStyleLight:";
        self.thumbLabel.text = @"Thumb On: #007562  Off: #E8E9E8";
        self.trackLabel.text = @"Track   On: #48A599  Off: #6E6E6E";
    } else if (identifier == MGRDarkIdentifier) {
        self.materialSwitch  = [self darkStyleSwitch];
        self.mainLabel.text  = @"MGUMaterialSwitchStyleDark:";
        self.thumbLabel.text = @"Thumb On: #5AB7AA  Off: #9F9F9F";
        self.trackLabel.text = @"Track   On: #385B56   Off: #4B4C4B";
    } else if (identifier == MGRCustomizedStyleIdentifier) {
        self.materialSwitch  = [self customizedStyleSwitch];
        self.mainLabel.text  = @"Customized Style:";
        self.thumbLabel.text = @"You can set any colors to attributes.";
        self.trackLabel.text = @"(Thumb On/Off, Track On/Off, Ripple)";
    }
    [self.materialSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.switchContianerView  addSubview:self.materialSwitch];
    self.materialSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.materialSwitch.centerXAnchor constraintEqualToAnchor:self.switchContianerView.centerXAnchor].active = YES;
    [self.materialSwitch.centerYAnchor constraintEqualToAnchor:self.switchContianerView.centerYAnchor].active = YES;
    [self.materialSwitch.widthAnchor   constraintEqualToConstant:self.materialSwitch.frame.size.width].active = YES;
    [self.materialSwitch.heightAnchor  constraintEqualToConstant:self.materialSwitch.frame.size.height].active = YES;
    
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 컨트롤 메서드
- (void)stateChanged:(MGUMaterialSwitch *)materialSwitch {
    
    if (materialSwitch.switchOn == YES) {
        if ([self.identifier isEqualToString:MGRDefaultIdentifier]) {
            self.mainLabel.text  = @"MGUMaterialSwitchStyleDefault: ON";
        } else if ([self.identifier isEqualToString:MGRLightIdentifier]) {
            self.mainLabel.text  = @"MGUMaterialSwitchStyleLight: ON";
        } else if ([self.identifier isEqualToString:MGRDarkIdentifier]) {
            self.mainLabel.text  = @"MGUMaterialSwitchStyleDark: ON";
        } else if ([self.identifier isEqualToString:MGRCustomizedStyleIdentifier]) {
            self.mainLabel.text  = @"Customized Style: ON";
        }
        
    } else {
        if ([self.identifier isEqualToString:MGRDefaultIdentifier]) {
            self.mainLabel.text  = @"MGUMaterialSwitchStyleDefault: OFF";
        } else if ([self.identifier isEqualToString:MGRLightIdentifier]) {
            self.mainLabel.text  = @"MGUMaterialSwitchStyleLight: OFF";
        } else if ([self.identifier isEqualToString:MGRDarkIdentifier]) {
            self.mainLabel.text  = @"MGUMaterialSwitchStyleDark: OFF";
        } else if ([self.identifier isEqualToString:MGRCustomizedStyleIdentifier]) {
            self.mainLabel.text  = @"Customized Style: OFF";
        }
    }
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드

- (MGUMaterialSwitch *)defaultStyleSwitch {
    return [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                             style:MGUMaterialSwitchStyleDefault
                                          switchOn:YES];
}

- (MGUMaterialSwitch *)lightStyleSwitch {
    return [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                             style:MGUMaterialSwitchStyleLight
                                          switchOn:YES];
}

- (MGUMaterialSwitch *)darkStyleSwitch {
    return [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                             style:MGUMaterialSwitchStyleDark
                                          switchOn:YES];
}

- (MGUMaterialSwitch *)customizedStyleSwitch {
    MGUMaterialSwitch * resultSwtich = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                         style:MGUMaterialSwitchStyleDefault
                                                                      switchOn:YES];
    
    
    //! 디폴트로 맞춰놓고 조정한다.
    // Custom behaviors to each component
    resultSwtich.knobOnColor  = [UIColor colorWithRed:237./255. green:159./255. blue:53./255. alpha:1.0];
    resultSwtich.knobOffColor = [UIColor colorWithRed:232./255. green:233./255. blue:232./255. alpha:1.0];
    resultSwtich.trackOnColor  = [UIColor colorWithRed:243./255. green:204./255. blue:146./255. alpha:1.0];
    resultSwtich.trackOffColor = [UIColor colorWithRed:164./255. green:164./255. blue:164./255. alpha:1.0];
    // SwtichObject.thumbDisabledTintColor = [UIColor materialBombay]; <- 디폴트를 그냥 쓰겠다.
    // SwtichObject.trackDisabledTintColor = [UIColor materialIron];   <- 디폴트를 그냥 쓰겠다.
    resultSwtich.rippleFillColor   = [UIColor greenColor];

    return resultSwtich;
}

@end
