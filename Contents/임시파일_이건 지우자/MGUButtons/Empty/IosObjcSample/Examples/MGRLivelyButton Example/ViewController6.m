//
//  TestViewController.m
//  FancyBarButton
//
//  Created by Sebastien Windal on 2/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ViewController6.h"
#import "ModalViewController.h"
@import IosKit;

@interface ViewController6 ()

@property (weak, nonatomic) IBOutlet MGULivelyButton *bigButton;

@property (weak, nonatomic) IBOutlet MGULivelyButton *burgerButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *plustButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *plusCircleButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *closeButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *closeCircleButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *upCaretButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *downCaretButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *leftCaretButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *rightCaretButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *checkMarkButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *rightArrowButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *upArrowButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *downArrowButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *downLoadButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *pauseButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *playButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *stopButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *rewindButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *fastForwardButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *dotButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *horizontalMoreOptionsButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *verticalMoreOptionsButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *horizontalLineButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *verticalLineButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *reloadButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *locationButton;
@property (weak, nonatomic) IBOutlet MGULivelyButton *noneButton;

@property (nonatomic, assign) MGULivelyButtonStyle newStyle;

@end

@implementation ViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGULivelyButton";
    
    self.burgerButton.buttonStyle = MGULivelyButtonStyleHamburger;
    self.plusCircleButton.buttonStyle = MGULivelyButtonStyleCirclePlus;
    self.plustButton.buttonStyle = MGULivelyButtonStylePlus;
    self.closeButton.buttonStyle = MGULivelyButtonStyleClose;
    self.closeCircleButton.buttonStyle = MGULivelyButtonStyleCircleClose;
    self.upCaretButton.buttonStyle = MGULivelyButtonStyleCaretUp;
    self.downCaretButton.buttonStyle = MGULivelyButtonStyleCaretDown;
    self.leftCaretButton.buttonStyle = MGULivelyButtonStyleCaretLeft;
    self.rightCaretButton.buttonStyle = MGULivelyButtonStyleCaretRight;
    self.checkMarkButton.buttonStyle = MGULivelyButtonStyleCheckMark;
    self.leftArrowButton.buttonStyle = MGULivelyButtonStyleArrowLeft;
    self.rightArrowButton.buttonStyle = MGULivelyButtonStyleArrowRight;
    self.upArrowButton.buttonStyle = MGULivelyButtonStyleArrowUp;
    self.downArrowButton.buttonStyle = MGULivelyButtonStyleArrowDown;
    self.downLoadButton.buttonStyle = MGULivelyButtonStyleDownLoad;
    self.pauseButton.buttonStyle = MGULivelyButtonStylePause;
    self.playButton.buttonStyle = MGULivelyButtonStylePlay;
    self.stopButton.buttonStyle = MGULivelyButtonStyleStop;
    self.rewindButton.buttonStyle = MGULivelyButtonStyleRewind;
    self.fastForwardButton.buttonStyle = MGULivelyButtonStyleFastForward;
    self.dotButton.buttonStyle = MGULivelyButtonStyleDot;
    self.horizontalMoreOptionsButton.buttonStyle = MGULivelyButtonStyleHorizontalMoreOptions;
    self.verticalMoreOptionsButton.buttonStyle = MGULivelyButtonStyleVerticalMoreOptions;
    self.horizontalLineButton.buttonStyle = MGULivelyButtonStyleHorizontalLine;
    self.verticalLineButton.buttonStyle = MGULivelyButtonStyleVerticalLine;
    self.reloadButton.buttonStyle = MGULivelyButtonStyleReload;
    self.locationButton.buttonStyle = MGULivelyButtonStyleLocation;
    self.noneButton.buttonStyle = MGULivelyButtonStyleNone;

    self.bigButton.buttonStyle = MGULivelyButtonStyleClose;
    self.bigButton.config = [MGULivelyButtonConfiguration black_4_15_D_Config];
    [self.bigButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    
    MGULivelyButton *button = [[MGULivelyButton alloc] initWithFrame:CGRectMake(0,0,36,28)
                                                               style:MGULivelyButtonStyleHamburger
                                                       configuration:[MGULivelyButtonConfiguration blue_2_D_D_Config]];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    _newStyle = MGULivelyButtonStyleHamburger;
}

- (IBAction)changeButtonStyleAction:(MGULivelyButton *)sender {
    [self.bigButton setStyle:sender.buttonStyle animated:YES];
}

- (void)buttonAction:(MGULivelyButton *)sender {
    self.newStyle = (self.newStyle + 1) % 28;
    [sender setStyle:self.newStyle animated:YES];
}

- (void)push:(MGULivelyButton *)sender {
    ModalViewController *modalTestViewController = [ModalViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:modalTestViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
