//
//  MGROutlineItem.m
//  Modern Collection Views
//
//  Created by Kwan Hyun Son on 2021/01/01.
//

#import "MGROutlineItem.h"
#import "NSArray+Extension.h"
#import "NSError+Extension.h"
#import "NSException+Extension.h"

static NSString * const tempRoot = @"tempRoot";

@interface MGROutlineItem ()
@property (nonatomic, strong, readwrite) NSMutableArray <MGROutlineItem *>*subitems;
@property (nonatomic, strong) NSUUID *identifier; // string = [[NSUUID new] UUIDString];
@end

@implementation MGROutlineItem
@dynamic hasSubitem;
@dynamic indentationLevel;
@dynamic currentLocationInfo;
@dynamic recurrenceAllSubitems;
@dynamic recurrenceAllExpandedSubitems;
@dynamic recurrenceAllCollapsedSubitems;

- (instancetype)initWithContentItem:(id<NSSecureCoding>)contentItem
                           isFolder:(BOOL)isFolder
                           subitems:(NSArray <MGROutlineItem *>* _Nullable)subitems {
    self = [super init];
    if (self) {
        _contentItem = contentItem;
        _isFolder = isFolder;
        _expanded = NO;
        _identifier = [NSUUID new];
        [self appendSubitems:subitems];
    }
    return self;
}

//! 폴더에서 사용.
+ (instancetype)outlineWithContentItem:(id<NSSecureCoding>)contentItem
                              subitems:(NSArray <MGROutlineItem *>* _Nullable)subitems {
    return [[self alloc] initWithContentItem:contentItem isFolder:YES subitems:subitems];
}

//! 폴더가 아닌 곳에서 사용.
+ (instancetype)outlineWithContentItem:(id<NSSecureCoding>)contentItem {
    return [[self alloc] initWithContentItem:contentItem isFolder:NO subitems:nil];
}

//! 임시 루트.
+ (instancetype)tempRootWithSubitems:(NSArray <MGROutlineItem *>*)subitems {
    return [[self alloc] initWithContentItem:tempRoot isFolder:YES subitems:subitems];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }

    return [self isEqualToMGROutlineItem:(__typeof(self))object];
}


#pragma mark - <NSSecureCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder { // <NSCoding> 프로토콜 메서드
    self = [super init]; // NSObject가 만약 initWithCoder:를 구현했었다라고 가정하면, self = [super initWithCoder:aDecoder];
    if(self) {
        /// 주석친 것처럼 쓰지말고, decodeObjectOfClass:forKey:를 쓰자. 이유는 NSSecureCoding 문서를 읽어보자.
        ///_personName = [aDecoder decodeObjectForKey:@"personName"];
        Class contentItemClass = NSClassFromString([aDecoder decodeObjectOfClass:[NSString class] forKey:@"contentItemClassName"]);
        _contentItem = [aDecoder decodeObjectOfClass:contentItemClass forKey:@"contentItem"];
    
        _superItem = [aDecoder decodeObjectOfClass:[self class] forKey:@"superItem"];
        _subitems = [aDecoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [self class]]] forKey:@"subitems"];
        _identifier = [aDecoder decodeObjectOfClass:[NSUUID class] forKey:@"identifier"];
        _superItem = [aDecoder decodeObjectOfClass:[self class] forKey:@"superItem"];
        _expanded = [aDecoder decodeBoolForKey:@"expanded"];
        _isFolder = [aDecoder decodeBoolForKey:@"isFolder"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder { // <NSCoding> 프로토콜 메서드
    // NSObject가 만약 encodeWithCoder:를 구현했었다라고 가정하면, [super encodeWithCoder:aCoder]; 추가해야된다.
    [aCoder encodeObject:self.contentItem forKey:@"contentItem"];
    [aCoder encodeObject:NSStringFromClass([self.contentItem class]) forKey:@"contentItemClassName"];
    
    [aCoder encodeObject:self.subitems forKey:@"subitems"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.superItem forKey:@"superItem"];
    [aCoder encodeBool:_expanded forKey:@"expanded"];
    [aCoder encodeBool:_isFolder forKey:@"isFolder"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToMGROutlineItem:(MGROutlineItem *)item {
    if (self == item) {
        return YES;
    }

    if (item == nil) {
        return NO;
    }
    
    BOOL haveEqualIdentifier = (!self.identifier && !item.identifier) || [self.identifier isEqual:item.identifier];
    return haveEqualIdentifier;
}

- (NSUInteger)hash {
//    const NSUInteger prime = 31;
    NSUInteger result = [_identifier hash];
    return result;
}


#pragma mark - <NSItemProviderWriting>
- (NSProgress *)loadDataWithTypeIdentifier:(NSString *)typeIdentifier
          forItemProviderCompletionHandler:(void (^)(NSData *data, NSError *error))completionHandler {
    
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    
    __autoreleasing NSError *error = nil;
    @try {
        NSDictionary *dic = @{ MGROutlineItemContentItemKey : self.contentItem ,
                               MGROutlineItemIsFolderKey : @(self.isFolder) ,
                               MGROutlineItemSubitemsKey : self.subitems };
        // top level 은 딕셔너리 또는 배열이어야한다.
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self
//                                             requiringSecureCoding:NO
//                                                             error:&error];
        
        progress.completedUnitCount = 100;
        completionHandler(data, nil);
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        completionHandler(nil, error);
    }
    
    return progress;
}

+ (NSArray <NSString *>*)writableTypeIdentifiersForItemProvider {
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 140000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 110000)
    return @[UTTypeData.identifier];
#else // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(macOS 11.0, iOS 14, *)) {
        return @[UTTypeData.identifier];
    } else {
        return @[(NSString *)kUTTypeData];
    }
#endif
}


#pragma mark - <NSItemProviderReading>
+ (instancetype)objectWithItemProviderData:(NSData *)data
                            typeIdentifier:(NSString *)typeIdentifier
                                     error:(NSError * _Nullable *)outError {
    __autoreleasing NSError *error = nil;
    @try {
        // top level 은 딕셔너리 또는 배열이어야한다.
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        MGROutlineItem *subject = [[MGROutlineItem alloc] initWithContentItem:dic[MGROutlineItemContentItemKey]
                                                                     isFolder:[dic[MGROutlineItemIsFolderKey] boolValue]
                                                                     subitems:dic[MGROutlineItemSubitemsKey]];
//        MGROutlineItem *subject = [NSKeyedUnarchiver unarchivedObjectOfClass:[MGROutlineItem class] fromData:data error:&error];
        [error mgrMakeExceptionAndThrow];
        return subject;
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        NSAssert(FALSE, @"fatalError 발생");
    }
}

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 140000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 110000)
    return @[UTTypeData.identifier];
