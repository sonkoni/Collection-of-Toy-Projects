//
//  UIImage+Etc.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

//

#import "UIImage+Etc.h"
#import <BaseKit/BaseKit.h>
#import <GraphicsKit/GraphicsKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h> // UTTypeURL
#import <MobileCoreServices/MobileCoreServices.h> // kUTTypeURL

@implementation UIImage (Etc)

- (CGImageRef)newMgrCGImage {
    NSData *pngImageData = UIImagePNGRepresentation(self);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)pngImageData);
    return CGImageCreateWithPNGDataProvider((CGDataProviderRef)CFAutorelease(dataProvider), NULL, YES, kCGRenderingIntentDefault);
//    return CGImageCreateWithPNGDataProvider(dataProvider, NULL, YES, kCGRenderingIntentDefault);
}

- (NSURL *)mgrTempURLWithFileName:(NSString *)fileName withExtension:(MGUImageExtension)extension {
//     Create a URL in the /tmp directory
    NSString *extensionString = (extension == MGUImageExtensionPNG) ? @"png" : @"jpg";
    NSString *fullFileName = [NSString stringWithFormat:@"%@.%@", fileName, extensionString];
    NSURL *tempImageURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:fullFileName];
    NSData *imageData = nil;
    if (extension == MGUImageExtensionPNG) {
        imageData = UIImagePNGRepresentation(self);
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0);
    }

    [imageData writeToURL:tempImageURL
                  options:0
                    error:NULL];
    return tempImageURL;
}

- (NSData *)mgrPngData {
    if (self.imageOrientation == UIImageOrientationUp) {
        return UIImagePNGRepresentation(self);
    }

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(normalizedImage);
    
    /**  희한하게 신형 알고리즘이 용량이 더 크다. 퍼포먼스도 떨어진다.
    if (self.imageOrientation == UIImageOrientationUp) {
        return UIImagePNGRepresentation(self);
    }

    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat new];
    format.scale = self.scale;
//    format.opaque = YES;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.size format:format];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        [self drawAtPoint:CGPointZero];
    }];

    return UIImagePNGRepresentation(image);
     
    return [renderer PNGDataWithActions:^(UIGraphicsImageRendererContext *rendererContext) { 이걸로 간단하게 내보내는게 더 좋을듯.
        [self drawAtPoint:CGPointZero];
    }];
     */
}

- (BOOL)mgrIsEqualToImage:(UIImage *)object {
    if (self == object) {
        return YES;
    } else {
        return [UIImagePNGRepresentation(self) isEqualToData:UIImagePNGRepresentation(object)];
    }
}

- (BOOL)mgrHasAlpha {
    return MGEHasAlphaFromCGImage(self.CGImage);
}

+ (instancetype)mgrImageWithBundle:(NSBundle *)bundle
                          fileName:(NSString *)fileName
                            ofType:(NSString *)ext {
    NSData *data = [NSData mgrDataWithBundle:bundle fileName:fileName ofType:ext];
    return [UIImage imageWithData:data];
}

@end
/*
NSData *data =>
CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
CFDictionaryRef dicRef = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
{
    ColorModel = RGB;
    DPIHeight = 72;
    DPIWidth = 72;
    Depth = 8;
    Orientation = 3;
    PixelHeight = 3024;
    PixelWidth = 4032;
    ProfileName = "Display P3";
    "{Exif}" = {
        ColorSpace = 1;
        ComponentsConfiguration = (1, 2, 3, 0);
        ExifVersion = (2, 2, 1);
        FlashPixVersion = (1, 0);
        PixelXDimension = 4032;
        PixelYDimension = 3024;
        SceneCaptureType = 0;
    };
    "{JFIF}" = {
        DensityUnit = 1;
        JFIFVersion = (1, 0, 2);
        XDensity = 72;
        YDensity = 72;
    };
    "{TIFF}" = {
        Orientation = 3;
        ResolutionUnit = 2;
        XResolution = 72;
        YResolution = 72;
    };
}
*/
