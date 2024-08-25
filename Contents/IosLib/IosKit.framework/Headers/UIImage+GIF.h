//
//  UIImage+GIF.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-04-06
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GIF)
/*
    // self.imageView1.contentMode = UIViewContentModeScaleToFill;
    self.imageView1.image = [UIImage mguGifWithName:@"jeremy"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"adventure-time" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    self.imageView2.image = [UIImage mguGifWithData:imageData];
 */
+ (UIImage * _Nullable)mguGifWithData:(NSData *)data; // `지정 초기화`에 해당
+ (UIImage * _Nullable)mguGifWithURL:(NSString *)url;
+ (UIImage * _Nullable)mguGifWithName:(NSString *)name;
+ (UIImage * _Nullable)mguGifWithAsset:(NSString *)asset;

@end

NS_ASSUME_NONNULL_END
