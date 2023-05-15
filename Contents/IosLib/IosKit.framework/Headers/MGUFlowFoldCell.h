//
//  MGUFlowFoldCell.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUFlowCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUFlowFoldCell : MGUFlowCell
@property (nonatomic, assign, getter = isFoldingShadowHidden) BOOL foldingShadowHidden; // 디폴트 NO;
@end

NS_ASSUME_NONNULL_END
