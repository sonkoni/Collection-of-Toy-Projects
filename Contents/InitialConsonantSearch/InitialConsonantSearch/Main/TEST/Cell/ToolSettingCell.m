//
//  TableViewCell.m
//  ChartTypeTest
//
//  Created by Kwan Hyun Son on 2023/08/31.
//

#import "ToolSettingCell.h"

@interface ToolSettingCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;
@end

@implementation ToolSettingCell

#pragma mark - Override

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.userInteractionEnabled = NO;
    self.showsReorderControl = YES;
    self.backgroundColor = [UIColor whiteColor]; // 드래그 시 그림자를 나오게 해야한다
}

#pragma mark - 세터 & 게터

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setTitle:title forState:UIControlStateNormal];
}

@end
