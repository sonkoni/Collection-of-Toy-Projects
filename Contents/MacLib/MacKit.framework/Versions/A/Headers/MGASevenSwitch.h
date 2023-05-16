//
//  MGASevenSwitch.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-20
//  ----------------------------------------------------------------------
//

#import <MacKit/MGASevenSwitchConfiguration.h>

NS_ASSUME_NONNULL_BEGIN
extern NSNotificationName const MGASevenSwitchStateChangedNotification;

/*!
 * @class      MGASevenSwitch
 * @abstract   퍼스트 리스폰더 일때, 스페이스 또는 좌우 방향키로 움직일 수 있다.
 * @discussion height = 22.0; width  = height * 1.75;
 * @code
        // Target - Action
        self.sevenSwitch.target = self;
        self.sevenSwitch.action = @selector(switchPress:);
        - (IBAction)switchPress:(MGASevenSwitch *)sender {
            NSLog(@"Switch is now: %d", sender.switchOn);
        }
 
        // 현재 상태 추적. 손가락으로 움직이는 도중이라도 관찰.
        - (void)windowDidLoad {
            [super windowDidLoad];
            ...
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
 * @endcode
 */
IB_DESIGNABLE @interface MGASevenSwitch : NSControl

//! 버튼의 상태를 결정한다. 이 값을 프로그래머틱하게 설정하면 애니메이션이 들어가면서 변환된다.
//! 그러나 on 상태에서 또 on을 설정하면, 아무런 일도 일어나지 않게 만들었다.
@property (nonatomic, assign) IBInspectable BOOL switchOn;

@property (nonatomic, strong) IBInspectable NSColor *offTintColor; // 디폴트 [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]; // 회색빛
@property (nonatomic, strong) IBInspectable NSColor *onTintColor; // 디폴트 [UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1.0]

@property (nonatomic, strong) IBInspectable NSColor *onThumbTintColor;  // 디폴트 whiteColor
@property (nonatomic, strong) IBInspectable NSColor *offThumbTintColor; // 디폴트 whiteColor

@property (nonatomic, strong) IBInspectable NSColor *onBorderColor;    //
@property (nonatomic, strong) IBInspectable NSColor *offBorderColor;    // 디폴트 [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0] 회색빛

@property (nonatomic, strong) IBInspectable NSColor *decoLayerColor;    // off(정지 상태)에서의 데코뷰의 칼라.

@property (nonatomic, assign, getter = isHandCursorType) IBInspectable BOOL handCursorType; // 👆 디폴트는 YES
@property (nonatomic, copy, nullable) void (^mouseHoverConditionalBlock)(BOOL);

//! 알림은 오지 않는다. 프로그래머가 강제로 움직이는 것이며, 애니메이션을 줄지 말지를 선택할 수 있다.
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated;

- (instancetype)initWithFrame:(NSRect)frameRect
                     switchOn:(BOOL)switchOn
                configuration:(MGASevenSwitchConfiguration * _Nullable)configuration;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
