//
//  ViewController5.m
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 27/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "ViewController5.h"
@import IosKit;

@interface ViewController5 ()
@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch;
@property (nonatomic, strong) id <NSObject>sevenSwitchObserver;
@end

@implementation ViewController5

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:_sevenSwitchObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGUSevenSwitch를 만들었다.";
    
    //! FIXME: offTintActiveColor를 onTintColor 보다 먼저 때려야 작동하는 오류가 존재한다.
//    self.sevenSwitch1.offTintActiveColor =  UIColor.redColor;
//    self.sevenSwitch1.offTintColor = UIColor.yellowColor;
//    self.sevenSwitch1.onTintColor = [UIColor colorWithRed:0.20 green:0.42 blue:0.86 alpha:1.0];
//    self.sevenSwitch1.on = YES;

    
    CGPoint center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
    
    _sevenSwitch = [[MGUSevenSwitch alloc] initWithCenter:center
                                                 switchOn:YES
                                            configuration:[MGUSevenSwitchConfiguration defaultConfiguration]];
    [self.sevenSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sevenSwitch];
    [self.sevenSwitch mgrPinCenterToSuperviewCenterWithFixSize:self.sevenSwitch.frame.size];
    
    __weak __typeof(self) weakSelf = self;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    _sevenSwitchObserver = [nc addObserverForName:MGUSevenSwitchStateChangedNotification
                                           object:self.sevenSwitch // poster
                                            queue:[NSOperationQueue mainQueue]
                                       usingBlock:^(NSNotification *note) {
        // NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSLog(@"바뀌었냐?? %d", weakSelf.sevenSwitch.switchOn);
    }];
}

- (IBAction)sevenSwitch1ValueChanged:(MGUSevenSwitch *)sender {
    if (sender.switchOn == YES) {
        NSLog(@"밸류가 바뀌었네. ON");
    } else {
        NSLog(@"밸류가 바뀌었네. OFF");
    }
}

- (void)switchChanged:(MGUSevenSwitch *)sender {
    if (sender.switchOn == YES) {
        NSLog(@"밸류가 바뀌었네. ON");
    } else {
        NSLog(@"밸류가 바뀌었네. OFF");
    }
}


#pragma mark - 버튼 액션 메서드

- (IBAction)onWithAnimated:(id)sender {
    [self.sevenSwitch setSwitchOn:YES withAnimated:YES];
}
- (IBAction)offWithAnimated:(id)sender{
    [self.sevenSwitch setSwitchOn:NO withAnimated:YES];
}
- (IBAction)onWithNoAnimated:(id)sender{
    [self.sevenSwitch setSwitchOn:YES withAnimated:NO];
}
- (IBAction)offWithNoAnimated:(id)sender{
    [self.sevenSwitch setSwitchOn:NO withAnimated:NO];
}

@end
