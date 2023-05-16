//
//  ViewController6.m
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 29/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "ViewController6.h"
@import BaseKit;
@import GraphicsKit;
@import IosKit;

@interface ViewController6 ()
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak) IBOutlet UIView *containerView1;
@property (weak) IBOutlet UIView *containerView2;
@property (weak) IBOutlet UIView *containerView3;
@property (weak) IBOutlet UIView *containerView4;
@property (weak) IBOutlet UIView *containerView5;
@property (weak) IBOutlet UIView *containerView6;
@property (weak) IBOutlet UIView *containerView7;
@property (weak) IBOutlet UIView *containerView8;
@property (weak) IBOutlet UIView *containerView9;
@property (weak) IBOutlet UIView *containerView10;

@property (weak) IBOutlet UISwitch *appleSwitch;

@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch1;
@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch2;
@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch3;
@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch4;
@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch5;
@property (nonatomic, strong) MGUSevenSwitch *sevenSwitch6;
@end

@implementation ViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIView *containerView in self.containerViews) {
        containerView.backgroundColor = UIColor.whiteColor;
        containerView.layer.borderColor = UIColor.redColor.CGColor;
        containerView.layer.borderWidth = 1.0 / UIScreen.mainScreen.scale;
    }
    

    MGUSevenSwitchConfiguration *configuration = [MGUSevenSwitchConfiguration defaultConfiguration];
    configuration.onTintColor = [UIColor colorWithRed:0.20 green:0.42 blue:0.86 alpha:1.0];
    configuration.onBorderColor = configuration.onTintColor;
    _sevenSwitch1 =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                                 switchOn:YES
                                            configuration:configuration];
    
    [self.sevenSwitch1 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView1 addSubview:self.sevenSwitch1];
    [self.sevenSwitch1 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(85.0, 46.0)];
    
    configuration = [MGUSevenSwitchConfiguration defaultConfiguration];
    NSBundle *bundle = [NSBundle mgrIosRes];
    configuration.offImage = [UIImage imageNamed:@"cross.png" inBundle:bundle withConfiguration:nil];
    configuration.onImage  = [UIImage imageNamed:@"check.png" inBundle:bundle withConfiguration:nil];
    configuration.onTintColor = [UIColor colorWithHue:0.08 saturation:0.74 brightness:1.00 alpha:1.00];
    configuration.onBorderColor = configuration.onTintColor;
    configuration.cornerRadius = 4.0;
    
    _sevenSwitch2 =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                                 switchOn:YES
                                            configuration:configuration];
    
    [self.sevenSwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView2 addSubview:self.sevenSwitch2];
    [self.sevenSwitch2 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(100.0, 50.0)];
    
    configuration = [MGUSevenSwitchConfiguration defaultConfiguration];
    
    configuration.onTintColor = [UIColor colorWithRed:0.45 green:0.58 blue:0.67 alpha:1.0];
    configuration.decoViewColor = [UIColor colorWithRed:0.07 green:0.09 blue:0.11 alpha:1.0];
    configuration.offThumbTintColor = [UIColor colorWithRed:0.19 green:0.23 blue:0.33 alpha:1.0];
    configuration.onThumbTintColor = configuration.offThumbTintColor;
    configuration.offTintColor =  [UIColor colorWithRed:0.07 green:0.09 blue:0.11 alpha:1.0];
    configuration.offBorderColor = UIColor.clearColor;
    configuration.onBorderColor = UIColor.clearColor;
    configuration.shadowColor = UIColor.blackColor;
        
    _sevenSwitch3 =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                                 switchOn:YES
                                            configuration:configuration];
    
    [self.sevenSwitch3 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView3 addSubview:self.sevenSwitch3];

    [self.sevenSwitch3 mgrPinCenterToSuperviewCenterWithFixSize:self.sevenSwitch3.frame.size];
    
    _sevenSwitch4 =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                                 switchOn:YES
                                            configuration:[MGUSevenSwitchConfiguration yellowConfiguration]];
    
    [self.sevenSwitch4 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView4 addSubview:self.sevenSwitch4];
    [self.sevenSwitch4 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(66.0, 31.0)];
    
    _sevenSwitch5 =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                                 switchOn:YES
                                            configuration:[MGUSevenSwitchConfiguration defaultConfiguration2]];
    
    [self.sevenSwitch5 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView5 addSubview:self.sevenSwitch5];
    [self.sevenSwitch5 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(66.0, 31.0)];
    
    
    configuration = [MGUSevenSwitchConfiguration defaultConfiguration];
    UIView *knobAccessoryView = [UIView new];
    knobAccessoryView.backgroundColor = [UIColor clearColor];
    knobAccessoryView.userInteractionEnabled = NO;
    UIView *knobAccessoryBorderView = [UIView new];
    knobAccessoryBorderView.backgroundColor = [UIColor clearColor];
    knobAccessoryBorderView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.04].CGColor;
    knobAccessoryBorderView.layer.borderWidth = 0.5;
    knobAccessoryBorderView.layer.cornerRadius = 6.0;
    [knobAccessoryView addSubview:knobAccessoryBorderView];
    knobAccessoryBorderView.translatesAutoresizingMaskIntoConstraints = NO;
    [knobAccessoryBorderView mgrPinCenterToSuperviewCenter];
    [knobAccessoryBorderView.widthAnchor constraintEqualToAnchor:knobAccessoryView.widthAnchor constant:1.0].active = YES;
    [knobAccessoryBorderView.heightAnchor constraintEqualToAnchor:knobAccessoryView.heightAnchor constant:1.0].active = YES;
    configuration.knobAccessoryView = knobAccessoryView;
    
    MGEInnerShadowLayer *innerShadowLayer =
    [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5].CGColor
                                        innerShadowOffset:CGSizeMake(-1.0, 1.0)
                                    innerShadowBlurRadius:3.0];
    innerShadowLayer.frame = CGRectMake(0.0, 0.0, 51.0, 31.0);
    innerShadowLayer.cornerRadius = 6.0;
    innerShadowLayer.contentsScale = [UIScreen mainScreen].scale;
    configuration.backAccessoryView = [UIView new];
    [configuration.backAccessoryView.layer addSublayer:innerShadowLayer];
        
    UIColor *color = [[UIColor whiteColor] mgrColorWithNoiseWithOpacity:0.05 andBlendMode:kCGBlendModeNormal];
    configuration.onThumbTintColor = color;
    configuration.offThumbTintColor = color;
    configuration.onTintColor = [UIColor systemYellowColor];
    configuration.offTintColor = [UIColor mgrColorFromHexString:@"434343"];
    configuration.onBorderColor = [UIColor clearColor];
    configuration.offBorderColor = [UIColor clearColor];
    configuration.decoViewColor = [UIColor clearColor];
    configuration.cornerRadius = 6.0;
    configuration.knobRatio = 12.0 / 27.0;
    _sevenSwitch6 =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                                 switchOn:YES
                                            configuration:configuration];
    [self.sevenSwitch6 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView6 addSubview:self.sevenSwitch6];
    [self.sevenSwitch6 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(51.0, 31.0)];
}


- (void)switchChanged:(MGUSevenSwitch *)sender {
    if (sender.switchOn == YES) {
        NSLog(@"밸류가 바뀌었네. ON ");
    } else {
        NSLog(@"밸류가 바뀌었네. OFF ");
    }
}
@end