#else // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(macOS 11.0, iOS 14, *)) {
        return @[UTTypeData.identifier];
    } else {
        return @[(NSString *)kUTTypeData];
    }
#endif
}


#pragma mark - Action
- (void)appendSubitems:(NSArray <MGROutlineItem *>*)subitems {
    if (_subitems == nil) {
        _subitems = @[].mutableCopy;
    }
    [self registerSubitems:subitems];
    for (MGROutlineItem *subitem in subitems) {
        [_subitems addObject:subitem];
    }
}

- (void)insertSubitems:(NSArray <MGROutlineItem *>*)subitems afterItem:(MGROutlineItem *)afterItem {
    NSInteger index = [_subitems indexOfObject:afterItem];
    if (index != NSNotFound) {
        [self registerSubitems:subitems];
        [_subitems mgrInsertObjects:subitems atIndex:index + 1];
    }
}

- (void)insertSubitems:(NSArray <MGROutlineItem *>*)subitems beforeItem:(MGROutlineItem *)beforeItem {
    NSInteger index = [_subitems indexOfObject:beforeItem];
    if (index != NSNotFound) {
        [self registerSubitems:subitems];
        [_subitems mgrInsertObjects:subitems atIndex:index];
    }
}

- (void)deleteSubitems:(NSArray <MGROutlineItem *>*)items {
    NSArray <MGROutlineItem *>*intersectionArray = [NSArray mgrIntersectionArray:self.subitems array2:items];
    [self unRegisterSubitems:intersectionArray];
    [_subitems removeObjectsInArray:intersectionArray];
}

- (void)deleteAllSubitems {
    [self unRegisterSubitems:_subitems];
    _subitems = @[].mutableCopy;
}

- (void)removeFromSuperitem {
    MGROutlineItem *superItem = self.superItem;
    if (superItem != nil) {
        [superItem deleteSubitems:@[self]];
    }
}

