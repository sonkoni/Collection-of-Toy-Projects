//
//  IndicatorSettingSearchController.h
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/18/23.
//

#import <UIKit/UIKit.h>
#import <IosKit/IosKit.h>
#import "IndicatorSettingViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndicatorSettingSearchController : UIViewController<UISearchBarDelegate>
@property (nonatomic, strong) IndicatorSettingViewModel *viewModel;
@property (nonatomic, assign) BOOL emptyStringMode; // 디폹트 YES
@property (nonatomic, assign) BOOL debounceEnabled; // 디폹트 YES
@property (nonatomic, copy, nullable) void (^selectItemCompletion)(MGROutlineItem <DTOIndicatorSetting *>*);
@end

NS_ASSUME_NONNULL_END
