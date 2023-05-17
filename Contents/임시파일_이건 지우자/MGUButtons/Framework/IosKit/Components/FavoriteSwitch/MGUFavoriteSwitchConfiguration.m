//
//  MGRFavoriteButtonColorConfiguration.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 17/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUFavoriteSwitchConfiguration.h"
#import "MGUFavoriteSwitch.h"
@import BaseKit;

NSArray <UIImage *>*MGUFavoriteSwitchImage(MGUFavoriteSwitchImageType imageType) {
    if (imageType == MGUFavoriteSwitchImageTypeStar) {
        return @[[UIImage imageNamed:@"MGUFavoriteSwitch_star"
                            inBundle:[NSBundle mgrIosRes]
                   withConfiguration:nil]];
    }

    if (imageType == MGUFavoriteSwitchImageTypeHeart) {
        return @[[UIImage imageNamed:@"MGUFavoriteSwitch_heart"
                            inBundle:[NSBundle mgrIosRes]
                   withConfiguration:nil]];
    }

    if (imageType == MGUFavoriteSwitchImageTypeLike) {
        return @[[UIImage imageNamed:@"MGUFavoriteSwitch_like"
                            inBundle:[NSBundle mgrIosRes]
                   withConfiguration:nil]];
    }

    if (imageType == MGUFavoriteSwitchImageTypeSmile) {
        return @[[UIImage imageNamed:@"MGUFavoriteSwitch_smile"
                            inBundle:[NSBundle mgrIosRes]
                   withConfiguration:nil]];
    }

    if (imageType == MGUFavoriteSwitchImageTypeCollectSet) {
        return @[[UIImage imageNamed:@"MGUFavoriteSwitch_collect_nor"
                            inBundle:[NSBundle mgrIosRes]
                   withConfiguration:nil],
                 [UIImage imageNamed:@"MGUFavoriteSwitch_collect_sel"
                            inBundle:[NSBundle mgrIosRes]
                   withConfiguration:nil]];
    }

    return @[[UIImage new]];
}


#pragma mark - Color Configuration
@implementation MGUFavoriteSwitchColorConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _imageColorOn  = [UIColor colorWithRed:255.0/255.0 green:172.0/255.0 blue:51.0/255.0 alpha:1.0];
    _imageColorOff = [UIColor colorWithRed:136.0/255.0 green:153.0/255.0 blue:166.0/255.0 alpha:1.0];
    _rippleColor   = [UIColor colorWithRed:255.0/255.0 green:172.0/255.0 blue:51.0/255.0 alpha:1.0];
    _sparkColor    = [UIColor colorWithRed:250.0/255.0 green:120.0/255.0 blue:68.0/255.0 alpha:1.0];
    _sparkColor2   = [UIColor colorWithRed:125.0/255.0 green:60.0/255.0 blue:34.0/255.0 alpha:1.0];
}

- (void)applyConfiguration:(MGUFavoriteSwitch *)favoriteButton {
    favoriteButton.imageColorOff = self.imageColorOff;
    favoriteButton.imageColorOn = self.imageColorOn;
    favoriteButton.rippleColor = self.rippleColor;
    favoriteButton.sparkColor = self.sparkColor;
    favoriteButton.sparkColor2 = self.sparkColor2;
}

//! --------------------------------------------------------
+ (MGUFavoriteSwitchColorConfiguration *)default {
    return [[MGUFavoriteSwitchColorConfiguration alloc] init];
}

