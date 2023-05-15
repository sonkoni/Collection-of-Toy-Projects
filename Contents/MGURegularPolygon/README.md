# HexagonalWallpaper 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)

## 애니메이팅 가능한 Hexagonal Tiling Wallpaper View
- 앱의 배경을 꾸며줄 수 있는 애니메이팅 가능한 6각형 조각으로 빈틈없이 채우는(hexagonal tiling) Wallpaper View
- [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 Wallpaper의 요구사항이 있어서 제작함.
<p align="center"><img src="./screenshot/230516a1.jpg" width="100"></p>


## Features
*  6각형 ***크기*** 조절 가능
*  6각형 ***보더 굵기*** 조절 가능
*  애니메이팅 + 리벌스 애니메이팅 가능
*  HSB 기반 랜덤 칼라(보더, 면) 가능
*  Support **SWIFT** and **OBJECTIVE-C**. 

## Examples
> - n각형 생성 및 회전
> - 크기 조절 및 커팅
> - 애니메이팅 + 리벌스 애니메이팅
> - [IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용한 Wallpaper

n각형 생성 및 회전 | 크기 조절 및 커팅
---|---
<img src="./screenshot/Simulator Screen Recording - iPad Pro (12.9-inch) (6th generation) - 2023-05-15 at 18.30.29.gif" width="400">|<img src="./screenshot/Simulator Screen Recording - iPad Pro (12.9-inch) (6th generation) - 2023-05-15 at 18.33.45.gif" width="400">

애니메이팅 + 리벌스 애니메이팅 | [IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용한 Wallpaper
---|---
<img src="./screenshot/Simulator Screen Recording - iPad Pro (12.9-inch) (6th generation) - 2023-05-15 at 18.50.56.gif" width="400">|<img src="./screenshot/Simulator Screen Shot - iPad Pro (12.9-inch) (6th generation) - 2023-05-15 at 18.51.10.png" width="400">


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

This project is released under the MIT License.
