//
//  IndicatorSettingCell.h
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/10/23.
//

#import <UIKit/UIKit.h>
#import "IndicatorSettingViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndicatorSettingCell : UITableViewCell
@property (weak, nonatomic) DTOIndicatorSetting *data;
@property (nonatomic, getter=isExpanded) BOOL expanded;
@end

NS_ASSUME_NONNULL_END
