//
//  MGUOnOffSkin.h
//
//  Created by Kwan Hyun Son on 2021/11/15.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <IosKit/MGUOnOffSkinInterface.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MMTTopButtonSkinSymbol
 @abstract   ......
 @constant   MMTTopButtonSkinSymbolNone     .....
 @constant   MMTTopButtonSkinSymbolPlus     .....
 @constant   MMTTopButtonSkinSymbolQuestion .....
 
 */
typedef NS_ENUM(NSUInteger, MMTTopButtonSkinSymbol) {
    MMTTopButtonSkinSymbolNone = 0,
    MMTTopButtonSkinSymbolPlus,
    MMTTopButtonSkinSymbolQuestion
};

@interface MMTTopButtonSkin : UIView <MGUOnOffSkinInterface>

//@property (nonatomic, assign) CGFloat duration; // 디폴트 0.1;
//- (void)setSkinType:(MGUOnOffSkinType)skinType animated:(BOOL)animated;
@property (nonatomic, assign) MMTTopButtonSkinSymbol skinSymbol;
- (void)setSkinSymbol:(MMTTopButtonSkinSymbol)skinSymbol completion:(void(^_Nullable)(void))completionBlock;
@end

NS_ASSUME_NONNULL_END
