# Alert & Action Sheet 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)


## **MGUAlertViewController** & **MGUActionSheetController** 
- `MGUNeoSegControl`는 `UISegmentedControl` 보다 더 많은 기능과 디자인의 자유도를 보장하는 커스텀 SegmentedControl
    - `UIControl` 서브클래스로 제작함
- [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 SheetViewController에 위치할 커스텀 SegmentedControl에 대한 요구사항이 있어서 제작함. [MiniTimer](https://apps.apple.com/app/id1618148240)에서도 사용함.
<p align="center"><img src="./screenshot/230516b2.jpg" width="900"></p>


## Features
*  Colors, Gradients, Fonts 등 커스텀 가능
*  Style presets 지원
*  Supports texts and images
*  Text와 Image의 배치를 vertical 또는 horizontal로 배치가능
*  백그라운드 및 segment를 커스텀 뷰로 제공 가능
*  Haptic Feedback 제공 : 제스처로 토글 시 Haptic Feedback이 터치한 Device를 통해 전달된다.
    * `UIImpactFeedbackGenerator` 이용하여 구현함
*  **Swift** and **Objective-C** compatability
*  Written in Objective-C


## Preview
> - MGUNeoSegControl (iOS)
>   - [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 커스텀 스위치의 요구사항이 있어서 제작함.
>   - [MiniTimer](https://apps.apple.com/app/id1618148240)에서도 사용함.

MGUNeoSegControl (iOS) | [IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용한 예 | [MiniTimer](https://apps.apple.com/app/id1618148240)에서 사용 예
---|---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 13.04.15.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-17 at 13.04.42.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 Pro - 2023-05-25 at 21.37.05.gif" width="250">

[MiniTimer](https://apps.apple.com/app/id1618148240)에서 사용 예 |
---|
<img src="./screenshot/Simulator Screen Recording - iPad Pro (12.9-inch) (6th generation) - 2023-05-25 at 21.30.15.gif" width="805"> |

## Presets and Styles
> - Transition Styles (`MGUAlertViewController`에서 `transitionStyle`은 iPhone, iPad 모두 동일하게 적용된다.)
>   - 전면부: `.fgFade`, `.fgSlideFromTop`, `.fgSlideFromTopRotation`, `.fgSlideFromBottom` 중 택 1
>   - 후면부: `.bgScale` 또는 none

$~$|`.fgFade`|`.fgSlideFromTop`|`.fgSlideFromTopRotation`|`.fgSlideFromBottom`
---|---|---|---|---
$~$|<img src="./screenshot/MGUAlertViewTransitionStyleFGFade.gif" width="190">|<img src="./screenshot/MGUAlertViewTransitionStyleFGSlideFromTop.gif" width="190">|<img src="./screenshot/MGUAlertViewTransitionStyleFGSlideFromTopRotation.gif" width="190">|<img src="./screenshot/MGUAlertViewTransitionStyleFGSlideFromBottom.gif" width="190">
`.bgScale` |<img src="./screenshot/MGUAlertViewTransitionStyleFGFade_Scale.gif" width="190">|<img src="./screenshot/MGUAlertViewTransitionStyleFGSlideFromTop_Scale.gif" width="190">|<img src="./screenshot/MGUAlertViewTransitionStyleFGSlideFromTopRotation_Scale.gif" width="190">|<img src="./screenshot/MGUAlertViewTransitionStyleFGSlideFromBottom_Scale.gif" width="190">


---

> - Transition Styles (`MGUActionSheetController`에서 `transitionStyle`은 iPhone, iPad은 **다르게** 적용된다.)
>   - 아이폰: `.fgFade`, `.fgSlideFromBottom` 중 택 1
>   - 아이패드: 팝업 스타일로 자동 설정된다.

<table>
<thead>
  <tr>
    <th></th>
    <th colspan="2"><Strong>아이폰</Strong></th>
    <th>아이패드</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Transition Style</td>
    <td align="center"><code>.fgFade</code></td>
    <td align="center"><code>.fgSlideFromBottom</code></td>
    <td align="center">팝업스타일로 자동 설정됨</td>
  </tr>
  <tr>
    <td></td>
    <td><img src="./screenshot/FGFade.gif" width="170"></td>
    <td><img src="./screenshot/FGSlideFromBottom.gif" width="170"></td>
    <td rowspan="2"><img src="./screenshot/Simulator Screen Recording - iPad mini (6th generation) - 2023-06-02 at 13.32.50.gif" width="380"></td>
  </tr>
  <tr>
    <td>Full Appearance</td>
    <td><img src="./screenshot/FGFade_Full.gif" width="170"></td>
    <td><img src="./screenshot/FGSlideFromBottom_Full.gif" width="170"></td>
  </tr>
</tbody>
</table>


## Usage

> Swift
```swift

let config = MGUNeoSegConfiguration.forge()
containerView.backgroundColor = config.backgroundColor
let segmentedControl = MGUNeoSegControl.init(titles: self.dropTitleAndImageModels(),
                                       selecedtitle: "",
                                      configuration: config)
view.addSubview(segmentedControl)
segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
segmentedControl.impactOff = false

```

> Objective-C
```objective-c

MGUNeoSegControl *segmentedControl =
[[MGUNeoSegControl alloc] initWithTitles:[self imageModels]
                            selecedtitle:@"chrome"
                           configuration:[MGUNeoSegConfiguration iOS7Configuration]];
[self.view addSubview:segmentedControl];
[segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];

```

## Documentation

- 컨텐츠 배치를 위한 설계도
<img src="./screenshot/230531a1.jpg" width="1000">

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
