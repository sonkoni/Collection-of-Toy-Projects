# DayNightSwitch 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)
![macOS](https://img.shields.io/badge/MAC%20OS-000000?style=flat-square&logo=macos&logoColor=F0F0F0)

## **MGUDNSwitch** (***iOS***) <br/> **MGADNSwitch** (***macOS***)
- `DayNightSwitch`는 [Dribbble](https://dribbble.com/shots/1909289-Day-Night-Toggle-Button-GIF) 에서 발견한 스위치 디자인에 영감을 얻어 `UIControl`(iOS), `NSControl`(macOS)을 서브 클래싱하여 제작함. 
    - `MGUDNSwitch` : iOS 용 (`UIControl` 서브클래스)
    - `MGADNSwitch` : macOS 용 (`NSControl` 서브클래스)
- 유사 프로젝트 : [SevenSwitch](https://github.com/sonkoni/Collection-of-Toy-Projects/tree/main/Contents/SevenSwitch)
<p align="center"><img src="./screenshot/230530a3.gif" width="200"></p>

## Features
*  커스텀 사이즈 가능(`intrinsicContentSize`도 가지고 있음)
*  커스텀 Shape 가능
    * ON, OFF 각각의 상태에 대하여 보더, 백그라운드, 손잡이 색을 개별적으로 설정가능
*  커스텀 손잡이 가능
*  Haptic Feedback 제공 : 제스처로 토글 시 Haptic Feedback이 터치한 Device(아이폰, 트랙패드 등)를 통해 전달된다.
    * iOS : `UIImpactFeedbackGenerator` 이용하여 구현함
    * macOS : `NSHapticFeedbackManager` 이용하여 구현함
*  제스처가 다 끝나지 않은 상태(손가락이 떨어지지 않은 상태)에서 ON, OFF를 오고가는 상태를 Notification 등록을 통해 감시 가능
    * iOS : `MGUDNSwitchStateChangedNotification` 을 이용하여 감시 가능함
    * macOS : `MGADNSwitchStateChangedNotification` 을 이용하여 감시 가능함
*  MGADNSwitch(macOS)는 마우스 hover 시에 커서 타입을 정할 수 있다.    
*  MGADNSwitch(macOS)는 Interface Builder에서 설정가능하다. - 그러나 XCode 자체 렌더링 버그가 있기 때문에 추천하지 않는다.
    * Swift : `@IBDesignable` `@IBInspectable`
    * Objective-C : `IB_DESIGNABLE` `IBInspectable`
*  **Swift** and **Objective-C** compatability
*  Support **iOS**(***MGUDNSwitch***) and **macOS**(***MGADNSwitch***).
*  Written in Objective-C


## Preview
> - MGUDNSwitch (iOS)
>   - [MiniTimer](https://apps.apple.com/app/id1618148240)을 만들면서 커스텀 스위치의 요구사항이 있어서 제작함.
> - MGADNSwitch (macOS)

MGUDNSwitch (iOS) | MGADNSwitch (macOS)
---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-30 at 19.12.19.gif" width="250">|<img src="./screenshot/Screen Recording 2023-05-30 at 18.58.38.gif" width="450">


## Usage

> Swift
```swift

let sevenSwitch = MGUSevenSwitch(center: CGPoint.zero, switchOn: isBig, configuration: MGUSevenSwitchConfiguration.default())
view.addSubview(sevenSwitch)
sevenSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

```

> Objective-C
```objective-c

_sevenSwitch =[[MGUSevenSwitch alloc] initWithCenter:CGPointZero
                                            switchOn:YES
                                       configuration:[MGUSevenSwitchConfiguration yellowConfiguration]];
[self.view addSubview:self.sevenSwitch];
[self.sevenSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

```
> Interface Builder

<img src="./screenshot/230531a1.jpg" width="500">


## Documentation
<img src="./screenshot/230530a1.jpg" width="1000">

## Author

sonkoni(손관현), isomorphic111@gmail.com


## Credits

Inspired by Dribbble [post](https://dribbble.com/shots/1909289-Day-Night-Toggle-Button-GIF)
 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
