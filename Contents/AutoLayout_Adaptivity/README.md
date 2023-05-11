# AutoLayout Adaptivity 

## Device Size Classes 및 Orientation 에 따른 AutoLayout Adaptivity **테스트** 샘플
- AutoLayout의 변경 + `layoutIfNeeded` + UIView animation으로 작동한다.
    - 애니메이션 블락 내부에서 `layoutIfNeeded`를 호출해야한다. 
    
## 현재 테스트
## 💻 STACK

![](https://img.shields.io/badge/Javascript-F7DF1E?style=flat-square&logo=JavaScript&logoColor=black)
![](https://img.shields.io/badge/Swift-FA7343?style=flat-square&logo=Swift&logoColor=white)
<br>
![](https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=HTML5&logoColor=white)
![](https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=CSS3&logoColor=white)
![](https://img.shields.io/badge/PostCSS-DD3A0A?style=flat-square&logo=PostCSS&logoColor=white)
<br>
![](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=React&logoColor=black)
![](https://img.shields.io/badge/Redux-764ABC?style=flat-square&logo=Redux&logoColor=white)
![](https://img.shields.io/badge/ReduxSaga-999999?style=flat-square&logo=Redux-Saga&logoColor=white)
![](https://img.shields.io/badge/GraphQL-E10098?style=flat-square&logo=GraphQL&logoColor=white)
<br>
![](https://img.shields.io/badge/Netlify-00C7B7?style=flat-square&logo=Netlify&logoColor=white)
![](https://img.shields.io/badge/MSAzure-0078D4?style=flat-square&logo=MicrosoftAzure&logoColor=white)

## Examples
> - Swift Sample
>
> - Objective-C Sample

`Swift`|```Objective-C```
---|---
<img src="./screenshot/Simulator_Screen_Recording_iPhone_14_Pro_2023_05_10_at_15.40.16.800px.gif" width="250">|<img src="./screenshot/Simulator_Screen_Recording_iPhone_14_Pro_2023_05_10_at_15.40.27.mp4.gif" width="250">


## Documentation

- [Read the full **documentation** here](http://wiki.mulgrim.net/page/Api:UIKit/UIView/-_layoutIfNeeded)

```swift

@objc private func switchToggled(_ sender: UISwitch) {
    sender.isEnabled = false
    centerYConstraint.isActive = false
    if sender.isOn == true {
        centerYConstraint = targetView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        widthConstraint.constant = 100.0
    } else {
        centerYConstraint = targetView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)
        widthConstraint.constant = 50.0
    }
    centerYConstraint.isActive = true
        
    let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) {
        self.view.layoutIfNeeded() // 애니메이션 블락 안에서 layoutIfNeeded 메서드를 호출해야한다. 
    }
    animator.addCompletion { _ in
        sender.isEnabled = true
    }
    animator.startAnimation()
}

```

## Bug
### System Bug
- `UISwitch` 토글 시 XCode 콘솔 상에서 발생하는 다음과 같은 메시지는 `UIKit` 버그에 해당한다.
```
invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. This message will only appear once per execution.
```
- [Apple Developer Forums](https://developer.apple.com/forums/thread/132035?answerId=416935022#416935022) 에서 애플의 엔지니어가 버그를 인정했다.
> Wow, that was depressingly easy to reproduce. I did a little digging and this is definitely a bug in UIKit, one that we’re tracking as (r. 57322394). The good news is that, AFAICT, it’s not actively toxic. CF is coping with this misbehaviour in a reasonable way.
>
> Share and Enjoy
>
>   —
>
> Quinn "The Eskimo!"
>
> Apple Developer Relations, Developer Technical Support, Core OS/Hardware
>  ```
>  let myEmail = "eskimo" + "1" + "@apple.com"
>  ```


## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License.
