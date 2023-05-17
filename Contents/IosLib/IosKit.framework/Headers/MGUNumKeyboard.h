//
//  MGUNumKeyboard.h
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <IosKit/MGUNumKeyboardConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef
typedef NS_ENUM(NSInteger, MGUNumKeyboardLayoutType) {
    MGUNumKeyboardLayoutTypeStandard1 = 1,   // allowsDoneButton으로 레이아웃이 약간 달라질 수 있다.
    MGUNumKeyboardLayoutTypeStandard2,       // allowsDoneButton은 아무런 효과가 없다. : layout 고정
    MGUNumKeyboardLayoutTypeLowHeightStyle1, // allowsDoneButton은 아무런 효과가 없다. : layout 고정
    MGUNumKeyboardLayoutTypeLowHeightStyle2  // allowsDoneButton은 아무런 효과가 없다. : layout 고정
};


#pragma mark - 프로토콜 선언 <MGUNumKeyboardDelegate>
// 텍스트 편집 시퀀스의 일부로 델리게이트 객체로 전송되는 메시지이다. 모두 옵셔널.
// ----------------------------------------------------------------------

@class MGUNumKeyboard;
@protocol MGUNumKeyboardDelegate <NSObject>
@optional
- (BOOL)numberKeyboard:(MGUNumKeyboard *)numberKeyboard shouldInsertText:(NSString *)text; // ① : 숫자 또는 . 에 대하여 삽입 시킬지를 묻는다.
- (BOOL)numberKeyboardShouldReturn:(MGUNumKeyboard *)numberKeyboard; // ② : done(or return or 엔터) 버튼을 눌렀을 때, 키보드를 감출 것인지
- (BOOL)numberKeyboardShouldDeleteBackward:(MGUNumKeyboard *)numberKeyboard; // ③ : 딜리트 버튼을 눌렀을 때, character를 지울 것인지에 대한 정보.
//
// ① : 구현자체를 하지 않으면 YES를 반환하는 것과 동일. NO를 반환하면 숫자 또는 . 키를 눌렀을 때, 아무것도 하지 않을 것이다.
// ② : 구현자체를 하지 않으면 YES를 반환하는 것과 동일. NO를 반환하면 done 버튼을 눌렀을 때, 아무것도 하지 않을 것이다.(키보드 그대로.)
// ③ : 구현자체를 하지 않으면 YES를 반환하는 것과 동일. NO를 반환하면 딜리트 버튼을 눌렀을 때, 아무것도 하지 않을 것이다.(지우지 않는다.)
@end


#pragma mark - 인터페이스

@interface MGUNumKeyboard : UIInputView

@property (nonatomic, weak, nullable) id <MGUNumKeyboardDelegate> delegate;          // MGUNumKeyboardDelegate프로토콜을 구현하는 객체
@property (nonatomic, weak, nullable) id <UIKeyInput> keyInput;   // ① receiver key input 객체. lazy. textField에 해당함.
@property (nonatomic, assign) BOOL allowsDoneButton;              // ② 디폴트 NO
@property (nonatomic, assign) BOOL enablesReturnKeyAutomatically; // ③ 사용자가 숫자를 입력할 때 Return 키가 자동으로 활성화되는지 여부를 나타내는 값.
@property (nonatomic, strong) NSString *returnKeyTitle;             // 디폴트 타이틀 : “Done”
@property (nonatomic, assign) BOOL roundedButtonShape;              // 디폴트 NO
@property (nonatomic, assign) BOOL soundOn;
@property (nonatomic, copy, nullable) void (^specialKeyHandlerBlock)(void);
@property (nonatomic, copy, nullable) void (^deleteSoundPlayBlock)(void);
@property (nonatomic, copy, nullable) void (^normalSoundPlayBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame
                       locale:(nullable NSLocale *)locale // ④ 키보드 옵션(특히 NSLocaleDecimalSeparator)을 지정하는 NSLocale 객체.
                   layoutType:(MGUNumKeyboardLayoutType)layoutType
                configuration:(MGUNumKeyboardConfiguration * _Nullable)configuration NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame inputViewStyle:(UIInputViewStyle)inputViewStyle NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
//
// ① : 만약 nil이면 responder chain의 맨 위에있는 객체가 이용된다.
// ② : YES이면, decimal separator 키(. 키)가 표시될 것이다. 디폴트 NO;
// ③ : 디폴트 NO. YES로 설정하면 텍스트 입력 영역에 텍스트가 없을 때 키보드는 Return 키를 비활성화한다. 텍스트를 입력하자마자 Return 키가 자동으로 활성화된다.
// ④ : 키보드에 사용되는 옵션 (특히 NSLocaleDecimalSeparator)을 지정하는 NSLocale 객체. 현재 로케일을 사용하려면 nil을 넣어라.

// [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
// - (void)textFieldDidChange:(UITextField *)sender;