+ (MGUFavoriteSwitchColorConfiguration *)MattePink {
    MGUFavoriteSwitchColorConfiguration *configuration = [[MGUFavoriteSwitchColorConfiguration alloc] init];
    configuration.imageColorOn = [UIColor colorWithRed:254.0/255.0 green:110.0/255.0 blue:111.0/255.0 alpha:1.0];
    configuration.rippleColor = [UIColor colorWithRed:254.0/255.0 green:110.0/255.0 blue:111.0/255.0 alpha:1.0];
    configuration.sparkColor = [UIColor colorWithRed:226.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
    configuration.sparkColor2 = [UIColor colorWithRed:113.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0];
    
    return configuration;
}
+ (MGUFavoriteSwitchColorConfiguration *)MatteSky {
    MGUFavoriteSwitchColorConfiguration *configuration = [[MGUFavoriteSwitchColorConfiguration alloc] init];
    configuration.imageColorOn = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    configuration.rippleColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    configuration.sparkColor = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
    configuration.sparkColor2 = [UIColor colorWithRed:20.5/255.0 green:64.0/255.0 blue:92.5/255.0 alpha:1.0];
    return configuration;
}
+ (MGUFavoriteSwitchColorConfiguration *)MatteGreen {
    MGUFavoriteSwitchColorConfiguration *configuration = [[MGUFavoriteSwitchColorConfiguration alloc] init];
    configuration.imageColorOn = [UIColor colorWithRed:45.0/255.0 green:204.0/255.0 blue:112.0/255.0 alpha:1.0];
    configuration.rippleColor = [UIColor colorWithRed:45.0/255.0 green:204.0/255.0 blue:112.0/255.0 alpha:1.0];
    configuration.sparkColor = [UIColor colorWithRed:45.0/255.0 green:195.0/255.0 blue:106.0/255.0 alpha:1.0];
    configuration.sparkColor2 = [UIColor colorWithRed:22.5/255.0 green:97.5/255.0 blue:53.5/255.0 alpha:1.0];
    return configuration;
}

@end


//#pragma mark - Style Configuration : Spark Mode 일때의 스타일을 결정한다.
//
//@implementation MGRFavoriteButtonStyleConfiguration
//
//- (instancetype)init {
//    self  = [super init];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}
//
//- (void)commonInit {
//    
//}
//
//+ (MGRFavoriteButtonStyleConfiguration *)defaultStyleConfiguration {
//    return [[MGRFavoriteButtonStyleConfiguration alloc] init];
//}
//
//@end
//
////@property (nonatomic, assign) BOOL useRadomColor; // 디폴트 YES
////@property (nonatomic, assign) BOOL useFlashStyle; // 디폴트 YES

//#import "MGRBundleHelper.h"
//NSArray <UIImage *>*MGUFavoriteSwitchImage(MGUFavoriteSwitchImageType imageType) {
//    if (imageType == MGUFavoriteSwitchImageTypeStar) {
//        return @[MGRBundleImg(NSStringFromClass([MGUFavoriteSwitch class]),
//                              @"MGUFavoriteSwitch_star.png")];
//    }
//
//    if (imageType == MGUFavoriteSwitchImageTypeHeart) {
//        return @[MGRBundleImg(NSStringFromClass([MGUFavoriteSwitch class]),
//                            @"MGUFavoriteSwitch_heart.png")];
//    }
//
//    if (imageType == MGUFavoriteSwitchImageTypeLike) {
//        return @[MGRBundleImg(NSStringFromClass([MGUFavoriteSwitch class]),
//                            @"MGUFavoriteSwitch_like.png")];
//    }
//
//    if (imageType == MGUFavoriteSwitchImageTypeSmile) {
//        return @[MGRBundleImg(NSStringFromClass([MGUFavoriteSwitch class]),
//                            @"MGUFavoriteSwitch_smile.png")];
//    }
//
//    if (imageType == MGUFavoriteSwitchImageTypeCollectSet) {
//        return @[MGRBundleImg(NSStringFromClass([MGUFavoriteSwitch class]),
//                              @"MGUFavoriteSwitch_collect_nor.png"),
//                 MGRBundleImg(NSStringFromClass([MGUFavoriteSwitch class]),
//                              @"MGUFavoriteSwitch_collect_sel.png")];
//    }
//
//    return @[[UIImage new]];
//}