//! 반드시 주어진 TempRoot 이용.
- (NSArray <MGROutlineItem *>*)superitemsToUpperLimit {
    if (self.expanded == YES) {
        NSAssert(FALSE, @"폴더이면서 열려 있다면 호출 자체를 하지 마라.");
    }
    
    MGROutlineItem *superItem = self.superItem;
    MGROutlineItem *currentItem = self;
    NSMutableArray <MGROutlineItem *>*arr = [NSMutableArray array];
    if (superItem == nil) {
        NSAssert(FALSE, @"현재 손가락에 해당하는 아이템이 Root라면 호출 자체를 하지 마라.");
    } else if (superItem.subitems.lastObject != self) {
        NSAssert(FALSE, @"현재 손가락에 해당하는 아이템이 superItem의 마지막 아이템이 아니라면 호출 자체를 하지 마라.");
    } else {
        while (superItem.subitems.lastObject == currentItem && superItem != nil) { // 최초 한번은 무조건 들어온다.
            [arr addObject:superItem];
            currentItem = superItem;
            superItem = superItem.superItem;
        } // 딱 한단계 빼고 다 모은다. nil은 없다.
        
        if ([arr.lastObject isTempRoot] == NO) {
            if (arr.lastObject.superItem == nil) {
                NSAssert(FALSE, @"주어진 TempRoot를 사용해야한다.");
            }
            [arr addObject:arr.lastObject.superItem];
        }
    }
    return arr.copy;
}

