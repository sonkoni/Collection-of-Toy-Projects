//
//  MGUImageDownloader.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUImageDownloader.h"
#import "NSFileManager+ImageDownloader.h"
@import BaseKit;

@interface MGUImageDownloader ()
@property (nonatomic, strong, nullable) NSURLSessionDataTask *task;
@end

@implementation MGUImageDownloader
static NSError * _downloadFailed;

+ (NSError *)downloadFailed {
    return _downloadFailed;
}

+ (void)setDownloadFailed:(NSError *)downloadFailed {
    _downloadFailed = downloadFailed;
}


#pragma mark - 인스턴스 메서드.
- (void)downloadImageUrl:(NSURL *)url
              completion:(void(^)(UIImage *image, NSURL *url, NSError *error))completion {
    
    //! 최초에는 cached된 이미지가 없으므로 아래의 - imageDataFrom: 메서드에서 에러 로그가 발생한다. (return 값은 nil)
    //! 그리고 else 쪽이 실행된다. 그러면 웹에서 이미지를 다운로드 한다.
    //! 만약, 이미 앱을 한번 실행 시켜서 이미지가 다운로드 되었다면, - imageDataFrom:의 반환값은 nil이 아니다. 따라서 if 쪽으로 실행된다.
    UIImage *cachedImage = [self imageDataFrom:url]; // 앱에 저장되어있는 이미지가 있다면 가져온다.
    
    if (cachedImage != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(cachedImage, url, nil);
            }
        });
    } else {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            NSURLSessionConfiguration * configuration =
            [NSURLSessionConfiguration defaultSessionConfiguration];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            
            self.task = [session dataTaskWithURL:url
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
                if (error != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion != nil) {
                            completion(nil, url, error);
                        }
                    });
                    return;
                }
                
                UIImage *image = [[UIImage alloc] initWithData:data];
                if (data == nil || image == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion != nil) {
                            completion(nil, url, [MGUImageDownloader downloadFailed]);
                        }
                    });
                    return;
                }
                
                [self save:data fromUrl:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion != nil) {
                        completion(image, url, nil);
                    }
                });
            }];
            
            [self.task resume];
        });
    }
}

- (void)cancel {
    [self.task cancel];
}


#pragma mark - private
- (NSURL * _Nullable)save:(NSData *)data fromUrl:(NSURL *)remoteUrl {
    NSString *filename = remoteUrl.mgrFilename;
    if (filename == nil) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager saveImage:data filename:filename];
}

//! 현재 디바이스에 내가 원하는 이미지가 저장되어있는지 확인하여 가져온다.
//! 즉, 최초에 이 메서드를 호출하면 없을 것이다. 즉, 반환값은 nil이고, 
- (UIImage * _Nullable)imageDataFrom:(NSURL *)remoteUrl {
    NSString *filename = remoteUrl.mgrFilename; // 원격 url을 통해 unique한 이름을 만든 것이다.
    if (filename == nil) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager imageDataFilename:filename];
    if (data == nil) {
        return nil;
    }
    
    return [[UIImage alloc] initWithData:data];
}

@end
