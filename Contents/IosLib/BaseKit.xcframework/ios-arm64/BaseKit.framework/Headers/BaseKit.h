//
//  BaseKit.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  Prefix : MGR
//  시스템/파운데이션/앱서비스 등과 앱로직 관련 공용 함수 제공
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

//! Project version number for BaseKit.
FOUNDATION_EXPORT double BaseKitVersionNumber;

//! Project version string for BaseKit.
FOUNDATION_EXPORT const unsigned char BaseKitVersionString[];

//! Macro
#import <BaseKit/MGRDeferMacro.h>
#import <BaseKit/MGRDispatchQueueMacro.h>
#import <BaseKit/MGRNotOverrideMacro.h>
#import <BaseKit/MGRNullMacro.h>
#import <BaseKit/MGRSafeKeypathMacro.h>
#import <BaseKit/MGRScreenMacro.h>
#import <BaseKit/MGRDeviceMacro.h>
#import <BaseKit/MGRNotAvailableMacro.h>
#import <BaseKit/MGRDebugMacro.h>
#import <BaseKit/MGRTypeMacro.h>
#import <BaseKit/MGRFanalClassMacro.h>
#import <BaseKit/MGRWarnUnusedResultMacro.h>

//! Type
#import <BaseKit/Assets.h>
#import <BaseKit/MGRSysType.h>
#import <BaseKit/MGRProtocolType.h>
#import <BaseKit/MGRStructType.h>
#import <BaseKit/MGRBlockType.h>

//! MathHelper
#import <BaseKit/MGRMathHelper.h>

//! DispatchHelper
#import <BaseKit/MGRDispatchGroupHelper.h>
#import <BaseKit/MGRDispatchDebounceHelper.h>
#import <BaseKit/MGRDispatchThrottleHelper.h>
#import <BaseKit/MGRDispatchTimerHelper.h>

//! Extension
#import <BaseKit/NSArray+Extension.h>
#import <BaseKit/NSAttributedString+Extension.h>
#import <BaseKit/NSBundle+Extension.h>
#import <BaseKit/NSCalendar+Extension.h>
#import <BaseKit/NSData+Extension.h>
#import <BaseKit/NSDate+Extension.h>
#import <BaseKit/NSDictionary+Extension.h>
#import <BaseKit/NSError+Extension.h>
#import <BaseKit/NSException+Extension.h>
#import <BaseKit/NSIndexPath+Extension.h>
#import <BaseKit/NSIndexSet+Extension.h>
#import <BaseKit/NSJSONSerialization+Extension.h>
#import <BaseKit/NSMapTable+Extension.h>
#import <BaseKit/NSMeasurement+Extension.h>
#import <BaseKit/NSNumber+Extension.h>
#import <BaseKit/NSNumberFormatter+Extension.h>
#import <BaseKit/NSObject+Extension.h>
#import <BaseKit/NSString+Extension.h>
#import <BaseKit/NSURL+Extension.h>
#import <BaseKit/NSUserDefaults+Extension.h>
#import <BaseKit/UNUserNotificationCenter+Extension.h>

//! Components
#import <BaseKit/MGRCoder.h>
#import <BaseKit/MGRCoreDataStack.h>
#import <BaseKit/MGRDelegateProxy.h>
#import <BaseKit/MGRWeakProxy.h>
#import <BaseKit/MGREmpty.h>
#import <BaseKit/MGROutlineItem.h>
#import <BaseKit/MGROutlineItem+Extension.h>
#import <BaseKit/MGRTimer.h>
#import <BaseKit/MGRPub.h>
#import <BaseKit/MGRBind.h>
#import <BaseKit/MGRRouter.h>
#import <BaseKit/MGRFidObject.h>
#import <BaseKit/MGRTagObject.h>
#import <BaseKit/MGRKeyObject.h>
#import <BaseKit/MGRPub+Foundation.h>
#import <BaseKit/MGRWeakObject.h>
#import <BaseKit/MGRResult.h>
#import <BaseKit/MGRState.h>
