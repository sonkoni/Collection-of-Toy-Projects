//
//  ViewControllerA.m
//  IosObjcSample
//
//  Created by Kwan Hyun Son on 2023/09/05.
//

#import "ViewControllerA.h"
#import <IosKit/IosKit.h>

@interface ViewControllerA ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) MGUDropdownButton *dropdownButton1;
@property (nonatomic, strong) MGUDropdownButton *dropdownButton2;
@property (nonatomic, strong) MGUDropdownButton *dropdownButton3;
@property (nonatomic, strong) MGUDropdownButton *dropdownButton4;
@property (nonatomic, strong) MGUDropdownButton *dropdownButton5;
@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dropdownButton1 = [MGUDropdownButton new];
    self.dropdownButton1.cellClass = [MGULineWidthDropdownCell class];
    self.dropdownButton1.dropdownData = @[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)];
    self.dropdownButton1.selectedIndex = 0;
    [self.dropdownButton1 addTarget:self action:@selector(dropdownBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.contentView addSubview:self.dropdownButton1];
//    self.dropdownButton1.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.dropdownButton1.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
//    [self.dropdownButton1.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:50.0].active = YES;
//    [self.dropdownButton1.widthAnchor constraintEqualToConstant:78.0].active = YES;
    
    self.dropdownButton1.defaultBackgroundColor = [MGUDropdownButton defaultBackgroundColor];
    
//    self.dropdownButton2 = [MGUDropdownButton new];
//    self.dropdownButton2.cellClass = [MGUTextDropdownCell class];
//    self.dropdownButton2.dropdownData = @[@"전봉색상", @"전값대비", @"보합색"];
//    self.dropdownButton2.dismissOnRotation = NO; // 회전 시 안사라지게 할 수 있다.
//    self.dropdownButton2.selectedIndex = 0;
//    self.dropdownButton2.placeHolderTextAlignment = NSTextAlignmentRight;
//    self.dropdownButton2.textAlignment = NSTextAlignmentLeft;
//    [self.dropdownButton2 addTarget:self action:@selector(dropdownBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.contentView addSubview:self.dropdownButton2];
//    [self.dropdownButton2 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(90.0, 28.0)];
    
//
//    
//    self.dropdownButton3 = [MGUDropdownButton new];
//    self.dropdownButton3.cellClass = [MGULineDashDropdownCell class];
//    self.dropdownButton3.dropdownData = @[@(0), @(1), @(2), @(3), @(4)];
//    self.dropdownButton3.selectedIndex = 0;
//    self.dropdownButton3.dismissOnRotation = NO; // 회전 시 안사라지게 할 수 있다.
//    [self.contentView addSubview:self.dropdownButton3];
//    self.dropdownButton3.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.dropdownButton3.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-50.0].active = YES;
//    [self.dropdownButton3.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:50.0].active = YES;
//    [self.dropdownButton3.widthAnchor constraintEqualToConstant:78.0].active = YES;
//    [self.dropdownButton3 addTarget:self action:@selector(dropdownBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
//        
//    UIImage *image1 = [UIImage imageNamed:@"stockfill.rect.stretch"];
//    UIImage *image2 = [UIImage imageNamed:@"stockfill.oval"];
//    UIImage *image3 = [UIImage imageNamed:@"stockfill.rect"];
//    self.dropdownButton4 = [MGUDropdownButton new];
//    self.dropdownButton4.cellClass = [MGUImageDropdownCell class];
//    self.dropdownButton4.dropdownData = @[image1, image2, image3];
//    self.dropdownButton4.selectedIndex = 0;
//    self.dropdownButton4.dismissOnRotation = NO; // 회전 시 안사라지게 할 수 있다.
//    [self.contentView addSubview:self.dropdownButton4];
//    self.dropdownButton4.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.dropdownButton4.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-50.0].active = YES;
//    [self.dropdownButton4.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:150.0].active = YES;
//    [self.dropdownButton4.widthAnchor constraintEqualToConstant:90.0].active = YES;
//    [self.dropdownButton4 addTarget:self action:@selector(dropdownBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.dropdownButton5 = [MGUDropdownButton new];
    self.dropdownButton5.cellClass = [MGUFillTypeDropdownCell class];
    self.dropdownButton5.dropdownData = @[@"영역 채움", MGUDropdownCellFillTypeHorizontal, MGUDropdownCellFillTypeVerical, MGUDropdownCellFillTypeDiagonalCounterClockwise, MGUDropdownCellFillTypeDiagonalClockwise, MGUDropdownCellFillTypeCross, MGUDropdownCellFillTypeX,  MGUDropdownCellFillTypeEmpty];
    self.dropdownButton5.selectedIndex = 0;
    self.dropdownButton5.dismissOnRotation = NO; // 회전 시 안사라지게 할 수 있다.
    [self.contentView addSubview:self.dropdownButton5];
    self.dropdownButton5.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.dropdownButton5.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-50.0].active = YES;
//    [self.dropdownButton5.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:300.0].active = YES;
    
    [self.dropdownButton5.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [self.dropdownButton5.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:50.0].active = YES;
    
    [self.dropdownButton5.widthAnchor constraintEqualToConstant:90.0].active = YES;
    [self.dropdownButton5 addTarget:self action:@selector(dropdownBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)dropdownBtnValueChanged:(MGUDropdownButton *)sender {
    if (sender == self.dropdownButton1) {
        NSLog(@"dropdownButton1 값 변화 %ld", sender.selectedIndex);
    } else if (sender == self.dropdownButton2) {
        NSLog(@"dropdownButton2 값 변화 %ld", sender.selectedIndex);
    } else if (sender == self.dropdownButton3) {
        NSLog(@"dropdownButton3 값 변화 %ld", sender.selectedIndex);
    } else if (sender == self.dropdownButton4) {
        NSLog(@"dropdownButton4 값 변화 %ld", sender.selectedIndex);
    } else if (sender == self.dropdownButton5) {
        NSLog(@"dropdownButton5 값 변화 %ld", sender.selectedIndex);
    }
}

@end
