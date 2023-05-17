//
//  NSBundle+Base.h
//  BaseKit
//
//  Created by Kiro on 2022/11/09.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (KitResource)
#if TARGET_OS_OSX
@property (class, nonatomic, readonly) NSBundle *mgrMacRes;
#elif TARGET_OS_IPHONE
@property (class, nonatomic, readonly) NSBundle *mgrIosRes;
#endif
@end

@interface NSBundle (Extension)
#if TARGET_OS_OSX
- (NSString *)mgrAppName;
#endif
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-05-25 : 라이브러리 정리됨
*/
//
// https://developer.apple.com/library/archive/qa/qa1544/_index.html
// http://wiki.mulgrim.net/page/Project:Xcode/Information_Property_List/문서_해석
