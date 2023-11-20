//
//  NSException+MGRDescription.h
//  NSErrorTEST
//
//  Created by Kwan Hyun Son on 10/06/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSException (Description)

- (void)mgrDescription;  // DEBUG ONLY

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
