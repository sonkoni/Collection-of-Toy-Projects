//
//  UIImage+DarkModeSupport.m
//  DarkMode
//
//  Created by Kwan Hyun Son on 2020/12/18.
//

#import "UIImage+DarkModeSupport.h"

@implementation UIImage (DarkModeSupport)

+ (UIImage *)mgrDynamicImageWithNormalImage:(UIImage *)normalImage
                                  darkImage:(UIImage *)darkImage {
    if (normalImage == nil || darkImage == nil) {
        return normalImage ? : darkImage;
    }
    if (@available(iOS 13.0, *)) {
        UIImageAsset* imageAseset = [[UIImageAsset alloc] init];
    
        //! lightImage 등록
        UITraitCollection* lightImageTrateCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:
        @[[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight],
          [UITraitCollection traitCollectionWithDisplayScale:normalImage.scale]]];
        [imageAseset registerImage:normalImage withTraitCollection:lightImageTrateCollection];
    
        //! darkImage 등록
        UITraitCollection* darkImageTrateCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:
        @[[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark],
          [UITraitCollection traitCollectionWithDisplayScale:darkImage.scale]]];
        [imageAseset registerImage:darkImage withTraitCollection:darkImageTrateCollection];
    
        return [imageAseset imageWithTraitCollection:[UITraitCollection currentTraitCollection]];
    }
    else {
        return normalImage;
   }
}

@end
