//
//  OutlineItem.m
//  Modern Collection Views
//
//  Created by Kwan Hyun Son on 2021/01/01.
//

#import "OutlineItem.h"
#import "NSArray+MGRBase.h"
#import "NSError+MGRBase.h"
#import "NSException+MGRBase.h"

@interface OutlineItem ()
@property (nonatomic, strong, readwrite) NSMutableArray <OutlineItem *>*subitems;
@property (nonatomic, strong) NSUUID *identifier; // string = [[NSUUID new] UUIDString];
@end

@implementation OutlineItem
@dynamic recurrenceAllSubitems;
@dynamic currentLocationInfo;

- (instancetype)initWithTitle:(NSString *)title
               viewController:(Class)viewControllerClass
                     subitems:(NSArray <OutlineItem *>* _Nullable)subitems {
    self = [super init];
    if (self) {
        _title = title;
        
        if ([viewControllerClass isSubclassOfClass:[UIViewController class]] == NO &&
            viewControllerClass != nil) {
            NSAssert(FALSE, @"두 번째 인수는 UIViewController 계통의 클래스 객체만 넣어야한다.");
        }
        _viewControllerClass = viewControllerClass;
        _identifier = [NSUUID new];
        [self appendSubitems:subitems];
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

    return [self isEqualToOutlineItem:(__typeof(self))object];
}


#pragma mark - <NSSecureCoding>
- (instancetype)initWithCoder:(NSCoder *)aDecoder { // <NSCoding> 프로토콜 메서드
    self = [super init]; // NSObject가 만약 initWithCoder:를 구현했었다라고 가정하면, self = [super initWithCoder:aDecoder];
    if(self) {
        /// 주석친 것처럼 쓰지말고, decodeObjectOfClass:forKey:를 쓰자. 이유는 NSSecureCoding 문서를 읽어보자.
        ///_personName = [aDecoder decodeObjectForKey:@"personName"];
        _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _subitems = [aDecoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [OutlineItem class]]]
                                             forKey:@"subitems"];
        
        // https://stackoverflow.com/questions/47056194/how-can-you-encode-and-decode-class-type-object-in-objective-c
        // 잘모르겠다.
//        _viewControllerClass = [aDecoder decodeObjectOfClass:[UIViewController class] forKey:@"viewControllerClass"];
        _viewControllerClass = [aDecoder decodeObjectForKey:@"viewControllerClass"];
        
        _identifier = [aDecoder decodeObjectOfClass:[NSUUID class] forKey:@"identifier"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder { // <NSCoding> 프로토콜 메서드
    // NSObject가 만약 encodeWithCoder:를 구현했었다라고 가정하면, [super encodeWithCoder:aCoder]; 추가해야된다.
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subitems forKey:@"subitems"];
    [aCoder encodeObject:self.viewControllerClass forKey:@"viewControllerClass"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - <NSItemProviderWriting>
- (NSProgress *)loadDataWithTypeIdentifier:(NSString *)typeIdentifier
          forItemProviderCompletionHandler:(void (^)(NSData *data, NSError *error))completionHandler {
    
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    
    __autoreleasing NSError *error = nil;
    @try {
        // 이렇게 사용하면 안된다. 활성화된 내용을 참고하자. 탑 레벨은 배열이나 딕셔너리여야한다.
//        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        progress.completedUnitCount = 100;
        completionHandler(data, nil);
        [error mgrMakeExceptionAndThrow];
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        completionHandler(nil, error);
    }
    
    return progress;
}

+ (NSArray<NSString *> *)writableTypeIdentifiersForItemProvider {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 150000 // Deployment Target 이 15.0이다. 기계가 15 이상부터 다 들어온다.
    return @[UTTypeData.identifier];
#else // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 15, *)) {
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
        // 이렇게 사용하면 안된다. 활성화된 내용을 참고하자. 탑 레벨은 배열이나 딕셔너리여야한다.
//        OutlineItem *subject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [error mgrMakeExceptionAndThrow];
        return subject;
    } @catch(NSException *excpt) {
        [excpt mgrDescription];
        NSAssert(FALSE, @"fatalError 발생");
    }
}

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 150000 // Deployment Target 이 15.0이다. 기계가 15 이상부터 다 들어온다.
    return @[UTTypeData.identifier];
#else // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 15, *)) {
        return @[UTTypeData.identifier];
    } else {
        return @[(NSString *)kUTTypeData];
    }
#endif
}

