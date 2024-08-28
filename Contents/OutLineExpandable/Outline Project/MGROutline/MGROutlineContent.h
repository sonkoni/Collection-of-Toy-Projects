//
//  ContentItem.h
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/09/01.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGROutlineContent : NSObject <NSSecureCoding, NSCopying>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, nullable) Class viewControllerClass ; // 클래스 객체(싱글톤), UIViewController 계통만 가능.

+ (instancetype)itemWithTitle:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title
          viewControllerClass:(Class)viewControllerClass;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
