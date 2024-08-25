//
//  MGUTextView.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-02-27
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUTextView : UITextView
@property (nonatomic, strong) NSString *placeHolderText;
@property (nonatomic, strong, nullable) NSString *rightButtonTitle;
@property (nonatomic, assign) BOOL isUseRightButton; // YES
@property (nonatomic, copy, nullable) void (^rightButtonCompletion)(void);
@end

NS_ASSUME_NONNULL_END
