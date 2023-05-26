//
//  ViewControllerB.h
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MailCollectionLayoutType
 @abstract   테이블 뷰같은 형식과, 좀 떨어진 형식
 @constant   MailCollectionLayoutType1
 @constant   MailCollectionLayoutType2
 */
typedef NS_ENUM(NSUInteger, MailCollectionLayoutType) {
    MailCollectionLayoutType1 = 1, // 0은 피하는 것이 좋다.
    MailCollectionLayoutType2
};

@interface ViewControllerB : UIViewController

- (instancetype)initWithType:(MailCollectionLayoutType)type NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
