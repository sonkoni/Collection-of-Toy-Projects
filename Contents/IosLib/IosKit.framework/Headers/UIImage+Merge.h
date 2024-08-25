//
//  UIImage+Merge.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-01
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Merge)

// 이미지를 붙여준다. 배열에 들어온 순으로 차례차례 배치하여 하나의 이미지로 반환한다.
//
// CGSize drawSize = self.imageView.bounds.size;
// UIImage *image1 = [self.view1 mgrScreenshot];
// UIImage *image2 = [self.view2 mgrScreenshot];
// CGRect rect1 = CGRectMake(0.0, 0.0, drawSize.width / 2.0, drawSize.height / 2.0);
// CGRect rect2 = CGRectMake(drawSize.width / 2.0,
//                           drawSize.height / 2.0,
//                           drawSize.width / 2.0,
//                           drawSize.height / 2.0);
// UIImage *result = [UIImage mgrMergeImageWithDrawSize:drawSize
//                                            views:@[image1, image2]
//                                           frames:@[@(rect1), @(rect2)]];
// self.imageView.image = result;
//
+ (UIImage *)mgrMergeImageWithDrawSize:(CGSize)drawSize
                                 views:(NSArray <UIImage *>*)images
                                frames:(NSArray <NSValue *>*)frames; // size를 super의 bounds로 본다
@end

NS_ASSUME_NONNULL_END
