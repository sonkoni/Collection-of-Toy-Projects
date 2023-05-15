# AutoLayout Adaptivity 

## Device Size Classes 및 Orientation 에 따른 AutoLayout Adaptivity **테스트** 샘플
- Size classes (compact, regular)에 따른 AutoLayout Adaptivity : Swift Sample
- Orientation (Portrait, Landscape)에 따른 AutoLayout Adaptivity : Objective-C Sample
    
## Examples
> - Swift Sample
>   - Interface Builder based
>
> - Objective-C Sample
>   - Programmatically based

`Swift` |`Objective-C`
---|---
<img src="./screenshot/Simulator_Screen_Recording_iPhone_14_2023-05-13 at 9.00.05.gif" width="450">|<img src="./screenshot/Screen Recording 2023-05-15 at 12.00.52.gif" width="450">    

## Documentation

- 여기에 존재하지 않는 추가적인 문서는 다음의 기술위키 문서를 참고하세요.
    - [자동회전](http://wiki.mulgrim.net/page/Project:IOs-ObjC/자동회전)
    - [오토레이아웃](http://wiki.mulgrim.net/page/Project:IOs-ObjC/오토레이아웃)
    - [콤팩트와_레귤러](http://wiki.mulgrim.net/page/Project:IOs-ObjC/콤팩트와_레귤러)
    - [intrinsicContentSize](http://wiki.mulgrim.net/page/Api:UIKit/UIView/intrinsicContentSize)
    - [뷰 전환](http://wiki.mulgrim.net/page/Project:Mac-ObjC/뷰_전환)




<img src="./screenshot/230515a1.jpg" width="900">

- snippets : Objective-C Programmatically based
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureDataSource];
    [self updateUI];
    __weak __typeof(self) weakSelf = self;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    self.observer = [notificationCenter addObserverForName:UIDeviceOrientationDidChangeNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *note) {
        if (weakSelf.presentedViewController == nil &&
            UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) == YES) {
            ViewControllerX *vc = [ViewControllerX new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:vc animated:YES completion:^{}];
        }
    }];
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

* https://stackoverflow.com/questions/74050444/have-anyone-experienced-same-error-log-in-related-with-view-controller-orientati



## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License.
