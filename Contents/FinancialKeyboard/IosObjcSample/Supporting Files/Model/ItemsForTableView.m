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
        
        Item *item1 = [[Item alloc] initWithText:@"프리셋 보기"
                                      detailText:@"기본적인 템플릿 맛보기"];
        
        Item *item2 = [[Item alloc] initWithText:@"ScrollView Inset - 애플 키보드"
                                      detailText:@"키보드가 올라올 때, 반응성 보기"];
        
        Item *item3 = [[Item alloc] initWithText:@"ScrollView Inset - FinancialKeyboard"
                                      detailText:@"키보드가 올라올 때, 반응성 보기"];
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section0 = @{
        @"Basic" : @[item1]
        }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section1 = @{
        @"Advanced" : @[item2, item3]
        }.mutableCopy;
        
        _allItems = @[section0, section1].mutableCopy;
    }
    
    return self;
}
@end
