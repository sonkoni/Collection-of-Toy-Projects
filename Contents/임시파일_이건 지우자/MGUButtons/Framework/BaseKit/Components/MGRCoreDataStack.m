//
//  MGRCoreDataStack.m
//

#import "MGRCoreDataStack.h"

@implementation MGRCoreDataStack
#pragma mark - Base
- (instancetype)initWithLocalName:(NSString *)name {
    self = [self init];
    if (self) {
        _persistentContainer = [self localPersistentContainerWithName:name];
    }
    return self;
}

- (instancetype)initWithCloudName:(NSString *)name {
    self = [self init];
    if (self) {
        _persistentContainer = [self cloudPersistentContainerWithName:name isEnableKey:nil];
    }
    return self;
}

#pragma mark - Persistent Container
- (NSPersistentContainer *)localPersistentContainerWithName:(NSString *)name {
    NSPersistentContainer *container = [[NSPersistentContainer alloc] initWithName:name];
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        NSAssert(NO, @"ERROR");
    }];
    return container;
}

- (NSPersistentCloudKitContainer *)cloudPersistentContainerWithName:(NSString *)name isEnableKey:(NSString * _Nullable)isEnableKey {
    NSPersistentCloudKitContainer *container = [[NSPersistentCloudKitContainer alloc] initWithName:name];
    // 사용자가 아이클라우드 활성화 했으면 토큰이 있다.
    id iCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    // 스토어 옵션 불러와서 히스토리 추적 및 원격 변경 추적 활성화
    NSPersistentStoreDescription *storeDescription = container.persistentStoreDescriptions.firstObject;
    // [storeDescription setOption:@(YES) forKey:NSPersistentHistoryTrackingKey];
    // [storeDescription setOption:@(YES) forKey:NSPersistentStoreRemoteChangeNotificationPostOptionKey];
    // 위 옵션은 몇 더 테스트 해봐야 함.
    
    // 사용자가 아이클라우드 껐거나, 유비키가 있는데 그게 꺼져 있으면 전체 스토어 옵션을 지워버린다.
    if (!iCloudToken ||
        (isEnableKey && ![[NSUbiquitousKeyValueStore defaultStore] boolForKey:isEnableKey])) {
        storeDescription.cloudKitContainerOptions = nil;
    }
    
    // 스토어 로딩
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            NSAssert(NO, @"ERROR");
        }
    }];
    // 머지 정책 설정
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    // container.viewContext.transactionAuthor = @"APP"; // 트래킹 이름
    container.viewContext.automaticallyMergesChangesFromParent = YES;
    container.viewContext.shouldDeleteInaccessibleFaults = YES; // 삭제된 개체에 대한 장애 발생 시 걍 삭제함
    
    // 로드되는 동안 query generation 고정
    // container.viewContext.shouldDeleteInaccessibleFaults = YES;
    // 그런데  iOS 10 and macOS 10.12 부터는 스토리지 스냅샷을 떠서... 어떻게 하겠다는 건지.. 더 테스트 해와야 함
    // 참고: https://cocoacasts.com/what-are-core-data-query-generations
    // if (![container.viewContext setQueryGenerationFromToken:NSQueryGenerationToken.currentQueryGenerationToken error:nil]) {
    //    NSLog(@"Failed to pin viewContext to the current generation");
    //    NSAssert(NO, @"");
    // }

    
    // 컨테이너 반환
    return container;
}

#pragma mark - Info
- (NSManagedObjectContext *)context {
    return _persistentContainer.viewContext;
}

- (NSArray<NSEntityDescription *> *)entities {
    return _persistentContainer.persistentStoreCoordinator.managedObjectModel.entities;
    // OLD CODE
    //  NSPersistentStoreCoordinator *storeCoordinator = _persistentContainer.persistentStoreCoordinator;
    //  NSManagedObjectModel *model = storeCoordinator.managedObjectModel;
    //  return model.entities;
}

- (NSArray<NSPropertyDescription *> *)properties:(NSString *)entityName {
    return [[_persistentContainer.persistentStoreCoordinator.managedObjectModel.entitiesByName objectForKey:entityName] properties];
}


#pragma mark - 프리셋

