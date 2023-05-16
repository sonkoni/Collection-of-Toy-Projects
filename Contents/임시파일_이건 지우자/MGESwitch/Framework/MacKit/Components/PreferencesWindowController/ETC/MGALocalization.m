//
//  MGALocalization.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGALocalization.h"

@interface MGALocalization ()
// 1차 키는 MGALocalizationIdentifier(NSUInteger)를 위한 NSNumber 인스턴스
@property (class, nonatomic, strong, readonly) NSDictionary <NSNumber *, NSDictionary <NSString *, NSString *>*>*localizedStrings;
@end

@implementation MGALocalization
static NSDictionary *_localizedStrings = nil;

+ (NSDictionary <NSNumber *, NSDictionary <NSString *, NSString *>*>*)localizedStrings {
  if (_localizedStrings == nil) {
      NSDictionary *dic1 = @{
          @"ar": @"تفضيلات",
          @"ca": @"Preferències",
          @"cs": @"Předvolby",
          @"da": @"Indstillinger",
          @"de": @"Einstellungen",
          @"el": @"Προτιμήσεις",
          @"en": @"Preferences",
          @"en-AU": @"Preferences",
          @"en-GB": @"Preferences",
          @"es": @"Preferencias",
          @"es-419": @"Preferencias",
          @"fi": @"Asetukset",
          @"fr": @"Préférences",
          @"fr-CA": @"Préférences",
          @"he": @"העדפות",
          @"hi": @"प्राथमिकता",
          @"hr": @"Postavke",
          @"hu": @"Beállítások",
          @"id": @"Preferensi",
          @"it": @"Preferenze",
          @"ja": @"環境設定",
          @"ko": @"환경설정",
          @"ms": @"Keutamaan",
          @"nl": @"Voorkeuren",
          @"no": @"Valg",
          @"pl": @"Preferencje",
          @"pt": @"Preferências",
          @"pt-PT": @"Preferências",
          @"ro": @"Preferințe",
          @"ru": @"Настройки",
          @"sk": @"Nastavenia",
          @"sv": @"Inställningar",
          @"th": @"การตั้งค่า",
          @"tr": @"Tercihler",
          @"uk": @"Параметри",
          @"vi": @"Tùy chọn",
          @"zh-CN": @"偏好设置",
          @"zh-HK": @"偏好設定",
          @"zh-TW": @"偏好設定"
      };
      
      NSDictionary *dic2 = @{
          @"ar": @"تفضيلات…",
          @"ca": @"Preferències…",
          @"cs": @"Předvolby…",
          @"da": @"Indstillinger…",
          @"de": @"Einstellungen…",
          @"el": @"Προτιμήσεις…",
          @"en": @"Preferences…",
          @"en-AU": @"Preferences…",
          @"en-GB": @"Preferences…",
          @"es": @"Preferencias…",
          @"es-419": @"Preferencias…",
          @"fi": @"Asetukset…",
          @"fr": @"Préférences…",
          @"fr-CA": @"Préférences…",
          @"he": @"העדפות…",
          @"hi": @"प्राथमिकता…",
          @"hr": @"Postavke…",
          @"hu": @"Beállítások…",
          @"id": @"Preferensi…",
          @"it": @"Preferenze…",
          @"ja": @"環境設定…",
          @"ko": @"환경설정...",
          @"ms": @"Keutamaan…",
          @"nl": @"Voorkeuren…",
          @"no": @"Valg…",
          @"pl": @"Preferencje…",
          @"pt": @"Preferências…",
          @"pt-PT": @"Preferências…",
          @"ro": @"Preferințe…",
          @"ru": @"Настройки…",
          @"sk": @"Nastavenia…",
          @"sv": @"Inställningar…",
          @"th": @"การตั้งค่า…",
          @"tr": @"Tercihler…",
          @"uk": @"Параметри…",
          @"vi": @"Tùy chọn…",
          @"zh-CN": @"偏好设置…",
          @"zh-HK": @"偏好設定⋯",
          @"zh-TW": @"偏好設定⋯"
      };
      
      _localizedStrings = @{ @(MGALocalizationIdentifierPreferences) : dic1,
                             @(MGALocalizationIdentifierPreferencesEllipsized) : dic2};
  }
  return _localizedStrings;
}

+ (NSString *)subscriptIdentifier:(MGALocalizationIdentifier)identifier {
    // Force-unwrapped since all of the involved code is under our control.
    NSDictionary <NSString *, NSString *>*localizedDict = [MGALocalization localizedStrings][@(identifier)];
    NSString *defaultLocalizedString = localizedDict[@"en"];
    
    // Iterate through all user-preferred languages until we find one that has a valid language code.
    __block NSLocale *preferredLocale = [NSLocale currentLocale];
    
    NSArray <NSString *>*preferredLanguages = [NSLocale preferredLanguages];
    [preferredLanguages enumerateObjectsUsingBlock:^(NSString *ident, NSUInteger idx, BOOL *stop) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:ident];
        if (locale.languageCode != nil) {
            preferredLocale = locale;
            *stop = YES;
        }
    }];

    NSString *languageCode = preferredLocale.languageCode;
    if (languageCode == nil) {
        return defaultLocalizedString;
    }
    
    // Chinese is the only language where different region codes result in different translations.
    if ([languageCode isEqualToString:@"zh"] == YES) {
        NSString *regionCode = preferredLocale.countryCode;
        if (regionCode == nil) {
            regionCode = @"";
        }
        
        if ([regionCode isEqualToString:@"HK"] || [regionCode isEqualToString:@"TW"]) {
            return localizedDict[[NSString stringWithFormat:@"%@-%@", languageCode, regionCode]];
        } else {
            // Fall back to "regular" zh-CN if neither the HK or TW region codes are found.
            return localizedDict[[NSString stringWithFormat:@"%@-CN", languageCode]];
        }
    } else {
        NSString *localizedString = localizedDict[languageCode];
        if (localizedString != nil) {
            return localizedString;
        }
    }
    
    return defaultLocalizedString;
}

@end
