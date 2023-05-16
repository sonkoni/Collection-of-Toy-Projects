//
//  MGADNSwitch.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-20
//  ----------------------------------------------------------------------
//

#import <MacKit/MGADNSwitchConfiguration.h>

NS_ASSUME_NONNULL_BEGIN
extern NSNotificationName const MGADNSwitchStateChangedNotification;

/*!
 * @class      MGADNSwitch
 * @abstract   퍼스트 리스폰더 일때, 스페이스 또는 좌우 방향키로 움직일 수 있다.
 * @discussion height = 30.0; width  = height * 1.75;
 * @code
        // Target - Action
        self.dnSwitch.target = self;
        self.dnSwitch.action = @selector(switchPress:);
        - (IBAction)switchPress:(MGADNSwitch *)sender {
            NSLog(@"Switch is now: %d", sender.switchOn);
        }
 
        // 현재 상태 추적. 손가락으로 움직이는 도중이라도 관찰.
        - (void)windowDidLoad {
            [super windowDidLoad];
            ...
            __weak __typeof(self) weakSelf = self;
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            _dnSwitchObserver = [nc addObserverForName:MGADNSwitchStateChangedNotification
                                                   object:self.dnSwitch // poster
                                                    queue:[NSOperationQueue mainQueue]
                                               usingBlock:^(NSNotification *note) {
                // NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
                NSLog(@"바뀌었냐?? %d", weakSelf.dnSwitch.switchOn);
            }];
        }
 
        - (void)dealloc {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc removeObserver:_dnSwitchObserver];
        }
 * @endcode
 */

IB_DESIGNABLE @interface MGADNSwitch : NSControl

//! 버튼의 상태를 결정한다. 이 값을 프로그래머틱하게 설정하면 애니메이션이 들어가면서 변환된다.
//! 그러나 on 상태에서 또 on을 설정하면, 아무런 일도 일어나지 않게 만들었다.
@property (nonatomic, assign) IBInspectable BOOL switchOn;

@property (nonatomic, strong) IBInspectable NSColor *offTintColor;
@property (nonatomic, strong) IBInspectable NSColor *onTintColor;

@property (nonatomic, strong) IBInspectable NSColor *onThumbTintColor;
@property (nonatomic, strong) IBInspectable NSColor *offThumbTintColor;

@property (nonatomic, strong) IBInspectable NSColor *onSubThumbColor;
@property (nonatomic, strong) IBInspectable NSColor *offSubThumbColor;

@property (nonatomic, strong) IBInspectable NSColor *onBorderColor;
@property (nonatomic, strong) IBInspectable NSColor *offBorderColor;

@property (nonatomic, assign, getter = isHandCursorType) IBInspectable BOOL handCursorType; // 👆 디폴트는 YES
@property (nonatomic, copy, nullable) void (^mouseHoverConditionalBlock)(BOOL);

//! 알림은 오지 않는다. 프로그래머가 강제로 움직이는 것이며, 애니메이션을 줄지 말지를 선택할 수 있다.
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated;

- (instancetype)initWithFrame:(NSRect)frameRect
                     switchOn:(BOOL)switchOn
                configuration:(MGADNSwitchConfiguration * _Nullable)configuration;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
