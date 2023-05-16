//
//  MGRDoseCollectionViewCell.m
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUDosePickerCollectionViewCell.h"

@implementation MGUDosePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [transition setDuration:0.15];
    [self.label.layer addAnimation:transition forKey:nil];
    self.label.font = (self.selected == YES) ? self.highlightedFont : self.font;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUDosePickerCollectionViewCell *self) {
    self.layer.doubleSided = NO; // 별차이를 못느끼겠다. 위키 Api:Core Animation/CALayer/doubleSided
    self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.label.backgroundColor      = [UIColor clearColor];
    self.label.textColor            = [UIColor grayColor];
    self.label.highlightedTextColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 1;
    self.label.lineBreakMode = NSLineBreakByTruncatingTail; // 길어졌을 때 뒤쪽 부분이 말줄임표(...)로 표시된다. 위키 참고.
    self.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.label.translatesAutoresizingMaskIntoConstraints = YES;
    self.label.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin    |
                                   UIViewAutoresizingFlexibleLeftMargin   |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleRightMargin);
    [self.contentView addSubview:self.label];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.imageView];
    
    self.label.userInteractionEnabled     = NO;
    self.imageView.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
}

@end
