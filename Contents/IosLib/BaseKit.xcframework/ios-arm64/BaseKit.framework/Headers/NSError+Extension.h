//
//  NSError+MGRDescription.h
//  AppleMusicAppSync
//
//  Created by Kwan Hyun Son on 09/06/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Description)

- (void)mgrDescription;  // DEBUG ONLY

- (NSException *)mgrMakeException;

- (void)mgrMakeExceptionAndThrow;

- (LAError)mgrConvertLAError; // Touch ID, Face ID 에러 종류
@end

NS_ASSUME_NONNULL_END

/***
Person *person = [Person new];
@try {
	NSError *error;
	[person error:&error];
	if (error != nil) {
		NSException *excpt = [error mgrMakeException];
		@throw(excpt);
	}
} @catch(NSException *excpt) {
	[excpt mgrDescription];
}

//----- 더 간단한 표현.

Person *person = [Person new];
@try {
	NSError *error;
	[person error:&error];
	[error mgrMakeExceptionAndThrow];
} @catch(NSException *excpt) {
	[excpt mgrDescription];
}
**/
