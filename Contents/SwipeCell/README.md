# SwipeCell 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)

## **MGUSwipeTableViewCell (***UITableView***)** <br/> **MGUSwipeCollectionViewCell (***UICollectionView***)**
- 커스텀 CollectionView 에서 스와이프 기능을 지원하고 UITableView에서도 더 더양한 외관과 기능을 제공하는 스와이프 가능한 cell  
    - `UITableViewCell`, `UICollectionViewCell` 을 서브클래싱하여 제작함
- [MiniTimer](https://apps.apple.com/app/id1618148240)를 만들면서 커스텀 CollectionView에서 스와이프 기능을 요청하여 제작함.
<p align="center"><img src="./screenshot/230526a1.jpg" width="800"></p>

 
## Features
*  Leading 및 Trailing swipe actions 지원
    * 아랍어와 같은 RTL(right to left) 방향의 문자 시스템에서는 leading이 오른쪽에서 대응하게 설계됨
*  Action button에 대하여 다양한 Display Mode와 Styles을 지원함
    * Button Display Mode: Image+Title, Image Only, Title Only 
    * Button Styles: Background Color, Circular 
*  다양한 Transition Styles 제공
    * Border Style 
    * Drag Style
    * Reveal Style
*  다양한 Transition Animation Type 제공
    * None 
    * Default
    * Favorite
    * Spring
    * Rotate
*  다양한 Expansion Styles 제공
    * None 
    * Selecton
    * Fill
    * Fill+Delete
    * FillReverse           
*  Diffable 기반 대응
*  Haptic Feedback 제공 : Expansion 발생 시 Haptic Feedback이 터치한 Device를 통해 전달된다.
    * `UIImpactFeedbackGenerator` 이용하여 구현함  
*  `UITableView`와 `UICollectionView` 모두 지원           
*  **Swift** and **Objective-C** compatability
*  Written in Objective-C


## Preview
> - MGUSwipeCollectionViewCell (UICollectionView)
>   - [MiniTimer](https://apps.apple.com/app/id1618148240)를 만들면서 커스텀 CollectionView에서 스와이프 기능을 요청하여 제작함.
> - MGUSwipeTableViewCell (UITableView)


MGUSwipeTableViewCell | MGUSwipeCollectionViewCell | [MiniTimer](https://apps.apple.com/app/id1618148240)(iPhone)에서 사용 예
---|---|---
<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-26 at 10.40.11.gif" width="250">|<img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-26 at 11.00.22.gif" width="250">|<img src="./screenshot/noch2-1.1-mod.gif" width="250">

[MiniTimer](https://apps.apple.com/app/id1618148240)(iPad)에서 사용 예 |
---|
<img src="./screenshot/pad2-1.1-mod.gif" width="805"> |


## Presets and Styles
> Transition Styles

Border Style|Drag Style|Reveal Style
---|---|---
<img src="./screenshot/TransitionStyle_Border.gif" width="310">|<img src="./screenshot/TransitionStyle_Drag.gif" width="310">|<img src="./screenshot/TransitionStyle_Reveal.gif" width="310">

---
> Transition Animation Type

None|Default|Favorite|Spring|Rotate
---|---|---|---|---
<img src="./screenshot/Transition_Animation_None.gif" width="175">|<img src="./screenshot/Transition_Animation_Default.gif" width="175">|<img src="./screenshot/Transition_Animation_Favorite.gif" width="175">|<img src="./screenshot/Transition_Animation_Spring.gif" width="175">|<img src="./screenshot/Transition_Animation_Rotate.gif" width="175">

---
> Expansion Styles

None|Selecton|Fill|Fill+Delete|FillReverse
---|---|---|---|---
<img src="./screenshot/ExpansionStyle_None.gif" width="175">|<img src="./screenshot/ExpansionStyle_Selecton.gif" width="175">|<img src="./screenshot/ExpansionStyle_Fill.gif" width="175">|<img src="./screenshot/ExpansionStyle_Fill+Delete.gif" width="175">|<img src="./screenshot/ExpansionStyle_FillReverse.gif" width="175">

---
> Button Display Mode & Button Styles

&nbsp; &nbsp; &nbsp; Display Mode<br/>└───────┐<br/>Style &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|Image+Title|Image Only|Title Only
---|---|---|---
Background Color |<img src="./screenshot/Button_Display_Mode_Image+Title.jpg" width="250">|<img src="./screenshot/Button_Display_Mode_ImageOnly.jpg" width="250">|<img src="./screenshot/Button_Display_Mode_TitleOnly.jpg" width="250">
Circular   |<img src="./screenshot/Button_Style_Circular_Image+Title.jpg" width="250">|<img src="./screenshot/Button_Style_Circular_ImageOnly.jpg" width="250">|<img src="./screenshot/Button_Style_Circular_TitleOnly.jpg" width="250">




## Usage

<details> 
<summary>👇🖱️ Swift에서의 사용</summary>
<hr>

> * `MGUSwipeCollectionViewCell` 또는 `MGUSwipeTableViewCell`의 `delegate` 프라퍼티를 설정한다.
```swift
//! TableView
dataSource =
UITableViewDiffableDataSource (tableView: tableView) {
     (tableView: UITableView, indexPath: IndexPath, item: String) -> MGUSwipeTableViewCell? in
    guard let cell = tableView.dequeueReusableCell(
        withIdentifier:NSStringFromClass(MGUSwipeTableViewCell.self),
        for: indexPath) as? MGUSwipeTableViewCell else {
       return MGUSwipeTableViewCell()
    }
    var content = cell.defaultContentConfiguration()
    content.text = item
    cell.contentConfiguration = content
    cell.delegate = self // delegate 설정해야 swipe를 이용할 수 있다.
    return cell
}

//! CollectionView
dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                cellProvider: { (collectionView: UICollectionView,
                                                                 indexPath: IndexPath,
                                                                 cellModel: EmailCellModel) -> MGUSwipeCollectionViewCell? in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CollectionViewEmailCell.self), for: indexPath) as? CollectionViewEmailCell else {
        return MGUSwipeCollectionViewCell()
     }
    cell.setData(cellModel)
    cell.delegate = self // delegate 설정해야 swipe를 이용할 수 있다.
    return cell
})

```

------

> * `MGUSwipeCollectionViewCellDelegate` 또는 `MGUSwipeTableViewCellDelegate`의 프로토콜을 구현한다.
>    * 필요에 따라서 옵셔널 메서드도 구현한다.
```swift
//! TableView
func tableView(_ tableView: UITableView, trailing_SwipeActionsConfigurationForRowAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
    let deleteAction = MGUSwipeAction.init(style: .destructive, title: nil) {[weak self] action, sourceView, completionHandler in
        if let items = [self?.items[indexPath.row]] as? [String],
           var snapshot = self?.dataSource?.snapshot() {
            snapshot.deleteItems(items)
            self?.items.remove(at: indexPath.row)
            self?.dataSource?.mgrSwipeApply(snapshot, tableView: tableView)
            //! 중요: MGUSwipeTableViewCell를 사용하여 스와이프로 삭제할 때는 내가 만든 메서드를 사용해야한다. ∵ 애니메이션 효과 때문에
        }
    }
    let image = UIImage.init(systemName: "trash")
    deleteAction.image = image?.mgrImage(with: .white)
    let configuration = MGUSwipeActionsConfiguration.init(actions: [deleteAction])
    configuration.expansionStyle = .fill()
    configuration.transitionStyle = .reveal
    configuration.backgroundColor = .systemRed
    return configuration
}

//! CollectionView
func collectionView(_ collectionView: UICollectionView, trailing_SwipeActionsConfigurationForItemAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
    let deleteAction = MGUSwipeAction.init(style: .destructive, title: nil) {[weak self] action, sourceView, completionHandler in
        if let items = [self?.emails[indexPath.row]] as? [EmailCellModel],
           var snapshot = self?.dataSource?.snapshot() {
            snapshot.deleteItems(items)
            self?.emails.remove(at: indexPath.row)
            self?.dataSource?.mgrSwipeApply(snapshot, collectionView: collectionView)
            //! 중요: MGUSwipeCollectionViewCell를 사용하여 스와이프로 삭제할 때는 내가 만든 메서드를 사용해야한다. ∵ 애니메이션 효과 때문에
        }
    }
    let image = UIImage.init(systemName: "trash")
    deleteAction.image = image?.mgrImage(with: .white)
    deleteAction.title = "Trash"
    let configuration = MGUSwipeActionsConfiguration.init(actions: [deleteAction])
    configuration.expansionStyle = .fill()
    configuration.transitionStyle = .reveal
    configuration.backgroundColor = .systemRed
    return configuration
}

```
</details>


<details> 
<summary>👇🖱️ Objective-C에서의 사용</summary>
<hr>

> *  `MGUSwipeCollectionViewCell` 또는 `MGUSwipeTableViewCell`의 `delegate` 프라퍼티를 설정한다.
```objective-c
//! TableView
_dataSource =
[[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView
                                            cellProvider:^MGUSwipeTableViewCell *(UITableView *tableView, NSIndexPath *indexPath, NSString *item) {
    MGUSwipeTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MGUSwipeTableViewCell class])
                                    forIndexPath:indexPath];
    UIListContentConfiguration *content = [cell defaultContentConfiguration];
    content.text = item;
    cell.contentConfiguration = content;
    cell.delegate = self; // delegate 설정해야 swipe를 이용할 수 있다.
    return cell;
}];

//! CollectionView
self->_diffableDataSource =
[[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView
                                                      cellProvider:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, EmailCellModel *cellModel) {
    CollectionViewEmailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewEmailCell class]) forIndexPath:indexPath];
    [cell setData:cellModel];
    cell.delegate = self; // delegate 설정해야 swipe를 이용할 수 있다.
    return cell;
}];

```

------
> * `MGUSwipeCollectionViewCellDelegate` 또는 `MGUSwipeTableViewCellDelegate`의 프로토콜을 구현한다.
>     * 필요에 따라서 옵셔널 메서드도 구현한다.
```objective-c
//! TableView
- (MGUSwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailing_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    MGUSwipeAction *deleteAction =
    [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                   title:nil
                                 handler:^(MGUSwipeAction * _Nonnull action,
                                           __kindof UIView * _Nonnull sourceView,
                                           void (^ _Nonnull completionHandler)(BOOL)) {
        NSDiffableDataSourceSnapshot <NSString *, NSString *>*snapshot = weakSelf.dataSource.snapshot;
        [snapshot deleteItemsWithIdentifiers:@[weakSelf.items[indexPath.row]]];
        [weakSelf.items removeObjectAtIndex:indexPath.row];
        [weakSelf.dataSource mgrSwipeApplySnapshot:snapshot tableView:tableView completion:nil];
        //! 중요: MGUSwipeTableViewCell를 사용하여 스와이프로 삭제할 때는 내가 만든 메서드를 사용해야한다. ∵ 애니메이션 효과 때문에
    }];
            
    UIImage *image = [UIImage systemImageNamed:@"trash"];
    deleteAction.image = [image mgrImageWithColor:[UIColor whiteColor]];
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    return configuration;
}

//! CollectionView
- (MGUSwipeActionsConfiguration *)collectionView:(UICollectionView *)collectionView
trailing_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewEmailCell *cell = (CollectionViewEmailCell *)[collectionView cellForItemAtIndexPath:indexPath];
    __weak __typeof(self) weakSelf = self;
    MGUSwipeAction *deleteAction =
    [MGUSwipeAction swipeActionWithStyle:MGUSwipeActionStyleDestructive
                                   title:@"Trash"
                                 handler:^(MGUSwipeAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        NSDiffableDataSourceSnapshot <NSNumber *, EmailCellModel *>*snapshot = weakSelf.diffableDataSource.snapshot;
        [snapshot deleteItemsWithIdentifiers:@[weakSelf.emails[indexPath.row]]];
        [weakSelf.emails removeObjectAtIndex:indexPath.row];
        [weakSelf.diffableDataSource mgrSwipeApplySnapshot:snapshot collectionView:weakSelf.collectionView completion:nil];
        //! 중요: MGUSwipeCollectionViewCell를 사용하여 스와이프로 삭제할 때는 내가 만든 메서드를 사용해야한다. ∵ 애니메이션 효과 때문에
    }];
    UIImage *image = [UIImage systemImageNamed:@"trash"];
    deleteAction.image = [image mgrImageWithColor:[UIColor whiteColor]];
    MGUSwipeActionsConfiguration *configuration = [MGUSwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.expansionStyle = [MGUSwipeExpansionStyle fill];
    configuration.transitionStyle = MGUSwipeTransitionStyleReveal;
    configuration.backgroundColor = [UIColor systemRedColor];
    return configuration;
}

```
</details>


## Documentation

* `MGUSwipeCollectionViewCell`(CollectionView)을 사용할 경우에는 `UIListContentConfiguration`을 사용해서는 **안된다**.
    * iOS 14이상 부터 지원하는 CollectionView Cell의 스와이프와 충돌하므로 `UIListContentConfiguration`를 사용하지 않으면 문제 없이 작동한다.
    * TableView는 문제 없이 작동한다.
    
        
* 스와이프 액션으로 셀을 삭제할 때는 클로저 내부에서 다음과 같은 메서드로 삭제해야한다.
>
>        * 내부의 애니메이션 처리를 위해 필요하다.
> ```objective-c
> // objective-c
> - (void)mgrSwipeApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
>                     tableView:(UITableView *)tableView
>                    completion:(void(^_Nullable)(void))completion;
> ```
> ```swift
> // swift
> func mgrSwipeApply(
>     _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
>     tableView: UITableView,
>     completion: (() -> Void)? = nil
> )    
> ```    
> ```swift
> func tableView(_ tableView: UITableView, trailing_SwipeActionsConfigurationForRowAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
>     let deleteAction = MGUSwipeAction.init(style: .destructive, title: nil) {[weak self] action, sourceView, completionHandler in
>         if let items = [self?.items[indexPath.row]] as? [String],
>            var snapshot = self?.dataSource?.snapshot() {
>             snapshot.deleteItems(items)
>             self?.items.remove(at: indexPath.row)
>             self?.dataSource?.mgrSwipeApply(snapshot, tableView: tableView)
>             //! 중요: MGUSwipeTableViewCell를 사용하여 스와이프로 삭제할 때는 내가 만든 메서드를 사용해야한다. ∵ 애니메이션 효과 때문에
>         }
>     }
>     ...
>     return configuration
> }
> 
> ```    

    

## Author

sonkoni(손관현), isomorphic111@gmail.com


## Credits

* Inspired by [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit) by [Mohammad Kurabi](https://github.com/kurabi).
    * [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit)에는 치명적인 버그가 존재하여 그대로 사용할 수 없어 Objective-C로 재작성하면서 발견된 모든 버그를 수정하고, 필요하다고 생각되는 기능을 추가하였음. 추가적으로 메서드 형식을 현재 애플 스와이프와 유사한 방식으로 호출할 수 있도록 모든 요소를 현대적으로 바꿨음.

### Differences and Improvements 
---------
> [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit) by [Mohammad Kurabi](https://github.com/kurabi)|MGUSwipeTableViewCell
> ---|---
> **Left**, **right** swipe actions based.<br/>아랍어와 같이 RTL(right to left)방향으로 문자가 쓰여지는 언어에서<br/>적절하게 대응을 못함.<br/><p align="center"><img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-30 at 10.25.34.gif" width="150"></p> | **Leading**, **Trailing** swipe actions based.<br/>아랍어와 같이 RTL(right to left)방향으로 문자가 쓰여지는 언어에서<br/>적절하게 대응함.<br/><p align="center"><img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-30 at 10.23.17.gif" width="150"></p>
> Built-in Transition Animation Type 없음. | There exists a built-in **[Transition Animation Type](#presets-and-styles)**.<br/>1. None<br/>2. Default<br/>3. Favorite<br/>4. Spring<br/>5. Rotate
> Delete Animation 작동 안함(버그로 추정)<br/>삭제 시 그냥 펑 사라짐<br/><p align="center"><img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-29 at 14.52.32.gif" width="150"></p> | Delete Animation 정상 작동<br/>삭제 시 mask view를 통해 자연스럽게 삭제하게 만듬<br/><p align="center"><img src="./screenshot/Simulator Screen Recording - iPhone 14 - 2023-05-30 at 09.12.30.gif" width="150"></p>
> **Swift** compatability | **Swift** and **Objective-C** compatability


---------
> * Differences and improvements in ***TableView***
>
> [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit) by [Mohammad Kurabi](https://github.com/kurabi)|MGUSwipeTableViewCell
> ---|---
> `UITableViewStyleInsetGrouped` 사용시 앱이 **크래쉬** 됨<br/><ul><li>[x] `UITableViewStylePlain`</li><li>[x] `UITableViewStyleGrouped`</li><li>[ ] `UITableViewStyleInsetGrouped` - 앱 ***크래쉬*** 됨</li></ul><br/><p align="center"><img src="./screenshot/Screenshot 2023-05-30 at 13.12.44.jpg" width="300"></p> | 다음 세 가지 `UITableViewStyle` 모두 정상적으로 작동함<br/><ul><li>[x] `UITableViewStylePlain`</li><li>[x] `UITableViewStyleGrouped`</li><li>[x] `UITableViewStyleInsetGrouped`</li></ul><br/><p align="center"><img src="./screenshot/Screenshot 2023-05-30 at 13.09.31.jpg" width="300"></p>


---------
> * Differences and improvements in ***CollectionView***
>
> [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit) by [Mohammad Kurabi](https://github.com/kurabi) | MGUSwipeCollectionViewCell 
> ---|---
> swipe로 cell을 expand한 후 Device를 회전하면 cell이 닫히는 버그 존재함<br/><p align="center"><img src="./screenshot/Screen Recording 2023-05-30 at 12.43.04.gif" width="300"></p> | 정상적으로 작동함<br/><p align="center"><img src="./screenshot/Screen Recording 2023-05-30 at 12.57.46.gif" width="300"></p>
> Device를 360도 회전하면 cell의 레이아웃이 망가짐<br/><p align="center"><img src="./screenshot/Screen Recording 2023-05-30 at 12.45.15.gif" width="300"></p> | 정상적으로 작동함<br/><p align="center"><img src="./screenshot/Screen Recording 2023-05-30 at 12.59.18.gif" width="300"></p>





## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
