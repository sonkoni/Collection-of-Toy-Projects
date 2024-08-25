//
//  NSFileManager+Date.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-02
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Date)

// path: 파일의 저장경로
- (NSDate * _Nullable)mgrCreationDateWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
