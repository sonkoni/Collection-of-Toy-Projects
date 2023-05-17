//
//  NSURL+Filename.m
//
//  Created by Kwan Hyun Son on 2020/11/14.
//

#import "NSURL+Extension.h"
#import "NSData+Extension.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h> // UTTypeURL
#if TARGET_OS_OSX
#define MGR_UNI_COLOR NSColor
#define MGEImage NSImage
#define MGR_UNI_VIEW NSView
#elif TARGET_OS_IPHONE
#define MGR_UNI_COLOR UIColor
#define MGEImage UIImage
#define MGR_UNI_VIEW UIView
#endif

@implementation NSURL (Filename)

/// Hashed filename from remote url path
- (NSString *)mgrFilename {
    
    NSData *urlStringData = [self.absoluteString dataUsingEncoding:NSUTF8StringEncoding
                                              allowLossyConversion:NO];
    if (urlStringData == nil) {
        return nil;
    }
    
    return [urlStringData mgrHexEncodedString];
}

- (NSString *)mgrByteCountWithCountStyle:(NSByteCountFormatterCountStyle)countStyle {
    NSNumber *result = nil;
    NSString *fileSizeString = nil;
    BOOL success = [self getResourceValue:&result
                                   forKey:NSURLFileSizeKey
                                    error:NULL];
    if (result != nil && success == YES) {
        NSUInteger fileSize = [result unsignedIntegerValue];
        NSByteCountFormatter *byteCountFormatter = [NSByteCountFormatter new];
        byteCountFormatter.countStyle = countStyle;
        fileSizeString = [byteCountFormatter stringFromByteCount:(long long)(fileSize)];
    }
    return fileSizeString;
}

- (MGEImage *)mgrWebFavIcon {
    id image = nil;
#if DEBUG
    NSString *faviconURL = [NSString stringWithFormat:@"https://%@/favicon.ico",self.host]; // http에서 s를 붙이는게 맞는 것 같음.
#if TARGET_OS_OSX
    image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:faviconURL]];
#elif TARGET_OS_IPHONE
    image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:faviconURL]]];
#endif  /* TARGET */
#endif  /* DEBUG */
    return image;
}


#pragma mark - 애플 샘플코드에서 가져옴.
- (BOOL)mgrIsFolder {
    NSArray <NSURLResourceKey>*resourceKeys = @[NSURLIsDirectoryKey, NSURLIsPackageKey];
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSNumber *>*resources = [self resourceValuesForKeys:resourceKeys error:&error];
    if (resources != nil) {
        BOOL isURLDirectory = [resources[NSURLIsDirectoryKey] boolValue];
        if (isURLDirectory == YES) {
            if ([resources[NSURLIsPackageKey] boolValue] == NO) {
                return YES;
            }
        }
    }
    if (error != nil) {
        NSLog(@"%@", error.description);
    }
    return NO;
}

- (BOOL)mgrIsImage {
    BOOL isImage = NO;
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, UTType *>*resource = [self resourceValuesForKeys:@[NSURLContentTypeKey] error:&error];
//    NSDictionary <NSURLResourceKey, NSString *>*resource = [self resourceValuesForKeys:@[NSURLTypeIdentifierKey] error:&error];
    if (resource != nil) {
        UTType *type = resource[NSURLContentTypeKey];
        if (type != nil && [type conformsToType:UTTypeImage] == YES) {
            return YES;
        }
//        NSString *type = resource[NSURLTypeIdentifierKey];
//        NSArray <NSString *>*imageTypes = (__bridge_transfer NSArray <NSString *>*)CGImageSourceCopyTypeIdentifiers();
//        for (NSString *imageType in imageTypes) {
//            if (UTTypeConformsTo((__bridge CFStringRef)type, (__bridge CFStringRef)imageType)) {
//                isImage = YES;
//                break; // Done deducing it's an image file.
//            }
//        }
    } else {
        // Can't find the type identifier, so check further by extension.
        NSArray <NSString *>*imageFormats = @[@"jpg", @"jpeg", @"png", @"gif", @"tiff"];
        NSString *ext = self.pathExtension;
        isImage = [imageFormats containsObject:ext];
    }
        
    if (error != nil) {
        NSLog(@"%@", error.description);
    }
    return isImage;
}

- (UTType *)mgrFileType {
    UTType *fileType = nil;
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, UTType *>*resource = [self resourceValuesForKeys:@[NSURLContentTypeKey] error:&error];
    // NSDictionary <NSURLResourceKey, NSString *>*resource = [self resourceValuesForKeys:@[NSURLTypeIdentifierKey] error:&error];
    if (resource != nil) {
        fileType = resource[NSURLContentTypeKey];
//        fileType = resource[NSURLTypeIdentifierKey];
    }
    
    if (error != nil) {
        NSLog(@"%@", error.description);
    }
    return fileType;
}

