//
//  ViewController1.m
//
//  Created by Kwan Hyun Son on 15/05/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewController1.h"
@import IosKit;

@interface ViewController1 () <MGUSegmentedControlDataSource>

@property (nonatomic, strong) UIStackView         *stackView;
@property (nonatomic, strong) MGUSegmentedControl *graySegmentedControl;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGUSegmentedControl 기본";
    
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    [self.view addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    
    [self addSegmentedControlExample:[self graySegmentedControl] withBackgroundColor:[UIColor colorWithWhite:0.96f alpha:1.0f]];
    [self addSegmentedControlExample:[self blueSegmentedControl] withBackgroundColor:[UIColor colorWithRed:0.36f green:0.64f blue:0.88f alpha:1.0f]];
    [self addSegmentedControlExample:[self flatGraySegmentedControl] withBackgroundColor:[UIColor colorWithRed:0.12f green:0.12f blue:0.15f alpha:1.0f]];
    [self addSegmentedControlExample:[self purpleSegmentedControl] withBackgroundColor:[UIColor colorWithWhite:0.24f alpha:1.0f]];
    [self addSegmentedControlExample:[self switchSegmentedControl] withBackgroundColor:[UIColor colorWithWhite:0.18f alpha:1.0f]];
    
}

- (void)addSegmentedControlExample:(MGUSegmentedControl *)segmentedControl withBackgroundColor:(UIColor *)backgroundColor {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f)];
    backgroundView.backgroundColor = backgroundColor;
    [self.stackView addArrangedSubview:backgroundView];
    segmentedControl.dataSource = self;
    [backgroundView addSubview:segmentedControl];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentedControl.centerXAnchor constraintEqualToAnchor:backgroundView.centerXAnchor].active = YES;
    [segmentedControl.centerYAnchor constraintEqualToAnchor:backgroundView.centerYAnchor].active = YES;
}

- (MGUSegmentedControl *)graySegmentedControl {
    _graySegmentedControl = [[MGUSegmentedControl alloc] initWithTitles:@[@"kg", @"mg"]];
    [_graySegmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _graySegmentedControl;
    //
    // 바뀔 수 있는지(늘어나고 줄어들고) 여부를 나타낸다. 디폴트는 NO이다.
    // 값이 바뀔때. 알림이 온다.
}

- (MGUSegmentedControl *)blueSegmentedControl {
    MGUSegmentedControl *blueSegmentedControl = [[MGUSegmentedControl alloc] initWithTitles:@[@"Nearby", @"Worldwide"]
                                                                              configuration:[MGUSegmentConfiguration blueConfiguration]];
    [blueSegmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    return blueSegmentedControl;
}

- (MGUSegmentedControl *)flatGraySegmentedControl {
    MGUSegmentedControl *flatGraySegmentedControl = [[MGUSegmentedControl alloc] initWithTitles:@[@"ENGLISH", @"한국어"]
                                                                                  configuration:[MGUSegmentConfiguration flatGrayConfiguration]];
    
    //! 사이즈도 변경가능하다. translatesAutoresizingMaskIntoConstraints = NO를 때려줘야한다.
    flatGraySegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [flatGraySegmentedControl.widthAnchor constraintEqualToConstant:240.0f].active = YES;
    [flatGraySegmentedControl.heightAnchor constraintEqualToConstant:44.0f].active = YES;
    
    [flatGraySegmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    return flatGraySegmentedControl;
}

- (MGUSegmentedControl *)purpleSegmentedControl {
    MGUSegmentedControl *purpleSegmentedControl = [[MGUSegmentedControl alloc] initWithTitles:@[@"Lists", @"Followers"]
                                                                                configuration:[MGUSegmentConfiguration purpleConfiguration]];
    purpleSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [purpleSegmentedControl.widthAnchor constraintEqualToConstant:200.0f].active = YES;
    [purpleSegmentedControl.heightAnchor constraintEqualToConstant:40.0f].active = YES;
    
    [purpleSegmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    return purpleSegmentedControl;
}

- (MGUSegmentedControl *)switchSegmentedControl {
    MGUSegmentedControl *switchSegmentedControl = [[MGUSegmentedControl alloc] initWithTitles:@[@"On", @"Off"]
                                                                                 selecedtitle:@"Off"
                                                                                configuration:[MGUSegmentConfiguration switchConfiguration]];
    switchSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [switchSegmentedControl.widthAnchor constraintEqualToConstant:140.0f].active = YES;
    [switchSegmentedControl.heightAnchor constraintEqualToConstant:70.0f].active = YES;
  
    [switchSegmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    return switchSegmentedControl;
}

- (void)segmentValueChanged:(MGUSegmentedControl *)sender {
    NSLog(@"밸류가 바뀌었네.");
}

//! FIXME: iOS 13에서 버그가 발생하여 우선 주석처리한다.
/*
- (BOOL)prefersStatusBarHidden {
    return YES;
}
 */
@end

