//
//  ChartSettingCell.h
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/09/01.
//

#import <UIKit/UIKit.h>
#import "ToolSettingViewModel.h"
#import "LineSettingViewModel.h"
#import <IosKit/IosKit.h>
@class DTOLineSetting;

NS_ASSUME_NONNULL_BEGIN

@interface LineSettingCell : UITableViewCell
@property (weak, nonatomic) DTOLineSetting *data;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropButtonWidthConstraint; // 디폴트 90.0 // 세부항목에서만 사용됨
@end

NS_ASSUME_NONNULL_END


