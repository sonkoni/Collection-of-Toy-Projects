//
//  ChartSettingViewController.h
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/09/01.
//

#import <UIKit/UIKit.h>
@class LineSettingViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface LineSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LineSettingViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
