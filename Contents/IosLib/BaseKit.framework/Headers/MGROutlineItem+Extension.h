//
//  MGROutlineItem+Mulgrim.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-04
//  ----------------------------------------------------------------------
//

#import <BaseKit/MGROutlineItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGROutlineItem <__covariant ObjectType: id<NSSecureCoding>> (Mulgrim)

//! 초기화가 너무 길어서 짧게 만들었다.
+ (instancetype)mgrContent:(ObjectType)contentItem
                  subitems:(NSArray <MGROutlineItem <ObjectType>*>* _Nullable)subitems;

//! 폴더가 아닌 곳에서 사용.
+ (instancetype)mgrContent:(ObjectType)contentItem;

@end

NS_ASSUME_NONNULL_END
