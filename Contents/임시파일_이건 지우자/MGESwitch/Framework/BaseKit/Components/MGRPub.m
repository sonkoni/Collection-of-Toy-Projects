//
//  MGRPub.m
//  Created by Kiro on 2022/12/07.
//

#import "MGRPub.h"
#import <BaseKit/MGRDebugMacro.h>
//#if TARGET_OS_OSX
//#define THREAD_COUNT            16
//#elif TARGET_OS_IPHONE
//#define THREAD_COUNT            8
//#endif

#if DEBUG && MGRPUB_DEBUG
#define PUB_DEBUG_LINE              MGR_DEBUG_LINE
#define PUB_DEBUG_LOG(OBJ)          MGR_DEBUG_LOG(OBJ)
#else
#define PUB_DEBUG_LINE
#define PUB_DEBUG_LOG(OBJ)
#endif

@implementation MGRPub
+ (dispatch_queue_t)queue:(MGRPubQueue)queueType {
    if (queueType == MGRPubQueueHigh) {
        return dispatch_queue_create("MGRPub.High", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0));
    }
    if (queueType == MGRPubQueueLow) {
        return dispatch_queue_create("MGRPub.Low", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0));
    }
    if (queueType == MGRPubQueueBack) {
        return dispatch_queue_create("MGRPub.Back", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0));
    }
    return dispatch_get_main_queue();
}
- (void)dealloc {PUB_DEBUG_LINE;}
- (MGRPub *)parent {return nil;}
- (void)subscribe:(MGRPubToken *)listener {}
- (void)unsubscribe:(MGRPubToken *)listener {}
- (MGRPubQueue)queueType {return 0;}
@end
