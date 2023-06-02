# Alert & Action Sheet 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)


## **MGUAlertViewController** & **MGUActionSheetController**
- `MGUAlertViewController`, `MGUActionSheetController`는 `UIAlertController` 보다 더 많은 기능과 디자인의 자유도를 보장하는 커스텀 AlertController
    - `UIViewControllerTransitioningDelegate` 프로토콜을 따르는 `UIViewController` 서브클래스로 `MGUAlertViewController`를 제작함
        - `UIPresentationController`의 커스텀 서브클래스를 이용해 프르젠테이션의 초기 설정을 관할하게함
        - `UIViewControllerAnimatedTransitioning`을 따르는 커스텀 클래스를 이용하여 present 및 dismiss를 관할하는 객체를 구성함
    - `MGUActionSheetController`는 `MGUAlertViewController`의 서브클래스로 제작함
- [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 커스텀 AlertViewController 및 ActionSheetController의 요구사항이 있어서 제작함. 
<p align="center"><img src="./screenshot/230602a1.jpg" width="1000"></p>


## Features
* `UIAlertController` 과 유사한 구성 및 일반 `UIViewController` 프리젠트와 동일한 메서드(`present(_:animated:completion:)`)를 이용하여 present 및 dismiss
* `UIAlertController` 과 유사한 방식으로 `UITextField` 추가
* `UIAlertController` 과 유사한 방식으로 `MGUActionSheetController`는 iPad에서 프리젠트 시에 popover 스타일 지원
    * `MGUActionSheetController`는 iPad에서 백그라운드 터치로 자동 dimiss 호출됨
*  세 가지 서로 다른 커스텀 content view를 제공하여 구성 및 디자인의 자유도를 높임
*  백그라운에 대하여 Dim 스타일 또는 blur 스타일을 선택 가능
*  `MGUAlertViewController`는 pan gesture로 dimiss 가능(On/Off 가능). 백그라운드 터치로 dimiss 가능(On/Off 가능)
*  제공되는 텍스트(타이틀, 메시지, 버튼)의 font, color, 배경색 설정가능
*  다양한Transition Styles 제공 - [Presets and Styles](#presets-and-styles) 참고
    * `MGUAlertViewController`
        * Presented ViewController 에 대한 4가지 스타일 제공 
        * Presenting ViewController 에 대한 Scale Shrink 스타일 제공
    * `MGUActionSheetController`
        * iPhone 에서 Presented ViewController 에 대한 2가지 스타일 제공
        * iPad 에서 팝오버 스타일 제공
*  **Swift** and **Objective-C** compatability
*  Written in Objective-C


## Preview
> - MGUAlertViewController
>   - [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 커스텀 AlertViewController의 요구사항이 있어서 제작함.
>   - [MiniTimer](https://apps.apple.com/app/id1618148240)에서도 사용함.


No Button|Three Buttons|TextField|Custom Font|Long Message
:---:|:---:|:---:|:---:|:---:
<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.04.39.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.05.07.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.06.35.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.06.43.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.06.56.gif" width="175">
**Custom Content View**|**Custom Content View**|**Custom Content View**|**[IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용**|**[IV-Drop](https://apps.apple.com/app/id1574452904) Onboarding**
<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 14.34.47.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 14.35.04.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 14.35.16.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 14.35.47.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 14.36.12.gif" width="175">


----

> - MGUActionSheetController
>   - [IV-Drop](https://apps.apple.com/app/id1574452904)을 만들면서 커스텀 ActionSheetController의 요구사항이 있어서 제작함.
>   - 아이패드에서는 Transition Style이  팝업 스타일로 자동 설정된다.


$~$|**[IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용**|**[IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용**|**[IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용**|**[IV-Drop](https://apps.apple.com/app/id1574452904)에서 사용**
:---:|:---:|:---:|:---:|:---:
<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.28.53.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.28.59.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.29.08.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.29.28.gif" width="175">|<img src="./screenshot/Simulator Screen Recording - iPhone SE (3rd generation) - 2023-06-02 at 15.29.36.gif" width="175">


<table>
<thead>
  <tr>
    <th colspan="2">아이패드에서 Preview</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><img src="./screenshot/Simulator Screen Recording - iPad mini (6th generation) - 2023-06-02 at 15.57.16.gif" width="480"></td>
    <td><img src="./screenshot/Simulator Screen Recording - iPad mini (6th generation) - 2023-06-02 at 15.57.24.gif" width="480"></td>
  </tr>
</tbody>
</table>


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
>   - 아이폰: `.fgFade`, `.fgSlideFromBottom` 중 택 1, configuration의 `isFullAppearance`를 `true`로 설정하면 꽉찬 모양으로 표기됨.
>   - 아이패드: 팝업 스타일로 자동 설정된다.

<table>
<thead>
  <tr>
    <th></th>
    <th colspan="2">아이폰</th>
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

let title = "타이틀"
let message = "메시지"

let configuration = MGUAlertViewConfiguration()
configuration.transitionStyle = [.fgSlideFromTop, .bgScale]
configuration.backgroundTapDismissalGestureEnabled = true
configuration.swipeDismissalGestureEnabled = true
configuration.alwaysArrangesActionButtonsVertically = false

let okActionHandler = { (action: MGUAlertAction?) -> Void in
    print("Ok 버튼 눌렀음.")
}
let okAction = MGUAlertAction.init(title: "Ok", style: .default, handler: okActionHandler, configuration: nil)

let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
    print("Cancel 버튼 눌렀음.")
}
let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)
        
let alertViewController = MGUAlertViewController(configuration: configuration, title: title, message: message, actions: [okAction, cancelAction])
present(alertViewController, animated: true)

```

----

> Objective-C
```objective-c

NSString *title = @"타이틀";
NSString *message = @"메시지";

MGUAlertViewConfiguration *configuration = [MGUAlertViewConfiguration new];
configuration.transitionStyle = MGUAlertViewTransitionStyleFGSlideFromTop | MGUAlertViewTransitionStyleBGScale;
configuration.backgroundTapDismissalGestureEnabled = YES;
configuration.swipeDismissalGestureEnabled = YES;
configuration.alwaysArrangesActionButtonsVertically = NO;

void (^okActionHandler)(MGUAlertAction * _Nonnull) = ^(MGUAlertAction * _Nonnull action) { NSLog(@"Ok 버튼 눌렀음.");};
MGUAlertAction *okAction = [[MGUAlertAction alloc] initWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:okActionHandler
                                                   configuration:nil];

void (^cancelActionHandler)(MGUAlertAction * _Nonnull) = ^(MGUAlertAction * _Nonnull action) { NSLog(@"Cancel 버튼 눌렀음.");};
MGUAlertAction *cancelAction = [[MGUAlertAction alloc] initWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:cancelActionHandler
                                                       configuration:nil];

MGUAlertViewController *alertViewController = [[MGUAlertViewController alloc] initWithConfiguration:configuration
                                                                                              title:title
                                                                                            message:message
                                                                                            actions:@[okAction, cancelAction]];
[self presentViewController:alertViewController animated:YES completion:nil];

```

## Documentation

- 컨텐츠 배치를 위한 설계도
<img src="./screenshot/230531a1.jpg" width="1000">

- 위키 링크 넣자.

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## Credits

샘플에서 사용된 아래의 [이미지](https://www.istockphoto.com/kr/벡터/화려한-하늘과-바위가있는-아름다운-해변의-일몰-gm1408146499-459099221)의 Author는 [John Alberton](https://www.istockphoto.com/kr/portfolio/JohnAlberton?mediatype=illustration)

[<img src="./screenshot/JohnAlberton.jpg" width="200">](https://www.istockphoto.com/kr/벡터/화려한-하늘과-바위가있는-아름다운-해변의-일몰-gm1408146499-459099221)

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
