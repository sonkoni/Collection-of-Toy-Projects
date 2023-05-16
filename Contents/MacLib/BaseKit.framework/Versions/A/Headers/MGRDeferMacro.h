//
//  MGRDefer.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-04-24
//  ----------------------------------------------------------------------
// 스코프를 벗어날 때 블락을 실행시키는 Defer 이다. 아래와 같이 쓰면 된다.
//      MGR_DEFER {
//          NSLog(@"스코프 벗어나면 때려라");
//      };
//

#ifndef MGRDeferMacro_h
#define MGRDeferMacro_h
#import <Foundation/Foundation.h>

// 데퍼로 때릴 공개함수
void MGRDeferExecuteCleanupBlock(__strong dispatch_block_t *block);

// 아래에서 매크로를 이용해 문구와 현재 줄번호를 합쳐서 'mgr_exit_block_54' 와 같이 만들 것이다.
// 기본 매크로 __LINE__ 을 이용하기 위해 매크로 두 개를 포갰다. 혹시라도 defer 를 여러 개 쓸 경우 이름이 겹칠까 해서 소스코드 줄번호 넣음...
#define __MGRDefer_METAMACRO_CONCAT(A, B)      __MGRDefer_METAMACRO_CONCAT_(A, B)
#define __MGRDefer_METAMACRO_CONCAT_(A, B)     A##B

// 아래 매크로는 다음과 같은 블락(예를 들어 23 은 현재 줄번호)을 컴파일러 cleanup 지시자를 이용해 MGRDeferExecuteCleanupBlock 함수를 치게 만들 것이다.
//   void (^mgr_exit_block_23)(void) = ^{...};
//   이걸 이렇게 ==>>   __strong MGRDeferBlock mgr_exit_block_23 __attribute__((cleanup(MGRDeferExecuteCleanupBlock), unused)) = ^{...};
//
//  * 매크로 __MGRDefer_METAMACRO_CONCAT(mgr_exit_block_, __LINE__) 를 이용해 mgr_exit_block_23 과 같이 '텍스트+줄번호'로 블락 이름을 만들 것이다.
//         이렇게 한 이유는 cleanup 은 특정 변수에 선언되기 때문에 변수 이름이 있어야 한다.
//  * 컴파일러 지시자 __attribute__((cleanup(함수이름))) 는 스코프를 벗어나면 함수를 때릴거야
//  * 컴파일러 지시자 __attribute__((__unused__)) 는 매크로 __unused 이다. 현재 스코프에서 변수를 선언만 하고 사용하지 않아도 경고하지 마.
//         이렇게 한 이유는 컴파일러가 변수를 사용하지 않으면 노랑 경고가 뜨기 때문이다.
//         여기에서는 해당 스코트에서 블락으로 선언된 변수를 쓰지 않고 그 스코프를 벗어나서 사용할 것이기 때문에 정상적인 코드이다. 따라서 경고하지 마라.
//
#define MGR_DEFER \
    __strong dispatch_block_t __MGRDefer_METAMACRO_CONCAT(mgr_exit_block_, __LINE__) __attribute__((cleanup(MGRDeferExecuteCleanupBlock), unused)) = ^


#endif /* MGRDeferMacro_h */


//  우연하게 cleanup 컴파일러 지시자를 알게 됐는데, 이게 함수 스코프 밖을 벗어나 특정 지역변수가 죽을 때 특정 함수를 때릴 수 있는 기능이다.
//  이를 이용하면 defer 를 구현할 수 있다. 별로 쓰잘데 없는 것처럼 보이지만,
//  특정 메서드나 함수에서 return 이 발생한 이후에 실행되어야 하거나 async 관련 코드 등에서 사용하기 좋다.
//
//  암튼 스위프트 defer 와 똑같다.
//  - (매우중요) defer 는 여러 개 걸 수 있는데, 나중에 걸린 새끼가 스코프를 벗어날 때 먼저 실행된다.
//             스택이다. 먼저 쌓은 놈이 제일 밑에 깔리고 늦게 쌓인 놈이 제일 위에 있다. 그래서 실행은 역순
//
//  관현이가 보여준 YUDisplacementTransition 프로젝트의 내부에서 사용하는 MetalPetal 프레임워크에서 가져왔다.
//  위의 cleanup 컴파일러 지시자 아이디어를 defer로 잘 구현해 놓았다. 좋구만.
//  골뱅이 @ 를 사용하기 위해 try-finaly 로 래핑한 코드는 쓰잘데 없어서 빼버렸다. 나머지 똑같다.
//      https://github.com/MetalPetal/MetalPetal
//      https://github.com/YuAo/YUDisplacementTransition
//
