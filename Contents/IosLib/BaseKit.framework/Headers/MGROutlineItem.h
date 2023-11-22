//
//  MGROutlineItem.h
//
//  Created by Kwan Hyun Son on 2021/01/01.
//
// Apple의 원래 프로젝트에서 - isEqual: 자체가 그냥 포인터 비교처럼되어있었다.
// 따라서 copying 프로토콜은 만들지도 않겠다.

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#endif

#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
@class MGROutlineItemLocationInfoValue;
@class MGROutlineItem;
typedef const MGROutlineItemLocationInfoValue *MGROutlineItemLocation;

NS_ASSUME_NONNULL_BEGIN

@protocol MGROutlineItemContent
@required
@property (nonatomic, weak) MGROutlineItem *outlineItem;
@end

typedef NSString * MGROutlineItemKey NS_TYPED_ENUM;
static MGROutlineItemKey const MGROutlineItemContentItemKey = @"contentItem";
static MGROutlineItemKey const MGROutlineItemIsFolderKey = @"isFolder";
static MGROutlineItemKey const MGROutlineItemSubitemsKey = @"subitems";

@interface MGROutlineItem<__covariant ObjectType: id<NSSecureCoding>> : NSObject <NSItemProviderWriting, NSItemProviderReading, NSSecureCoding>

@property (nonatomic, strong) ObjectType contentItem;
@property (nonatomic, readonly) NSArray <MGROutlineItem <ObjectType>*>*subitems;
@property (nonatomic, readonly) NSArray <MGROutlineItem <ObjectType>*>*recurrenceAllSubitems; // @dynamic 자기자신 제외. 위치를 확인하기 위해. Temp 이용
@property (nonatomic, readonly) NSArray <MGROutlineItem <ObjectType>*>*recurrenceAllExpandedSubitems; // @dynamic 자기자신 제외. expand 전체를 확인하기 위해. Temp 이용
@property (nonatomic, readonly) NSArray <MGROutlineItem <ObjectType>*>*recurrenceAllCollapsedSubitems; // @dynamic 자기자신 제외. collapse 전체를 확인하기 위해. Temp 이용
//collapse
@property (nonatomic, weak) MGROutlineItem <ObjectType>*superItem;
@property (nonatomic, readonly, nullable) MGROutlineItem <ObjectType>*progenitor; // @dynamic 자신의 최종 뿌리
@property (nonatomic, readonly) MGROutlineItemLocation currentLocationInfo; // @dynamic

//! iOS 14에서는 사용자체를 안할 것으로 예상된다.
@property (nonatomic, getter=isExpanded) BOOL expanded;     // 디폴트 NO
@property (nonatomic, readonly) BOOL isFolder;
@property (nonatomic, readonly) BOOL hasSubitem;            // @dynamic
@property (nonatomic, readonly) NSInteger indentationLevel;      // @dynamic

//! 모두 가능.
- (instancetype)initWithContentItem:(ObjectType)contentItem
                           isFolder:(BOOL)isFolder
                           subitems:(NSArray <MGROutlineItem <ObjectType>*>* _Nullable)subitems;

//! 폴더에서 사용.
+ (instancetype)outlineWithContentItem:(ObjectType)contentItem
                              subitems:(NSArray <MGROutlineItem <ObjectType>*>* _Nullable)subitems; // nil 이면 빈 폴더 의미.
//! 폴더가 아닌 곳에서 사용.
+ (instancetype)outlineWithContentItem:(ObjectType)contentItem;

//! 임시 루트. 계산을 위해 필요하다.
+ (instancetype)tempRootWithSubitems:(NSArray <MGROutlineItem <ObjectType>*>*)subitems;

- (void)appendSubitems:(NSArray <MGROutlineItem <ObjectType>*>*)subitems;
- (void)insertSubitems:(NSArray <MGROutlineItem <ObjectType>*>*)subitems afterItem:(MGROutlineItem <ObjectType>*)afterItem;
- (void)insertSubitems:(NSArray <MGROutlineItem <ObjectType>*>*)subitems beforeItem:(MGROutlineItem <ObjectType>*)beforeItem;

- (void)deleteSubitems:(NSArray <MGROutlineItem <ObjectType>*>*)items;
- (void)deleteAllSubitems;
- (void)removeFromSuperitem;
- (BOOL)isTempRoot;

/*!
 * @method      superitemsToUpperLimit
 * @abstract    OmniOutliner를 참고하여 만들었다. 제스처가 위치한 손가락의 셀을 바깥쪽으로 초과하여 이동할 수 있는 super item을 모은다.
 * @discussion  컨텐츠 또는 폴더일 경우 닫힌경우 바깥쪽으로 초과하여 super item으로 이동가능할 수 있다. 올라가다가 subitem이 super item의 last item이 아니라면 그 super 까지가 마지막이다.
 * @warning     이렇게 모을 수 있는 조건 자체가 현재 위치의 아이템이 그 아이템의 super의 last 아이템임을 가정한다.
 * @return      MGROutlineItem 인스턴스를 포함하는 배열, 루트가 최종일 경우 NSNull 객체를 넣을 수 있다.
 */
- (NSArray <MGROutlineItem <ObjectType>*>*)superitemsToUpperLimit;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


//!------------------------------------------------------------------------------------------------------------------------------------------
/*!
 * @class MGROutlineItemLocationInfoValue
 * @abstract 옮길 때, 위치에 대한 정보를 얻기 위한 Value 객체. Swift의 Tuple 같은 존재.
 * @discussion CGPoint location, CGPoint translation, CGPoint velocity 가 존재한다. 초기화는 함수로만 가능하도록 만들었다.
 */
@interface MGROutlineItemLocationInfoValue : NSObject <NSCopying>
@property (nonatomic, nullable) MGROutlineItem *superItem;
@property (nonatomic, nullable) MGROutlineItem *afterItem;
@property (nonatomic, nullable) MGROutlineItem *beforeItem;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

extern const MGROutlineItemLocation _Nonnull MGROutlineItemLocationMake(MGROutlineItem * _Nullable superItem,
                                                                  MGROutlineItem * _Nullable afterItem,
                                                                  MGROutlineItem * _Nullable beforeItem);
extern const BOOL MGROutlineItemLocationEqualToLocation(MGROutlineItemLocation value1, MGROutlineItemLocation value2);

@end

NS_ASSUME_NONNULL_END
