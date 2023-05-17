//
//  MGUSevenSwitch.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-03
//  ----------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import <IosKit/MGUSevenSwitchConfiguration.h>

NS_ASSUME_NONNULL_BEGIN
extern NSNotificationName const MGUSevenSwitchStateChangedNotification; // 제스처가 지속되는 과정에서 on off 상태에 관심이 있다면

/*!
 * @class      MGUSevenSwitch
 * @abstract   ...
 * @discussion ...
 * @code
        @property (nonatomic, strong) id <NSObject>sevenSwitchObserver;
 
        // Target - Action
        - (IBAction)switchChanged:(MGUSevenSwitch *)sender {
            if (sender.switchOn == YES) {
            NSLog(@"밸류가 바뀌었네. ON");
        } else {
            NSLog(@"밸류가 바뀌었네. OFF");
        }
 
        // 현재 상태 추적. 손가락으로 움직이는 도중이라도 관찰.
        _sevenSwitch = [[MGUSevenSwitch alloc] initWithCenter:center
                                                    switchOn:YES
                                                configuration:[MGUSevenSwitchConfiguration defaultConfiguration]];
        [self.sevenSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.sevenSwitch];
        [self.sevenSwitch mgrPinCenterToSuperviewCenterWithFixSize:self.sevenSwitch.frame.size];
        
        __weak __typeof(self) weakSelf = self;
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        _sevenSwitchObserver = [nc addObserverForName:MGUSevenSwitchStateChangedNotification
                                                object:self.sevenSwitch // poster
                                                queue:[NSOperationQueue mainQueue]
                                            usingBlock:^(NSNotification *note) {
            // NSNumber *duration = note.userInfo[UIKeyboardAnimationDurationUserInfoKey];
            NSLog(@"바뀌었냐?? %d", weakSelf.sevenSwitch.switchOn);
        }];
 
        - (void)dealloc {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc removeObserver:_sevenSwitchObserver];
        }
 * @endcode
 */
@interface MGUSevenSwitch : UIControl

//! 버튼의 상태를 결정한다. 이 값을 프로그래머틱하게 설정하면 애니메이션이 들어가면서 변환된다.
//! 그러나 on 상태에서 또 on을 설정하면, 아무런 일도 일어나지 않게 만들었다.
@property (nonatomic) BOOL switchOn;
@property (nonatomic) MGUSevenSwitchCornerRadius cornerRadius;
@property (nonatomic) MGUSevenSwitchKnobRatio knobRatio;

//@property (nonatomic) UIColor *offTintActiveColor; // 디폴트 [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
@property (nonatomic) UIColor *decoViewColor;    // off(정지 상태)에서의 데코뷰의 칼라.
@property (nonatomic) UIColor *offTintColor;      // 디폴트 clearColor
@property (nonatomic) UIColor *onTintColor;       // 디폴트 [UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1.0]

@property (nonatomic) UIColor *onBorderColor;    //
@property (nonatomic) UIColor *offBorderColor;    // 디폴트 [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0] 회색빛

@property (nonatomic) UIColor *offThumbTintColor; // 디폴트 whiteColor
@property (nonatomic) UIColor *onThumbTintColor;  // 디폴트 whiteColor

@property (nonatomic) UIColor *shadowColor;       // grayColor

@property (nonatomic, nullable) __kindof UIView *backAccessoryView;
@property (nonatomic, nullable) __kindof UIView *knobAccessoryView;
@property (nonatomic) UIImage *knobImage;
@property (nonatomic) UIImage *onImage;
@property (nonatomic) UIImage *offImage;

@property (nonatomic) NSString *onLabelTitle;
@property (nonatomic) NSString *offLabelTitle;
@property (nonatomic) NSTextAlignment onLabelTextAlignment;
@property (nonatomic) NSTextAlignment offLabelTextAlignment;
@property (nonatomic) UIColor *onLabelTextColor;
@property (nonatomic) UIColor *offLabelTextColor;
@property (nonatomic) UIFont *onLabelTextFont;
@property (nonatomic) UIFont *offLabelTextFont;

- (instancetype)initWithCenter:(CGPoint)center
                      switchOn:(BOOL)switchOn
                 configuration:(MGUSevenSwitchConfiguration * _Nullable)configuration;
- (instancetype)initWithFrame:(CGRect)frame
                     switchOn:(BOOL)switchOn
                configuration:(MGUSevenSwitchConfiguration * _Nullable)configuration NS_DESIGNATED_INITIALIZER;

//! 알림은 오지 않는다. 프로그래머가 강제로 움직이는 것이며, 애니메이션을 줄지 말지를 선택할 수 있다.
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated;
- (CGFloat)borderWidth;

/** 이용불가 **/
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
