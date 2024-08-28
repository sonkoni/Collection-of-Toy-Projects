//
//  OutlineItemCell.h
//  Modern Collection Views
//
//  Created by Kwan Hyun Son on 2021/01/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGROutlineItemCell : UICollectionViewCell

@property (class, nonatomic, strong, readonly) NSString *reuseIdentifer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, getter=isExpanded) BOOL expanded;
@property (nonatomic, getter=isGroup) BOOL group;
@property (nonatomic, assign) NSInteger indentationLevel; // 디폴트 0 : 1단계마다 20씩 증가.
@property (nonatomic, assign) CGFloat indentationWidth; // 디폴트 20.0


- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
