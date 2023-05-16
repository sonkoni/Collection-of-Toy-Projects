//
//  WindowController.m
//  SevenSwitch_macOS
//
//  Created by Kwan Hyun Son on 2022/03/08.
//

@import MacKit;
#import "WindowController.h"

@interface WindowController ()
@property (weak, nonatomic) IBOutlet NSView *containerA;
@property (weak, nonatomic) IBOutlet NSView *containerB;
@property (weak, nonatomic) IBOutlet NSView *containerC;

@property (nonatomic, strong) MGASevenSwitch *sevenSwitchA;
@property (nonatomic, strong) MGASevenSwitch *sevenSwitchB;
@property (weak, nonatomic) IBOutlet NSSwitch *appleSwitch;
@property (nonatomic, strong) MGASevenSwitch *sevenSwitchBIG;

@property (nonatomic, strong) MGASevenSwitch *sevenSwitch;
@property (nonatomic, strong) id <NSObject>sevenSwitchObserver;
@end

@implementation WindowController

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:_sevenSwitchObserver];
}

- (NSNibName)windowNibName {
    return NSStringFromClass([WindowController class]);
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.backgroundColor = [NSColor whiteColor];
    
    MGASevenSwitchConfiguration *sevenSwitchAConfig = [MGASevenSwitchConfiguration defaultConfiguration];
    sevenSwitchAConfig.onTintColor = [NSColor mgrColorFromHexString:@"C4449E"];
    sevenSwitchAConfig.onBorderColor = sevenSwitchAConfig.onTintColor;
    _sevenSwitchA = [[MGASevenSwitch alloc] initWithFrame:NSZeroRect
                                                 switchOn:NO
                                            configuration:sevenSwitchAConfig];
    [self.containerA addSubview:self.sevenSwitchA];
    [self.sevenSwitchA mgrPinCenterToSuperviewCenter];
    
    
    MGASevenSwitchConfiguration *sevenSwitchBConfig = [MGASevenSwitchConfiguration defaultConfiguration];
    sevenSwitchBConfig.onTintColor = [NSColor mgrColorFromHexString:@"2AA8FA"];
    sevenSwitchBConfig.onBorderColor = sevenSwitchBConfig.onTintColor;
    sevenSwitchBConfig.onThumbTintColor = [NSColor systemYellowColor];
    _sevenSwitchB = [[MGASevenSwitch alloc] initWithFrame:NSZeroRect
                                                 switchOn:NO
                                            configuration:sevenSwitchBConfig];
    [self.containerB addSubview:self.sevenSwitchB];
    [self.sevenSwitchB mgrPinCenterToSuperviewCenter];
    
    
    MGASevenSwitchConfiguration *sevenSwitchBIGConfig = [MGASevenSwitchConfiguration defaultConfiguration];
    sevenSwitchBIGConfig.offBorderColor = [NSColor blackColor];
    _sevenSwitchBIG = [[MGASevenSwitch alloc] initWithFrame:NSZeroRect
                                                 switchOn:YES
                                            configuration:sevenSwitchBIGConfig];
    [self.containerC addSubview:self.sevenSwitchBIG];
    [self.sevenSwitchBIG mgrPinCenterToSuperviewCenterWithFixSize:NSMakeSize(175.0, 100.0)];
    
    MGASevenSwitchConfiguration *config = [MGASevenSwitchConfiguration defaultConfiguration];
    config.onTintColor = [NSColor systemYellowColor];
    config.onThumbTintColor = [NSColor systemBlueColor];
    config.onBorderColor = config.onTintColor;
    config.offThumbTintColor = [NSColor lightGrayColor];
    _sevenSwitch = [[MGASevenSwitch alloc] initWithFrame:CGRectZero switchOn:NO configuration:config];
    self.sevenSwitch.target = self;
    self.sevenSwitch.action = @selector(sevenSwitchValueChanged:);
    [self.containerC addSubview:self.sevenSwitch];
    self.sevenSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sevenSwitch.centerXAnchor constraintEqualToAnchor:self.containerC.centerXAnchor].active = YES;
    [self.sevenSwitch.bottomAnchor constraintEqualToAnchor:self.containerC.bottomAnchor constant:-20.0].active = YES;
    
    
    //! restorable 로 인하여 재차 빌드했을 때, initialFirstResponder가 제대로 적용안되는 현상이 존재함.
    //! loop를 완전히 완성해야 제대로 작동하는 것으로 사료된다.
    //! https://stackoverflow.com/questions/55719308/makefirstresponder-does-not-always-fire
    //! http://www.extelligentcocoa.org/the-strange-case-of-initialfirstresponder/
    //! https://www.raywenderlich.com/1395-state-restoration-tutorial-getting-started
    //!
    self.window.restorable = NO; // 디폴트가 YES였다.
    [self.window makeFirstResponder:self.sevenSwitch];
    self.window.initialFirstResponder = self.sevenSwitch;
    self.sevenSwitch.nextKeyView = self.appleSwitch;
    self.appleSwitch.nextKeyView = self.sevenSwitchBIG;
    self.sevenSwitchBIG.nextKeyView = self.sevenSwitchA;
    self.sevenSwitchA.nextKeyView = self.sevenSwitchB;
    self.sevenSwitchB.nextKeyView = self.sevenSwitch;
    
    __weak __typeof(self) weakSelf = self;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    _sevenSwitchObserver = [nc addObserverForName:MGASevenSwitchStateChangedNotification
                                           object:self.sevenSwitch // poster
                                            queue:[NSOperationQueue mainQueue]
                                       usingBlock:^(NSNotification *note) {
        // NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSLog(@"바뀌었냐?? %d", weakSelf.sevenSwitch.switchOn);
    }];
}


#pragma mark - Action
- (void)sevenSwitchValueChanged:(MGASevenSwitch *)sevenSwitch {
    NSLog(@"MGASevenSwitch is now: %d", sevenSwitch.switchOn);
}

@end
