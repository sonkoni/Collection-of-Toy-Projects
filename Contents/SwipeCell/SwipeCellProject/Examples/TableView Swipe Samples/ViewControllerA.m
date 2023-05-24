//
//  ViewController1.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/02/08.
//

@import IosKit;
#import "ViewControllerA.h"
#import "EmailCell.h"
#import "EmailCellModel.h"

@interface ViewControllerA () <MGUSwipeTableViewCellDelegate, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray <EmailCellModel *>*emails;
@property (nonatomic, assign) MGUSwipeTransitionStyle transitionStyle;
@property (nonatomic, assign) BOOL isSwipeRightEnabled;
@property (nonatomic, assign) ButtonDisplayMode buttonDisplayMode;
@property (nonatomic, assign) ButtonStyle buttonStyle;
@property (nonatomic, assign) MGUSwipeTransitionAnimationType transitionAnimationType;
@property (nonatomic, assign) BOOL usesTallCells;
@property (nonatomic, strong) UITableViewDiffableDataSource <NSNumber *, EmailCellModel *>*diffableDataSource;
@property (nonatomic, assign) UIUserInterfaceLayoutDirection userInterfaceLayoutDirection; // 아랍어 순서 또는 영어 순서 (좌우)
@end

@implementation ViewControllerA

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Inbox", @"");
    _userInterfaceLayoutDirection =
    [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute];
    //
    // 일반전인 문자 순서: 문자를 왼쪽에서 오른쪽으로 적는다. UIUserInterfaceLayoutDirectionLeftToRight
    // 아랍어, 히브리어 같은 문자 순서: 문자를 오른쪽에서 왼쪽으로 적는다. UIUserInterfaceLayoutDirectionRightToLeft
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    [self configureTableView];
    [self configureDataSource];
    [self resetData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIEdgeInsets edgeInsets = self.tableView.layoutMargins;
    edgeInsets.left = 32.0;
    edgeInsets.right = 16.0;
    self.tableView.layoutMargins = edgeInsets;
    self.navigationController.toolbarHidden = NO;
}


#pragma mark - 생성 & 소멸
static void CommonInit(ViewControllerA *self) {
    self->_emails = @[].mutableCopy;
    self->_isSwipeRightEnabled = YES;
    self->_transitionStyle = MGUSwipeTransitionStyleBorder;
    self->_buttonDisplayMode = titleAndImage;
    self->_buttonStyle = backgroundColor;
    self->_usesTallCells = NO;
    self->_transitionAnimationType = MGUSwipeTransitionAnimationTypeNone;
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([EmailCell class]) bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([EmailCell class])];
}

- (void)configureDataSource {
    _diffableDataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                                                      cellProvider:^EmailCell *(UITableView * tableView,
                                                                                                NSIndexPath *indexPath,
                                                                                                EmailCellModel *itemIdentifier) {
        
        EmailCell *cell =
        (EmailCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmailCell class])
                                                    forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.selectedBackgroundView = [self createSelectedBackgroundView];
        cell.multipleSelectionBackgroundView = [self createMultipleSelectedBackgroundView];
        
        EmailCellModel *email = self.emails[indexPath.row];
        cell.fromLabel.text = email.from;
        cell.dateLabel.text = email.relativeDateString;
        cell.subjectLabel.text = email.subject;
        cell.bodyLabel.text = email.body;
        cell.bodyLabel.numberOfLines = self.usesTallCells ? 0 : 2;
        cell.unread = email.unread;
        
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

    self.diffableDataSource.defaultRowAnimation = UITableViewRowAnimationAutomatic;
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


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing == YES) {
        return;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

//! 반드시 구현해줘야한다. 스크롤 왔다갔다하면 frame을 못찾는다.
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.maskView != nil) {
        cell.maskView.frame = cell.bounds;
    }
}


#pragma mark - <SwipeTableViewCellDelegate>
#pragma mark - @required
- (MGUSwipeActionsConfiguration *)tableView:(UITableView *)tableView
leading_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        EmailCell *cell = (EmailCell *)[tableView cellForRowAtIndexPath:indexPath];
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

