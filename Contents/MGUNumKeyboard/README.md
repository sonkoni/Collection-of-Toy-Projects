# MGUNumKeyboard 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)

## **MGUNumKeyboard**
- 스크롤 제스처로 몸무게를 설정할 수 있는 RulerView
    - `UIScrollView` 를 기반으로 제작함
- [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 SheetViewController에 위치할 RulerView에 대한 요구사항이 있어서 제작함.
<p align="center"><img src="./screenshot/230516b1.jpg" width="400"></p>


## Features
*  더블 탭, 트리플 탭 지원
    * 더블 탭, 트리플 탭 에 따라 이동할 길이 선택가능
*  Style presets 지원
    * 중앙 바늘의 모양에 대한 presets 지원
    * RulerView의 표시된 눈금의 위치와 길이에 대한 presets 지원
*  KG, LB 선택가능
*  Sound 지원
    * Driven Sound와 Scroll Sound의 소리 종류 및 간격을 각각 다르게 설정함
*  손가락이 접촉한 상태에는 스크롤의 저항을 표현하기 위해 Easing 함수를 이용함.
*  **Swift** and **Objective-C** compatability


## Examples
> - MGURulerView (iOS)
>   - [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 무게를 측정할 RulerView의 요구사항이 있어서 제작함.


스크롤 및 더블 탭 | 짧게 이동, 길게 이동 | 특정 지점으로 점프 
---|---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 15.32.22.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 15.33.35.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 15.35.01.gif" width="250">

[IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용 |
---|
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 15.36.04.gif" width="250">|

## Usage

> Swift
```swift

rulerView = MGURulerView.init(frame: .zero, initialValue: randomDoubleValue, indicatorType: indicatorType, config: rulerViewConfig)
guard let rulerView = rulerView else { return }
rulerView.delegate = self
rulerView.soundOn = true
rulerView.normalSoundPlayBlock = sound?.playSoundTickHaptic()
rulerView.skipSoundPlayBlock = sound?.playSoundRolling()
containerView.addSubview(rulerView)

```

> Objective-C
```objective-c

self.rulerView = [[MGURulerView alloc] initWithFrame:CGRectZero
                                        initialValue:randomDoubleValue
                                       indicatorType:self.indicatorType
                                              config:self.rulerViewConfig];
self.rulerView.delegate = self;
self.rulerView.soundOn = YES;
self.rulerView.normalSoundPlayBlock = [self.sound playSoundTickHaptic];
self.rulerView.skipSoundPlayBlock = [self.sound playSoundRolling];
[self.containerView addSubview:self.rulerView];

```

## Documentation

- RulerView의 바늘의 배치를 위한 설계도
<img src="./screenshot/230517a2.jpg" width="1000">

- Style presets 지원
<img src="./screenshot/230517a3.jpg" width="1000">

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
