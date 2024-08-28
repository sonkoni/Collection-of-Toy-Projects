//
//  NSMutableArray+MGRFiltering.h
//  SampleBufferPlayer
//
//  Created by Kwan Hyun Son on 2020/06/29.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Filtering)


- (id)mgrRemovedObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
