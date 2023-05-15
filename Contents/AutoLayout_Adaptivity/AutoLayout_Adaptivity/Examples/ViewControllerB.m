//
//  ViewControllerC.m
//  AutoLayout_Adaptivity
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

#import "ViewControllerB.h"

@interface ViewControllerX : UIViewController
@end
@implementation ViewControllerX

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) { // 디스미스 될 상황이다.
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self makeDecoCell];
    // 일회성 알림
    __weak __typeof(self) weakSelf = self;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotificationCenter * __weak weakCenter = notificationCenter;
    id __block token = [notificationCenter addObserverForName:UIDeviceOrientationDidChangeNotification
                                    object:nil
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:^(NSNotification *note) {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            [weakCenter removeObserver:token];
            [UIViewController attemptRotationToDeviceOrientation];
            [weakSelf dismissViewControllerAnimated:YES completion:^{}];
            //
            // iOS 16 부터 시스템 버그로 추정되는 로그 메시지가 나온다.
            // `[Assert] A new orientation transaction token is being requested while a valid one already exists. ...`
            // https://stackoverflow.com/questions/74050444/have-anyone-experienced-same-error-log-in-related-with-view-controller-orientati
        }
    }];
}

#pragma mark - 생성 & 소멸
- (void)makeDecoCell {
    NSMutableArray <UIView *>*cells = [NSMutableArray arrayWithCapacity:9];
    CGFloat eyePosition = 500.0;
    CGFloat interval = 80.0;
    CGFloat start = interval * -4;
    for (NSInteger i = 0; i < 9; i++) {
        UIView *view = [UIView new];
        UIColor *rancomColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0
                                               green:(arc4random() % 256) / 255.0
                                                blue:(arc4random() % 256) / 255.0
                                               alpha:1.0];
        view.backgroundColor = rancomColor;
        [cells addObject:view];
        [self.view addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        [view.widthAnchor constraintEqualToAnchor:view.heightAnchor].active = YES;
        [view.widthAnchor constraintEqualToConstant:200.0].active = YES;
        
        CATransform3D transform3D = CATransform3DIdentity;
        transform3D.m34 = -1.0 / eyePosition;
        CGFloat translationZ = (i == 4)? 0.0 : -200.0;
        CGFloat translationX = (i * interval) + start;
        CGFloat rotation = 0.0;
        if (i < 4) {
            rotation = (M_PI_4 * 1.7);
            translationX = translationX - 80.0;
        } else if (i > 4) {
            rotation = (M_PI_4 * -1.7);
            translationX = translationX + 80.0;
        }
        
        transform3D = CATransform3DTranslate(transform3D, translationX, 0.0, translationZ);
        transform3D = CATransform3DRotate(transform3D, rotation, 0.0, 1.0, 0.0);
        view.layer.transform = transform3D;
    }
}
@end

typedef NSString * MainSection NS_TYPED_ENUM;
static MainSection const list  = @"List";

@interface ViewControllerB ()
@property (nonatomic, strong, nullable) UITableViewDiffableDataSource <MainSection, NSString *>*dataSource;
@property (nonatomic, strong, nullable) NSDiffableDataSourceSnapshot <MainSection, NSString *>*currentSnapshot;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id <NSObject>observer;
@end

@implementation ViewControllerB

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureDataSource];
    [self updateUI];
    __weak __typeof(self) weakSelf = self;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    self.observer = [notificationCenter addObserverForName:UIDeviceOrientationDidChangeNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *note) {
        if (weakSelf.presentedViewController == nil &&
            UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) == YES) {
            ViewControllerX *vc = [ViewControllerX new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:vc animated:YES completion:^{}];
        }
    }];
}


#pragma mark - 생성 & 소멸
- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    Class classObject = [UITableViewCell class];
    [self.tableView registerClass:classObject forCellReuseIdentifier:NSStringFromClass(classObject)];
}

- (void)configureDataSource {
    _dataSource =
    [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                                cellProvider:^UITableViewCell *(UITableView *tableView,
                                                                                NSIndexPath * indexPath,
                                                                                NSString *itemIdentifier) {
        UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        UIListContentConfiguration *content = [cell defaultContentConfiguration];
        content.text = itemIdentifier;
        content.secondaryText = @"↺";
        content.prefersSideBySideTextAndSecondaryText = YES;
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
        cell.contentConfiguration = content;
        return cell;
    }];
    self.dataSource.defaultRowAnimation = UITableViewRowAnimationFade;
}

- (void)updateUI {
    _currentSnapshot = [NSDiffableDataSourceSnapshot new];
    [self.currentSnapshot appendSectionsWithIdentifiers:@[list]];
    [self.currentSnapshot appendItemsWithIdentifiers:@[@"Sample1", @"Sample2", @"Sample3", @"Sample4"]
                           intoSectionWithIdentifier:list];
    [self.dataSource applySnapshot:self.currentSnapshot animatingDifferences:NO];
}

@end
