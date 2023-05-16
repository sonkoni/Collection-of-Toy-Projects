//
//  WindowController.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/03/08.
//

#import "WindowController.h"
@import MacKit;

@interface WindowController ()
@property (weak, nonatomic) IBOutlet NSView *container1;
@property (weak, nonatomic) IBOutlet NSView *container2;

@property (weak, nonatomic) IBOutlet NSView *container1_bottom;
@property (nonatomic, strong) MGASevenSwitch *sevenSwitch;
@property (nonatomic, strong) id <NSObject>sevenSwitchObserver;


@property (weak, nonatomic) IBOutlet MGASevenSwitch *sevenSwitchXX;
@property (weak, nonatomic) IBOutlet MGASevenSwitch *sevenSwitchYY;
@property (weak, nonatomic) IBOutlet NSSwitch *appleSwitch;
@property (weak, nonatomic) IBOutlet MGASevenSwitch *sevenSwitchLarge;
@end

@implementation WindowController
//! - initWithWindow: 를 nil을 넣어서 초기화해도 닙이름을 잘 찾아갈 수 있게 해준다.
- (NSNibName)windowNibName {
    return NSStringFromClass([WindowController class]);
}

- (void)windowDidLoad {
    [super windowDidLoad];
//!    [self setupAppearance];
    self.window.backgroundColor = [NSColor blackColor];
    
    self.container1.layer = [CALayer layer];
    self.container2.layer = [CALayer layer];
    self.container1.wantsLayer = YES;
    self.container2.wantsLayer = YES;
    self.container1.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.container2.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    MGASevenSwitchConfiguration *config = [MGASevenSwitchConfiguration defaultConfiguration];
    config.onTintColor = [NSColor systemYellowColor];
    config.onThumbTintColor = [NSColor systemBlueColor];
    config.onBorderColor = config.onTintColor;
    config.offThumbTintColor = [NSColor lightGrayColor];
    _sevenSwitch = [[MGASevenSwitch alloc] initWithFrame:CGRectZero switchOn:NO configuration:config];
    self.sevenSwitch.target = self;
    self.sevenSwitch.action = @selector(sevenSwitchValueChanged:);
    [self.container1_bottom addSubview:self.sevenSwitch];
    self.sevenSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sevenSwitch.centerXAnchor constraintEqualToAnchor:self.container1_bottom.centerXAnchor].active = YES;
    [self.sevenSwitch.bottomAnchor constraintEqualToAnchor:self.container1_bottom.bottomAnchor constant:-20.0].active = YES;
    
    
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
    self.appleSwitch.nextKeyView = self.sevenSwitchLarge;
    self.sevenSwitchLarge.nextKeyView = self.sevenSwitchXX;
    self.sevenSwitchXX.nextKeyView = self.sevenSwitchYY;
    self.sevenSwitchYY.nextKeyView = self.sevenSwitch;
    
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

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:_sevenSwitchObserver];
}

#pragma mark - Action
- (void)sevenSwitchValueChanged:(MGASevenSwitch *)sevenSwitch {
    NSLog(@"MGASevenSwitch is now: %d", sevenSwitch.switchOn);
}


#pragma mark - Helper
- (void)setupAppearance {
    //    NSAppearanceNameAqua
    //    NSAppearanceNameDarkAqua
        self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
        
        /** The following two Vibrant appearances should only be set on an NSVisualEffectView, or one of its container subviews.
         NSAppearanceNameVibrantDark
         NSAppearanceNameVibrantLight
         */
        
        /* The following appearance names are for matching using bestMatchFromAppearancesWithNames:
           Passing any of them to appearanceNamed: will return NULL
         */
    //    NSArray<NSAppearanceName> * names = @[NSAppearanceNameAccessibilityHighContrastAqua,
    //                                          NSAppearanceNameAccessibilityHighContrastDarkAqua,
    //                                          NSAppearanceNameAccessibilityHighContrastVibrantLight,
    //                                          NSAppearanceNameAccessibilityHighContrastVibrantDark];
    //    self.window.appearance = [NSAppearance appearanceNamed:[[NSAppearance alloc] bestMatchFromAppearancesWithNames:names]];
        
        
    //    self.window.backgroundColor = [NSColor yellowColor];
}

@end
