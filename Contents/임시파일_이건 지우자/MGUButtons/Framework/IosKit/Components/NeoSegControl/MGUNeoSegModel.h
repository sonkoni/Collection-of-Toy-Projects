//
//  MGUNeoSegModel.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUNeoSegModel : NSObject
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *imageName;
@property (nonatomic, strong, nullable) NSURL *imageUrl;
@property (nonatomic, assign, readonly) BOOL isImageAvailable; //! @dynamic readolny

//! 구현하였음.
- (BOOL)isEqual:(id)object;

//! 초기화 메서드.
- (instancetype)initWithTitle:(NSString * _Nullable)title  NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTitle:(NSString * _Nullable)title
                    imageName:(NSString * _Nullable)imageName;
- (instancetype)initWithTitle:(NSString * _Nullable)title
                     imageUrl:(NSString * _Nullable)imageUrl;
+ (instancetype)segmentModelWithTitle:(NSString * _Nullable)title;
+ (instancetype)segmentModelWithTitle:(NSString * _Nullable)title
                            imageName:(NSString * _Nullable)imageName;
+ (instancetype)segmentModelWithTitle:(NSString * _Nullable)title
                             imageUrl:(NSString * _Nullable)imageUrl;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
