//
//  MGUFlowIndicatorSupplementaryView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUFlowFoldTransformer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUFlowIndicatorSupplementaryView : UICollectionViewCell
@property (nonatomic, strong) MGUFlowElementKindFold elementKindFold; // Leading, Trailing
@property (nonatomic, strong) UIColor *indicatorColor; // 디폴트 black
@property (nonatomic, assign) CGSize indicatorSize; // 디폴트 CGSizeZero // 알아서 만든다.
@end

NS_ASSUME_NONNULL_END
