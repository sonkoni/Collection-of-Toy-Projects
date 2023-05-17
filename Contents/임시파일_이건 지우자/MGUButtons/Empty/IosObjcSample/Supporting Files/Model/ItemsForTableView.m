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
        Item *item0 = [[Item alloc] initWithText:@"MGUSegmentedControl" detailText:@"NYSegmentedControlDemo 스타일"];
        
        Item *item1 = [[Item alloc] initWithText:@"MGUNeoSegControl" detailText:@"RESegmentedControl 스타일"];
        Item *item1_1 = [[Item alloc] initWithText:@"MGUNeoSegControl" detailText:@"MMT Project에서 사용할 스타일"];
                
        Item *item3 = [[Item alloc] initWithText:@"MGUButton Class" detailText:@"Pulse Flash Shake Ripple 효과를 넣어보자."];
        
        Item *item4 = [[Item alloc] initWithText:@"MGURippleButton Class" detailText:@"Google Meterial Style Ripple Button"];
        
        Item *item5 = [[Item alloc] initWithText:@"MGULivelyButton Class" detailText:@"누를 때마다 path로 모양이 변한다."];
        
        Item *item6 = [[Item alloc] initWithText:@"MGUDisplaySwitcherButton Class" detailText:@"두가지 path로 교환된다."];
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section0 = @{
            @"MGUSegmentedControl 섹션" : @[item0] }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section1 = @{
            @"MGUNeoSegControl 섹션" : @[item1, item1_1] }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section2 = @{
            @"MGUButton Class 섹션" : @[item3] }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section3 = @{
            @"MGURippleButton Class 섹션" : @[item4] }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section4 = @{
            @"MGULivelyButton Class 섹션" : @[item5] }.mutableCopy;
        
        NSMutableDictionary <NSString *, NSArray <Item *>*>* section5 = @{
            @"MGUDisplaySwitcherButton Class 섹션" : @[item6] }.mutableCopy;
        
        _allItems = @[section0, section1, section2, section3, section4, section5].mutableCopy;
    }
    return self;
}
@end
