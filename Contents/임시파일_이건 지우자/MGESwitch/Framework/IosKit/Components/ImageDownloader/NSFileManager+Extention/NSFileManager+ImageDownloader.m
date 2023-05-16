//
//  NSFileManager+ImageDownloader.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import "NSFileManager+ImageDownloader.h"
@import BaseKit;

@implementation NSFileManager (ImageDownloader)

- (NSURL * _Nullable)saveImage:(NSData *)data filename:(NSString *)filename {
    NSURL *directory = [self imagesDirectory];
    if (directory == nil) {
        return nil;
    }
    
    return [self save:data filename:filename directory:directory];
}

- (NSURL * _Nullable)save:(NSData *)data filename:(NSString *)filename directory:(NSURL *)directory {
    NSURL *fileLocation = [directory URLByAppendingPathComponent:filename];
    
    @try {
        NSError *error; // 여러번의 try catch를 이용할 경우 위로 빼줘도 괜찮다.
        [data writeToURL:fileLocation
                 options:0
                   error:&error];
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
    }
    
    return fileLocation;
}

- (NSData * _Nullable)imageDataFilename:(NSString *)filename {
    NSURL *directory = [self imagesDirectory];
    if (directory == nil) {
        return nil;
    }
    
    return [self dataFromDirectory:directory filename:filename];
}

//! 최초에 ImageDownloader에서 - downloadImageUrl:completion: 에서 chache 이미지가 없을 때, 이곳의 로그가 출력된다.
- (NSData * _Nullable)dataFromDirectory:(NSURL *)directory filename:(NSString *)filename {
    NSURL *fileLocation = [directory URLByAppendingPathComponent:filename];
    NSData *data = nil;
    @try {
        NSError *error; // 여러번의 try catch를 이용할 경우 위로 빼줘도 괜찮다.
        data = [NSData dataWithContentsOfURL:fileLocation options:0 error:&error];
        [error mgrMakeExceptionAndThrow];
        
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        return nil;
    }
    return data;
}

- (void)removeImagesDirectory {
    NSURL *imagesDirectory = [self imagesDirectory];
    if (imagesDirectory == nil) {
        return;
    }
    
    @try {
        NSError *error; // 여러번의 try catch를 이용할 경우 위로 빼줘도 괜찮다.
        [self removeItemAtURL:imagesDirectory
                        error:&error];
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
    }
}


#pragma mark - Private
- (NSURL * _Nullable)imagesDirectory {
    NSURL *directory = [self directory];
    if (directory == nil) {
        return nil;
    }
    
    NSURL *imagesDirectory = [directory URLByAppendingPathComponent:@"images" isDirectory:YES];
    
    @try {
        NSError *error; // 여러번의 try catch를 이용할 경우 위로 빼줘도 괜찮다.
        [self createDirectoryAtPath:imagesDirectory.path
        withIntermediateDirectories:YES
                         attributes:nil
                              error:&error];
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
    }
    
    return imagesDirectory;
}

/// Bundle directory in cache directory
- (NSURL * _Nullable)directory {
    NSURL *cacheDirectory = [self URLsForDirectory:NSCachesDirectory
                                         inDomains:NSUserDomainMask].firstObject;
    
    //! [NSBundle bundleForClass:[MGUNeoSegControl class]].bundleIdentifier;
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    if (cacheDirectory == nil || bundleIdentifier == nil) {
        return nil;
    }
    
    NSURL *directory = [cacheDirectory URLByAppendingPathComponent:bundleIdentifier isDirectory:YES];

    @try {
        NSError *error; // 여러번의 try catch를 이용할 경우 위로 빼줘도 괜찮다.
        [self createDirectoryAtPath:directory.path
        withIntermediateDirectories:YES
                         attributes:nil
                              error:&error];
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
    }

    return directory;
}

@end