- (MGUSwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailing_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    EmailCell *cell = (EmailCell *)[tableView cellForRowAtIndexPath:indexPath];

    void (^closure)(UIAlertAction *alertAction) = ^(UIAlertAction *alertAction) {
        [cell hideSwipeAnimated:YES completion:nil];
    };

    MGUSwipeAction *flag = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDefault
                                             title:nil
                                           handler:^(MGUSwipeAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        completionHandler(YES); // 자동 hide!!
    }];

    [self configureAction:flag with:ActionDescriptorFlag];

    MGUSwipeAction *delete = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                             title:nil
                                           handler:^(MGUSwipeAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
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
                [self.diffableDataSource mgrSwipeApplySnapshot:snapshot tableView:self.tableView completion:nil];
                
                // UITableViewStyleInsetGrouped 스타일일때, offset이 셀의 전체영역이 테이블뷰보다 작아질때 애니메이션이 끊기는 현상이 발생하여
                // 아래의 코드를 넣었다.
                [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.0 delay:0.0 options:0 animations:^{
                    [self.tableView layoutIfNeeded];
                } completion:nil];
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
            [self.diffableDataSource mgrSwipeApplySnapshot:snapshot tableView:self.tableView completion:nil];

            // UITableViewStyleInsetGrouped 스타일일때, offset이 셀의 전체영역이 테이블뷰보다 작아질때 애니메이션이 끊기는 현상이 발생하여
            // 아래의 코드를 넣었다.
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.0 delay:0.0 options:0 animations:^{
                [self.tableView layoutIfNeeded];
            } completion:nil];
        }
    }];

    [self configureAction:delete with:ActionDescriptorTrash];

    MGUSwipeAction *more = [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDefault
                                             title:nil
                                           handler:^(MGUSwipeAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *replyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reply", @"")
                                                              style:UIAlertActionStyleDefault
                                                            handler:closure];
        UIAlertAction *forwardAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Forward", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:closure];
        UIAlertAction *markAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Mark...", @"")
                                                             style:UIAlertActionStyleDefault
                                                           handler:closure];
        UIAlertAction *notifyMeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Notify Me...", @"")
                                                                 style:UIAlertActionStyleDefault
                                                               handler:closure];
        UIAlertAction *moveMessageMeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Move Message...", @"")
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:closure];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                               style:UIAlertActionStyleCancel
                                                             handler:closure];

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

#pragma mark - @optional
- (CGRect)visibleRectForTableView:(UITableView *)tableView {
    if (self.usesTallCells == NO) {
        return CGRectNull;
    }
    return tableView.safeAreaLayoutGuide.layoutFrame;
}

// - (void)tableView:(UITableView *)tableView
// willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)tableView:(UITableView *)tableView
// willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)tableView:(UITableView *)tableView
// didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath {}
// - (void)tableView:(UITableView *)tableView
// didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath {}


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
        self.transitionStyle = MGUSwipeTransitionStyleReveal;
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
        self.transitionStyle = MGUSwipeTransitionStyleReveal;
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
        [self.tableView reloadData];
    }];
    UIAlertAction *tallAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Tall", @"")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
        self.usesTallCells = YES;
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
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
        self.transitionAnimationType = MGUSwipeTransitionAnimationTypeDefault;
    }];
    
    UIAlertAction *springAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Spring Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType = MGUSwipeTransitionAnimationTypeSpring;
    }];
    
    UIAlertAction *rotateAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Rotate Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType = MGUSwipeTransitionAnimationTypeRotate;
    }];
    
    UIAlertAction *favoriteAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Favorite Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType = MGUSwipeTransitionAnimationTypeFavorite;
    }];
    
    UIAlertAction *noneAnimationTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"None Animation Type", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
        self.transitionAnimationType = MGUSwipeTransitionAnimationTypeNone;
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

- (UIView *)createSelectedBackgroundView {
    UIView *view = [UIView new];
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    return view;
}

- (UIView *)createMultipleSelectedBackgroundView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