- (BOOL)isTempRoot {
    if ([self.contentItem isKindOfClass:[NSString class]] && [self.contentItem isEqualToString:tempRoot]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 세터 & 게터
- (BOOL)hasSubitem {
    if (self.subitems.count < 1) {
        return NO;
    } else {
        return YES;
    }
}

- (NSInteger)indentationLevel {
    NSInteger indentLevel = 0;
    MGROutlineItem *outlineItem = self.superItem;
    while (outlineItem != nil) {
        indentLevel++;
        outlineItem = outlineItem.superItem;
    }
    return indentLevel;
}

- (NSArray<__kindof MGROutlineItem *> *)recurrenceAllSubitems {
    NSMutableArray<MGROutlineItem *> *recurrenceAllSubitems = [self _recurrenceAllSubitems];
    [recurrenceAllSubitems removeObject:self];
    return recurrenceAllSubitems;
}

- (NSArray<__kindof MGROutlineItem *> *)recurrenceAllExpandedSubitems {
    NSMutableArray<MGROutlineItem *> *recurrenceAllExpandedSubitems = [self _recurrenceAllSubitemsWithExpanded:YES];
    [recurrenceAllExpandedSubitems removeObject:self];
    return recurrenceAllExpandedSubitems;
}

- (NSArray<__kindof MGROutlineItem *> *)recurrenceAllCollapsedSubitems {
    NSMutableArray<MGROutlineItem *> *recurrenceAllCollapsedSubitems = [self _recurrenceAllSubitemsWithExpanded:NO];
    [recurrenceAllCollapsedSubitems removeObject:self];
    return recurrenceAllCollapsedSubitems;
}

- (MGROutlineItemLocation)currentLocationInfo {
    if (self.superItem != nil) {
        if (self.superItem.subitems.count <= 1) { // 부모의 서브 아이템이 오직 자신 뿐일 경우.
            return MGROutlineItemLocationMake(self.superItem, nil, nil);
        } else { // 부모의 서브 아이템이 2 개 이상일 경우
            if ([self.superItem.subitems.firstObject isEqual:self] == YES) { // 자신이 첫 번째 아이템일 경우.
                return MGROutlineItemLocationMake(self.superItem, nil, self.superItem.subitems[1]);
            } else if ([self.superItem.subitems.lastObject isEqual:self] == YES) { // 자신이 마지막 아이템일 경우.
                NSInteger index = [self.superItem.subitems indexOfObject:self] - 1;
                return MGROutlineItemLocationMake(self.superItem, self.superItem.subitems[index], nil);
            } else  { // 자신이 부모의 첫 번째 또는 마지막 아이템이 아닐 경우.
                NSInteger index = [self.superItem.subitems indexOfObject:self] - 1;
                return MGROutlineItemLocationMake(self.superItem, self.superItem.subitems[index], self.superItem.subitems[index + 2]);
            }
        }
    } else {
        NSAssert(FALSE, @"부모가 없을 경우, controller에서 판단해야한다.");
        return nil; // 판단할 수 없다.
    }
}


#pragma mark - Helper
- (void)registerSubitems:(NSArray <MGROutlineItem *>*)subitems {
    for (MGROutlineItem *item in subitems) {
        item.superItem = self;
    }
}

- (void)unRegisterSubitems:(NSArray <MGROutlineItem *>*)subitems {
    for (MGROutlineItem *item in subitems) {
        item.superItem = nil;
    }
}

- (NSMutableArray <__kindof MGROutlineItem *>*)_recurrenceAllSubitems {
    NSMutableArray <MGROutlineItem *>*all = @[].mutableCopy;
    void (^getSubitemsBlock)(MGROutlineItem *current) = ^(MGROutlineItem *current){
        [all addObject:current];
        for (MGROutlineItem *sub in current.subitems) {
            [all addObjectsFromArray:[sub _recurrenceAllSubitems]];
        }
    };
    getSubitemsBlock(self);
    return all;
}

- (NSMutableArray<__kindof MGROutlineItem *> *)_recurrenceAllSubitemsWithExpanded:(BOOL)isExpanded {
    NSMutableArray <MGROutlineItem *> *all = @[].mutableCopy;
    void (^getSubViewsBlock)(MGROutlineItem *current) = ^(MGROutlineItem *current){
        
        if (current.isExpanded == isExpanded) {
            [all addObject:current];
        }

        for (MGROutlineItem *sub in current.subitems) {
            [all addObjectsFromArray:[sub _recurrenceAllSubitemsWithExpanded:isExpanded]];
        }
    };
    getSubViewsBlock(self);
    return all;
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }
@end


//!------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MGROutlineItemLocationInfoValue
- (instancetype)initWithSuperItem:(MGROutlineItem *)superItem
                        afterItem:(MGROutlineItem *)afterItem
                       beforeItem:(MGROutlineItem *)beforeItem {
    self = [super init];
    if (self) {
        _superItem = superItem;
        _afterItem = afterItem;
        _beforeItem = beforeItem;
    }
    return self;
    
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (([object isKindOfClass:[self class]] == NO) || (object == nil)) {
        return NO;
    }
    /** ❊ 중요 : super의 - isEqual: 메서드가 pointer 값의 동일성 비교결과라면 호출금지다.
    super의 - isEqual:이 pointer 값의 동일성 비교결과가 아니라면 주석 부분을 풀어준다.
    if ([super isEqual:object] == NO) {
    return NO;
    }
    */
    
    return [self isEqualToOutlineItemLocationInfoValue:(__typeof(self))object];
}

- (id)copyWithZone:(NSZone *)zone {
    MGROutlineItemLocationInfoValue *locationInfoValue = [[[self class] allocWithZone:zone] init];
    /*  super가 NSCopying 프로토콜을 따른다면 이걸 사용해야한다.
     OutlineItemLocationInfoValue *locationInfoValue = [super copyWithZone:zone];
    */
    if (locationInfoValue) {
        /** NSUUID를 OutlineItem 객체가 사용하므로 딥카피하자. **/
        locationInfoValue->_superItem = _superItem;
        locationInfoValue->_afterItem = _afterItem;
        locationInfoValue->_beforeItem = _beforeItem;
    }
    
    return locationInfoValue;
}

- (NSUInteger)hash {
    const NSUInteger prime = 31;
    /** ❊ 중요 : super의 - hash 메서드가 pointer 값이라면 호출금지다.
    super의 - hash가 pointer 값이 아니라면 아니라면 주석 부분을 풀어준다.
    NSUInteger result = [super hash];
    */
    //! 객체
    NSUInteger result = [_superItem hash];
    result = prime * result + [_afterItem hash];
    result = prime * result + [_beforeItem hash];
    return result;
}


#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToOutlineItemLocationInfoValue:(MGROutlineItemLocationInfoValue *)locationInfoValue {
    if (self == locationInfoValue) {
        return YES;
    }
    
    if (locationInfoValue == nil) {
        return NO;
    }
    
    //! 스칼라일 경우는 단순히 둘만 비교해도 된다.
    BOOL haveEqualSuperItem = (self.superItem == locationInfoValue.superItem); // NSUUID를 사용하므로.
    BOOL haveEqualAfterItem = (self.afterItem == locationInfoValue.afterItem); // NSUUID를 사용하므로.
    BOOL haveEqualBeforeItem = (self.beforeItem == locationInfoValue.beforeItem); // NSUUID를 사용하므로.
    
    return haveEqualSuperItem && haveEqualAfterItem && haveEqualBeforeItem;
}

const MGROutlineItemLocation _Nonnull MGROutlineItemLocationMake(MGROutlineItem *superItem,
                                                                   MGROutlineItem *afterItem,
                                                                   MGROutlineItem *beforeItem) {
    return [[MGROutlineItemLocationInfoValue alloc] initWithSuperItem:superItem afterItem:afterItem beforeItem:beforeItem];
}

const BOOL MGROutlineItemLocationEqualToLocation(MGROutlineItemLocationInfoValue *value1, MGROutlineItemLocationInfoValue *value2) {
    if ([value1 isEqualToOutlineItemLocationInfoValue:value2] == YES) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }

@end

