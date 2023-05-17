//
//  MGALocalization.h
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGALocalizationIdentifier
 @abstract   ......
 @constant   MGALocalizationIdentifier     .....
 @constant   MGALocalizationIdentifier   .....
 */
typedef NS_ENUM(NSUInteger, MGALocalizationIdentifier) {
    MGALocalizationIdentifierPreferences = 0,
    MGALocalizationIdentifierPreferencesEllipsized
};


@interface MGALocalization : NSObject

/**
Returns the localized version of the given string.

- Parameter identifier: Identifier of the string to localize.

- Note: If the system's locale can't be determined, the English localization of the string will be returned.
*/
+ (NSString *)subscriptIdentifier:(MGALocalizationIdentifier)identifier;

@end

NS_ASSUME_NONNULL_END