- (BOOL)mgrIsHidden {
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSNumber *>*resource = [self resourceValuesForKeys:@[NSURLIsHiddenKey] error:&error];
    return [resource[NSURLIsHiddenKey] boolValue];
}

#if TARGET_OS_OSX
- (NSImage *)mgrIcon {
    NSImage *icon;
    
    NSArray <NSURLResourceKey>*resourceKeys = @[NSURLCustomIconKey, NSURLEffectiveIconKey];
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSImage *>*resource = [self resourceValuesForKeys:resourceKeys error:&error];
    if (resource != nil) {
        icon = resource[NSURLCustomIconKey];
        if (icon != nil) {
            return icon;
        }
        icon = resource[NSURLEffectiveIconKey];
        if (icon != nil) {
            return icon;
        }
    } else {
        // Failed to not find the icon from the URL, so make a generic one.
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 110000
        UTType *type = [self mgrIsFolder] ? UTTypeFolder : UTTypeImage;
        icon = [[NSWorkspace sharedWorkspace] iconForContentType:type];
#else
        if (@available(macOS 11.0, *)) {
            UTType *type = [self mgrIsFolder] ? UTTypeFolder : UTTypeImage;
            icon = [[NSWorkspace sharedWorkspace] iconForContentType:type];
        } else {
            unsigned int osType = [self mgrIsFolder] ? kGenericFolderIcon : kGenericDocumentIcon;
            NSString *iconType = NSFileTypeForHFSTypeCode((OSType)osType);
            icon = [[NSWorkspace sharedWorkspace] iconForFileType:iconType];
        }
#endif
    }
    return icon;
}
#endif

- (NSString *)mgrLocalizedName {
    NSString *localizedName = @"";
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSString *>*resource = [self resourceValuesForKeys:@[NSURLLocalizedNameKey] error:&error];
    if (resource != nil) {
        localizedName = resource[NSURLLocalizedNameKey];
    } else {
        // Failed to get the localized name, so use it's last path component as the name.
        localizedName = self.lastPathComponent;
    }
    return localizedName;
}

- (NSString *)mgrFileSizeString {
    NSString *fileSizeString = @"-";
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSNumber *>*resource = [self resourceValuesForKeys:@[NSURLTotalFileAllocatedSizeKey] error:&error];
    if (resource != nil) {
        NSNumber *allocatedSize = resource[NSURLTotalFileAllocatedSizeKey];
        NSString *formattedNumberStr =
        [NSByteCountFormatter stringFromByteCount:[allocatedSize longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
        NSString * fileSizeTitle = NSLocalizedString(@"on disk", @"");
        fileSizeString = [NSString stringWithFormat:@"%@%@", fileSizeTitle, formattedNumberStr];
    }
    
    if (error != nil) {
        NSLog(@"%@", error.description);
    }
    return fileSizeString;
}

- (NSDate *)mgrCreationDate {
    NSDate *creationDate = nil;
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSDate *>*resource = [self resourceValuesForKeys:@[NSURLCreationDateKey] error:&error];
    if (resource != nil) {
        creationDate = resource[NSURLCreationDateKey];
    }
    return creationDate;
}

- (NSDate *)mgrModificationDate {
    NSDate *modificationDate = nil;
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSDate *>*resource = [self resourceValuesForKeys:@[NSURLContentModificationDateKey] error:&error];
    if (resource != nil) {
        modificationDate = resource[NSURLContentModificationDateKey];
    }
    return modificationDate;
}

- (NSString *)mgrKind {
    NSString *kind = @"-";
    NSError *error = nil;
    NSDictionary <NSURLResourceKey, NSString *>*resource =
    [self resourceValuesForKeys:@[NSURLLocalizedTypeDescriptionKey] error:&error];
    if (resource != nil) {
        kind = resource[NSURLLocalizedTypeDescriptionKey];
    }
    return kind;
}

@end


@implementation NSURL (FileLocation)
#if TARGET_OS_OSX
+ (NSURL *)mgrDesktopPicturesFolder {
    // Macintosh HD > System > Library > Desktop Pictures
    NSURL *picturesURL =
        [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSSystemDomainMask].lastObject;
    return [picturesURL URLByAppendingPathComponent:@"Desktop Pictures"];
}
#endif

+ (NSURL *)mgrAppDocumentsURL {
    return [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
}
+ (NSURL *)mgrAppCachesURL {
    return [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
}
+ (NSURL *)mgrAppSupportURL {
    return [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
}
+ (NSURL *)mgrAppTempURL {
    return [NSURL fileURLWithPath:NSTemporaryDirectory()];
}

@end

#undef MGR_UNI_COLOR
#undef MGEImage
#undef MGR_UNI_VIEW
