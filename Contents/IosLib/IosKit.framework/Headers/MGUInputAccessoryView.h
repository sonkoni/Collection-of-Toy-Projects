//
//  MGUInputAccessoryView.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import <IosKit/MGUInputTextView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUInputAccessoryView : UIView
@property (strong, nonatomic, nullable) IBOutlet MGUInputTextView *inputTextView;
@property (nonatomic, copy, nullable) void (^sendCompletion)(NSString *);
@property (nonatomic, strong) NSString *placeHolderText;
@end

NS_ASSUME_NONNULL_END
