//
//  ItemForTableView.m
//  CustomizingNavigationBar
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
        Item *item1 = [[Item alloc] initWithText:@"MGUDNSwitch" detailText:@"Day Night Switch"];

        Item *item2 = [[Item alloc] initWithText:@"MGUFlatSwitch" detailText:@"Flat Switch - V 체크"];

        Item *item3 = [[Item alloc] initWithText:@"MGUMaterialSwitch" detailText:@"MGUMaterialSwitch Basic"];
        Item *item4 = [[Item alloc] initWithText:@"MGUMaterialSwitch" detailText:@"MGUMaterialSwitch various examples"];

        Item *item5 = [[Item alloc] initWithText:@"MGUSevenSwitch" detailText:@"UISwitch와 같은 모양 연출가능하다."];
        Item *item6 = [[Item alloc] initWithText:@"MGUSevenSwitch" detailText:@"MGUSevenSwitch various examples"];

        Item *item7 = [[Item alloc] initWithText:@"MGUFavoriteSwitch" detailText:@"Favorite Switch Basic"];

        Item *item8 = [[Item alloc] initWithText:@"MGUOnOffButton" detailText:@"MGUOnOffButton Basic"];
        
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section0 = @{
            @"MGUDNSwitch 섹션" :
        @[item1]
        }.mutableCopy;

        NSMutableDictionary <NSString *, NSArray <Item *>*>* section1 = @{
            @"MGUFlatSwitch 섹션" :
        @[item2]
        }.mutableCopy;

        NSMutableDictionary <NSString *, NSArray <Item *>*>* section2 = @{
            @"MGUMaterialSwitch 섹션" : @[item3, item4]
        }.mutableCopy;

        NSMutableDictionary <NSString *, NSArray <Item *>*>* section3 = @{
            @"MGUSevenSwitch 섹션" : @[item5, item6]
        }.mutableCopy;

        NSMutableDictionary <NSString *, NSArray <Item *>*>* section4 = @{
            @"MGUFavoriteSwitch 섹션" :
        @[item7]
        }.mutableCopy;

        NSMutableDictionary <NSString *, NSArray <Item *>*>* section5 = @{
            @"MGUOnOffButton 섹션" :
        @[item8]
        }.mutableCopy;

        _allItems = @[section0, section1, section2, section3, section4, section5].mutableCopy;
    }
    
    return self;
}

@end





