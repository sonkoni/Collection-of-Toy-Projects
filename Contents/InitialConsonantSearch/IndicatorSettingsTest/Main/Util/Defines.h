//
//  Defines.h
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *DefinesImageName NS_TYPED_EXTENSIBLE_ENUM;
static DefinesImageName const DefinesImageNameCheckmarkCircleFill = @"checkmark.circle.fill";
static DefinesImageName const DefinesImageNameCheckmarkCircle = @"checkmark.circle";
static DefinesImageName const DefinesImageNameChevronForward = @"chevron.forward";
static DefinesImageName const DefinesImageNameGearshape = @"gearshape";
static DefinesImageName const DefinesImageNameIndent = @"indent";
static DefinesImageName const DefinesImageNameMinus = @"minus";
static DefinesImageName const DefinesImageNamePlus = @"plus";
static DefinesImageName const DefinesImageNameRadioFill = @"radio.fill";
static DefinesImageName const DefinesImageNameRadio = @"radio";
static DefinesImageName const DefinesImageNameSettingGo = @"settingGo";
static DefinesImageName const DefinesImageNameStarFill = @"star.fill";
static DefinesImageName const DefinesImageNameStar = @"star";
static DefinesImageName const DefinesImageNameUncheckmarkCircle = @"uncheckmark.circle";
static DefinesImageName const DefinesImageNameUncheckmarkCircleOpaque = @"uncheckmark.circle.opaque";
static DefinesImageName const DefinesImageNameXmark = @"xmark";

@interface Defines : NSObject

+ (UIImage * _Nullable)imageNamed:(DefinesImageName)imageName
           imageWithRenderingMode:(UIImageRenderingMode)renderingMode;

@end

NS_ASSUME_NONNULL_END
