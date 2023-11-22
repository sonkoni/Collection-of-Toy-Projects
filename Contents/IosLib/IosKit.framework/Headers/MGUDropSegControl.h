//
//  MGUDropSegControl.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-11-16
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUDropSegTextCell.h>
#import <IosKit/MGUDropSegManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUDropSegControl : UIControl
@property (nonatomic, assign) CGFloat itemHeight; // 디폴트 28.0
@property (nonatomic, strong) NSArray <MGUDropSegManager *>*data;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) UIImage *subitemImage;
@property (nonatomic, strong) UIColor *selectedImageTintColor;
@property (nonatomic, strong) UIColor *normalImageTintColor;
@property (nonatomic, assign) CGFloat imageSpacing;
@property (nonatomic, assign) UIEdgeInsets imageContainerInsets;

@property(nonatomic, assign) BOOL dismissOnRotation; // 디폴트 YES

@end

NS_ASSUME_NONNULL_END
