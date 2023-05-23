//
//  ViewControllerC.m
//  MGRFlowViewExample_koni
//
//  Created by Kwan Hyun Son on 2021/09/28.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import IosKit;
#import "ViewControllerC.h"

@interface ViewControllerC () <MGUFlowViewDelegate>
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) MGUFlowView *flowView;
@property (nonatomic, strong) MGUFlowDiffableDataSource <NSNumber *, NSString *>*diffableDataSource;
@property (nonatomic, strong) NSArray <NSString *>*items;
@end

@implementation ViewControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonInit(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIAction *action = [UIAction actionWithTitle:@"" image:nil identifier:nil handler:^(UIAction *action) {
        UIStepper *stepper = action.sender;
        NSArray <NSString *>*items = [self.items subarrayWithRange:NSMakeRange(0, (NSInteger)stepper.value)];
        NSDiffableDataSourceSnapshot <NSNumber *, NSString *>*snapshot = [NSDiffableDataSourceSnapshot new];
        [snapshot appendSectionsWithIdentifiers:@[@(0)]];
        [snapshot appendItemsWithIdentifiers:items intoSectionWithIdentifier:@(0)];
        [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES completion:^{}];
    }];
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero primaryAction:action];
    stepper.minimumValue = 1;
    stepper.maximumValue = 16;
    stepper.stepValue = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:stepper];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.bounds.size.width - (2 * 20.0);
    _itemSize = CGSizeMake(width, 65.0);
    if (CGSizeEqualToSize(_itemSize, self.flowView.itemSize) == NO) {
        self.flowView.itemSize = _itemSize;
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(ViewControllerC *self) {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Vega Style - Reverse";
    self.items = @[@"faceid",
                   @"calendar.badge.clock",
                   @"teletype.answer.circle.fill",
                   @"coloncurrencysign.circle",
                   @"photo.on.rectangle.angled",
                   @"square.grid.3x3",
                   @"note.text.badge.plus",
                   @"person.crop.circle.badge.plus",
                   @"globe.badge.chevron.backward",
                   @"circle.hexagongrid.fill",
                   @"trash.circle",
                   @"folder.badge.plus",
                   @"paperplane",
                   @"tray.full",
                   @"mic.slash.circle.fill",
                   @"sun.dust.fill"];

    CGFloat width = UIScreen.mainScreen.bounds.size.width - (2 * 20.0);
    self->_itemSize = CGSizeMake(width, 65.0);

    self.flowView  = [MGUFlowView new];
    [self.flowView registerClass:[MGUFlowCell class]
          forCellWithReuseIdentifier:NSStringFromClass([MGUFlowCell class])];
    [self.flowView registerClass:[MGUFlowIndicatorSupplementaryView class]
      forSupplementaryViewOfKind:MGUFlowElementKindVegaLeading
             withReuseIdentifier:MGUFlowElementKindVegaLeading];
    
    self.flowView.itemSize = self.itemSize;
    self.flowView.leadingSpacing = 28.0;
    self.flowView.interitemSpacing = 20.0;
    self.flowView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowView.decelerationDistance = [MGUFlowView automaticDistance];
    self.flowView.transformer = nil;
    self.flowView.delegate = self;
    self.flowView.bounces = YES;
    self.flowView.alwaysBounceVertical = YES;
    self.flowView.reversed = YES;
    
    self.flowView.clipsToBounds = YES;
    MGUFlowVegaTransformer *transformer = [MGUFlowVegaTransformer vegaTransformerWithBothSides:NO];
    self.flowView.transformer = transformer;

    [self.view addSubview:self.flowView];
    [self.flowView mgrPinEdgesToSuperviewSafeAreaLayoutGuide];

    self->_diffableDataSource =
    [[MGUFlowDiffableDataSource alloc] initWithFlowView:self.flowView
                                           cellProvider:^UICollectionViewCell *(UICollectionView *collectionView,
                                                                                NSIndexPath * indexPath,
                                                                                NSString *str) {
        MGUFlowCell *cell =
        (MGUFlowCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MGUFlowCell class])
                                                                 forIndexPath:indexPath];
        
        if (cell == nil) {
            return [MGUFlowCell new];
        }
        UIImageSymbolConfiguration *symbolConfiguration =
            [UIImageSymbolConfiguration configurationWithPointSize:22.0
                                                            weight:UIImageSymbolWeightMedium
                                                             scale:UIImageSymbolScaleMedium];
        UIImageSymbolConfiguration *colorConfig = [UIImageSymbolConfiguration configurationPreferringMulticolor];
        UIImageConfiguration *config = [colorConfig configurationByApplyingConfiguration:symbolConfiguration];
        cell.tintColor =  [UIColor colorWithRed:(arc4random() % 256) / 255.0
                                          green:(arc4random() % 256) / 255.0
                                           blue:(arc4random() % 256) / 255.0
                                          alpha:1.0];
        UIListContentConfiguration *contentConfiguration = [UIListContentConfiguration cellConfiguration];
        contentConfiguration.text = [(NSString *)[str componentsSeparatedByString:@"."].firstObject capitalizedString];
        contentConfiguration.secondaryText = str;
        contentConfiguration.secondaryTextProperties.color = [UIColor darkGrayColor];
        
        UIFontDescriptor *fontDescriptor = [[UIFont systemFontOfSize:12.0 weight:10.0] fontDescriptor];
        UIFontDescriptor *designFontDescriptor = [fontDescriptor fontDescriptorWithDesign:UIFontDescriptorSystemDesignDefault];
        UIFontDescriptor *italicFontDescriptor = [designFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        if (italicFontDescriptor) {
            contentConfiguration.secondaryTextProperties.font = [UIFont fontWithDescriptor:italicFontDescriptor size:0.0];
        } else if (designFontDescriptor) {
            contentConfiguration.secondaryTextProperties.font = [UIFont fontWithDescriptor:designFontDescriptor size:0.0];
        } else {
            contentConfiguration.secondaryTextProperties.font = [UIFont fontWithDescriptor:fontDescriptor size:0.0];
        }
        
        contentConfiguration.image = [UIImage systemImageNamed:str withConfiguration:config];
        cell.contentConfiguration = contentConfiguration;
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration listPlainCellConfiguration];
        backgroundConfiguration.backgroundColor = [UIColor whiteColor];
        backgroundConfiguration.cornerRadius = 14.0;
        cell.backgroundConfiguration = backgroundConfiguration;
        
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(1.0, 5.0);
        cell.layer.shadowRadius = 8.0;
        cell.layer.shadowOpacity = 0.2;
        cell.layer.masksToBounds = NO;
        cell.layer.shouldRasterize = YES; // http://wiki.mulgrim.net/page/Api:Core_Animation/CALayer/shouldRasterize
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        return cell;
    }];
    
    self.diffableDataSource.elementOfKinds = @[MGUFlowElementKindVegaLeading];
    
    self.diffableDataSource.supplementaryViewProvider =
    ^UICollectionReusableView *(UICollectionView *collectionView, NSString * elementKind, NSIndexPath *indexPath) {
        MGUFlowIndicatorSupplementaryView * cell =
        [collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                           withReuseIdentifier:elementKind
                                                  forIndexPath:indexPath];
        
        if ([elementKind isEqualToString:MGUFlowElementKindVegaLeading] == YES) {
            cell.indicatorColor = [UIColor systemTealColor];
        } else {
            NSCAssert(FALSE, @"뭔가 잘못들어왔다.");
        }
    
        return cell;
    };
    
    self.diffableDataSource.volumeType = MGUFlowVolumeTypeFinite; // 디폴트
    
    NSDiffableDataSourceSnapshot <NSNumber *, NSString *>*snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    // NSArray <NSString *>*items = self.items;
    NSArray <NSString *>*items = [self.items subarrayWithRange:NSMakeRange(0, 1)];
    [snapshot appendItemsWithIdentifiers:items intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:NO completion:^{}];
}


#pragma mark - <MGUFlowViewDelegate>
// 모두 옵셔널. 샘플이므로 생략.

@end
