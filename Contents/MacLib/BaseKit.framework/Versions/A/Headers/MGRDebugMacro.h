//
//  MGRDebugMacro.h
//  Copyright © 2022 mulgrim. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-23
//  ----------------------------------------------------------------------
//

#ifndef MGRDebugMacro_h
#define MGRDebugMacro_h
#import <Foundation/Foundation.h>
// ----------------------------------------------------------------------
//  MGR_DEBUG_LINE;
//
#if DEBUG
#define MGR_DEBUG_LINE              printf("* DEBUG <%p> %s\n", self, __PRETTY_FUNCTION__)
#else
#define MGR_DEBUG_LINE
#endif


// ----------------------------------------------------------------------
//  MGR_DEBUG_LOG(객체); // 객체의 description 을 출력한다
//
#if DEBUG
#define MGR_DEBUG_LOG(OBJ)      printf("* DEBUG <%p> %s : %s\n", self, __PRETTY_FUNCTION__, [[OBJ description] UTF8String])
#else
#define MGR_DEBUG_LOG(OBJ)
#endif

#endif /* MGRDebugMacro_h */
