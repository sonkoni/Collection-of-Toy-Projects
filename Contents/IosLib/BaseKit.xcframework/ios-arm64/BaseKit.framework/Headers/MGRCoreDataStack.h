//
//  MGRCoreDataStack.h
// ----------------------------------------------------------------------
// 코어데이터 스택을 만든다.
//  - 아이클라우드 연동 시 initWithCloudName 로 만들면 NSPersistentContainer 대신 NSPersistentCloudKitContainer 를 사용하게 된다.
//  - 스키마를 조정해서 로그를 안 나오게 할 수 있다.
//      xcode 의 메뉴 Product 의 Run 스키마에 다음을 추가한다. 이건 로그를 끄는 옵션인데 체크를 통해 필요할 때만 활성화하자.
//      Argument Passed On Launch
//          -com.apple.CoreData.CloudKitDebug 0
//          -com.apple.CoreData.Logging.stderr 0
//          -com.apple.CoreData.SQLDebug 0
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRCoreDataStack : NSObject
@property (nonatomic, strong, readonly) NSPersistentContainer *persistentContainer;

/* 이니셜라이징 */
- (instancetype)initWithLocalName:(NSString *)name;
- (instancetype)initWithCloudName:(NSString *)name; // icloud 와 연동될 경우

/* 정보 */
- (NSManagedObjectContext *)context;
- (NSArray<NSEntityDescription *> *)entities;
- (NSArray<NSPropertyDescription *> *)properties:(NSString *)entityName;

/* 프리셋 */
- (NSPredicate *)predicate:(NSString *)attribute containsNoCaseNoAccent:(NSString *)searchString;
- (NSSortDescriptor *)sortDescriptorAscendingWithKey:(NSString *)key;
- (NSSortDescriptor *)sortDescriptorDescendingWithKey:(NSString *)key;
- (NSFetchRequest *)fetchRequestWithEntity:(NSString *)entityName predicate:(NSPredicate * _Nullable)predicate;
- (NSFetchRequest *)fetchRequestFromEntity:(NSString *)entityName predicate:(NSPredicate * _Nullable)predicate sort:(NSArray<NSSortDescriptor *> * _Nullable)sortDescriptors;
- (NSFetchRequest *)fetchRequestFromEntity:(NSString *)entityName predicate:(NSPredicate * _Nullable)predicate sort:(NSArray<NSSortDescriptor *> * _Nullable)sortDescriptors limit:(NSUInteger)fetchLimit size:(NSUInteger)fetchBatchSize;
- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request sectionNameKeyPath:(nullable NSString *)keyPath cacheName:(nullable NSString *)name;

/* 최대최소 찾기 */
- (NSNumber * _Nullable)numberMaxOfType:(NSAttributeType)type fromEntity:(NSString *)entityName attr:(NSString *)attrName;
- (NSNumber * _Nullable)numberMinOfType:(NSAttributeType)type fromEntity:(NSString *)entityName attr:(NSString *)attrName;
- (NSArray *)objectMaxFromEntity:(NSString *)entityName attr:(NSString *)attrName;
- (NSArray *)objectMinFromEntity:(NSString *)entityName attr:(NSString *)attrName;

/* 읽기쓰기 */
- (void)saveContext;
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request;
- (nullable __kindof NSManagedObject *)objectRegisteredForID:(NSManagedObjectID *)objectID;
- (nullable __kindof NSManagedObject *)existingObjectWithID:(NSManagedObjectID *)objectID error:(NSError **)error;
- (nullable NSManagedObjectID *)managedObjectIDForURIRepresentation:(NSURL *)url;
- (NSManagedObject *)createObject:(NSString *)entityName;
- (void)deleteObject:(NSManagedObject *)object;
- (void)clearEntity:(NSString *)entityName;

@end

NS_ASSUME_NONNULL_END
