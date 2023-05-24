//
//  ViewControllerB.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/24.
//

@import IosKit;
#import "ViewControllerB.h"
#import "CollectionViewEmailCell.h"
#import "EmailCellModel.h"

@interface ViewControllerB () <UICollectionViewDelegateFlowLayout,
                                            MGUSwipeCollectionViewCellDelegate>
@property (nonatomic, strong) NSMutableArray <EmailCellModel *>*emails;
@property (nonatomic, assign) MGUSwipeTransitionStyle transitionStyle;
@property (nonatomic, assign) BOOL isSwipeRightEnabled;
@property (nonatomic, assign) ButtonDisplayMode buttonDisplayMode;
@property (nonatomic, assign) ButtonStyle buttonStyle;
@property (nonatomic, assign) MGUSwipeTransitionAnimationType transitionAnimationType;
@property (nonatomic, assign) BOOL usesTallCells;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource <NSNumber *, EmailCellModel *>*diffableDataSource;
@property (nonatomic, assign) MailCollectionLayoutType type;
@property (nonatomic, assign) UIUserInterfaceLayoutDirection userInterfaceLayoutDirection; // 아랍어 순서 또는 영어 순서 (좌우)
@end

@implementation ViewControllerB

- (instancetype)initWithType:(MailCollectionLayoutType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray <NSIndexPath *>*indexPaths = [self.collectionView indexPathsForSelectedItems];
    if (indexPaths != nil) {
        for (NSIndexPath *indexPath in indexPaths) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        }
    }
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self.view layoutIfNeeded];
//    self.collectionView.frame = self.view.bounds;
    [self.collectionView.collectionViewLayout invalidateLayout];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    _userInterfaceLayoutDirection =
    [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute];
    //
    // 일반전인 문자 순서: 문자를 왼쪽에서 오른쪽으로 적는다. UIUserInterfaceLayoutDirectionLeftToRight
    // 아랍어, 히브리어 같은 문자 순서: 문자를 오른쪽에서 왼쪽으로 적는다. UIUserInterfaceLayoutDirectionRightToLeft
    _emails = @[].mutableCopy;
    _isSwipeRightEnabled = YES;
    _transitionStyle = MGUSwipeTransitionStyleBorder;
    _buttonDisplayMode = titleAndImage;
    _buttonStyle = backgroundColor;
    _usesTallCells = NO;
    _transitionAnimationType = MGUSwipeTransitionAnimationTypeNone;
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    ///_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // system inset에 영향을 받지 않으려면.
    _collectionView.delegate = self;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collectionView.allowsMultipleSelection = NO; // 디폴트가 NO이다.
    [_collectionView registerClass:[CollectionViewEmailCell class]
        forCellWithReuseIdentifier:NSStringFromClass([CollectionViewEmailCell class])];

    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mgrPinEdgesToSuperviewEdges];
    self.navigationItem.title = NSLocalizedString(@"Inbox", @"");
    UIBarButtonItem *spaceitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    UIImage *moreOutlineImage =
    [[UIImage systemImageNamed:@"ellipsis.circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *moreOutline = [[UIBarButtonItem alloc] initWithImage:moreOutlineImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(moreTapped:)];
    self.toolbarItems = @[spaceitem, moreOutline];
    
    _diffableDataSource =
    [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView
                                                          cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, EmailCellModel *email) {
        CollectionViewEmailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewEmailCell class])
                                                                    forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];

        cell.fromLabel.text = email.from;
        cell.dateLabel.text = email.relativeDateString;
        cell.subjectLabel.text = email.subject;
        cell.bodyLabel.text = email.body;
        cell.bodyLabel.numberOfLines = self.usesTallCells ? 0 : 2;
        cell.unread = email.unread;
        
        if (self.type == MailCollectionLayoutType2) {
            cell.clip = NO;
        }
        
        if (self.type == MailCollectionLayoutType1) {
            cell.cornerRadius = 0.0;
        } else {
            cell.swipeableContentView.backgroundColor = [UIColor whiteColor];
            cell.swipeableContentView.layer.cornerRadius = 10.0;
            cell.backgroundColor = UIColor.clearColor;
            cell.cornerRadius = 10.0;
            cell.swipeDecoLeftColor = [UIColor whiteColor];
            cell.swipeDecoRightColor = [UIColor whiteColor];
        }
        
        NSString *imageName = nil;
        if (self.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) { // 일반 언어 순서
            imageName = @"chevron.compact.right";
        } else { // 아랍어 순서
            imageName = @"chevron.compact.left";
        }
        UIImageSymbolConfiguration *symbolConfiguration = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightLight];
        UIImage *image = [UIImage systemImageNamed:imageName withConfiguration:symbolConfiguration];
        cell.disclosureImageView.image = image;
        cell.disclosureImageView.tintColor = [UIColor lightGrayColor];
        
        return cell;
    }];
    
    [self resetData];
}

