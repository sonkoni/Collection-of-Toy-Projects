//
//  ViewControllerB.m
//  IosObjcSample
//
//  Created by Kwan Hyun Son on 11/16/23.
//

#import "ViewControllerB.h"
#import <IosKit/IosKit.h>

@interface ViewControllerB ()
@property (nonatomic, strong) MGUDropSegControl *dropSegControl1;
@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    DTODropSeg *seg0 = [[DTODropSeg alloc] initWithTitle:@"일" extendedTitle:@"일"];
    DTODropSeg *seg1 = [[DTODropSeg alloc] initWithTitle:@"주" extendedTitle:@"주"];
    DTODropSeg *seg2 = [[DTODropSeg alloc] initWithTitle:@"월" extendedTitle:@"월"];
    DTODropSeg *seg3 = [[DTODropSeg alloc] initWithTitle:@"년" extendedTitle:@"년"];
    MGUDropSegManager *manager0 = [[MGUDropSegManager alloc] initWithDropSegs:@[seg0, seg1, seg2, seg3]
                                                                selectedIndex:0];

    seg0 = [[DTODropSeg alloc] initWithTitle:@"1" extendedTitle:@"1분"];
    seg1 = [[DTODropSeg alloc] initWithTitle:@"3" extendedTitle:@"3분"];
    seg2 = [[DTODropSeg alloc] initWithTitle:@"5" extendedTitle:@"5분"];
    seg3 = [[DTODropSeg alloc] initWithTitle:@"10" extendedTitle:@"10분"];
    DTODropSeg *seg4 = [[DTODropSeg alloc] initWithTitle:@"15" extendedTitle:@"15분"];
    DTODropSeg *seg5 = [[DTODropSeg alloc] initWithTitle:@"30" extendedTitle:@"30분"];
    DTODropSeg *seg6 = [[DTODropSeg alloc] initWithTitle:@"45" extendedTitle:@"45분"];
    DTODropSeg *seg7 = [[DTODropSeg alloc] initWithTitle:@"60" extendedTitle:@"60분"];
    DTODropSeg *seg8 = [[DTODropSeg alloc] initWithTitle:@"90" extendedTitle:@"90분"];
    DTODropSeg *seg9 = [[DTODropSeg alloc] initWithTitle:@"120" extendedTitle:@"120분"];
    MGUDropSegManager *manager1 = [[MGUDropSegManager alloc] initWithDropSegs:@[seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, seg9]
                                                                selectedIndex:9];

    seg0 = [[DTODropSeg alloc] initWithTitle:@"1" extendedTitle:@"1틱"];
    seg1 = [[DTODropSeg alloc] initWithTitle:@"3" extendedTitle:@"3틱"];
    seg2 = [[DTODropSeg alloc] initWithTitle:@"5" extendedTitle:@"5틱"];
    seg3 = [[DTODropSeg alloc] initWithTitle:@"10" extendedTitle:@"10틱"];
    seg4 = [[DTODropSeg alloc] initWithTitle:@"15" extendedTitle:@"15틱"];
    seg5 = [[DTODropSeg alloc] initWithTitle:@"20" extendedTitle:@"20틱"];
    seg6 = [[DTODropSeg alloc] initWithTitle:@"30" extendedTitle:@"30틱"];
    seg7 = [[DTODropSeg alloc] initWithTitle:@"45" extendedTitle:@"45틱"];
    seg8 = [[DTODropSeg alloc] initWithTitle:@"60" extendedTitle:@"60틱"];
    seg9 = [[DTODropSeg alloc] initWithTitle:@"80" extendedTitle:@"80틱"];
    MGUDropSegManager *manager2 = [[MGUDropSegManager alloc] initWithDropSegs:@[seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, seg9]
                                                                selectedIndex:9];

    _dropSegControl1 = [MGUDropSegControl new];
    self.dropSegControl1.itemHeight = 30.0;
    self.dropSegControl1.cellClass = [MGUDropSegTextCell class];
    self.dropSegControl1.subitemImage = [[UIImage imageNamed:@"more.item"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.dropSegControl1.data = @[manager0, manager1, manager2];
    self.dropSegControl1.selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    [self.dropSegControl1 addTarget:self 
                             action:@selector(dropSegControlValueChanged:)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.dropSegControl1];
    self.dropSegControl1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dropSegControl1.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.dropSegControl1.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-100.0].active = YES;
    [self.dropSegControl1.widthAnchor constraintEqualToConstant:150.0].active = YES;
    [self.dropSegControl1.heightAnchor constraintEqualToConstant:30.0].active = YES;
    
    MGUDropSegManager *manager = self.dropSegControl1.data[1];
    DTODropSeg *dtoDropSeg = manager.dtoDropSegs[7];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"안녕!!!");
        self.dropSegControl1.selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    });
}

- (void)dropSegControlValueChanged:(MGUDropSegControl *)sender {
    NSLog(@"좆도 마키.... %ld - %ld", sender.selectedIndexPath.section, sender.selectedIndexPath.row);
}

@end
