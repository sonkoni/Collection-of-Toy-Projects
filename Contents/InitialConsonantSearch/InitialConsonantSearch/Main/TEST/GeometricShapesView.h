//
//  GeometricShapesView.h
//  ToolSettingTest
//
//  Created by Kwan Hyun Son on 2023/09/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GeometricShapesViewType) {
    GeometricShapesViewTypeEllipse = 0, // 타원
    GeometricShapesViewTypeRectangle,   // 사각형
    GeometricShapesViewTypeTriangle     // 삼각형
};

@interface GeometricShapesView : UIView
@property (nonatomic, assign) GeometricShapesViewType geometricShapesType;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *backColor;
- (instancetype)initWithType:(GeometricShapesViewType)type;
@end

NS_ASSUME_NONNULL_END
