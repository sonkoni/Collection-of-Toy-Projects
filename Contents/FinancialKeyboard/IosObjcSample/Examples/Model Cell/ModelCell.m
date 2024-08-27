//
//  ViewControllerX.m
//  IosObjcFinancialKeyboard
//
//  Created by Kwan Hyun Son on 1/10/24.
//

#import "ModelCell.h"

@implementation TableViewHeaderFooterView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.seperatorConstraint.constant = 1.0 / [UIScreen mainScreen].scale;
}
@end

@implementation TableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.seperatorConstraint.constant = 1.0 / [UIScreen mainScreen].scale;
    for (UIButton *button in @[self.tickModifyBtn]) {
        button.layer.cornerRadius = 4.0;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.backgroundColor = [UIColor whiteColor];
    }
    for (UIButton *button in @[self.minCheckBtn, self.tickCheckBtn]) {
        if (@available(iOS 13, *)) {
            [button setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
            [button setImage:[UIImage systemImageNamed:@"checkmark.circle"] forState:UIControlStateNormal];
        } else {
            UIImage *selectedImage = [UIImage imageNamed:@"checkmark.circle.fill"];
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImage *normalImage = [UIImage imageNamed:@"checkmark.circle"];
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            button.imageView.contentMode = UIViewContentModeCenter;
            button.tintColor = [UIColor systemRedColor];
        }
    }
}
@end

@implementation DTOMinTick
+ (instancetype)dtoWithCyle:(NSInteger)cycle selected:(BOOL)selected {
    DTOMinTick *result = [DTOMinTick new];
    result.cycle = cycle;
    result.selected = selected;
    return result;
}
@end
