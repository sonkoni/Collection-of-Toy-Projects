//
//  MGUSegment.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUSegmentTextRenderView;

@interface MGUSegment : UIView
@property (nonatomic) MGUSegmentTextRenderView *titleLabel;
@property (nonatomic) BOOL selected;
- (instancetype)initWithTitle:(NSString *)title;
@end
