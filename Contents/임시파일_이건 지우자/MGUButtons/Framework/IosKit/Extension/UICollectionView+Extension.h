//  UICollectionView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-27
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Extension)

//! 둘 다 index path가 낮은 순부터 정렬하여 반환한다.
- (NSArray <NSIndexPath *>* _Nullable)mgrOrderedIndexPathsForVisibleItems;
- (NSArray <NSIndexPath *>* _Nullable)mgrOrderedIndexPathsForFullVisibleItems; // collectionView 내부에 완전히 들어오는 visible 한 indexpath
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-07-27 : 최초 작성
 */
// https://stackoverflow.com/questions/46829901/how-to-determine-when-a-custom-uicollectionviewcell-is-100-on-the-screen/46833430#46833430
