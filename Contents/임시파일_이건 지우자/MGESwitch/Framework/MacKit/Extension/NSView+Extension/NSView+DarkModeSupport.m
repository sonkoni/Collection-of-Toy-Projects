//
//  NSView+DarkModeSupport.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSView+DarkModeSupport.h"

@implementation NSView (DarkModeSupport)


- (void)mgrAdoptAquaAppearance {
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
}

- (void)mgrAdoptDarkAquaAppearance {
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
}

- (void)mgrAdoptVibrantLightAppearance {
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
}

- (void)mgrAdoptVibrantDarkAppearance {
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
}

@end

