//
//  NSImage+Etc.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSImage+Etc.h"

@implementation NSImage (Etc)

- (id)mgrCGImage {
    NSSize size = [self size];
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    CGImageRef ref = [self CGImageForProposedRect:&rect context:[NSGraphicsContext currentContext] hints:NULL];
    return (__bridge id)ref;
    //
    // 그 외 다른 방법.
    // https://stackoverflow.com/questions/24595908/swift-nsimage-to-cgimage
//    NSData *imageData = self.TIFFRepresentation;
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
//    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
//    return maskRef;
}

+ (instancetype)mgrImageWithCGImage:(CGImageRef)cgImage {
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    NSImage *image = [NSImage new];
    [image addRepresentation:rep];
    return image;
}

+ (instancetype)mgrImageWithCIImage:(CIImage *)ciImage {
    NSCIImageRep *renderedImage = [[NSCIImageRep alloc] initWithCIImage:ciImage];
    NSImage *result = [[NSImage alloc] initWithSize:renderedImage.size];
    [result addRepresentation:renderedImage];
    return result;
}

+ (nullable NSImage *)mgrImageNamed:(NSImageName)name bundle:(nullable NSBundle *)bundle {
    if (bundle == nil) {
        return [[NSBundle mainBundle] imageForResource:name];
    } else {
        return [bundle imageForResource:name];
    }
}

+ (instancetype)mgrSystemSymbolName:(NSString *)symbolName
           accessibilityDescription:(NSString *)description
                  withConfiguration:(NSImageSymbolConfiguration *)configuration {
    NSImage *image = [NSImage imageWithSystemSymbolName:symbolName accessibilityDescription:description];
    return (configuration == nil) ? image : [image imageWithSymbolConfiguration:configuration];
}

+ (NSImage *)mgrMaskWithCornerRadius:(CGFloat)radius {
    NSImage *image = [NSImage imageWithSize:CGSizeMake(radius * 2, radius * 2)
                                    flipped:NO
                             drawingHandler:^BOOL(NSRect dstRect) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dstRect xRadius:radius yRadius:radius];
        [path fill];
        [[NSColor blackColor] set];
        return YES;
    }];
    image.capInsets = NSEdgeInsetsMake(radius, radius, radius, radius);
    image.resizingMode = NSImageResizingModeStretch;
    return image;
}

- (NSData *)mgrPNGData {
    CGRect imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGImageRef cgImage = [self CGImageForProposedRect:&imageRect
                                              context:nil
                                                hints:nil];
    if (cgImage == nil) {
        return nil;
    }
//    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:self.TIFFRepresentation];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    bitmapRep.size = self.size;
    
    return [bitmapRep representationUsingType:NSBitmapImageFileTypePNG
                                   properties:[NSDictionary dictionary]];
}

- (NSData *)mgrJPEGDataWithCompressionQuality:(CGFloat)compressionQuality {
    CGRect imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGImageRef cgImage = [self CGImageForProposedRect:&imageRect
                                              context:nil
                                                hints:nil];
    if (cgImage == nil) {
        return nil;
    }
//    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:self.TIFFRepresentation];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    bitmapRep.size = self.size;
    
    compressionQuality = MIN(MAX(0.0, compressionQuality), 1.0); // 1.0 에 가까울 수록 고품질.
    return [bitmapRep representationUsingType:NSBitmapImageFileTypeJPEG
                                   properties:@{NSImageCompressionFactor : @(compressionQuality)}];
}
@end


