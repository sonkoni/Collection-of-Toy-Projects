//
//  IndicatorSettingContentController.h
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/10/23.
//

#import <UIKit/UIKit.h>
#import <IosKit/IosKit.h>
#import "IndicatorSettingViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndicatorSettingContentController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IndicatorSettingViewModel *viewModel;
- (void)reloadData:(void(^)(void))completion;

- (void)scrollToRowAtItem:(MGROutlineItem <DTOIndicatorSetting *>*)item
         atScrollPosition:(UITableViewScrollPosition)scrollPosition
                 animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
