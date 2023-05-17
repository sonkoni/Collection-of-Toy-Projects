//
//  NSImage+DarkModeSupport.h
//
//  Copyright © 2022 Mulgrim Inc. All rights reserved.
//
// https://stackoverflow.com/questions/52849332/how-to-manually-create-dynamic-dark-light-nsimage-instances

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (DarkModeSupport)

+ (NSImage * _Nullable)mgrDynamicImageWithNormalImage:(NSImage *_Nullable)normalImage
                                            darkImage:(NSImage *_Nullable)darkImage;

@end

NS_ASSUME_NONNULL_END
