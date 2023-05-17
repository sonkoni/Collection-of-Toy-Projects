//
//  MGUSideBarConfig.h
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//! A파트와 B파트의 조합으로 만든다. A 파트에서 반드시 한개만 존재해야하고, B 파트는 선택
typedef NS_OPTIONS (NSInteger, MGUSideBarControllerTransitionStyle) {
    MGUSideBarControllerTransitionStyleNone     = 0,      // 0000 0000
    
    //! A 파트
    MGUSideBarControllerTransitionStyleLeading  = 1 << 0, // 0000 0001  /** Leading에서 등장함. */
    MGUSideBarControllerTransitionStyleTrailing = 1 << 1, // 0000 0010  /** Trailing에서 등장함. */
    MGUSideBarControllerTransitionStyleLeft     = 1 << 2, // 0000 0100  /** Left에서 등장함. */
    MGUSideBarControllerTransitionStyleRight    = 1 << 3, // 0000 1000  /** Right에서 등장함. */
    
    //! B 파트
    MGUSideBarControllerTransitionStyleDisplace = 1 << 4, // 0001 0000  /** 밀어버린다. 디폴트는 Overlay*/
    MGUSideBarControllerTransitionStyleReveal   = 1 << 5, // 0010 0000  /** 들어난다. 디폴트는 Overlay*/
};

// 사이드로 나오는 뷰의 크기를 부모의 비율러 정할지, 아니면 절대 사이즈로 할지.
typedef struct CG_BOXABLE MGUSideBarWidthDeterminant {
    CGFloat ratio;
    CGFloat absoluteWidth;
    BOOL isRatio; // NO 일때에는 ratio가 존재하면(0.0이 아니면) ratio를 max로 잡아준다.
} MGUSideBarWidthDeterminant;

static MGUSideBarWidthDeterminant const MGUSideBarWidthDeterminantDefault = {0.79, 100.0, YES};

CG_INLINE MGUSideBarWidthDeterminant MGUSideBarWidthDeterminantMake(CGFloat ratio, CGFloat absoluteWidth, BOOL isRatio) {
    MGUSideBarWidthDeterminant determinant = {ratio, absoluteWidth, isRatio};
    return determinant;
}

@interface MGUSideBarConfig : NSObject
@property (nonatomic, assign) BOOL backgroundTapDismissalGestureEnabled; // 디폴트 : YES
@property (nonatomic, assign) BOOL acceptFirstResponder; // 텍스트 필드가 존재할 때. 띄우면서 퍼스트 리스폰더로 만들것인지여부.
@property (nonatomic, assign) MGUSideBarWidthDeterminant widthDeterminant;
@property (nonatomic, assign) MGUSideBarControllerTransitionStyle transitionStyle;
@property (nonatomic, assign, readonly) BOOL isDirectionLeft; // @dynamic : transitionStyle의 정확한 방향을 알려준다.
@end

NS_ASSUME_NONNULL_END

