//
//  MGUDosePickerCollectionViewLayout.m
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUDosePickerCollectionViewLayout.h"
#import "MGUDosePickerCollectionViewCell.h"
#import "MGUDosePickerView.h"

@interface MGUDosePickerCollectionViewLayout ()
//@property (nonatomic, assign) CGFloat width;
//@property (nonatomic, assign) CGFloat midX;    // 지금 현재 보이는 콜렉션 뷰에서 가운데점과 왼쪽 끝에서부터의 길이

@property (nonatomic, assign) CGFloat radius;  // <- 회전반경.
@property (nonatomic, assign) CGFloat midY;    // 지금 현재 보이는 콜렉션 뷰에서 가운데점과 위쪽 끝에서부터의 길이
@property (nonatomic, assign) CGFloat maxAngle;

@property (nonatomic, assign) CGFloat depth;  // MGUDosePickerViewStyleFlatCenterPop 에서 중심에서 떨어진 cell을 설정할 때 사용. 0보다 같거나 작다.
@property (nonatomic, assign) CGFloat height; // MGUDosePickerViewStyleFlatCenterPop 에서 중심으로 가까워진 cell을 설정할 때 사용. 0보다 같거나 크다.

@property (nonatomic, assign, readonly) MGUDosePickerViewStyle pickerViewStyle;
@end

@implementation MGUDosePickerCollectionViewLayout
@dynamic pickerViewStyle;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing      = 0.0; // 디폴트 10.0
        self.minimumInteritemSpacing = 0.0; // 디폴트 10.0  현재 프로젝트에서는 minimumInteritemSpacing = 0.0
        // self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0); // 디폴트.
        self.depth = -150;
        self.height = 100;
    }
    return self;
}

//! 현재 레이아웃을 업데이트하도록 레이아웃 객체에 지시한다
- (void)prepareLayout {
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    self.midY   = CGRectGetMidY(visibleRect);
    self.radius = CGRectGetHeight(visibleRect) / 2;
//    self.midX  = CGRectGetMidX(visibleRect);
//    self.width = CGRectGetWidth(visibleRect) / 2;
    self.maxAngle = M_PI_2; // pi/2 : 90˚
    //
    // 레이아웃 업데이트는 collection view가 처음으로 내용을 표시할 때와 view가 변경되어 레이아웃이 명시적 또는 묵시적으로 무효화될 때마다 발생한다.
}

//! 인수로 주어진 새 bounds에 레이아웃 업데이트가 필요한지 리시버(레이아웃 객체)에 묻는다.
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds { // 디폴트는 NO
    return YES;
    //
    // 서브 클래스가 이 메서드를 재정의하여 collection view의 bounds 변경따라 cell 및 supplementary view들의 레이아웃 변경이 필요한지 여부에
    // 따라 적절한 값을 반환할 수 있다.
    // collection view의 bounds가 변경되고 이 메서드가 YES를 반환하면,
    // collection view는 - invalidateLayoutWithContext: 메서드를 호출하여 레이아웃을 무효화한다.
}

//! 인수로 주어진 rect의 모든 셀과 뷰에 대한 UICollectionViewLayoutAttributes 배열을 반환한다.
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    switch (self.pickerViewStyle) {
        case MGUDosePickerViewStyleFlat: {
            return [super layoutAttributesForElementsInRect:rect];
            break;
        }
        case MGUDosePickerViewStyleFlatCenterPop: {
            NSMutableArray *attributes = [NSMutableArray array];
            if ([self.collectionView numberOfSections] > 0) {
                for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]]; //! 여기서 호출한다.
                }
            }
            
            return attributes;
            break;
        }
        case MGUDosePickerViewStyleCylinder: {
//            return [super layoutAttributesForElementsInRect:rect];
            NSMutableArray *attributes = [NSMutableArray array];
            if ([self.collectionView numberOfSections] > 0) {
                for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]]; //! 여기서 호출한다.
                }
            }
            return attributes;
            break;
        }
        default: return nil;
            break;
    }
    //
    // 서브 클래스는 이 메서드를 재정의하여 뷰가 인수로 주어진 rect와 교차하는 모든 item에 대한 레이아웃 정보를 반환해야한다.
    // 구현시 셀, supplementary view 및 decoration view들을 포함한 모든 시각적 요소에 대한 속성을 반환해야한다.
    // 레이아웃 속성을 생성할 때는, 항상 올바른 요소 type(cell, supplementary 또는 decoration)을 나타내는 속성 객체를 생성하라.
    // collection view는 각 type의 attribute를 구별하고 해당 정보를 이용하여 작성할 view 및 관리 방법에 대한 결정을 내린다.
}

