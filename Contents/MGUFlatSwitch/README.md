# MGUFlatSwitch 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)

## **MGUFlatSwitch**
- 완료 및 체크를 상징하는 애니메이팅 가능한 커스텀 스위치
    - UIControl 서브클래스로 제작함
- [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 완료를 표기하는 애니메이션 요구사항이 있어서 제작함.
<p align="center"><img src="./screenshot/230517a3.jpg" width="200"></p>


## Features
*  `lineWidth` 설정 가능
*  `animationDuration` 설정 가능
*  CompletionHandler 제공
*  Interface Builder에서 설정가능 - 그러나 XCode 자체 버그가 있기 때문에 추천하지 않는다.
    * Swift : `@IBDesignable` `@IBInspectable`
    * Objective-C : `IB_DESIGNABLE` `IBInspectable`
*  **Swift** and **Objective-C** compatability


## Examples
> - [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 완료를 표기하는 애니메이션 요구사항이 있어서 제작함.  


MGUFlatSwitch Samples | [IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용한 예
---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 09.37.28.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 05.22.24.gif" width="250">


## Usage

> Swift
```swift

private var button = MGUFlatSwitch(frame: .zero, skinView: MMTMidButtonSkin())

```

> Objective-C
```objective-c

_button = [[MGUFlatSwitch alloc] initWithFrame:CGRectZero skinView:[MMTMidButtonSkin new]];

```

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## Credits
Inspired by Dribbble [post](https://dribbble.com/shots/1631598-On-Off)

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
