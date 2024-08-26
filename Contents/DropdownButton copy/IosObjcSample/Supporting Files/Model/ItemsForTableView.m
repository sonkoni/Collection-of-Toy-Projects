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
        
        Item *item0 = [[Item alloc] initWithText:@"MGUDropdownButton Class" detailText:@"차트연구소 프로젝트를 위해 만듬"];
        
        Item *item1 = [[Item alloc] initWithText:@"MGUDropSegControl Class" detailText:@"차트연구소 프로젝트를 위해 만듬"];
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section0 = @{
            @"MGUDropdownButton Class 섹션" : @[item0] }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section1 = @{
            @"MGUDropSegControl Class 섹션" : @[item1] }.mutableCopy;
        
        _allItems = @[section0, section1].mutableCopy;
    }
    return self;
}
@end
