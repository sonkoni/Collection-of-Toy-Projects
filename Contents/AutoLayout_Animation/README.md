# AutoLayout Animation 

## AutoLayout 변경을 애니메이션화하는 샘플

 UIViewPropertyAnimator
autolayout 을 먹이면서 애니메이션을 사용할 수 있다.


http://wiki.mulgrim.net/page/Api:UIKit/UIView/-_layoutIfNeeded


이 코드는 버튼을 누르면 littleView를 testView의 맨 위 왼쪽 모서리에 추가하고, 애니메이션을 사용하여 littleView를 부드럽게 표시하는 예제입니다.

layoutIfNeeded 메서드는 현재 뷰 계층 구조에 대해 변경 사항이 있을 때마다 레이아웃 시스템이 뷰의 레이아웃을 업데이트하도록 강제합니다. 이 메서드는 이전에 발생한 모든 레이아웃 변경 사항을 적용한 후에 새로운 레이아웃을 계산하므로, 애니메이션을 사용할 때 유용합니다.

애니메이션 블록은 UIViewPropertyAnimator 객체로 생성됩니다. 이 객체를 사용하여 애니메이션을 설정하고 실행합니다. 이 예제에서는 뷰의 레이아웃을 변경하고 변경 사항을 적용하기 위해 layoutIfNeeded를 호출하고, 해당 애니메이션을 animator.startAnimation 메서드를 호출하여 실행합니다. 이 과정에서 오토레이아웃 엔진이 변경된 레이아웃 제약을 계산하여 애니메이션 효과를 생성합니다.

즉, layoutIfNeeded는 현재 변경된 제약조건에 따라 View의 프레임을 업데이트하는 역할을 합니다. UIViewPropertyAnimator를 사용하여 layoutIfNeeded 메서드를 실행하면 시스템이 레이아웃 업데이트를 자동으로 애니메이션화합니다. 따라서, 애니메이션이 적용된 화면 전환이 가능합니다.


## Documentation

- 문서는 아래 링크를 참고하세요.
[Read the full **documentation** here](http://wiki.mulgrim.net/page/Api:UIKit/UIView/-_layoutIfNeeded)

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

AutoLayout Animation is available under the MIT license. See the LICENSE file for more info.
