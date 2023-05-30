//
//  Data.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/04/23.
//

#import "EmailCellModel.h"

@interface EmailCellModel ()
@property (class, nonatomic, strong, readonly) NSArray <EmailCellModel *>*mockEmails;
@end

@implementation EmailCellModel
@dynamic relativeDateString;
static NSArray <EmailCellModel *>*_mockEmails = nil;

+ (NSArray <EmailCellModel *>*)mockEmails {
    if (_mockEmails == nil) {
        EmailCellModel *email1 =
        [[EmailCellModel alloc] initWithFrom:@"Realm"
                            subject:@"Video: Operators and Strong Opinions with Erica Sadun"
                               body:@"Swift operators are flexible and powerful. They’re symbols that behave like functions, adopting a natural mathematical syntax, for example 1 + 2 versus add(1, 2). So why is it so important that you treat them like potential Swift Kryptonite? Erica Sadun discusses why your operators should be few, well-chosen, and heavily used. There’s even a fun interactive quiz! Play along with “Name That Operator!” and learn about an essential Swift best practice."
                               date:[NSCalendar nowAddingDays:0]];
        
        EmailCellModel *email2 =
        [[EmailCellModel alloc] initWithFrom:@"The Pragmatic Bookstore"
                            subject:@"[Pragmatic Bookstore] Your eBook 'Swift Style' is ready for download"
                               body:@"Hello, The gerbils at the Pragmatic Bookstore have just finished hand-crafting your eBook of Swift Style. It's available for download at the following URL:"
                               date:[NSCalendar nowAddingDays:0]];
        
        EmailCellModel *email3 =
        [[EmailCellModel alloc] initWithFrom:@"Instagram"
                            subject:@"mrx, go live and send disappearing photos and videos"
                               body:@"Go Live and Send Disappearing Photos and Videos. We recently announced two updates: live video on Instagram Stories and disappearing photos and videos for groups and friends in Instagram Direct."
                               date:[NSCalendar nowAddingDays:-1]];
        
        EmailCellModel *email4 =
        [[EmailCellModel alloc] initWithFrom:@"Smithsonian Magazine"
                            subject:@"Exclusive Sneak Peek Inside | Untold Stories of the Civil War"
                               body:@"For the very first time, the Smithsonian showcases the treasures of its Civil War collections in Smithsonian Civil War. This 384-page, hardcover book takes readers inside the museum storerooms and vaults to learn the untold stories behind the Smithsonian's most fascinating and significant pieces, including many previously unseen relics and artifacts. With over 500 photographs and text from forty-nine curators, the Civil War comes alive."
                               date:[NSCalendar nowAddingDays:-2]];
        
        EmailCellModel *email5 =
        [[EmailCellModel alloc] initWithFrom:@"Apple News"
                            subject:@"How to Change Your Personality in 90 Days"
                               body:@"How to Change Your Personality. You are not stuck with yourself. New research shows that you can troubleshoot personality traits — in therapy."
                               date:[NSCalendar nowAddingDays:-3]];
        
        EmailCellModel *email6 =
        [[EmailCellModel alloc] initWithFrom:@"Wordpress"
                            subject:@"New WordPress Site"
                               body:@"Your new WordPress site has been successfully set up at: http://example.com. You can log in to the administrator account with the following information:"
                               date:[NSCalendar nowAddingDays:-4]];
        
        EmailCellModel *email7 =
        [[EmailCellModel alloc] initWithFrom:@"IFTTT"
                            subject:@"See what’s new & notable on IFTTT"
                               body:@"See what’s new & notable on IFTTT. To disable these emails, sign in to manage your settings or unsubscribe."
                               date:[NSCalendar nowAddingDays:-5]];
        
        EmailCellModel *email8 =
        [[EmailCellModel alloc] initWithFrom:@"Westin Vacations"
                            subject:@"Your Westin exclusive expires January 11"
                               body:@"Last chance to book a captivating 5-day, 4-night vacation in Rancho Mirage for just $389. Learn more. No images? CLICK HERE"
                               date:[NSCalendar nowAddingDays:-6]];
        
        EmailCellModel *email9 =
        [[EmailCellModel alloc] initWithFrom:@"Nugget Markets"
                            subject:@"Nugget Markets Weekly Specials Starting February 15, 2017"
                               body:@"Scan & Save. For this week’s Secret Special, let’s “brioche” the subject of breakfast. This Friday and Saturday, February 24–25, buy one loaf of Euro Classic Brioche and get one free! This light, soft, hand-braided buttery brioche loaf from France is perfect for an authentic French toast feast. Make Christmas morning extra special with our Signature Recipe for Crème Brûlée French Toast Soufflé!"
                               date:[NSCalendar nowAddingDays:-7]];
        
        EmailCellModel *email10 =
        [[EmailCellModel alloc] initWithFrom:@"GeekDesk"
                            subject:@"We have some exciting things happening at GeekDesk!"
                               body:@"Wouldn't everyone be so much happier if we all owned GeekDesks?"
                               date:[NSCalendar nowAddingDays:-8]];
        
        _mockEmails = @[email1, email2, email3, email4, email5, email6, email7, email8, email9, email10];
    }
    
    return _mockEmails;
}

#pragma mark - 생성 & 소멸
- (instancetype)initWithFrom:(NSString *)from
                     subject:(NSString *)subject
                        body:(NSString *)body
                        date:(NSDate *)date {
    self = [super init];
    if (self) {
        CommonInit(self);
        _from = from;
        _subject = subject;
        _body = body;
        _date = date;
    }
    return self;
}

static void CommonInit(EmailCellModel *self) {
    self->_unread = NO;
}

- (NSString *)relativeDateString {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    if ( [currentCalendar isDateInToday:self.date] ) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.timeStyle = NSDateFormatterShortStyle;
        return [formatter stringFromDate:self.date];
    } else {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.doesRelativeDateFormatting = YES;
        return [formatter stringFromDate:self.date];
    }
}

@end

@implementation NSCalendar (EXtention)
+ (NSDate *)nowAddingDays:(NSInteger)days {
    NSDate *date = [NSDate date];
    return [date dateByAddingTimeInterval:(NSTimeInterval)(days) * 60.0 * 60.0 * 24.0];
}
@end
