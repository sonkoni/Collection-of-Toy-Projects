//
//  MGUMessagesCornerRoundingView.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE @interface MGUMessagesCornerRoundingView : UIView
@property (nonatomic) IBInspectable CGFloat cornerRadius; // 디폴트 0.0
@property (nonatomic) IBInspectable BOOL roundsLeadingCorners;  // 디폴트 NO
@property (nonatomic, assign) UIRectCorner roundedCorners; // 디폹트 UIRectCornerAllCorners
@end

NS_ASSUME_NONNULL_END
