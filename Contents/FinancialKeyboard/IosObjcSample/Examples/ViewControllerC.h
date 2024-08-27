//
//  ViewController.h
//  IosObjcFinancialKeyboard
//
//  Created by Kwan Hyun Son on 1/10/24.
//

#import <UIKit/UIKit.h>
#import "ModelCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet TableViewHeaderFooterView *testView;

@end


NS_ASSUME_NONNULL_END
