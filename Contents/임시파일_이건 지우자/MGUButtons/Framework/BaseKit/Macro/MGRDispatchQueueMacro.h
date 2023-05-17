//
//  MGRDispatchQueueMacro.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-07-05
// ----------------------------------------------------------------------
//  dispatch queue 각종 형태에 대한 매크로 지원. 우선순위는 그냥 0순위로 통일했다.
//      디스패치 메인큐(시스템 제공)
//          MGR_MAIN_QUEUE
//      디스패치 글로벌큐(시스템 제공)
//          MGR_GLOBAL_QUEUE_HIGH
//          MGR_GLOBAL_QUEUE
//          MGR_GLOBAL_QUEUE_LOW
//          MGR_GLOBAL_QUEUE_BACK
//      디스패치 커스텀 직렬큐 - 라벨을 c형 문자열로 넣는다
//          MGR_SERIAL_QUEUE_HIGH("com.mulgrim.hello-world")
//          MGR_SERIAL_QUEUE("com.mulgrim.hello-world")
//          MGR_SERIAL_QUEUE_LOW("com.mulgrim.hello-world")
//          MGR_SERIAL_QUEUE_BACK("com.mulgrim.hello-world")
//      디스패치 커스텀 병렬큐 - 라벨을 c형 문자열로 넣는다. 디스패치 배리어를 사용하려면 이걸 써야 한다
//          MGR_CONCURRENT_QUEUE_HIGH("com.mulgrim.hello-world")
//          MGR_CONCURRENT_QUEUE("com.mulgrim.hello-world")
//          MGR_CONCURRENT_QUEUE_LOW("com.mulgrim.hello-world")
//          MGR_CONCURRENT_QUEUE_BACK("com.mulgrim.hello-world")
// ----------------------------------------------------------------------
//

#ifndef MGRDispatchQueueMacro_h
#define MGRDispatchQueueMacro_h


// 시스템 직렬큐 : dispatch_queue_t 혹은 dispatch_queue_main_t 로 받음
#define MGR_MAIN_QUEUE           dispatch_get_main_queue()

// 시스템 병렬큐 : dispatch_queue_t 혹은 dispatch_queue_global_t 로 받음
#define MGR_GLOBAL_QUEUE_HIGH    dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
#define MGR_GLOBAL_QUEUE         dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
#define MGR_GLOBAL_QUEUE_LOW     dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
#define MGR_GLOBAL_QUEUE_BACK    dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

// 커스텀 직렬큐 : dispatch_queue_t 로 받음
#define MGR_SERIAL_QUEUE_HIGH(cLabel)   \
    dispatch_queue_create(cLabel, dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0))
#define MGR_SERIAL_QUEUE(cLabel)        \
    dispatch_queue_create(cLabel, DISPATCH_QUEUE_SERIAL)
#define MGR_SERIAL_QUEUE_LOW(cLabel)    \
    dispatch_queue_create(cLabel, dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0))
#define MGR_SERIAL_QUEUE_BACK(cLabel)   \
    dispatch_queue_create(cLabel, dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0))

// 커스텀 병렬큐 : dispatch_queue_t 로 받음
#define MGR_CONCURRENT_QUEUE_HIGH(cLabel)   \
    dispatch_queue_create(cLabel, dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, 0))
#define MGR_CONCURRENT_QUEUE(cLabel)        \
    dispatch_queue_create(cLabel, DISPATCH_QUEUE_CONCURRENT)
#define MGR_CONCURRENT_QUEUE_LOW(cLabel)    \
    dispatch_queue_create(cLabel, dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0))
#define MGR_CONCURRENT_QUEUE_BACK(cLabel)   \
    dispatch_queue_create(cLabel, dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_BACKGROUND, 0))


#endif /* MGRDispatchQueueMacro_h */

/*  ----------------------------------------------------------------------
    프로퍼티에는 strong 으로 잡는다. 아래 예시 참고
 
    @property (nonatomic, strong) dispatch_queue_global_t globalWorkingQueue;
 
    dispatch_queue_t workingQueue = MGR_SERIAL_QUEUE_BACK("com.mulgrim.hello-world");
    dispatch_async(workingQueue, ^{...});
    dispatch_async(MGR_GLOBAL_QUEUE, ^{...});
*/
