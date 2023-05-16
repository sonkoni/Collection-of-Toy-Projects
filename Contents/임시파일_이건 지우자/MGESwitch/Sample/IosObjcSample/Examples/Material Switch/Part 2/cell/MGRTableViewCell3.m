//
//  MGRTableViewCell3.m
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 25/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGRTableViewCell3.h"
@import IosKit;

@interface MGRTableViewCell3 ()
@end

@implementation MGRTableViewCell3

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone; // 선택되었을 때, 회색으로 변하는 것을 막는다.
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftSwitchContianerView.backgroundColor   = UIColor.clearColor;
    self.centerSwitchContianerView.backgroundColor = UIColor.clearColor;
    self.rightSwitchContianerView.backgroundColor  = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 소멸 메서드
//모든 config 와 create 함수가 있다
//ex: - (void)setupDefaultValues {…};


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 & 게터 메서드

- (void)setIdentifier:(MGRTableViewCellIdentifier)identifier {
    
    _identifier = identifier;
    // 어차피 이 셀은 identifier가 하나다.
    
    MGUMaterialSwitch *mgrSwitchSmall = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeSmall
                                                                          style:MGUMaterialSwitchStyleDefault
                                                                       switchOn:YES];
    
    MGUMaterialSwitch *mgrSwitchNormal = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeNormal
                                                                           style:MGUMaterialSwitchStyleDefault
                                                                        switchOn:YES];
    
    MGUMaterialSwitch *mgrSwitchBig = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeBig
                                                                        style:MGUMaterialSwitchStyleDefault
                                                                     switchOn:YES];
    
    [self.leftSwitchContianerView   addSubview:mgrSwitchSmall];
    [self.centerSwitchContianerView addSubview:mgrSwitchNormal];
    [self.rightSwitchContianerView  addSubview:mgrSwitchBig];
    
    for (MGUMaterialSwitch *materialSwitch in @[mgrSwitchSmall, mgrSwitchNormal, mgrSwitchBig]) {
        materialSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *containerView;
        if (materialSwitch == mgrSwitchSmall) {
            containerView = self.leftSwitchContianerView;
        } else if (materialSwitch == mgrSwitchNormal) {
            containerView = self.centerSwitchContianerView;
        } else if (materialSwitch == mgrSwitchBig) {
            containerView = self.rightSwitchContianerView;
        }
        
        [materialSwitch.centerXAnchor  constraintEqualToAnchor:containerView.centerXAnchor].active = YES;
        [materialSwitch.centerYAnchor  constraintEqualToAnchor:containerView.centerYAnchor].active = YES;
        [materialSwitch.widthAnchor    constraintEqualToConstant:materialSwitch.frame.size.width].active = YES;
        [materialSwitch.heightAnchor   constraintEqualToConstant:materialSwitch.frame.size.height].active = YES;
    }
}

@end
