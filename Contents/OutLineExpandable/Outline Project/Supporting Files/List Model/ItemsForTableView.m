//
//  ItemForTableView.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 13/12/2018.
//  Copyright © 2018 Mulgrim Inc. All rights reserved.
//

#import "ItemsForTableView.h"
#import "Item.h"

@implementation ItemsForTableView

+ (instancetype)sharedItems {
    static ItemsForTableView *sharedItems = nil;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        sharedItems =  [[self alloc] initPrivate];
    });
    
    return sharedItems;
}



/// 진짜 초기화 메서드, 최초 1회만 호출될 것이다.
- (instancetype)initPrivate {
    self = [super init];
    if(self) {
        
        Item *item0 = [[Item alloc] initWithText:@"UITableView" detailText:@"..."];
        
        Item *item1 = [[Item alloc] initWithText:@"UICollectionView" detailText:@"iOS 13"];
        Item *item2 = [[Item alloc] initWithText:@"UICollectionView" detailText:@"iOS 14"];
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section0 = @{
            @"TableView 이용" :
        @[item0]
        }.mutableCopy;

        NSMutableDictionary <NSString *, NSArray <Item *>*>* section1 = @{
            @"CollectionView 이용." : @[item1, item2]
        }.mutableCopy;
        
        _allItems = @[section0, section1].mutableCopy;
    }
    
    return self;
}

@end
