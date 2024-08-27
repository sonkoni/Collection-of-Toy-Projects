//
//  ViewControllerX.h
//  IosObjcFinancialKeyboard
//
//  Created by Kwan Hyun Son on 1/10/24.
//

#import <IosKit/IosKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic) IBOutlet NSLayoutConstraint *seperatorConstraint;
@end

@interface TableViewCell : UITableViewCell
@property (nonatomic) IBOutlet NSLayoutConstraint *seperatorConstraint;
@property (weak, nonatomic) IBOutlet UIButton *minCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *tickCheckBtn;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UIButton *tickModifyBtn;


@property (weak, nonatomic) IBOutlet MGUFinancialTextField *minField;
@end

@interface DTOMinTick : NSObject
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign) NSInteger cycle;
+ (instancetype)dtoWithCyle:(NSInteger)cycle selected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
