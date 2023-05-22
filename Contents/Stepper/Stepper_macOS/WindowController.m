//
//  WindowController.m
//  SevenSwitch_macOS
//
//  Created by Kwan Hyun Son on 2022/03/08.
//

@import MacKit;
#import "WindowController.h"

@interface WindowController ()
@property (weak, nonatomic) IBOutlet NSView *leftContainer;
@property (weak, nonatomic) IBOutlet NSView *rightContainer1;
@property (weak, nonatomic) IBOutlet NSView *rightContainer2;
@property (weak, nonatomic) IBOutlet NSView *rightContainer3;
@property (weak, nonatomic) IBOutlet NSView *rightContainer4;
@property (weak, nonatomic) IBOutlet NSView *rightContainer5;
@end

@implementation WindowController

- (NSNibName)windowNibName {
    return NSStringFromClass([WindowController class]);
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.backgroundColor = [NSColor whiteColor];
    
    self.leftContainer.wantsLayer = YES;
    self.leftContainer.layer.contents = [NSImage imageNamed:@"smoothie-berry"];
    self.leftContainer.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    
    MGAStepper *stepper1 = [[MGAStepper alloc] initWithConfiguration:[self testConfiguration]];
    [self.leftContainer addSubview:stepper1];
    stepper1.target = self;
    stepper1.action = @selector(valueChanged:);
    [stepper1 mgrPinCenterToSuperviewCenter];
    NSVisualEffectView *visualEffectView = [NSVisualEffectView new];
    visualEffectView.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    visualEffectView.material = NSVisualEffectMaterialPopover;
    [stepper1 mgrInsertSubview:visualEffectView atIndex:0];
    [visualEffectView mgrPinEdgesToSuperviewEdges];
    
    MGAStepper *stepper2 = [[MGAStepper alloc] initWithConfiguration:[MGAStepperConfiguration iOS13Configuration]];
    [self.rightContainer1 addSubview:stepper2];
    stepper2.target = self;
    stepper2.action = @selector(valueChanged:);
    [stepper2 mgrPinCenterToSuperviewCenter];
    
    MGAStepper *stepper3 = [[MGAStepper alloc] initWithConfiguration:[MGAStepperConfiguration iOS7Configuration]];
    [self.rightContainer2 addSubview:stepper3];
    stepper3.target = self;
    stepper3.action = @selector(valueChanged:);
    [stepper3 mgrPinCenterToSuperviewCenter];
    
    
    MGAStepper *stepper4 = [[MGAStepper alloc] initWithConfiguration:[MGAStepperConfiguration forgeDropConfiguration]];
    [self.rightContainer3 addSubview:stepper4];
    stepper4.target = self;
    stepper4.action = @selector(valueChanged:);
    [stepper4 mgrPinCenterToSuperviewCenter];
    
    
    MGAStepperConfiguration *configuration = [MGAStepperConfiguration defaultConfiguration];
    configuration.cornerRadius = 2.0;
    MGAStepper *stepper5 = [[MGAStepper alloc] initWithConfiguration:configuration];
    [self.rightContainer4 addSubview:stepper5];
    stepper5.target = self;
    stepper5.action = @selector(valueChanged:);
    [stepper5 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(120.0, 30.0)];
    
    
    MGAStepperConfiguration *config = [MGAStepperConfiguration forgeDropConfiguration2];
    config.cornerRadius = 4.0;
    config.items = @[@"H"].mutableCopy;
    MGAStepper *stepper6 = [[MGAStepper alloc] initWithConfiguration:config];
    [self.rightContainer5 addSubview:stepper6];
    stepper6.target = self;
    stepper6.action = @selector(valueChanged:);
    [stepper6 mgrPinCenterToSuperviewCenter];
}


#pragma mark - Actions
- (void)valueChanged:(MGAStepper *)sender {
    NSLog(@"valueChanged!! %f", sender.value);
}

- (MGAStepperConfiguration *)testConfiguration {
    MGAStepperConfiguration *result = [MGAStepperConfiguration defaultConfiguration];
    CGSize size = CGSizeMake(300.0, 67.0);
    CGFloat labelWidthRatio = (size.width - (2.0 * size.height)) / size.width;
    result.stepperLabelType = MGAStepperLabelTypeShowDraggable;
    result.intrinsicContentSize = size;
    result.cornerRadius = (size.height/2.0);
    
    NSImageSymbolConfiguration *symbolConfiguration =
    [NSImageSymbolConfiguration configurationWithPointSize:22.0
                                                    weight:NSFontWeightBold
                                                     scale:NSImageSymbolScaleLarge];
    
    //! iOS와 적용되는 메커니즘이 완전히 다르다. 예를 들어 "minus.circle.fill"에서
    //! 색을 하나만 설정했을 때, iOS는 mask로 찍어서 하나의 색을 먹이지만(꽉 채워진 원에 십자가로 구멍이 뚫림), macOS는 십자가와 원을 각각 먹여버린다.
    //! 따라서 실전 앱에서는 확인하면서 사용해보자. 메서드 사용하는 방식은 거의 유사하다.
    NSImage *image = [NSImage imageWithSystemSymbolName:@"minus.circle.fill" accessibilityDescription:nil];
    result.leftNormalImage = [image imageWithSymbolConfiguration:symbolConfiguration];
    image = [NSImage imageWithSystemSymbolName:@"plus.circle.fill" accessibilityDescription:nil];
    image = [image imageWithSymbolConfiguration:symbolConfiguration];
    result.rightNormalImage = image;
    
    NSImageSymbolConfiguration *colorConfig =
        [NSImageSymbolConfiguration configurationWithPaletteColors:@[[NSColor colorWithWhite:0.0 alpha:0.7]]];
    colorConfig = [colorConfig configurationByApplyingConfiguration:symbolConfiguration];
    image = [NSImage imageWithSystemSymbolName:@"minus.circle" accessibilityDescription:nil];
    result.leftDisabledImage = [image imageWithSymbolConfiguration:colorConfig];
    image = [NSImage imageWithSystemSymbolName:@"plus.circle" accessibilityDescription:nil];
    result.rightDisabledImage = [image imageWithSymbolConfiguration:colorConfig];

    result.buttonsContensColor = [NSColor colorWithWhite:0.0 alpha:0.5];
    result.labelTextColor = [NSColor labelColor];
    result.fullColor = [NSColor clearColor];
    result.limitHitAnimationColor = [NSColor clearColor];

    result.buttonsBackgroundColor = [NSColor clearColor];
    result.labelBackgroundColor = [NSColor clearColor];
    result.impactColor = [[NSColor blackColor] colorWithAlphaComponent:0.1];

    result.minimumValue = 0.0;
    result.maximumValue = 10.0;
    result.labelFont = [NSFont mgrSystemPreferredFont:NSFontTextStyleTitle2 traits:NSFontDescriptorTraitBold];
    result.labelWidthRatio = labelWidthRatio;
    result.minimumValue = 0.0;
    result.maximumValue = 8.0;

    NSMutableArray <NSString *>*arr = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 9; i++) {
        NSString *str = [NSString stringWithFormat:@"%ld Smoothies", i+1];
        [arr addObject:str];
    }

    result.items = arr;
    return result;
}
@end
