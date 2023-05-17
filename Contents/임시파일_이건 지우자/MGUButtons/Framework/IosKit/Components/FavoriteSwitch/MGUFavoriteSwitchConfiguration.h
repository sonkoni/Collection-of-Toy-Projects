//
//  MGRFavoriteButtonColorConfiguration.h
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 17/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUFavoriteSwitch;

NS_ASSUME_NONNULL_BEGIN
#pragma mark - Image Type
typedef NS_ENUM(NSInteger, MGUFavoriteSwitchImageType) {
    MGUFavoriteSwitchImageTypeNone = 0,
    MGUFavoriteSwitchImageTypeStar,    // ⭐️
    MGUFavoriteSwitchImageTypeHeart,   // 💛
    MGUFavoriteSwitchImageTypeLike,    // 👍
    MGUFavoriteSwitchImageTypeSmile,   // 🙂
    MGUFavoriteSwitchImageTypeCollectSet // 두 개다. ✩ ⭑
};

NSArray <UIImage *>*MGUFavoriteSwitchImage(MGUFavoriteSwitchImageType imageType);


#pragma mark - Color Configuration
@interface MGUFavoriteSwitchColorConfiguration : NSObject

@property (nonatomic, strong) UIColor *imageColorOn;
@property (nonatomic, strong) UIColor *imageColorOff;
@property (nonatomic, strong) UIColor *rippleColor;
@property (nonatomic, strong) UIColor *sparkColor;
@property (nonatomic, strong) UIColor *sparkColor2;


- (void)applyConfiguration:(MGUFavoriteSwitch *)favoriteButton;

//! 기본 템플릿들이다. --------------------------------------------------------
+ (MGUFavoriteSwitchColorConfiguration *)default; // Matte Orange
+ (MGUFavoriteSwitchColorConfiguration *)MattePink;
+ (MGUFavoriteSwitchColorConfiguration *)MatteSky;
+ (MGUFavoriteSwitchColorConfiguration *)MatteGreen;

@end


//#pragma mark - Style Configuration : Spark Mode 일때의 스타일을 결정한다.
//@interface MGRFavoriteButtonStyleConfiguration : NSObject
//
//@property (nonatomic, assign) BOOL useRadomColor; // 디폴트 YES
//@property (nonatomic, assign) BOOL useFlashStyle; // 디폴트 YES
//
//+ (MGRFavoriteButtonStyleConfiguration *)defaultStyleConfiguration;
//
//@end
NS_ASSUME_NONNULL_END


