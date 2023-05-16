# SevenSwitch 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)
![macOS](https://img.shields.io/badge/MAC%20OS-000000?style=flat-square&logo=macos&logoColor=F0F0F0)

## **MGUSevenSwitch**(***iOS***) & **MGASevenSwitch**(***macOS***)
- `SevenSwitch`는 `UISwitch` 및 `NSSwitch` 보다 더 많은 기능과 디자인의 자유도를 보장하는 커스텀 스위치
    - MGUSevenSwitch : iOS 용 (UIControl 서브클래스)
    - MGASevenSwitch : macOS 용 (NSControl 서브클래스)
- [MiniTimer](https://apps.apple.com/app/id1618148240)을 만들면서 팝업에 위치할 커스텀 스위치의 요구사항이 있어서 제작함.
<p align="center"><img src="./screenshot/230516b1.jpg" width="400"></p>


## Features
*  커스텀 사이즈 가능(`UISwitch` 및 `NSSwitch`와 동일한 `intrinsicContentSize`도 가지고 있음)
*  ON, OFF 영역에 이미지 또는 텍스트 설정 가능
*  커스텀 Shape 가능
    * ON, OFF 각각의 상태에 대하여 보더, 백그라운드, 손잡이 색을 개별적으로 설정가능
*  커스텀 손잡이 가능
*  Haptic Feedback 제공 : 제스처로 토글 시 Haptic Feedback이 터치한 Device(아이폰, 트랙패드 등)를 통해 전달된다.
    * iOS : `UIImpactFeedbackGenerator` 이용하여 구현함
    * macOS : `NSHapticFeedbackManager` 이용하여 구현함
*  제스처가 다 끝나지 않은 상태(손가락이 떨어지지 않은 상태)에서 ON, OFF를 오고가는 상태를 Notification 등록을 통해 감시 가능
    * iOS : `MGUSevenSwitchStateChangedNotification` 을 이용하여 감시 가능함
    * macOS : `MGASevenSwitchStateChangedNotification` 을 이용하여 감시 가능함
*  Interface Builder에서 설정가능하다. - 그러나 XCode 자체 버그가 있기 때문에 추천하지 않는다.
    * Swift : `@IBDesignable` `@IBInspectable`
    * Objective-C : `IB_DESIGNABLE` `IBInspectable`
*  MGASevenSwitch(macOS) 는 마우스 hover 시에 커서 타입을 정할 수 있다.    
*  **Swift** and **Objective-C** compatability
*  Support **iOS**(***MGUSevenSwitch***) and **macOS**(***MGASevenSwitch***).


## Examples
> - MGUSevenSwitch (iOS)
>   - [MiniTimer](https://apps.apple.com/app/id1618148240)을 만들면서 커스텀 스위치의 요구사항이 있어서 제작함.
> - MGASevenSwitch (macOS)


MGUSevenSwitch (iOS) | MGUSevenSwitch (iOS) | [MiniTimer](https://apps.apple.com/app/id1618148240)에서 사용한 예
---|---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-16 at 11.18.26.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-16 at 11.21.18.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-16 at 11.33.44.gif" width="250">

MGASevenSwitch (macOS) |
---|
<img src="./screenshot/Screen Recording 2023-05-16 at 12.04.22.gif" width="450">|


## Usage

## Documentation

- 도형 배치를 위한 알고리즘 구상
<img src="./screenshot/Hexagon.jpg" width="800">


- 포커스 랜덤 함수 구상
    - 예를 들어 파란색 부터 흰색을 HSB 값으로 랜덤하게 배치했을 때, 파란색에 치우치게 랜덤 색이 나오게 하기 위해서 구상함
<img src="./screenshot/FocusRandom.jpg" width="800">


- `layer` 의 `timeOffset` 프라퍼티를 이용하여, 슬라이더로 애니메이팅을 수동 조절할 수 있음
    - [**timeOffset**](http://wiki.mulgrim.net/page/Api:Core_Animation/protocol_CAMediaTiming/timeOffset) <- 기술 위키 문서
    - [**Pausing and Resuming Animations**](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW15)
```swift

@IBAction func sliderValueChanged(_ sender: UISlider) {
    hexagonalWallpaperView.layer.timeOffset = CFTimeInterval(sender.value)
}
private func onboardingAnimationStart() {
    let hexagonalProgressAnimation = self.hexagonalWallpaperView.hexagonalProgressAnimation()
    
    CATransaction.setCompletionBlock { }
    self.hexagonalWallpaperView.layer.add(hexagonalProgressAnimation, forKey: "HexagonalProgressAnimationKey")
}

```

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
