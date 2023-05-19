//
//  MGRDispatchGroupHelper.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
// ----------------------------------------------------------------------
//  VERSION_DATE    2021-10-23
// ----------------------------------------------------------------------
//

#ifndef MGRDispatchGroupHelper_h
#define MGRDispatchGroupHelper_h
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

// debugDescription 은 디버그 목적으로 런타임에서 사용하는 건데.
// A string that describes the object for debugging purposes.
// 암튼, 런타임에서 dispatchGroup 객체의 count 를 조회하겠다는 건데,
// 단순 조회용이 아니라 MGRDispatchGroupSafeLeave 에서 그룹을 나갈 때마다 탐색하게 되니까, dager 한 방식이다.
// 이건 디버그 단계에서는 잘 돌아가지만, 릴리즈 단계에서는 최적화 옵션이나 OS버전에 따라 먹통될 가능성이 많다.
// 가능하면 디버그 목적으로만 사용하자. DEBUG 매크로로 싸둘게 - kiro
//


NS_ASSUME_NONNULL_BEGIN

#if DEBUG
NSInteger MGRDispatchGroupGetEnterCount(dispatch_group_t dispatchGroup);

/**
* dispatch_group_leave 함수를 안전하게 사용할 수 있도록 래퍼함수에 해당한다.
* @param dispatchGroup     dispatch_group_t 타입의 인수
* @discussion              dispatch_group_leave 함수는 enter count 가 0 일때는 앱을 터지게 만든다. 따라서 count를 검사하고 사용할 수 있게 만들었다.
* @code
    NSLog(@"%@, [self.dispatchGroup debugDescription]);
    // 문자열로 다음과 같이 나온다. parsing을 통해 count를 확인하는 함수이다.
    // <OS_dispatch_group: group[0x600000027890] = { xref = 2, ref = 1, count = 0, gen = 0, waiters = 0, notifs = 0 }>
 @endcode
*/
void MGRDispatchGroupSafeLeave(dispatch_group_t dispatchGroup);

//! NSInteger MGRDispatchGroupGetEnterCount(dispatch_group_t dispatchGroup); 내부에서 static 함수로 사용함.

#endif /* DEBUG */

NS_ASSUME_NONNULL_END

#endif /* MGRDispatchGroupHelper_h */

//
// https://stackoverflow.com/questions/45610271/dispatchgroup-check-how-many-entered
