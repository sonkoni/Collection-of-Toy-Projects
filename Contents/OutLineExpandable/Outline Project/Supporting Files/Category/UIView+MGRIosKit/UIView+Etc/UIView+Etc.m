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

@end
