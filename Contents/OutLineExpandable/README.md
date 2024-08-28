# Outline Project 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)


## MGROutlineItem (***Objective-C***) <br/> SKHOutlineItem (***Swift***)
- 트리구조 라이브러리 & UI 구현(UI는 `UITableView` 또는 `UICollectionView` 이용)
- [MTS 프로젝트](https://youtu.be/161FoZYpU8I?si=z89zAGR5vfeHqILa&t=90)를 진행하면서 해당 트리구조 라이브러리 이용함.
> - MGROutlineItem
>   - 트리구조 라이브러리
>   - Written in **Objective-C**, **Swift** and **Objective-C** compatability
> - SKHOutlineItem
>   - 트리구조 라이브러리
>   - Written in **Swift**
<p align="center"><img src="./screenshot/240828a4.jpg" width="400"></p>

## Features
* 계층적 데이터의 구조를 잡아준다
* 실제로 사용될 컨텐츠는 **제네릭**으로 감싸는 구조
* 서브 아이템을 열고 닫을 수 있는 Flag를 지원하여 사용될 UI(TableView 또는 CollectionView)에서 이를 적절히 이용할 수 있다
* recurrence 기능을 제공하여 일괄적인 데이터 업데이트 가능
* 특정 아이템에서 자신의 indexPath에 대한 정보 Get 가능
* UI 에서 Drag & Drop 이용 시 아카이브 데이터 제공     
* MGROutlineItem
    * Written in **Objective-C**, **Swift** and **Objective-C** compatability
* SKHOutlineItem
    * Written in **Swift**

## Preview
> - MGROutlineItem (***Objective-C***), SKHOutlineItem (***Swift***) & UI
>   - 트리구조 알고리즘과 이를 뷰모델로 이용하여 구현한 UI(`UITableView` OR `UICollectionView`)

Sample 1 | Sample 2 | [MTS 프로젝트](https://youtu.be/161FoZYpU8I?si=z89zAGR5vfeHqILa&t=90)에서 사용 예
---|---|---
<img src="./screenshot/230520c1.gif" width="250">|<img src="./screenshot/230520c2.gif" width="250">|<img src="./screenshot/230520c3.gif" width="250">


## Usage

> Objective-C
```objective-c

MGROutlineItem *item0 =
[MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Compositional Layout"] subitems:@[
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Getting Started"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"List" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Grid" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Inset Items Grid" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Two-Column Grid" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Per-Section Layout"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Distinct Sections" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Adaptive Sections" viewControllerClass:classObjc]]]]]],
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Advanced Layouts"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Supplementary Views"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Item Badges" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Section Headers/Footers" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Pinnned Section Headers" viewControllerClass:classObjc]]]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Section Background Decoration" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Nested Groups" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Orthogonal Sections"] subitems:@[
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Orthogonal Sections" viewControllerClass:classObjc]],
            [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Orthogonal Section Behaviors" viewControllerClass:classObjc]]]]]],
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Conference App"] subitems:@[
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Videos" viewControllerClass:classObjc]],
        [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"News" viewControllerClass:classObjc]]]]
]];
    
MGROutlineItem *item1 =
[MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Diffable Data Source"] subitems:@[
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Mountains Search" viewControllerClass:classObjc]],
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Settings: Wi-Fi" viewControllerClass:classObjc]],
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"Insertion Sort Visualization" viewControllerClass:classObjc]],
    [MGROutlineItem outlineWithContentItem:[OutlineContent itemWithTitle:@"UITableView: Editing" viewControllerClass:classObjc]]]];
    
_menuItems = @[item0, item1].mutableCopy;

```

## Documentation

- DialControl의 Behavior를 위한 설계도
<img src="./screenshot/230520a2.jpg" width="1000">

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
