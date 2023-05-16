//
//  MGRTableViewCellIdentifier.h
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 26/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#ifndef MGRTableViewCellIdentifier_h
#define MGRTableViewCellIdentifier_h

/// 총 다섯 가지 종류의 tableView cell을 만들 것이고, 총 8개를 만들 것이다.(4개는 종류가 같음.)
typedef NSString *MGRTableViewCellIdentifier NS_STRING_ENUM;

static MGRTableViewCellIdentifier const MGRDefaultIdentifier         = @"Default";
static MGRTableViewCellIdentifier const MGRLightIdentifier           = @"Light";
static MGRTableViewCellIdentifier const MGRDarkIdentifier            = @"Dark";
static MGRTableViewCellIdentifier const MGRCustomizedStyleIdentifier = @"CustomizedStyle";

static MGRTableViewCellIdentifier const MGRSizeIdentifier    = @"Size";

static MGRTableViewCellIdentifier const MGRBounceIdentifier  = @"Bounce";

static MGRTableViewCellIdentifier const MGRRippleIdentifier  = @"Ripple";

static MGRTableViewCellIdentifier const MGREnabledIdentifier = @"Enabled";


#endif /* MGRTableViewCellIdentifier_h */
