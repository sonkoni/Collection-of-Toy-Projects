//
//  MGUAlertViewButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

@interface MGUAlertViewButton : UIButton

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) UIAlertActionStyle alertActionStyle; // Sheet Mode에 대비하기 위해.
@property (nonatomic) UIColor *highlightedButtonBackgroundColor;

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end