- (void)resetData {
    self.emails = [EmailCellModel mockEmails].mutableCopy;
    [self.emails enumerateObjectsUsingBlock:^(EmailCellModel *email, NSUInteger idx, BOOL *stop) {
        email.unread = NO;
    }];
    
    self.usesTallCells = NO;
    NSDiffableDataSourceSnapshot <NSNumber *, EmailCellModel *>*snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@(0)]];
    [snapshot appendItemsWithIdentifiers:self.emails intoSectionWithIdentifier:@(0)];
    [self.diffableDataSource applySnapshot:snapshot animatingDifferences:YES completion:^{}];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == MailCollectionLayoutType1) {
        return CGSizeMake(collectionView.frame.size.width, (self.usesTallCells == YES) ? 160.0 : 98.0);
    } else {
        return CGSizeMake(collectionView.frame.size.width - 80.0, (self.usesTallCells == YES) ? 160.0 : 98.0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    // vertical 일 때 => 위, 아래 간격
    if (self.type == MailCollectionLayoutType1) {
        return 0.0;
    } else {
        return 20.0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    [self.navigationController pushViewController:[ViewController new] animated:YES];
    //
//    if (self.tableView.editing == YES) {
//        return;
//    } else {
//        [self.navigationController pushViewController:[ViewController new] animated:YES];
//    }
}

//! 물론 cell.maskView 자체가 없기는 하지만, 이걸 해야할 필요가 있을까??
- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(CollectionViewEmailCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.maskView != nil) {
        cell.maskView.frame = cell.bounds;
    }
}


#pragma mark - <MGUSwipeCollectionViewCellDelegate>
//!------------------------------------------------- @required
- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
leading_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSwipeRightEnabled == NO) {
        return nil;
    }
    EmailCellModel *email = self.emails[indexPath.row];
    MGUSwipeAction *read = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDefault
                                             title:nil
                                           handler:^(MGUSwipeAction * _Nonnull action,
                                                     __kindof UIView * _Nonnull sourceView,
                                                     void (^ _Nonnull completionHandler)(BOOL)) {
        
        BOOL updatedStatus = !email.unread;
        email.unread = updatedStatus;
        CollectionViewEmailCell *cell = (CollectionViewEmailCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setUnread:updatedStatus animated:YES];

        completionHandler(YES); // 자동 hide!!
    }];

    read.accessibilityLabel = email.unread ? @"Mark as Read" : @"Mark as Unread";

    ActionDescriptor descriptor = email.unread ? ActionDescriptorRead : ActionDescriptorUnread;

    [self configureAction:read with:descriptor];
    
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[read]];
      
    //! 쭉 당겼을 때, 발생하게 하는 것. 애플의 performsFirstActionWithFullSwipe = YES 해당. nil 이면 NO
    configuration.expansionStyle = [MGUSwipeExpansionStyle selection];
    configuration.transitionStyle = self.transitionStyle;
    configuration.buttonSpacing = 4.0;
    
    if (self.buttonStyle == circular) {
        configuration.backgroundColor = [UIColor systemGray6Color];
    }

    return configuration;
}

- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
trailing_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewEmailCell *cell = (CollectionViewEmailCell *)[collectionView cellForItemAtIndexPath:indexPath];

    void (^closure)(UIAlertAction *alertAction) = ^(UIAlertAction *alertAction) {
        [cell hideSwipeAnimated:YES completion:nil];
    };

    MGUSwipeAction *flag = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDefault
                                             title:nil
                                           handler:^(MGUSwipeAction * _Nonnull action,
                                                     __kindof UIView * _Nonnull sourceView,
                                                     void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES); // 자동 hide!!
    }];

    [self configureAction:flag with:ActionDescriptorFlag];

    MGUSwipeAction *delete = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                             title:nil
                                           handler:^(MGUSwipeAction * _Nonnull action,
                                                     __kindof UIView * _Nonnull sourceView,
                                                     void (^ _Nonnull completionHandler)(BOOL)) {
        if (indexPath.row == 1 || indexPath.row == 2) {
            // fill 또는 fillReverse
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Delete", @"")
                                                                                message:NSLocalizedString(@"delete row", @"")
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", @"")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                NSDiffableDataSourceSnapshot <NSNumber *, EmailCellModel *>*snapshot = self.diffableDataSource.snapshot;
                [snapshot deleteItemsWithIdentifiers:@[self.emails[indexPath.row]]];
                [self.emails removeObjectAtIndex:indexPath.row];
                [self.diffableDataSource mgrSwipeApplySnapshot:snapshot collectionView:self.collectionView completion:nil];
            }];
     
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action) {
                if (indexPath.row == 1) {
                    [cell hideSwipeAnimated:YES completion:nil];
                }
            }];
     
            [controller addAction:deleteAction];
            [controller addAction:cancelAction];
            [self mgrPresentAlertViewController:controller animated:YES completion:nil];
        } else {
            NSDiffableDataSourceSnapshot <NSNumber *, EmailCellModel *>*snapshot = self.diffableDataSource.snapshot;
            [snapshot deleteItemsWithIdentifiers:@[self.emails[indexPath.row]]];
            [self.emails removeObjectAtIndex:indexPath.row];
            [self.diffableDataSource mgrSwipeApplySnapshot:snapshot collectionView:self.collectionView completion:nil];
//            [self.collectionView mgrDeleteItemsAtIndexPaths:@[indexPath] completionBlock:^{}];
        }
    }];

    [self configureAction:delete with:ActionDescriptorTrash];

    MGUSwipeAction *more = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDefault title:nil
                                                  handler:^(MGUSwipeAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        UIAlertController *controller =
            [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *replyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reply", @"") style:UIAlertActionStyleDefault handler:closure];
        UIAlertAction *forwardAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Forward", @"") style:UIAlertActionStyleDefault handler:closure];
        UIAlertAction *markAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Mark...", @"") style:UIAlertActionStyleDefault handler:closure];
        UIAlertAction *notifyMeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Notify Me...", @"") style:UIAlertActionStyleDefault handler:closure];
        UIAlertAction *moveMessageMeAction =
            [UIAlertAction actionWithTitle:NSLocalizedString(@"Move Message...", @"") style:UIAlertActionStyleDefault handler:closure];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:closure];
        
        [controller addAction:replyAction];
        [controller addAction:forwardAction];
        [controller addAction:markAction];
        [controller addAction:notifyMeAction];
        [controller addAction:moveMessageMeAction];
        [controller addAction:cancelAction];
        [self mgrPresentAlertViewController:controller animated:YES completion:nil];
    }];

    [self configureAction:more with:ActionDescriptorMore];

    NSArray <MGUSwipeAction *>*actions;
    
    if (indexPath.row == 1) {
        actions = @[delete];
    } else if (indexPath.row == 2) {
        actions = @[delete, flag];
    } else {
        actions = @[delete, flag, more];
    }
    
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:actions];

    //! 쭉 당겼을 때, 발생하게 하는 것. 애플의 performsFirstActionWithFullSwipe = YES 해당. nil 이면 NO
    if (indexPath.row == 1) {
        configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    } else if (indexPath.row == 2) {
        configuration.expansionStyle = [MGUSwipeExpansionStyle fillReverse];
    } else {
        configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    }
      
    configuration.transitionStyle = self.transitionStyle;
    configuration.buttonSpacing = 4.0;
    
    if (self.buttonStyle == circular) {
        configuration.backgroundColor = [UIColor systemGray6Color];
    }

    return configuration;
}

//!------------------------------------------------- @optional
- (void)collectionView:(UICollectionView *)collectionView
willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {
//    CollectionViewEmailCell *cell = (CollectionViewEmailCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.swipeableContentView.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner; //
}

- (void)collectionView:(UICollectionView *)collectionView
willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {
//    CollectionViewEmailCell *cell = (CollectionViewEmailCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.swipeableContentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner; // 좌측
}

- (void)collectionView:(UICollectionView *)collectionView
didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}

- (void)collectionView:(UICollectionView *)collectionView
didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}

- (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView  {
    if (self.usesTallCells == NO) {
        return CGRectNull;
    }
    return collectionView.safeAreaLayoutGuide.layoutFrame;
}


#pragma mark - Action
- (void)moreTapped:(UIBarButtonItem *)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Swipe Transition Style"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *borderAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Border", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionStyle = MGUSwipeTransitionStyleBorder;
    }];
    
    UIAlertAction *dragAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Drag", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionStyle = MGUSwipeTransitionStyleDrag;
    }];
    
    UIAlertAction *revealAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reveal", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionStyle =     MGUSwipeTransitionStyleReveal;
    }];
    
    NSString *title = [NSString stringWithFormat:@"%@ Swipe Right", self.isSwipeRightEnabled ? @"Disable" : @"Enable"];
    UIAlertAction *disableOrEnableAction = [UIAlertAction actionWithTitle:title
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
        self.isSwipeRightEnabled = !self.isSwipeRightEnabled;
    }];
    
    UIAlertAction *buttonDisplayModeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Button Display Mode", @"")
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
        [self buttonDisplayModeTapped];
    }];
    
    UIAlertAction *buttonStyleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Button Style", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
        [self buttonStyleTapped];
    }];
    
    UIAlertAction *cellHeightAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cell Height", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
        [self cellHeightTapped];
    }];
    
    UIAlertAction *transitionAnimationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Transition Animation Type", @"")
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {
        [self transitionAnimationTapped];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", @"")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action) {
        [self resetData];
        
    }];
    
    [controller addAction:borderAction];
    [controller addAction:dragAction];
    [controller addAction:revealAction];
    [controller addAction:disableOrEnableAction];
    [controller addAction:buttonDisplayModeAction];
    [controller addAction:buttonStyleAction];
    [controller addAction:cellHeightAction];
    [controller addAction:transitionAnimationAction];
    [controller addAction:cancelAction];
    [controller addAction:resetAction];
    
    [self mgrPresentAlertViewController:controller animated:YES completion:nil];
}

