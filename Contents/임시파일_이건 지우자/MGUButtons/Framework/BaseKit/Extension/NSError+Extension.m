//
//  NSError+MGRDescription.m
//  AppleMusicAppSync
//
//  Created by Kwan Hyun Son on 09/06/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSError+Extension.h"
#import "NSException+Extension.h"

@implementation NSError (Description)

- (void)mgrDescription {
#if DEBUG
    NSLog(@"%@", self.domain);
    NSLog(@"%ld", (long)self.code);
    NSLog(@"%@", self.userInfo);
    NSLog(@"%@", self.localizedDescription);
    NSLog(@"%@", self.localizedFailureReason);
    NSLog(@"%@", self.localizedRecoverySuggestion);
    NSLog(@"%@", self.localizedRecoveryOptions);
#endif  /* DEBUG */
}

- (NSException *)mgrMakeException {
    
    NSString *reason =
    [NSString stringWithFormat:@"에러 도메인 : %@ \n 에러코드 : %ld \n 실패이유 : %@ \n 복구제안 : %@ \n 복구옵션 : %@"
     , self.domain, (long)self.code, self.localizedFailureReason, self.localizedRecoverySuggestion, self.localizedRecoveryOptions];
    
    NSException *exception = [NSException exceptionWithName:self.localizedDescription
                                                     reason:reason
                                                   userInfo:self.userInfo];
    
    return exception;
}

- (void)mgrMakeExceptionAndThrow {
    NSException *e = [self mgrMakeException];
    @throw(e);
}

@end

//typedef NSString * NSExceptionName;
/***************    Generic Exception names        ***************/
//NSExceptionName const NSGenericException;
//NSExceptionName const NSRangeException;
//NSExceptionName const NSInvalidArgumentException;
//NSExceptionName const NSInternalInconsistencyException;

//NSExceptionName const NSMallocException;

//NSExceptionName const NSObjectInaccessibleException;
//NSExceptionName const NSObjectNotAvailableException;
//NSExceptionName const NSDestinationInvalidException;

//NSExceptionName const NSPortTimeoutException;
//NSExceptionName const NSInvalidSendPortException;
//NSExceptionName const NSInvalidReceivePortException;
//NSExceptionName const NSPortSendException;
//NSExceptionName const NSPortReceiveException;

//NSExceptionName const NSOldStyleException;

//NSExceptionName const NSInconsistentArchiveException;
//
/*** 예시
NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                 reason:@"이러이러한 이유 "
                                               userInfo:userInfoDic];
*/
