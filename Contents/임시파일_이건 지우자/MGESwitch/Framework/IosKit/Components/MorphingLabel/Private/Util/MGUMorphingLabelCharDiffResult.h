//
//  LTCharacterDiffResult.h
//  MGUMorphingLabel
//
//  Created by Kwan Hyun Son on 24/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUMorphingLabelCharDiffResultType) {
    MGUMorphingLabelCharDiffResultTypeSame = 1, // 0은 피하는 것이 좋다.
    MGUMorphingLabelCharDiffResultTypeAdd,
    MGUMorphingLabelCharDiffResultTypeDelete,
    MGUMorphingLabelCharDiffResultTypeMove,          // offset 필요
    MGUMorphingLabelCharDiffResultTypeMoveAndAdd,    // offset 필요
    MGUMorphingLabelCharDiffResultTypeReplace
};

// MGUMorphingLabelCharDiffResult : Character Difference Result
@interface MGUMorphingLabelCharDiffResult : NSObject
@property (nonatomic, assign) MGUMorphingLabelCharDiffResultType resultType;
@property (nonatomic, assign) NSInteger offset;

- (instancetype)initWithEnum:(MGUMorphingLabelCharDiffResultType)resultType;
              
- (NSString *)debugDescription; // 재정의.
- (BOOL)isEqual:(MGUMorphingLabelCharDiffResult *)object;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
