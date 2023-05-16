//
//  MGRTableViewCell2.m
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 25/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGRTableViewCell2.h"
@import IosKit;

@interface MGRTableViewCell2 ()
@property (nonatomic, strong) NSArray <MGUMaterialSwitch *>*swtiches;
@end

@implementation MGRTableViewCell2

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone; // 선택되었을 때, 회색으로 변하는 것을 막는다.
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftSwitchContianerView.backgroundColor  = UIColor.clearColor;
    self.rightSwitchContianerView.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 & 게터 메서드

- (void)setIdentifier:(MGRTableViewCellIdentifier)identifier {
    _identifier = identifier;
    
    if (identifier == MGRBounceIdentifier) {
        self.swtiches        = [self bounceSwitches];
        self.leftLabel.text  = @"Bounce OFF";
        self.rightLabel.text = @"Bounce ON";
    } else if (identifier == MGRRippleIdentifier) {
        self.swtiches        = [self rippleEffectSwitches];
        self.leftLabel.text  = @"Ripple OFF";
        self.rightLabel.text = @"Ripple ON";
    } else if (identifier == MGREnabledIdentifier) {
        self.swtiches        = [self enabledSwitches];
        self.leftLabel.text  = @"Enabled OFF";
        self.rightLabel.text = @"Enabled ON";
    }

    [self.leftSwitchContianerView   addSubview:self.swtiches.firstObject];
    [self.rightSwitchContianerView  addSubview:self.swtiches.lastObject];
    
    for (MGUMaterialSwitch *materialSwitch in self.swtiches) {
        materialSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *containerView;
        if (materialSwitch == self.swtiches.firstObject) {
            containerView = self.leftSwitchContianerView;
        } else if (materialSwitch == self.swtiches.lastObject) {
            containerView = self.rightSwitchContianerView;
        }
        
        [materialSwitch.centerXAnchor  constraintEqualToAnchor:containerView.centerXAnchor].active = YES;
        [materialSwitch.centerYAnchor  constraintEqualToAnchor:containerView.centerYAnchor].active = YES;
        [materialSwitch.widthAnchor    constraintEqualToConstant:materialSwitch.frame.size.width].active = YES;
        [materialSwitch.heightAnchor   constraintEqualToConstant:materialSwitch.frame.size.height].active = YES;
    }
    
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드
- (NSArray <MGUMaterialSwitch *>*)bounceSwitches {
    MGUMaterialSwitch *mgrSwitchBounceOFF = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                              style:MGUMaterialSwitchStyleLight
                                                                           switchOn:YES];
    mgrSwitchBounceOFF.bounceEnabled = NO;
    
    MGUMaterialSwitch *mgrSwitchBounceON= [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                            style:MGUMaterialSwitchStyleLight
                                                                         switchOn:YES];
    mgrSwitchBounceON.bounceEnabled = YES; // default value
    
    return @[mgrSwitchBounceOFF, mgrSwitchBounceON];
}

- (NSArray <MGUMaterialSwitch *>*)rippleEffectSwitches {
    MGUMaterialSwitch *mgrSwitchRippleOFF = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                              style:MGUMaterialSwitchStyleDefault
                                                                           switchOn:YES];
    mgrSwitchRippleOFF.rippleEnabled = NO;
    
    MGUMaterialSwitch *mgrSwitchRippleON= [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                            style:MGUMaterialSwitchStyleDefault
                                                                         switchOn:YES];
    mgrSwitchRippleON.rippleEnabled = YES; // default value
    
    return @[mgrSwitchRippleOFF, mgrSwitchRippleON];
}

- (NSArray <MGUMaterialSwitch *>*)enabledSwitches {
    MGUMaterialSwitch *mgrSwitchEnabledOFF = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                               style:MGUMaterialSwitchStyleLight
                                                                            switchOn:YES];
    //mgrSwitchEnabledOFF.isEnabled = NO;
    mgrSwitchEnabledOFF.enabled = NO;
    
    MGUMaterialSwitch *mgrSwitchEnabledON = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                              style:MGUMaterialSwitchStyleLight
                                                                           switchOn:NO];
    mgrSwitchEnabledON.enabled = YES; // default value
    
    return @[mgrSwitchEnabledOFF, mgrSwitchEnabledON];
}

@end
