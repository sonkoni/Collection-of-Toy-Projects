//
//  MGUImageDownloader.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//
// https://github.com/sh-khashimov/RESegmentedControl

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGUImageDownloader 는 현재 MGUNeoSegControl에서만 사용되고 있다.
 * @discussion  MGUNeoSegControl 이 web에서 URL을 이용하여 이미지 받을 때만 사용되고 있다. 외부로 공개하지 않는다.
 *              ...
 */
@interface MGUImageDownloader : NSObject
@property (class, nonatomic, strong) NSError *downloadFailed;
- (void)downloadImageUrl:(NSURL *)url
              completion:(void(^)(UIImage *image, NSURL *url, NSError *error))completion;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
