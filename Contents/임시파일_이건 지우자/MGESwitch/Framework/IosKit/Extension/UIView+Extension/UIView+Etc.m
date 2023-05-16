//
//  UIView+Etc.m
//
//  Created by Kwan Hyun Son on 26/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIView+Etc.h"

@implementation UIView (Etc)

- (BOOL)mgrIsRTLLocale {
    UIUserInterfaceLayoutDirection interfaceLayoutDirection =
    [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute];
    if (interfaceLayoutDirection != UIUserInterfaceLayoutDirectionRightToLeft) {
        return NO;
    } else {
        return YES;
    }
    //
    // MGSwipeTableCell(https://github.com/MortimerGoro/MGSwipeTableCell) 에서 참고함.
    //    if (@available(iOS 9, *)) {
    //        return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
    //    } else if ([self isAppExtension]) { // [[NSBundle mainBundle].executablePath rangeOfString:@".appex/"].location != NSNotFound
    //        return [NSLocale characterDirectionForLanguage:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]]==NSLocaleLanguageDirectionRightToLeft;
    //    } else {
    //        UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    //        return application.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    //    }
}

- (__kindof UIView *)mgrCopyView {
    NSLog(@"- mgrCopyView 이것은 디버깅용이다.");
    NSError *error = nil;
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [archiver encodeObject:self forKey:@"view"];
    [archiver finishEncoding];
    NSData *data = [archiver encodedData];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
    if (error != nil) { NSLog(@"error 발생 %@", error); }
    unarchiver.requiresSecureCoding = NO;
    UIView *result = [unarchiver decodeObjectForKey:@"view"];
    [result removeConstraints:result.constraints]; // 반드시 필요하다. 자기자신의 가로세로가 고정되어있다면 이것도 복사가 되기 때문이다.
    return result;
    
//    return [unarchiver decodeObjectForKey:@"view"];
    
    /*! Deprecated 된 메서드를 이용하는 방법.
    NSError *error = nil;
    NSData *viewCopyData =
    [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
    if (error != nil) {
        NSLog(@"에러 %@", error);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIView *result = [NSKeyedUnarchiver unarchiveObjectWithData:viewCopyData];
    [result removeConstraints:result.constraints]; // 반드시 필요하다. 자기자신의 가로세로가 고정되어있다면 이것도 복사가 되기 때문이다.
    return result;
#pragma clang diagnostic pop
     
     // 애플이 예전에 사용했던 방식과 유사하다. MenuItemViewEmbeddinganNSViewinsideanNSMenuItem 프로젝트 아카이브 문서에 있음.
     NSData *viewCopyData = [NSArchiver archivedDataWithRootObject:self.myButtonView];
     id viewCopy = [NSUnarchiver unarchiveObjectWithData:viewCopyData];
     */
    
    /* Unpublished APIs를 이용하는 방법. 이거를 상단에 적어준다.
    @interface UINibEncoder : NSCoder
    - initForWritingWithMutableData:(NSMutableData*)data;
    - (void)finishEncoding;
    @end

    @interface UINibDecoder : NSCoder
    - initForReadingWithData:(NSData *)data error:(NSError **)err;
    @end
    
    // 이제 다음의 방식으로 복제한다.
    NSError *error = nil;
    NSMutableData *mData = [NSMutableData new];
    UINibEncoder *encoder = [[UINibEncoder alloc] initForWritingWithMutableData:mData];
    [encoder encodeObject:self forKey:@"view"];
    [encoder finishEncoding];
    UINibDecoder *decoder = [[UINibDecoder alloc] initForReadingWithData:mData error:&error];
    UIView *result = [decoder decodeObjectForKey:@"view"];
    [result removeConstraints:result.constraints]; // 반드시 필요하다. 자기자신의 가로세로가 고정되어있다면 이것도 복사가 되기 때문이다.
    return result;
    */
}
@end
