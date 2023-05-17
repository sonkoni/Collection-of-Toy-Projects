//
//  MGUSegmentTextRenderView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUSegmentTextRenderView : UIView
@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong) UIFont  *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont  *selectedFont;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, assign) BOOL isSelectedTextGlowON;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) CGRect selectedTextDrawingRect;
@end

NS_ASSUME_NONNULL_END
