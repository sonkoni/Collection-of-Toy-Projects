# AutoLayout Animation 

## AutoLayout 변경을 애니메이션화하는 샘플
* AutoLayout의 변경 + `layoutIfNeeded` + UIView animation으로 작동한다.

## Examples

## Documentation

[Read the full **documentation** here](http://wiki.mulgrim.net/page/Api:UIKit/UIView/-_layoutIfNeeded)
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

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License.
