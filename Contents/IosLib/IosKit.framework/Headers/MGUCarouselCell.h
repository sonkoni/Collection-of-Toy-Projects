//
//  MGUCarouselCell.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUCarouselCell : UICollectionViewCell
@property (nonatomic, strong, nullable) UILabel *textLabel; // 셀의 메인 텍스트 컨텐츠에 사용된 UILabel.
@property (nonatomic, strong, nullable) UIImageView *imageView; // 셀의 이미지 뷰디폴트 값은 nil.
@property (nonatomic, strong) UIColor *selectionColor;
@end

NS_ASSUME_NONNULL_END