// NSPredicate
//  %K : 따옴표 없이 문자열 치환(K는 대문자로 씀)
//  [c] : 대소문자 비교 안함
//  [d] : è é ê 같은 액션트 문자 구분 안함
//  < > != 등 표준 논리비교 연산자 및 괄호() 사용 가능. = 와 == 는 동일하게 처리됨
//  AND OR 혹은 && || 사용 가능. 부정어는 NOT 혹은 ! 사용. ex @"dateOfBirth < %@ AND NOT lastName == %@", currentDate, @"Smith"
//  BEGINSWITH : 시작일치 ex. @"department.name BEGINSWITH 'dep'"
//  ENDSWITH : 끝부분 일치 ex. @"department.name ENDSWITH 'Sales'"
//  CONTAINS : 포함 ex. @"department.name BEGINSWITH 'shipping'"
//  LIKE : 와일드카드(*, ?) 문자를 지정할 수 있음. ex. @"department.name BEGINSWITH 'De?i*n'"
//  MATCHES : 정규포현식 스타일 비교. ex. @"department.name MATCHES 'S[ao]les'" ; // sales 나 soles 모두 매칭함
//  BETWEEN : 범위 비쇼. ex @"student.age BETWEEN {10, 20}" ; // 10살~20살 학생
//  IN : 집합관계 ex. @"firstName IN %@", [someDic allValues]; 혹은 @"firstName IN {"A", "B", "C"}"
//  ANY, SOME, ALL, NONE 등도 있음.
- (NSPredicate *)predicate:(NSString *)attribute containsNoCaseNoAccent:(NSString *)searchString {
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attribute, searchString];
}

// NSSortDescriptor
//  - 특정 계산이 포함되어 정렬할 경우 sortDescriptorWithKey:ascending:comparator: 를 이용한다.
- (NSSortDescriptor *)sortDescriptorAscendingWithKey:(NSString *)key {
    return [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
}

- (NSSortDescriptor *)sortDescriptorDescendingWithKey:(NSString *)key {
    return [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
}

// NSFetchRequest
//  1. predicate :
//  2. sortDescriptors 결과를 어떻게 소팅할지 결정한다. 배열로 담는다.
//  3. 제한설정
//      * fetchBatchSize: 한 번에 가지고 올 갯수(DB에 한 번 연결하여 한방에 가지고 올 갯수). 0이면 무한대
//      * fetchLimit: 최대로 가지고 올 갯수(DB 연결 횟수와는 상관없이 최대로 가져올 자료 수). 0이면 무한대
//      * fetchOffset: 최대로 가지고 온 오프셋
//      예를 들어 fetchBatchSize = 20; fetchLimit = 100; 이면 한번 DB를 연결하여 20개씩 긁는데, 총 100개만 가져올 거라는 뜻임.
//      그러면 전체자료 1000 개 중 하나의 배열에 100개가 들어가는데, 그 중 20개만 실제로 들어가고 나머지는 80개는 폴트된다.
//      다시 리퀘스트를 만들어 DB에 연결되면 이전 오프셋을 지정해줘야 이어서 가져올 수 있다. fetchOffset = _prevOffset; 으로 지정해줘야 함.
//  4. resultType : NSManagedObject 로 담을지 objectID 를 담을지 등등을 결정한다. NSManagedObjectIDResultType 이 기본값이다.
//  과거에는 다음과 같이 만들었다.
//      * NSEntityDescription *entity = [NSEntityDescription entityForName:inManagedObjectContext:];
//      * NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//      * fetchRequest.entity = entity;
- (NSFetchRequest *)fetchRequestWithEntity:(NSString *)entityName predicate:(NSPredicate * _Nullable)predicate {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = predicate;
    return request;
}

- (NSFetchRequest *)fetchRequestFromEntity:(NSString *)entityName predicate:(NSPredicate * _Nullable)predicate sort:(NSArray<NSSortDescriptor *> * _Nullable)sortDescriptors limit:(NSUInteger)fetchLimit size:(NSUInteger)fetchBatchSize {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.fetchBatchSize = fetchBatchSize;
    request.fetchLimit = fetchLimit;
    request.sortDescriptors = sortDescriptors;
    request.predicate = predicate;
    return request;
}


// NSFetchedResultsController - 패치를 능동적으로 실행하고 델리게이트를 통해 컨트롤.
//  - 특히 리퀘스트에 fetchBatchSize 를 지정해줘야 함
//  - 섹션을 캐싱한다. 여러 섹션 데이터를 끊김없이 표시하는 것이 좋은 기능이다.
//    하지만 이렇게 미리 불러올 데이터가 아주 큰 경우에는 앱의 첫 실행 속도가 상당히 느려진다. 배칭한다 해도 여전히 섹션 이름을 찾아야 하기 때문에 느려지긴 마찬가지다.
//    따라서 매우 많은 데이터를 미리 불러와야 한다면 NSFetchedResultsController 를 사용하지 않거나, 섹션을 사용하지 않는 편이 좋다.
//  - NSFetchRequest 를 바꿀 경우 반드시 deleteCacheWithName: 으로 기존의 캐쉬를 제거해줘야 한다.
- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request sectionNameKeyPath:(nullable NSString *)keyPath cacheName:(nullable NSString *)name {
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_persistentContainer.viewContext sectionNameKeyPath:keyPath cacheName:name];
}


// 테이블의 최대/최소값 찾기
// NSExpression 을 통해 해당 테이블을 골라낸 후 max: 와 min: 의 최종값을 딕셔너리로 받는 형태이다.
- (NSNumber * _Nullable)numberMaxOfType:(NSAttributeType)type fromEntity:(NSString *)entityName attr:(NSString *)attrName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setResultType:NSDictionaryResultType];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:attrName];
    NSExpression *expression = [NSExpression expressionForFunction:@"max:" arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"Value"]; // 딕셔너리 키
    [expressionDescription setExpression:expression];
    [expressionDescription setExpressionResultType:type];
    [request setPropertiesToFetch:@[expressionDescription]];
    NSArray *objects = [self executeFetchRequest:request];
    return [objects.firstObject valueForKey:@"Value"];
}
- (NSNumber * _Nullable)numberMinOfType:(NSAttributeType)type fromEntity:(NSString *)entityName attr:(NSString *)attrName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setResultType:NSDictionaryResultType];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:attrName];
    NSExpression *expression = [NSExpression expressionForFunction:@"min:" arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"Value"]; // 딕셔너리 키
    [expressionDescription setExpression:expression];
    [expressionDescription setExpressionResultType:type];
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSArray *objects = [self executeFetchRequest:request];
    return [objects.firstObject valueForKey:@"Value"];
}
// 최대최소에 해당하는 항목의 오브젝트 전체를 반환한다.
// 이 원리는, 특정 필드로 정렬한 다음 최상위 딱 1개만 갖고오는 것이다. 다양하게 응용 가능함.
- (NSArray *)objectMaxFromEntity:(NSString *)entityName attr:(NSString *)attrName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor *sortOrder = [self sortDescriptorDescendingWithKey:attrName]; // 역순정렬. 최대값이 제일 위로 감.
    request.sortDescriptors = @[sortOrder];
    request.fetchLimit = 1;
    return [self executeFetchRequest:request];
}
- (NSArray *)objectMinFromEntity:(NSString *)entityName attr:(NSString *)attrName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor *sortOrder = [self sortDescriptorAscendingWithKey:attrName]; // 순정렬. 최소값이 제일 위로 감.
    request.sortDescriptors = @[sortOrder];
    request.fetchLimit = 1;
    return [self executeFetchRequest:request];
}


