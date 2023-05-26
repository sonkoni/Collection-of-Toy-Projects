//
//  EmailCellModel.h
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/04/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmailCellModel : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL unread; // 디폴트 NO
@property (nonatomic, strong, readonly) NSString *relativeDateString; // @dynamic


- (instancetype)initWithFrom:(NSString *)from
                     subject:(NSString *)subject
                        body:(NSString *)body
                        date:(NSDate *)date;

+ (NSArray <EmailCellModel *>*)mockEmails;

@end



@interface NSCalendar (EXtention)
+ (NSDate *)nowAddingDays:(NSInteger)days;
@end

NS_ASSUME_NONNULL_END
