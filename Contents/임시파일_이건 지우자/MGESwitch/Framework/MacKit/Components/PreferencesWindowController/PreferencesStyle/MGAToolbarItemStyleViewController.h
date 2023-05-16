//
//  MGAToolbarItemStyleViewController.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGAPreferencesStyleInterface.h"
@protocol MGAPreferencePane;
@protocol MGAPreferencesStyleControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MGAToolbarItemStyleViewController : NSObject <MGAPreferencesStyleController>

@property (nonatomic, strong) NSToolbar *toolbar;
@property (nonatomic, assign) BOOL centerToolbarItems;
@property (nonatomic, strong) NSMutableArray <NSViewController <MGAPreferencePane>*>*preferencePanes;
@property (nonatomic, weak, nullable) id <MGAPreferencesStyleControllerDelegate>delegate;

- (instancetype)initWithPreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes
                                toolbar:(NSToolbar *)toolbar
                     centerToolbarItems:(BOOL)centerToolbarItems;


@end

NS_ASSUME_NONNULL_END
