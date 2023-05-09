# AutoLayout Animation 

## AutoLayout 변경을 애니메이션화하는 샘플
* AutoLayout의 변경 + `layoutIfNeeded` + UIView animation으로 작동한다.

## Examples

## Documentation

- [Read the full **documentation** here](http://wiki.mulgrim.net/page/Api:UIKit/UIView/-_layoutIfNeeded)
```objective-c
- (IBAction)buttonPush:(UIButton *)sender {
    [self.littleView removeFromSuperview];
    [self.testView addSubview:self.littleView];
    
    self.littleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.littleView.topAnchor constraintEqualToAnchor:self.testView.topAnchor].active = YES;
    [self.littleView.leadingAnchor constraintEqualToAnchor:self.testView.leadingAnchor].active = YES;
    
    UIViewPropertyAnimator * animator = [[UIViewPropertyAnimator alloc] initWithDuration:1.0
                                                                            dampingRatio:0.4
                                                                              animations:^{
        [self.testView layoutIfNeeded];
    }];

    [animator startAnimation];
}
```

## Bug
- `UISwitch` 토글 시 XCode 콘솔 상에서 발생하는 다음과 같은 메시지는 `UIKit` 버그에 해당한다.
```
invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. This message will only appear once per execution.
```
- [Apple Developer Forums](https://developer.apple.com/forums/thread/132035?answerId=416935022#416935022)
> Wow, that was depressingly easy to reproduce. I did a little digging and this is definitely a bug in UIKit, one that we’re tracking as (r. 57322394). The good news is that, AFAICT, it’s not actively toxic. CF is coping with this misbehaviour in a reasonable way.
> Share and Enjoy 
— 
> Quinn “The Eskimo!” 
> Apple Developer Relations, Developer Technical Support, Core OS/Hardware
``` let myEmail = "eskimo" + "1" + "@apple.com" ```


## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License.
