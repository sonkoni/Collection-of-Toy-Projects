//
//  OutlineItem.h
//
//  Created by Kwan Hyun Son on 2021/01/01.
//
// Apple의 원래 프로젝트에서 - isEqual: 자체가 그냥 포인터 비교처럼되어있었다.
// 따라서 copying 프로토콜은 만들지도 않겠다.

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
@class OutlineItemLocationInfoValue;

NS_ASSUME_NONNULL_BEGIN

@interface OutlineItem : NSObject <NSItemProviderWriting, NSItemProviderReading, NSSecureCoding> // NSCoding ? Codable

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, nullable) Class viewControllerClass ; // 클래스 객체(싱글톤), UIViewController 계통만 가능.
@property (nonatomic, strong, readonly) NSArray <OutlineItem *>*subitems;
@property (nonatomic, strong, readonly) NSArray <OutlineItem *>*recurrenceAllSubitems; // @dynamic
@property (nonatomic, weak) OutlineItem *superItem;
@property (nonatomic, strong, readonly) OutlineItemLocationInfoValue *currentLocationInfo; // @dynamic

- (instancetype)initWithTitle:(NSString *)title
               viewController:(Class _Nullable)viewControllerClass
                     subitems:(NSArray <OutlineItem *>* _Nullable)subitems;

- (void)appendSubitems:(NSArray <OutlineItem *>*)subitems;
- (void)insertSubitems:(NSArray <OutlineItem *>*)subitems afterItem:(OutlineItem *)afterItem;
- (void)insertSubitems:(NSArray <OutlineItem *>*)subitems beforeItem:(OutlineItem *)beforeItem;

- (void)deleteSubitems:(NSArray <OutlineItem *>*)items;
- (void)deleteAllSubitems;
- (void)removeFromSuperitem;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


//!------------------------------------------------------------------------------------------------------------------------------------------
/*!
 * @class OutlineItemLocationValue
 * @abstract 옮길 때, 위치에 대한 정보를 얻기 위한 Value 객체. Swift의 Tuple 같은 존재.
 * @discussion CGPoint location, CGPoint translation, CGPoint velocity 가 존재한다. 초기화는 함수로만 가능하도록 만들었다.
 */
@interface OutlineItemLocationInfoValue : NSObject <NSCopying>
@property (nonatomic, nullable) OutlineItem *superItem;
//@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, nullable) OutlineItem *afterItem;
@property (nonatomic, nullable) OutlineItem *beforeItem;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

extern OutlineItemLocationInfoValue * _Nonnull OutlineItemLocationInfoValueMake(OutlineItem * _Nullable superItem,
                                                                                OutlineItem * _Nullable afterItem,
                                                                                OutlineItem * _Nullable beforeItem);
const BOOL OutlineItemLocationInfoValueEqualToValue(OutlineItemLocationInfoValue *value1, OutlineItemLocationInfoValue *value2);

NS_ASSUME_NONNULL_END
