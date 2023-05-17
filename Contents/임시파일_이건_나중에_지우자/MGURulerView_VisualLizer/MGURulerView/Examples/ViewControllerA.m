//
//  MGRViewController.m
//  MGURulerView
//
//  Created by Kwan Hyun Son on 16/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "ViewControllerA.h"
@import IosKit;
@import AudioKit;

@interface ViewControllerA () <MGURulerViewDelegate, UITextFieldDelegate>
@property (weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) MGURulerView *rulerView;
@property (nonatomic, strong) MGOSoundRuler *sound;
@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)commonInit {
    _sound = [MGOSoundRuler rulerSound];    
    self.containerView.backgroundColor = UIColor.clearColor;
    self.containerView.layer.borderWidth = 0.5f;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.view.backgroundColor = self.backgroundColor;
    self.gotoTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.gotoTextField.keyboardAppearance  = UIKeyboardAppearanceDark;
    
    NSArray <NSString *>*values = @[@"0.0", @"34.1", @"58.8"];
    NSString *randomValue = values[arc4random_uniform(3)];
    CGFloat randomDoubleValue = [randomValue doubleValue];
    
    self.rulerView = [[MGURulerView alloc] initWithFrame:CGRectZero
                                            initialValue:randomDoubleValue
                                           indicatorType:self.indicatorType
                                                  config:self.rulerViewConfig];
    self.rulerView.delegate = self;
    self.rulerView.soundOn = YES;
    self.rulerView.normalSoundPlayBlock = [self.sound playSoundTickHaptic];
    self.rulerView.skipSoundPlayBlock = [self.sound playSoundRolling];
    
    [self.containerView addSubview:self.rulerView];
    [self.rulerView mgrPinEdgesToSuperviewEdges];
    
    [self rulerViewDidScroll:self.rulerView currentDisplayValue:randomDoubleValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [obj resignFirstResponder];
        }
    }];
}

- (IBAction)gotoClick:(UIButton *)sender {
    [self.rulerView goToValue:[self.gotoTextField.text doubleValue] animated:YES notify:YES];
}

- (IBAction)leftClick:(UIButton *)sender {
    [self.rulerView moveToLeft];
}

- (IBAction)rightClick:(UIButton *)sender {
    [self.rulerView moveToRight];
}

- (IBAction)longLeftClick:(UIButton *)sender {
    [self.rulerView moveFarToLeft];
}

- (IBAction)longRightClick:(UIButton *)sender {
    [self.rulerView moveFarToRight];
}


#pragma mark - <MGURulerViewDelegate>
- (void)rulerViewDidScroll:(MGURulerView *)rulerView currentDisplayValue:(CGFloat)currentDisplayValue {
    self.label.attributedText = MGURulerViewMainLabelAttrStr(currentDisplayValue,
                                                             [UIFont fontWithName:@"Menlo-Bold" size:34.0],
                                                             [UIColor whiteColor]);
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
