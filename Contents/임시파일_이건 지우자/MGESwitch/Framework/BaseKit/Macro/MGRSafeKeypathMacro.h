//
//  MGRSafeKeypathMacro.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-10-25
//  ----------------------------------------------------------------------
//  키패스를 안전하게 넣을 수 있다.
//

#ifndef MGRSafeKeypathMacro_h
#define MGRSafeKeypathMacro_h
#import <Foundation/Foundation.h>

// 다음은 base 를 포함하여 모두 적어주면, 모두 담긴다.  ex) @"self.label.text"
//      [self setValue:aString forKeyPath:MGR_KEYPATH(self.someLabel.text)];
#define MGR_KEYPATH(fullPath)            YES ? @#fullPath : (fullPath ? @"": nil)

// 다음은 base와 path 를 나눠서 적어준다. 그러면 path 만 담긴다 ex) @"someLabel.text"
//      [self setValue:aString forKeyPath:MGR_KEYPATH_FROM(self, someLabel.text)];
//      [self.someLabel setValue:aString forKeyPath:MGR_KEYPATH_FROM(self.someLabel, text)];
#define MGR_KEYPATH_FROM(base, path)     YES ? @#path : ((base ?: base.path) ? @"" : nil)

#endif /* MGRSafeKeypathMacro_h */

/*  ----------------------------------------------------------------------
    참고: https://holtwick.de/blog/keypath-refatoring
    1. 그냥 @"self.someObj.text" 하게 되면 자동완성이 안 되니까 입력해보고 양쪽을 싸게 되는데, 그걸 자동으로 해준다.
    2. 키패스를 입력해뒀는데, 나중에 프로퍼티 이름을 바꾸게 되면 런타임에서 에러가 터진다.
       이 매크로를 쓸 경우 스위프트처럼 존재검사를 하기 때문에 방어를 할 수 있다.
 *  1.1     2020-10-25      : MGR_ prefix
 *  1.0     2020-07-05      : 생성
 *
 */
