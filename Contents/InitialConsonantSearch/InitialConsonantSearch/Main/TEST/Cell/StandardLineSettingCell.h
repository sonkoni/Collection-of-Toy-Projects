//
//  StandardLineSettingCell.h
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/18.
//

#import "StandardLineSettingViewModel.h"
@class DTOStandardLineSetting;

NS_ASSUME_NONNULL_BEGIN

@interface StandardLineSettingCell : UITableViewCell
@property (weak, nonatomic) DTOStandardLineSetting *data;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

NS_ASSUME_NONNULL_END
