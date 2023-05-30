//
//  WindowController.m
//  DayNightSwitch_macOS
//
//  Created by Kwan Hyun Son on 2022/03/08.
//

@import MacKit;
#import "WindowController.h"

@interface WindowController ()
@property (weak, nonatomic) IBOutlet NSView *containerA;
@property (weak, nonatomic) IBOutlet NSView *containerB;
@property (weak, nonatomic) IBOutlet NSView *containerC;

@property (nonatomic, strong) MGADNSwitch *dnSwitchA;
@property (nonatomic, strong) MGADNSwitch *dnSwitchB;
@property (weak, nonatomic) IBOutlet NSSwitch *appleSwitch;
@property (nonatomic, strong) MGADNSwitch *dnSwitchBIG;
@end

@implementation WindowController

- (NSNibName)windowNibName {
    return NSStringFromClass([WindowController class]);
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    if (@available(macOS 10.15, *)) {
        self.window.backgroundColor = [NSColor colorWithName:nil dynamicProvider:^NSColor *(NSAppearance *appearance) {
            NSAppearanceName aquaORDarkAqua = [appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
            if ([aquaORDarkAqua isEqualToString:NSAppearanceNameAqua] == YES) {
                return [NSColor whiteColor];
            } else {
                return [NSColor lightGrayColor];
            }
        }];
    } else {
        self.window.backgroundColor = [NSColor whiteColor];
    }
    
    MGADNSwitchConfiguration *config = [MGADNSwitchConfiguration defaultConfiguration2];
    _dnSwitchA = [[MGADNSwitch alloc] initWithFrame:NSZeroRect switchOn:NO configuration:config];
    self.dnSwitchA.target = self;
    self.dnSwitchA.action = @selector(switchValueChanged:);
    [self.containerA addSubview:self.dnSwitchA];
    [self.dnSwitchA mgrPinCenterToSuperviewCenter];
    
    config = [MGADNSwitchConfiguration defaultConfiguration3];
    _dnSwitchB = [[MGADNSwitch alloc] initWithFrame:NSZeroRect switchOn:NO configuration:config];
    self.dnSwitchB.target = self;
    self.dnSwitchB.action = @selector(switchValueChanged:);
    [self.containerB addSubview:self.dnSwitchB];
    [self.dnSwitchB mgrPinCenterToSuperviewCenter];

    
    _dnSwitchBIG = [[MGADNSwitch alloc] initWithFrame:NSZeroRect switchOn:YES configuration:nil];
    self.dnSwitchBIG.target = self;
    self.dnSwitchBIG.action = @selector(switchValueChanged:);
    [self.containerC addSubview:self.dnSwitchBIG];
    [self.dnSwitchBIG mgrPinCenterToSuperviewCenterWithFixSize:NSMakeSize(175.0, 100.0)];
}


#pragma mark - Action
- (void)switchValueChanged:(MGADNSwitch *)sevenSwitch {
    NSLog(@"MGADNSwitch is now: %d", sevenSwitch.switchOn);
    if (sevenSwitch == self.dnSwitchBIG) {
        if (sevenSwitch.switchOn == YES) {
            NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
        } else {
            NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
        }
    }
}

@end