#pragma mark - isEqualTo___ClassName__:
- (BOOL)isEqualToOutlineItem:(OutlineItem *)item {
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


#pragma mark - Action
- (void)appendSubitems:(NSArray <OutlineItem *>*)subitems {
    if (_subitems == nil) {
        _subitems = @[].mutableCopy;
    }
    [self registerSubitems:subitems];
    for (OutlineItem *subitem in subitems) {
        [_subitems addObject:subitem];
    }
}

- (void)insertSubitems:(NSArray <OutlineItem *>*)subitems afterItem:(OutlineItem *)afterItem {
    NSInteger index = [_subitems indexOfObject:afterItem];
    if (index != NSNotFound) {
        [self registerSubitems:subitems];
        [_subitems mgrInsertObjects:subitems atIndex:index + 1];
    }
}

- (void)insertSubitems:(NSArray <OutlineItem *>*)subitems beforeItem:(OutlineItem *)beforeItem {
    NSInteger index = [_subitems indexOfObject:beforeItem];
    if (index != NSNotFound) {
        [self registerSubitems:subitems];
        [_subitems mgrInsertObjects:subitems atIndex:index];
    }
}

- (void)deleteSubitems:(NSArray <OutlineItem *>*)items {
    NSArray <OutlineItem *>*intersectionArray = [NSArray mgrIntersectionArray:self.subitems array2:items];
    [self unRegisterSubitems:intersectionArray];
    [_subitems removeObjectsInArray:intersectionArray];
}

- (void)deleteAllSubitems {
    [self unRegisterSubitems:_subitems];
    _subitems = @[].mutableCopy;
}

- (void)removeFromSuperitem {
    OutlineItem *superItem = self.superItem;
    if (superItem != nil) {
        [superItem deleteSubitems:@[self]];
    }
}


#pragma mark - 세터 & 게터
- (NSArray<OutlineItem *> *)recurrenceAllSubitems {
    NSMutableArray<OutlineItem *> *recurrenceAllSubitems = [self _recurrenceAllSubitems];
    [recurrenceAllSubitems removeObject:self];
    return recurrenceAllSubitems;
}

- (NSMutableArray <OutlineItem *>*)_recurrenceAllSubitems {
    NSMutableArray <OutlineItem *>*all = @[].mutableCopy;
    void (^getSubitemsBlock)(OutlineItem *current) = ^(OutlineItem *current){
        [all addObject:current];
        for (OutlineItem *sub in current.subitems) {
            [all addObjectsFromArray:[sub _recurrenceAllSubitems]];
        }
    };
    getSubitemsBlock(self);
    return all;
}

- (OutlineItemLocationInfoValue *)currentLocationInfo {
    if (self.superItem != nil) {
        if (self.superItem.subitems.count <= 1) { // 부모의 서브 아이템이 오직 자신 뿐일 경우.
            return OutlineItemLocationInfoValueMake(self.superItem, nil, nil);
        } else { // 부모의 서브 아이템이 2 개 이상일 경우
            if ([self.superItem.subitems.firstObject isEqual:self] == YES) { // 자신이 첫 번째 아이템일 경우.
                return OutlineItemLocationInfoValueMake(self.superItem, nil, self.superItem.subitems[1]);
            } else if ([self.superItem.subitems.lastObject isEqual:self] == YES) { // 자신이 마지막 아이템일 경우.
                NSInteger index = [self.superItem.subitems indexOfObject:self] - 1;
                return OutlineItemLocationInfoValueMake(self.superItem, self.superItem.subitems[index], nil);
            } else  { // 자신이 부모의 첫 번째 또는 마지막 아이템이 아닐 경우.
                NSInteger index = [self.superItem.subitems indexOfObject:self] - 1;
                return OutlineItemLocationInfoValueMake(self.superItem, self.superItem.subitems[index], self.superItem.subitems[index + 2]);
            }
        }
    } else {
        NSAssert(FALSE, @"부모가 없을 경우, controller에서 판단해야한다.");
        return nil; // 판단할 수 없다.
    }
}


#pragma mark - Helper
- (void)registerSubitems:(NSArray <OutlineItem *>*)subitems {
    for (OutlineItem *item in subitems) {
        item.superItem = self;
    }
}

- (void)unRegisterSubitems:(NSArray <OutlineItem *>*)subitems {
    for (OutlineItem *item in subitems) {
        item.superItem = nil;
    }
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)init {
    NSAssert(FALSE, @"- init 사용금지.");
    return nil;
}

@end


//!------------------------------------------------------------------------------------------------------------------------------------------------
@implementation OutlineItemLocationInfoValue
- (instancetype)initWithSuperItem:(OutlineItem *)superItem
                        afterItem:(OutlineItem *)afterItem
                       beforeItem:(OutlineItem *)beforeItem {
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
    OutlineItemLocationInfoValue *locationInfoValue = [[[self class] allocWithZone:zone] init];
    /*  super가 NSCopying 프로토콜을 따른다면 이걸 사용해야한다.
     OutlineItemLocationInfoValue *locationInfoValue = [super copyWithZone:zone];
    */
    if (locationInfoValue) {
        /** NSUUID를 OutlineItem 객체가 사용하므로 딥카피하자. **/
        locationInfoValue->_superItem = _superItem;
        locationInfoValue->_afterItem = _afterItem;
        locationInfoValue->_beforeItem = _beforeItem;
//        locationInfoValue->_index = _index;
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
- (BOOL)isEqualToOutlineItemLocationInfoValue:(OutlineItemLocationInfoValue *)locationInfoValue {
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

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }
@end

const OutlineItemLocationInfoValue * OutlineItemLocationInfoValueMake(OutlineItem *superItem, OutlineItem *afterItem, OutlineItem *beforeItem) {
    return [[OutlineItemLocationInfoValue alloc] initWithSuperItem:superItem afterItem:afterItem beforeItem:beforeItem];
}

const BOOL OutlineItemLocationInfoValueEqualToValue(OutlineItemLocationInfoValue *value1, OutlineItemLocationInfoValue *value2) {
    if ([value1 isEqualToOutlineItemLocationInfoValue:value2] == YES) {
        return YES;
    } else {
        return NO;
    }
}
