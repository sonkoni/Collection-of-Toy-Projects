# FinancialKeyboard - 작성중 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)


## **SKUFinancialKeyboard** & **MGUFinancialKeyboard**
> - MGUFinancialKeyboard
>   - MGUFinancialTextField 와 연동
>   - Written in **Objective-C**, **Swift** and **Objective-C** compatability
> - SKUFinancialKeyboard
>   - SKUFinancialTextField 와 연동
>   - Written in **Swift**

- `TextField` 와 반응하여 숫자 및 특정 기호를 입력받을 수 있는 커스텀 Number Keyboard
- `UIInputView` 를 기반으로 제작함
- [MTS 프로젝트](https://www.youtube.com/playlist?list=PLFPYBBPL_u8oSMkmvaVAF8Gg3Uhb4dOWG)를 진행하면서 증권사 앱에서 사용되는 text field에 반응하는 **Number Keyboard**에 대한 요구사항이 있어서 제작함.
<p align="center"><img src="./screenshot/240827b1.jpg" width="600"></p>

## Features
* 커스텀 사이즈 가능(`intrinsicContentSize`도 가지고 있으므로 autolayout으로 position만으로도 설정 가능)
* Auto direction 지원
    * 기본적으로 popup으로 등장하는 컨텐츠는 버튼의 아래쪽 등장한다. 
    * 그러나 만약 컨텐츠가 아래쪽에 등장했을 때, 가시권에서 벗어나는 경우라면 팝업 직전에 내부적으로 계산하여 위치를 자동 조정된다.
* Auto Height 지원
    * popup될 컨텐츠 리스트가 대량이어서 여유공간보다 클 경우 자동으로 컨텐츠 컨테이너가 조정되고 스크롤 가능하게된다.
* 회전 시 위치 재조정 지원
    * 화면 회전 시, 이미 표시된 팝오버는 현재 화면 상태에 맞게 위치가 자동으로 재조정되거나, 필요에 따라 자동으로 사라지게 하는 것을 선택할 수 있다.
    * `@property (nonatomic, getter=isDismissOnRotation) BOOL dismissOnRotation;`
*  Style presets 지원
    * 5가지의 presets 
    * Presets에 추가적 커스텀 가능 
*  Text alignment 설정가능 - `TextDropdownCell` 일때
    * Place holder text alignment를 설정가능
    * Content text alignment를 설정가능
* MGUDropdownButton
    * Written in **Objective-C**, **Swift** and **Objective-C** compatability
* SKUDropdownButton
    * Written in **Swift**


## Preview
> - SKUDropdownButton (Written in swift)
>   - [MTS 프로젝트](https://www.youtube.com/playlist?list=PLFPYBBPL_u8oSMkmvaVAF8Gg3Uhb4dOWG)를 진행하면서 증권사 앱에서 사용되는 **Dropdown Button**에 대한 요구사항이 있어서 제작함.
> - MGUDropdownButton (Written in Objective-C, **Swift** and **Objective-C** compatability)
 
SKUDropdownButton - line | SKUDropdownButton - text | SKUDropdownButton - dash | SKUDropdownButton - image | SKUDropdownButton - fill type
---|---|---|---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 15 Pro - 2024-08-26 at 17.39.04.gif" width="180"> | <img src="./screenshot/Simulator Screen Recording - iPhone 15 Pro - 2024-08-26 at 17.40.25.gif" width="180"> | <img src="./screenshot/Simulator Screen Recording - iPhone 15 Pro - 2024-08-26 at 17.41.31.gif" width="180"> | <img src="./screenshot/Simulator Screen Recording - iPhone 15 Pro - 2024-08-26 at 17.42.30.gif" width="180"> | <img src="./screenshot/Simulator Screen Recording - iPhone 15 Pro - 2024-08-26 at 17.43.05.gif" width="180">


<br/>

> - SKUDropSegControl (Written in swift)
>   - [MTS 프로젝트](https://www.youtube.com/playlist?list=PLFPYBBPL_u8oSMkmvaVAF8Gg3Uhb4dOWG)를 진행하면서 증권사 앱에서 사용되는 **Dropdown SegmentedControl**에 대한 요구사항이 있어서 제작함.
> - MGUDropSegControl (Written in Objective-C, **Swift** and **Objective-C** compatability)

SKUDropSegControl |
---|
<img src="./screenshot/Simulator Screen Recording - iPhone 15 Pro - 2024-08-26 at 17.43.34.gif" width="180"> |

## Presets and Styles
> Built-in configuration

Text|Image|Dash|Line
---|---|---|---
<img src="./screenshot/240827c1.jpg" width="110"> |<img src="./screenshot/240827c2.jpg" width="110">|<img src="./screenshot/240827c3.jpg" width="110">|<img src="./screenshot/240827c4.jpg" width="110">

## Usage

> Swift
```swift

let dropdownButton = SKUDropdownButton()
dropdownButton.cellClass = SKUTextDropdownCell.self
dropdownButton.dropdownData = ["전봉색상", "전값대비", "보합색"]
dropdownButton.selectedIndex = 0
dropdownButton.dismissOnRotation = false // 회전 시 안사라지게 할 수 있다.
dropdownButton.placeHolderTextAlignment = .right
dropdownButton.textAlignment = .left
dropdownButton.addTarget(self, action: #selector(dropdownBtnValueChanged(_:)), for: .valueChanged)
contentView.addSubview(dropdownButton)
dropdownButton.skhPinCenterToSuperviewCenterWithFixSize(CGSize(width: 90.0, height: 28.0))

```

> Objective-C
```objective-c

self.dropdownButton = [MGUDropdownButton new];
self.dropdownButton.cellClass = [MGUTextDropdownCell class];
self.dropdownButton.dropdownData = @[@"전봉색상", @"전값대비", @"보합색"];
self.dropdownButton.dismissOnRotation = NO; // 회전 시 안사라지게 할 수 있다.
self.dropdownButton.selectedIndex = 0;
self.dropdownButton.placeHolderTextAlignment = NSTextAlignmentRight;
self.dropdownButton.textAlignment = NSTextAlignmentLeft;
[self.dropdownButton addTarget:self action:@selector(dropdownBtnValueChanged:) forControlEvents:UIControlEventValueChanged];
[self.contentView addSubview:self.dropdownButton];
[self.dropdownButton mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(90.0, 28.0)];

```

## Documentation
- 회전 시 위치 재조정 지원
    - 화면 회전 시, 이미 표시된 팝오버는 현재 화면 상태에 맞게 위치가 자동으로 재조정되거나, 필요에 따라 자동으로 사라지게 하는 것을 선택할 수 있다.
    ```objective-c
    @property (nonatomic, getter=isDismissOnRotation) BOOL dismissOnRotation;
    
    self.dropdownButton.dismissOnRotation = NO; // 회전 시 팝업된 컨텐츠의 위치 재조정
    ```
    
default |`self.dropdownButton.dismissOnRotation = NO;`
---|---
<img src="./screenshot/Screen Recording 2024-08-27 at 13.13.11.gif" width="450">|<img src="./screenshot/Screen Recording 2024-08-27 at 13.12.36.gif" width="450">

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
