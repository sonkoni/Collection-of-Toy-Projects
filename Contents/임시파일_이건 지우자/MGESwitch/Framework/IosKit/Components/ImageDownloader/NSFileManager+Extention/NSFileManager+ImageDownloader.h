//
//  NSFileManager+ImageDownloader.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ImageDownloader)

- (NSURL * _Nullable)saveImage:(NSData *)data filename:(NSString *)filename;
- (NSURL * _Nullable)save:(NSData *)data filename:(NSString *)filename directory:(NSURL *)directory;
- (NSData * _Nullable)imageDataFilename:(NSString *)filename;
- (NSData * _Nullable)dataFromDirectory:(NSURL *)directory filename:(NSString *)filename; // 최초에 이미지가 없을 때, 에러로그 출력!

- (void)removeImagesDirectory;

@end

NS_ASSUME_NONNULL_END
