//
//  MGUMessageView.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/20.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <IosKit/MGUMessagesBaseView.h>

NS_ASSUME_NONNULL_BEGIN
// Nib 이름이다.
typedef NSString * MGUMessageViewLayout NS_TYPED_ENUM;
static MGUMessageViewLayout const MGUMessageViewLayoutMessageView  = @"_MGUMessages_MessageView";
static MGUMessageViewLayout const MGUMessageViewLayoutCardView   = @"_MGUMessages_CardView";
static MGUMessageViewLayout const MGUMessageViewLayoutTabView   = @"_MGUMessages_TabView";
static MGUMessageViewLayout const MGUMessageViewLayoutStatusLine = @"_MGUMessages_StatusLine";
static MGUMessageViewLayout const MGUMessageViewLayoutCenteredView  = @"_MGUMessages_CenteredView";


@protocol MGUMessagesIdentifiable <NSObject>
@optional
@required
- (NSString *)identifier;
@end

@protocol MGUMessagesAccessibleMessage <NSObject>
@optional
@required
- (NSString * _Nullable)accessibilityMessage;
- (NSObject * _Nullable)accessibilityElement;
- (NSMutableArray * _Nullable)additionalAccessibilityElements;
@end


@interface MGUMessageView : MGUMessagesBaseView <MGUMessagesIdentifiable, MGUMessagesAccessibleMessage>

@property (nonatomic, copy, nullable) void (^buttonTapHandler)(UIButton *button);

@property (weak, nonatomic, nullable) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic, nullable) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic, nullable) IBOutlet UIButton *button;
@property (nonatomic, strong) NSString *identifier; // @dynamicno

@property (nonatomic, strong, nullable) NSString *accessibilityPrefix;

#pragma mark - Creating message views
+ (MGUMessageView *)loadMessageViewNibNamed:(MGUMessageViewLayout)nibName
                                   owner:(id _Nullable)owner
                                 options:(NSDictionary<UINibOptionsKey, id> * _Nullable)options;

#pragma mark - Layout adjustments
- (void)configureIconWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

#pragma mark - Theming
- (void)configureTheme:(MGUMessagesTheme)theme iconStyle:(MGUMessagesIconStyle)iconStyle; // iconStyle: MGUMessagesIconStyle = .default
- (void)configureThemeBackgroundColor:(UIColor *)backgroundColor
                      foregroundColor:(UIColor *)foregroundColor
                            iconImage:(UIImage * _Nullable)iconImage
                             iconText:(NSString * _Nullable)iconText;


#pragma mark - Configuring the content
- (void)configureContentTitle:(NSString * _Nullable)title
                         body:(NSString * _Nullable)body
                    iconImage:(UIImage * _Nullable)iconImage
                     iconText:(NSString * _Nullable)iconText
                  buttonImage:(UIImage * _Nullable)buttonImage
                  buttonTitle:(NSString * _Nullable)buttonTitle
             buttonTapHandler:(void(^_Nullable)(UIButton *button))buttonTapHandler;

@end

NS_ASSUME_NONNULL_END
