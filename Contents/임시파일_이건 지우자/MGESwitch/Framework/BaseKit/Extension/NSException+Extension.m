//
//  NSException+MGRDescription.m
//  NSErrorTEST
//
//  Created by Kwan Hyun Son on 10/06/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSException+Extension.h"

@implementation NSException (Description)

- (void)mgrDescription {
#if DEBUG
    NSLog(@"name : %@", self.name);
    NSLog(@"reason : %@", self.reason);
    NSLog(@"userInfo dictionary");
    for (NSString *key in self.userInfo.allKeys) {
        NSLog(@"키 : %@", key);
        NSLog(@"값 : %@", self.userInfo[key]);
    }
#endif  /* DEBUG */
}

@end


//
//reason
//
