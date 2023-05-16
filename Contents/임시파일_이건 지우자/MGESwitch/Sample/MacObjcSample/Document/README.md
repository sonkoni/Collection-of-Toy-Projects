#  MGASwitch_Project

[iluuu1994](https://github.com/iluuu1994/ITSwitch) <- 원본.
[OskarGroth](https://github.com/OskarGroth/OGSwitch)

## 버그
* IB_DESIGNABLE 버그가 존재한다. static framework로 전환하면서 발생하는 버그를 렌더링 버그를 해결을 못하겠다. xib에서 설정은 가능하다. 그러나 렌더링이 되지 않는다. 땜빵으로 current project에서 빈 서브클래스를 만들어서 사용하면 렌더링이 된다. 그러나 불필요할 것 같아서 추천하지는 못하겠다.

## 스택뷰 쓰는 거 좆같다.
### 스택뷰의 서브뷰의 Content Compression Resitance Priority를 499로 맞췄다.
### 스택뷰의 눈이 보이는 Priority를 최대로 올렸다. 맞는지 모르겠다.
### 스택뷰를 Equal로 맞췄어도 겹치다 보면 못찾을 수 있다. 서브뷰 Equal도 강제로 한번 더 잡아주자.
### http://wiki.mulgrim.net/page/Project:Solution/스택뷰#Mac_OS


### 설정 
###* MainMenu.xib 를 분리해서 프로그래머틱하게 초기화했다.
###* - applicationShouldHandleReopen:hasVisibleWindows: Single-window app을 x 버튼 눌렀다가 독을 클릭하면 메인 윈도우가 뜨지 않은 현상을 해결한다.
