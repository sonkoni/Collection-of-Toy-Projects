//
//  ItemForTableView.h
//  CustomizingNavigationBar
//
//  Created by Kwan Hyun Son on 13/12/2018.
//  Copyright © 2018 Mulgrim Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item;

NS_ASSUME_NONNULL_BEGIN

@interface ItemsForTableView : NSObject

@property (nonatomic, strong) NSMutableArray <NSMutableDictionary <NSString *, NSArray <Item *>*>*>*allItems;
+ (instancetype)sharedItems;

@end

NS_ASSUME_NONNULL_END