//! 인수로 주어진 NSIndexPath에서 item의 레이아웃 속성을 반환한다. - layoutAttributesForElementsInRect:에서 호출했다.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    switch (self.pickerViewStyle) {
        case MGUDosePickerViewStyleFlat: {
            return attributes;
            break;
        }
        case MGUDosePickerViewStyleFlatCenterPop: {
            CGFloat cellHeight = attributes.frame.size.height;
            CGFloat distance = CGRectGetMidY(attributes.frame) - self.midY; // 위쪽은 음수, 아래쪽은 양수
            if (ABS(distance) > cellHeight) {
                attributes.transform3D = CATransform3DMakeTranslation(0, 0, self.depth);
                return attributes;
            } else {
                //CGFloat Height = ((self.depth - self.height) / cellWidth) * ABS(distance) + self.height; // 직선형.
                CGFloat Height = ((self.height-self.depth)/2.0) * cos(M_PI * ABS(distance) / cellHeight) + ((self.height+self.depth)/2.0);
                attributes.transform3D = CATransform3DMakeTranslation(0, 0, Height);
                return attributes;
            }
            break;
        }
        case MGUDosePickerViewStyleCylinder: {
            CGFloat distance = CGRectGetMidY(attributes.frame) - self.midY; // 왼쪽은 음수, 오른쪽은 양수
            CGFloat currentAngle = (self.maxAngle * distance) / (self.radius * M_PI_2); // 90˚
            CATransform3D transform = CATransform3DIdentity;
//            transform = CATransform3DTranslate(transform, 0, distance, -self.radius); // (CATransform3D t, tx, ty, tz);
//            transform = CATransform3DRotate(transform, currentAngle, 1, 0, 0);
            transform = CATransform3DTranslate(transform, 0, -distance, -self.radius); // (CATransform3D t, tx, ty, tz);
            transform = CATransform3DRotate(transform, -currentAngle, 1, 0, 0);
            transform = CATransform3DTranslate(transform, 0, 0, self.radius);
            attributes.transform3D = transform;
            
            if (ABS(currentAngle) < self.maxAngle) {
                attributes.alpha = 1.0f;
            } else {
                attributes.alpha = 0.0f;
            }
            return attributes;
            break;
        }
        default: return nil;
            break;
    }
    //
    // UICollectionViewLayout의 서브 클래스는 반드시 이 메서드를 재정의하고 이 메서드를 이용하여 collection view의 item에 대한 레이아웃 정보를 반환해야한다.
    // 그런데 본 클래스는 UICollectionViewLayout의 서브이므로 반드시는 아닐듯.
    // 이 메서드를 이용하여 해당 셀이있는 item에 대해서만 레이아웃 정보를 제공하라. supplementary view 또는 decoration view에는 사용해서는 안된다.
    // distance는 현재 가운데 점에서 각 아이템의 중점과의 거리(x Axis)를 의미한다. 왼쪽은 음수, 오른쪽은 양수이다.
    // ABS() 절대값을 뽑아주는 define 함수이다.
}


#pragma mark - 세터 & 게터
- (MGUDosePickerViewStyle)pickerViewStyle {
    MGUDosePickerView *view = (MGUDosePickerView *)self.collectionView.superview;
    return view.pickerViewStyle;
}

@end
