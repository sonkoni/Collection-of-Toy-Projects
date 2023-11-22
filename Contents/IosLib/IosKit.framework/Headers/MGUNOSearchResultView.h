//
//  MGUNOSearchResultView.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-10-17
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUNOSearchResultViewImageType) {
    MGUNOSearchResultViewImageTypeShow = 0, // 이미지 항상 보이기 디폴트
    MGUNOSearchResultViewImageTypeHidden,   // 이미지 항상 감추기
    MGUNOSearchResultViewImageTypeDynamic   // 이미지 vertical compact 일때 감추기
};

@interface MGUNOSearchResultView : UIView
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) MGUNOSearchResultViewImageType imageType; // default .Show
- (void)applyImage:(UIImage *)image; // 새로운 이미지를 설정할 수 있다.
@end

NS_ASSUME_NONNULL_END
