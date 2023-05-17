#  MGUButtonsPoject

## MGUSegmentedControlDemo
* NYSegmentedControlDemo을 최대한 단순화 시켰다. 문제가 생기면, 원본 소스를 살펴보자.
* https://github.com/nealyoung

* 제일 밑에 MGUSegmentedControl이 존재한다.
* 그 위에 MGUSegmentIndicator가 한개 존재한다. MGUSegmentIndicator는 MGUSegmentedControl의 서브 뷰이다.
* 그 위에 MGUSegment가 여러개 존재할 수 있다. MGUSegment는 MGUSegmentedControl의 서브 뷰이다.
    ** MGUSegment의 집합의 크기는 MGUSegmentedControl과 딱 들어 맞는다.
* 그 위에 MGUSegmentTextRenderView가 각 한개 씩 존재한다. MGUSegmentTextRenderView는 MGUSegment의 서브 뷰이다.
    ** MGUSegmentTextRenderView의 크기는 MGUSegment와 동일하다.
    ** autoresizingMask로 조절했다. autoresizingMask는 변화가 있을 때, 반응하게 된다.



## MGUNeoSegControl. Ver2
* ver1 에서의 비 효율성을 정리했다. configuration에서 2중으로 치는 것을 깔끔하게 정리했다. control의 세터 게터가 늘어나는 것을 막았다. - activeConfigurationForSegmentedControl으로 새로운 환경설정이 적용될 것이다. 예를 들어, 다크모드로 전환되거나, 새로운 configuration이 입력되었을 때, 호출될 것이다.  구 버전도 zip 파일로 묶었다. 거의 볼일은 없을 것이다.


* 아래의 모양을 참고해서 기존에 내가 만들었던 MGUSegmentedControl 을 수정해서 만들었다.
* 아래의 컨트롤은 팬이 작동하지 않는다. 그 외 여러가지 디테일에서 문제가 있었다.
* 참고할만한 HTTP 코드는 넣었다.
[sh-khashimov](https://github.com/sh-khashimov/RESegmentedControl)



## MGULivelyButton
FRDLivelyButton - objective - C 를 베이스로 만들었다.
https://github.com/sebastienwindal/FRDLivelyButton
https://github.com/yannickl/DynamicButton
https://github.com/victorBaro/VBFPopFlatButton

* clipsToBounds가 설정되지 않았다.
    가장자리를 걸쳐서 그려지는 path가 존재하기 때문이다. 그렇기 때문에 None에서 4개의 점이 보여버리는 문제가 있다.
    이것은 선택이 필요하다.


*  spring 이 부담스럽다면 아래의 주석으로 값을 변경하라.
    pathAnimation.initialVelocity  = 15.0f;
    pathAnimation.damping  = 20.0f;


## MGRButton
롱프레스도 구현되어있다.
롱프레스 방식은 두 가지가 있다.  다른 방식은 anotherLongPress.m에 정리했다.
### ripple style :  Bread or Shrink
* 원형의 radius를 사용하고 싶다면,  isRippleCircle = YES 로하라. (디폴트)
* 작은 radius를 사용하고 싶다면, 그냥 radius를 설정하면된다.

### 이미지 교환
* playPause 버튼처럼 이미지를 교환하려면, 코드로 버튼을 만들 것을 추천한다.


```objective-c anotherLongPress.m

@interface MGRHRSViewController () <MGRRulerViewDelegate, MGRSuggestionViewDelegate>

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILongPressGestureRecognizer *leftLongPressGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *rightLongPressGR;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong, nullable) dispatch_source_t gcdTimer;
@end

@implementation MGRHRSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}


#pragma mark - 생성 & 소멸

- (void)commonInit {
    self.leftLongPressGR  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.rightLongPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.leftButton  addGestureRecognizer:self.leftLongPressGR];
    [self.rightButton addGestureRecognizer:self.rightLongPressGR];
    self.leftLongPressGR.minimumPressDuration  = 0.3;
    self.rightLongPressGR.minimumPressDuration = 0.3;
}

- (void)longPress:(UILongPressGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan ) { NSLog(@"longPress 비긴 - 손가락이 눌러졌다.");
        self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
        dispatch_source_set_timer(self.gcdTimer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, NSEC_PER_SEC / 10); // 성능 및 배터리 -> tolerance 설정
        dispatch_source_set_cancel_handler(self.gcdTimer, ^{/*타이머 종료후 하고 싶은거 해라.*/});
        __weak __typeof(self)weakSelf = self;
        dispatch_source_set_event_handler(self.gcdTimer, ^{ // 실제로 작동할 메서드를 넣어라.
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)self = weakSelf;
                if (gr == self.leftLongPressGR) {
                    [self.rulerView moveFarToLeft];
                } else {
                    [self.rulerView moveFarToRight];
                }
            });
        });
        
        dispatch_source_set_registration_handler(self.gcdTimer, ^{ /* 타이머 기능 활성화됨 */}); // 디스패치 소스가 resume 될 때 실행되는 블락(엔큐 아님.)
        dispatch_resume(self.gcdTimer); // 발동
    } else if ( gr.state == UIGestureRecognizerStateEnded ) { NSLog(@"longPress 엔드 - 손가락이 떨어졌다.");
        __weak __typeof(self)weakSelf = self;
        dispatch_async(self.queue, ^{
            __strong __typeof(weakSelf)self = weakSelf;
            dispatch_source_cancel(self.gcdTimer);
            if (dispatch_source_testcancel(self.gcdTimer)) { // 0이 아니면 취소 완료. dispatch_source_cancel를 호출하여 취소가 되었는지 확인하는 함수.
                self.gcdTimer = nil;
            } else {
                NSLog(@"정상 cancel 되지 않았음. 좆됬군. 프로그램 다시 검토하라.");
            }
        });
    } else if ( gr.state == UIGestureRecognizerStatePossible   ) {
    } else if ( gr.state == UIGestureRecognizerStateRecognized ) {
    } else if ( gr.state == UIGestureRecognizerStateCancelled  ) {
    } else if ( gr.state == UIGestureRecognizerStateFailed     ) {
    } else if ( gr.state == UIGestureRecognizerStateChanged    ) {
    }
}

#pragma mark - 세터 & 게터

- (dispatch_queue_t)queue { // lazy.
    if (_queue == nil) {
        _queue = dispatch_queue_create("GCDTimerQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}

@end

```
