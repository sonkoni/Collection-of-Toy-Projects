# DialControl Samples 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)

## **DialControl Samples**
- 숫자 값을 입력받을 수 있는 Number Keyboard
    - `UIInputView` 를 기반으로 제작함
- [MiniTimer](https://apps.apple.com/app/id1618148240)을 만들면서 Number Keyboard에 대한 요구사항 이 있어서 제작함.
<p align="center"><img src="./screenshot/230516b1.jpg" width="400"></p>


## Features
*  Style presets 지원
    * 5가지의 Layout을 제공함 
    * 버튼의 모양 선택가능
    * 4 종류의 Appearance 제공
*  Sound 지원
    * iOS의 키보드 Sound가 Delete 키와 일반 키 소리가 다른 것을 발견하여 각각 다르게 만들었음
    * Sound Source는 Simulator에서 추출함
*  Delete 버튼 long press 지원    
    * long press 시, 일정한 간격으로 반복적으로 호출되어 실행된다. 
*  **Swift** and **Objective-C** compatability


## Examples
> - MGUNumKeyboard (iOS)
>   - [MiniTimer](https://apps.apple.com/app/id1618148240)을 만들면서 Number Keyboard에 대한 요구사항 이 있어서 제작함.

<!--> - 을 만들면서 커스텀 스위치의 요구사항이 있어서 제작함.-->

Sample 1 | Sample 2 | [MiniTimer](https://apps.apple.com/app/id1618148240)에서 사용 예
---|---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-20 at 09.05.19.gif" width="225">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-20 at 09.05.53.gif" width="225">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 Pro - 2023-05-20 at 09.29.19.gif" width="225">


## Usage

> Swift
```swift

let keyboard = MGUNumKeyboard(frame: .zero,
                              locale: nil,
                              layoutType: .lowHeightStyle1,
                              configuration: MGUNumKeyboardConfiguration.darkBlue())
keyboard.delegate = self
// keyboard.allowsDoneButton = true //! MGUNumKeyboardLayoutTypeStandard2에서는 아무런 효과가 없다.
keyboard.roundedButtonShape = false
keyboard.normalSoundPlayBlock = sound?.playSoundKeyPress
keyboard.deleteSoundPlayBlock = sound?.playSoundKeyDelete

keyboard.keyInput = privateTextField // self.textField.inputView = keyboard; 이렇게 설정 금지.
self.privateTextField.isUserInteractionEnabled = false
//! self.textField.alpha = 0.0f; <- 이렇게 실전에서는 처리할 것이다.
keyboard.soundOn = true
privateTextField.addTarget(self, action:#selector(textFieldDidChange(_:)), for: .editingChanged)

```

> Objective-C
```objective-c

MGUNumKeyboard *keyboard =
[[MGUNumKeyboard alloc] initWithFrame:CGRectZero
                               locale:nil
                           layoutType:MGUNumKeyboardLayoutTypeLowHeightStyle2
                        configuration:[MGUNumKeyboardConfiguration forgeConfiguration]];

keyboard.delegate = self;
// keyboard.allowsDoneButton = YES; //! LowHeightStyle에서는 아무런 효과가 없다.
keyboard.roundedButtonShape = YES;
keyboard.normalSoundPlayBlock = self.sound.playSoundKeyPress;
keyboard.deleteSoundPlayBlock = self.sound.playSoundKeyDelete;

keyboard.keyInput = self.privateTextField; // self.textField.inputView = keyboard; 이렇게 설정 금지.
self.privateTextField.userInteractionEnabled = NO;
//! self.textField.alpha = 0.0f; <- 이렇게 실전에서는 처리할 것이다.
keyboard.soundOn = YES;
[self.privateTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

```

## Documentation

- DialControl의 Behavior를 위한 설계도
<img src="./screenshot/230517a2.jpg" width="1000">

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
