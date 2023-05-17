//
//  MGASegmentedControlStyleViewController.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGAPreferencesStyleInterface.h"
@protocol MGAPreferencePane;

NS_ASSUME_NONNULL_BEGIN

@interface MGASegmentedControlStyleViewController : NSViewController <MGAPreferencesStyleController>

@property (nonatomic, weak, nullable) id <MGAPreferencesStyleControllerDelegate>delegate;
@property (nonatomic, strong) NSSegmentedControl *segmentedControl; // @dynamic

- (instancetype)initWithPreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes;

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
