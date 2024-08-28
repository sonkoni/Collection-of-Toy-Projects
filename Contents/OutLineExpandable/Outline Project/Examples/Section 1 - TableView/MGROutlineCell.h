//
//  MGROutlineCell.h
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/09/02.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGROutlineCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, getter=isExpanded) BOOL expanded;
@property (nonatomic, getter=isGroup) BOOL group;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END




//
//@property (nonatomic, getter=isExpanded) BOOL expanded;
//@property (nonatomic, getter=isGroup) BOOL group;
//@property (nonatomic, assign) NSInteger indentationLevel; // 디폴트 0 : 1단계마다 20씩 증가.
//@property (nonatomic, assign) CGFloat indentationWidth; // 디폴트 20.0