#pragma mark - Context CRUD
- (void)saveContext {
    NSError *error;
    if ([_persistentContainer.viewContext hasChanges] && ![_persistentContainer.viewContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request {
    NSError *error;
    NSArray *fetchedResult = [_persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (!fetchedResult) {
        NSLog(@"패치 에러 발생: %@", error);
    }
    return fetchedResult ? fetchedResult : @[];
}

/// 요청한 ID에 대한 Fault 객체를 반환한다. 가짜 ID로 요청해도 일단 fault 객체를 준다(프로퍼티 접근하면 터짐).
// objectWithID 메서드는 스토어에 해당 MO가 존재한다고 가정하고 객체를 반환한다. 즉 가짜를 반환할 수도 있다
- (__kindof NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID {
    return [_persistentContainer.viewContext objectWithID:objectID];
}

/// 등록된 ID에 대한 객체를 반환하며, 등록되지 않은 ID를 요청하면 nil 을 준다. 가능하면 이것을 이용한다.
- (nullable __kindof NSManagedObject *)objectRegisteredForID:(NSManagedObjectID *)objectID {
    return [_persistentContainer.viewContext objectRegisteredForID:objectID];
}

/// 요청한 ID에 대해 컨텍스트+스토어 전부에서 찾아서 존재하는 MO를 준다
//  existingObjectWithID:error 는 존재하는 MO만 반환한다. 즉 절대 fault를 리턴하지 않는다.
//  MO객체는 relation을 제외한 모든 필드가 꽉 채워진 상태로 반환된다.
- (nullable __kindof NSManagedObject *)existingObjectWithID:(NSManagedObjectID *)objectID error:(NSError **)error {
    return [_persistentContainer.viewContext existingObjectWithID:objectID error:error];
}

/// NSManagedObjectID 는 URI 로 표현될 수 있다. 반대로 이 메서드는 URI를 통해 NSManagedObjectID 를 반환한다.
- (nullable NSManagedObjectID *)managedObjectIDForURIRepresentation:(NSURL *)url {
    return [_persistentContainer.viewContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
}

- (NSManagedObject *)createObject:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_persistentContainer.viewContext];
}

- (void)deleteObject:(NSManagedObject *)object {
    [_persistentContainer.viewContext deleteObject:object];
}

- (void)clearEntity:(NSString *)entityName {
    NSPersistentStoreCoordinator *storeCoordinator = _persistentContainer.persistentStoreCoordinator;
    NSManagedObjectContext *context = _persistentContainer.viewContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *error;
    if (![storeCoordinator executeRequest:deleteRequest withContext:context error:&error]) {
        NSLog(@"패치 에러 발생: %@", error);
    }
}



@end
