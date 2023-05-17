//
//  MGRDeviceMacro.h
//  Copyright © 2022 mulgrim. All rights reserved.
//

#ifndef MGRDeviceMacro_h
#define MGRDeviceMacro_h

#if (TARGET_OS_IPHONE)
#define MGR_DEVICE_IS_PHONE         ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define MGR_DEVICE_IS_PAD           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#endif

#endif /* MGRDeviceMacro_h */
