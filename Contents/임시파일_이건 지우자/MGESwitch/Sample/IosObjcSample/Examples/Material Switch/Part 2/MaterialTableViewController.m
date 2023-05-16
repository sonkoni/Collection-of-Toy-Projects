//
//  MaterialTableViewController.m
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 25/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//


#import "MaterialTableViewController.h"
#import "MGRTableViewCellIdentifier.h"
#import "MGRTableViewCell1.h"
#import "MGRTableViewCell2.h"
#import "MGRTableViewCell3.h"

@interface MaterialTableViewController ()
@property (nonatomic, strong) NSArray      *sectionList;
@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, strong) NSMutableArray <UITableViewCell *>*cells;
@end

@implementation MaterialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Material Switch의 다양한 모습.";
    [self setupDefaultValues];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionName = [self.sectionList objectAtIndex:section];
    return [[self.dataSource objectForKey:sectionName ]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 섹션을 통해 identifier가 속한 배열을 찾는다.
    NSString *sectionName = self.sectionList[indexPath.section];
    NSArray *items        = self.dataSource[sectionName];
    
    // 해당 배열에서 현재 cell에 해당하는 identifier를 찾는다.
    MGRTableViewCellIdentifier cellIdentifier = items[indexPath.row];

    UITableViewCell *cell;
    
    for ( UITableViewCell *currnetCell in self.cells ) {
        MGRTableViewCellIdentifier identifier = [currnetCell valueForKey:@"identifier"];
        
        if ([identifier isEqualToString:cellIdentifier]) {
            cell = currnetCell;
            break;
        }
    }
    
    if (cell == nil) { //! 발동하지 않을 것이다.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}

// 열이 1000개 이상일 때, 성능저하를 가져온다. UITableView의 rowHeight 프라퍼티(viewDidLoad 에서)를 사용할 것을 추천한다.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionList objectAtIndex:section];
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 소멸 메서드
- (void)setupDefaultValues {
    
    self.sectionList = @[@"Style", @"Size", @"Bounce", @"Ripple Effect", @"Enabled"];
    
    NSArray *styles  = @[MGRDefaultIdentifier, MGRLightIdentifier, MGRDarkIdentifier, MGRCustomizedStyleIdentifier];
    NSArray *sizes   = @[MGRSizeIdentifier];
    NSArray *bounce  = @[MGRBounceIdentifier];
    NSArray *ripple  = @[MGRRippleIdentifier];
    NSArray *enabled = @[MGREnabledIdentifier];
    
    NSArray *datas  = @[styles, sizes, bounce, ripple, enabled];
    self.dataSource = [NSDictionary dictionaryWithObjects:datas forKeys:self.sectionList];
    
    //-------------------------------------------------------------------------------------
    self.cells = [NSMutableArray arrayWithCapacity:8];
    
    UINib *nib = [UINib nibWithNibName:@"MGRTableViewCell1" bundle:[NSBundle mainBundle]];
    MGRTableViewCell1 *cell1 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell1.identifier = MGRDefaultIdentifier;
    [self.cells addObject:cell1];
    
    cell1 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell1.identifier = MGRLightIdentifier;
    [self.cells addObject:cell1];
    
    cell1 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell1.identifier = MGRDarkIdentifier;
    [self.cells addObject:cell1];
    
    cell1 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell1.identifier = MGRCustomizedStyleIdentifier;
    [self.cells addObject:cell1];
    
    
    nib = [UINib nibWithNibName:@"MGRTableViewCell2" bundle:[NSBundle mainBundle]];
    MGRTableViewCell2 *cell2 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell2.identifier = MGRBounceIdentifier;
    [self.cells addObject:cell2];
    
    cell2 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell2.identifier = MGRRippleIdentifier;
    [self.cells addObject:cell2];
    
    cell2 = [nib instantiateWithOwner:self options:nil].lastObject;
    cell2.identifier = MGREnabledIdentifier;
    [self.cells addObject:cell2];
    
    
    MGRTableViewCell3 *cell3 = [[NSBundle mainBundle] loadNibNamed:@"MGRTableViewCell3"
                                                             owner:self
                                                           options:nil].lastObject;
    cell3.identifier = MGRSizeIdentifier;
    [self.cells addObject:cell3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
/*
 - (NSMutableArray <UITableViewCell *>*)tableViewCellSetup {
 
 NSMutableArray *arr = [NSMutableArray arrayWithCapacity:8];
 
 NSArray *styles = self.dataSource[@"Style"];
 for (MGRTableViewCellIdentifier identifier in styles) {
 
 [[NSBundle mainBundle] loadNibNamed:@"MGRTableViewCell1" owner:self options:nil].lastObject;
 
 MGRTableViewCell1 *cell = [[MGRTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
 [arr addObject:cell];
 }
 //UINib *nib = [UINib nibWithNibName:@"MGRTableViewCell" bundle:[NSBundle mainBundle]];
 //NSArray *topLevelObjects = [rawNib instantiateWithOwner:self options:nil];
 //NSArray *jooto = [[NSBundle mainBundle] loadNibNamed:@"MGRTableHeaderView" owner:self options:nil];
 
 
 UINib *rawNib = [UINib nibWithNibName:@"MGRLabelView" bundle:[NSBundle mainBundle]];
 self.doseLableView          = [rawNib instantiateWithOwner:self options:nil].lastObject;
 self.weightLableView        = [rawNib instantiateWithOwner:self options:nil].lastObject;
 self.medicationLableView    = [rawNib instantiateWithOwner:self options:nil].lastObject;
 self.concentrationLableView = [rawNib instantiateWithOwner:self options:nil].lastObject;
 self.totalTimeLableView     = [rawNib instantiateWithOwner:self options:nil].lastObject;
 

MGRTableViewCell2 *cell2 = [[MGRTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGRBounceIdentifier];
[arr addObject:cell2];

cell2 = [[MGRTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGRRippleIdentifier];
[arr addObject:cell2];

cell2 = [[MGRTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGREnabledIdentifier];
[arr addObject:cell2];

MGRTableViewCell3 *cell3 = [[MGRTableViewCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGRSizeIdentifier];
[arr addObject:cell3];

return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     재사용하고 싶지 않다.
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
     forIndexPath:indexPath];
    
    // 섹션을 통해 identifier가 속한 배열을 찾는다.
    NSString *sectionName = self.sectionList[indexPath.section];
    NSArray *items        = self.dataSource[sectionName];
    
    // 해당 배열에서 현재 cell에 해당하는 identifier를 찾는다.
    MGRTableViewCellIdentifier cellIdentifier = items[indexPath.row];
    UITableViewCell *cell;
    
    for (UITableViewCell * cellX in self.cells) {
        if ( [cellX.reuseIdentifier isEqualToString:cellIdentifier] == YES) {
            cell  = cellX;
            break;
        }
    }
    
    return cell;
}

 ***/