- (void)buttonDisplayModeTapped {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Button Display Mode"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *imageTitleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Image + Title", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.buttonDisplayMode = titleAndImage;
    }];
    
    UIAlertAction *imageOnlyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Image Only", @"")
                                                               style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
        self.buttonDisplayMode = imageOnly;
        }];
    
    UIAlertAction *titleOnlyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Title Only", @"")
                                                               style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.buttonDisplayMode = titleOnly;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                        handler:nil];
    
    [controller addAction:imageTitleAction];
    [controller addAction:imageOnlyAction];
    [controller addAction:titleOnlyAction];
    [controller addAction:cancelAction];
    
    [self mgrPresentAlertViewController:controller animated:YES completion:nil];
}

- (void)buttonStyleTapped {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Button Style"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *backgroundColorAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Background Color", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.buttonStyle = backgroundColor;
        self.transitionStyle = MGUSwipeTransitionStyleBorder;
    }];
    
    UIAlertAction *circularAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Circular", @"")
                                                               style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
        self.buttonStyle = circular;
        self.transitionStyle =     MGUSwipeTransitionStyleReveal;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                        handler:nil];
    [controller addAction:backgroundColorAction];
    [controller addAction:circularAction];
    [controller addAction:cancelAction];
    
    [self mgrPresentAlertViewController:controller animated:YES completion:nil];
}

- (void)cellHeightTapped {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Cell Height"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *normalAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Normal", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.usesTallCells = NO;
        [self.collectionView reloadData];
    }];
    
    
    UIAlertAction *tallAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Tall", @"")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
        self.usesTallCells = YES;
        [self.collectionView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString (@"Cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                        handler:nil];
    [controller addAction:normalAction];
    [controller addAction:tallAction];
    [controller addAction:cancelAction];
    
    [self mgrPresentAlertViewController:controller animated:YES completion:nil];
}

- (void)transitionAnimationTapped {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Transition Animation Type"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *defaultAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Default Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType =     MGUSwipeTransitionAnimationTypeDefault;
    }];
    
    UIAlertAction *springAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Spring Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType =     MGUSwipeTransitionAnimationTypeSpring;
    }];
    
    UIAlertAction *rotateAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Rotate Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType =     MGUSwipeTransitionAnimationTypeRotate;
    }];
    
    UIAlertAction *favoriteAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Favorite Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType =     MGUSwipeTransitionAnimationTypeFavorite;
    }];
    
    UIAlertAction *noneAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"None Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType =     MGUSwipeTransitionAnimationTypeNone;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                           style:UIAlertActionStyleCancel
                                                        handler:nil];
    [controller addAction:defaultAnimationTypeAction];
    [controller addAction:springAnimationTypeAction];
    [controller addAction:rotateAnimationTypeAction];
    [controller addAction:favoriteAnimationTypeAction];
    [controller addAction:noneAnimationTypeAction];
    [controller addAction:cancelAction];
    
    [self mgrPresentAlertViewController:controller animated:YES completion:nil];
}

#pragma mark - Helper
- (void)configureAction:(MGUSwipeAction *)action with:(ActionDescriptor)descriptor {
    action.title = ActionDescriptorTitleForDisplayMode(descriptor, self.buttonDisplayMode);
    action.image = ActionDescriptorImageForStyle(descriptor, self.buttonStyle, self.buttonDisplayMode);
    
    if (self.buttonStyle == backgroundColor) {
        action.backgroundColor = ActionDescriptorColorForStyle(descriptor, self.buttonStyle);
    } else if (self.buttonStyle == circular) {
        action.backgroundColor = UIColor.clearColor;
        action.textColor = ActionDescriptorColorForStyle(descriptor, self.buttonStyle);
        action.font = [UIFont systemFontOfSize:13.0];
    }
    
    action.transitionDelegate = [MGUSwipeTransitionAnimation transitionAnimationWithType:self.transitionAnimationType];
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil { NSCAssert(FALSE, @"- initWithNibName:bundle: 사용금지."); return nil; }

@end
