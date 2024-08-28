# Outline Project 

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
![Objective-C](https://img.shields.io/badge/Objective--C-3A95E3?style=flat-square&logo=apple&logoColor=white)<br/>
![iOS](https://img.shields.io/badge/IOS-000000?style=flat-square&logo=ios&logoColor=white)


## MGROutlineItem (***Objective-C***) <br/> SKHOutlineItem (***Swift***)
- 트리구조 라이브러리 & UI 구현(UI는 `UITableView` 또는 `UICollectionView` 이용)
- [MTS 프로젝트](https://youtu.be/161FoZYpU8I?si=z89zAGR5vfeHqILa&t=90)를 진행하면서 해당 트리구조 라이브러리 이용함.
> - `MGROutlineItem`
>   - 트리구조 라이브러리
>   - Written in **Objective-C**, **Swift** and **Objective-C** compatability
> - `SKHOutlineItem`
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
<details> 
<summary>👇🖱️ `SKHOutlineItem.swift` </summary>
<hr>

> <strong>Note:</strong> `MGROutlineItem.h`, `MGROutlineItem.m` 생략

```Swift

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
import MobileCoreServices
#endif
import UniformTypeIdentifiers

public protocol SKHOutlineItemContent: Codable, AnyObject {
    func outlineItem<T: Codable>(_ value: SKHOutlineItem<T>)
}

final public class SKHOutlineItem<T: Codable>: NSObject, Codable, NSItemProviderReading, NSItemProviderWriting {

    // MARK: - Property
    
    public var contentItem: T?
    public private(set) var subitems: Array<SKHOutlineItem<T>>?
    public var recurrenceAllSubitems: Array<SKHOutlineItem<T>>? { // 자기자신 제외. 위치를 확인하기 위해. Temp 이용
        var recurrenceAllSubitems = _recurrenceAllSubitems()
        recurrenceAllSubitems.removeAll {
            $0 === self
        }
        return recurrenceAllSubitems
    }
    var recurrenceAllExpandedSubitems: Array<SKHOutlineItem<T>>? { // 자기자신 제외. expand 전체를 확인하기 위해. Temp 이용
        var recurrenceAllExpandedSubitems = _recurrenceAllSubitems(isExpanded: true)
        recurrenceAllExpandedSubitems.removeAll {
            $0 === self
        }
        return recurrenceAllExpandedSubitems
    }
    var recurrenceAllCollapsedSubitems: Array<SKHOutlineItem<T>>? { // 자기자신 제외. collapse 전체를 확인하기 위해. Temp 이용
        var recurrenceAllCollapsedSubitems = _recurrenceAllSubitems(isExpanded: false)
        recurrenceAllCollapsedSubitems.removeAll {
            $0 === self
        }
        return recurrenceAllCollapsedSubitems
    }
    
    public weak var superitem: SKHOutlineItem<T>?
    public var progenitor: SKHOutlineItem<T>? {
        var result = self.superitem
        while result?.superitem !== nil {
            result = result?.superitem
        }
        return result
    }
    
    var currentLocationInfo: LocationInfo? {
        guard let superitem = self.superitem else {
            assertionFailure("부모가 없을 경우, controller에서 판단해야한다.")
            return nil
        }
        
        if let count = superitem.subitems?.count, count > 1 { // 부모의 서브 아이템이 2 개 이상일 경우
            
            if superitem.subitems?.first == self {
                return LocationInfo.init(superitem: superitem, afterItem: nil, beforeItem: superitem.subitems?[1])
            } else if superitem.subitems?.last == self {
                let index = count - 2
                return LocationInfo.init(superitem: superitem, afterItem: superitem.subitems?[index], beforeItem: nil)
            } else { // 자신이 부모의 첫 번째 또는 마지막 아이템이 아닐 경우.
                guard var index = superitem.subitems?.firstIndex(of: self) else {
                    assertionFailure("index가 nil 일 수는 없다. - 불가능")
                    return nil
                }
                index = index - 1
                return LocationInfo.init(superitem: superitem, afterItem: superitem.subitems?[index], beforeItem: superitem.subitems?[index + 2])
            }
        } else { // 부모의 서브 아이템이 오직 자신 뿐일 경우.
            return LocationInfo.init(superitem: superitem, afterItem: nil, beforeItem: nil)
        }
    }
    
    public var isExpanded: Bool = false
    private(set) var isFolder: Bool
    public var hasSubitem: Bool {
        if let subItem = self.subitems, subItem.count > 0 {
            return true
        }
        return false
    }
    
    public var indentationLevel: Int {
        var indentLevel: Int = 0
        var outlineItem = superitem
        while outlineItem != nil {
            indentLevel += 1
            outlineItem = outlineItem?.superitem
        }
        
        return indentLevel
    }
    
    private(set) var isTempRoot = false
    
    private var identifier = UUID()
    
    // MARK: - Override
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else {
            return false
        }
        if other === self {
            return true
        }
        
        return identifier == other.identifier
    }
    
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(identifier)
        return hasher.finalize()
    }
    
    // MARK: - 생성 & 소멸
    
    /// 모두 가능
    public init(contentItem: T?, isFolder: Bool, subitems: Array<SKHOutlineItem<T>>?) {
        self.contentItem = contentItem
        self.isFolder = isFolder
        super.init()
        append(subitems)
        if let item = contentItem as? (any SKHOutlineItemContent) {
            item.outlineItem(self)
        }
    }
    
    /// 폴더에서 사용. nil 이면 빈 폴더 의미.
    public convenience init(contentItem: T, subitems: Array<SKHOutlineItem<T>>?) {
        self.init(contentItem: contentItem, isFolder: true, subitems: subitems)
    }
    
    /// 폴더가 아닌 곳에서 사용.
    public convenience init(contentItem: T) {
        self.init(contentItem: contentItem, isFolder: false, subitems: nil)
    }
    
    /// 임시 루트. 계산을 위해 필요하다
    public convenience init(tempRoot subitems: Array<SKHOutlineItem<T>>?) {
        self.init(contentItem: nil, isFolder: true, subitems: subitems)
        isTempRoot = true
    }
    
    // MARK: - Actions
    
    public func append(_ subitems: Array<SKHOutlineItem<T>>?) {
        guard let subitems = subitems
        else {
            return
        }
        if self.subitems == nil {
            self.subitems = []
        }
        register(subitems)
        for subItem in subitems {
            self.subitems?.append(subItem)
        }
    }
    
    public func insert(
        _ subitems: [SKHOutlineItem<T>],
        afterItem: SKHOutlineItem<T>
    ) {
        if var items = self.subitems, 
           let index = items.firstIndex(of: afterItem) {
            register(subitems)
            items.insert(contentsOf: subitems, at: index + 1)
            self.subitems = items
        }
    }
    
    public func insert(
        _ subitems: [SKHOutlineItem<T>],
        beforeItem: SKHOutlineItem<T>
    ) {
        if var items = self.subitems,
           let index = items.firstIndex(of: beforeItem) {
            register(subitems)
            items.insert(contentsOf: subitems, at: index)
            self.subitems = items
        }
    }
    
    public func delete(
        _ subitems: [SKHOutlineItem<T>]
    ) {
        guard let items = self.subitems else {
            return
        }
        let intersection = Set(items).intersection(Set(subitems))
        let intersectionArray = Array(intersection)
        unRegister(intersectionArray)
        self.subitems?.removeAll(where: {
            intersectionArray.contains($0)
        })
    }
    
    public func deleteAllSubitems() {
        unRegister(subitems)
        subitems = [SKHOutlineItem<T>]()
    }
    
    public func removeFromSuperitem() {
        if let superitem = superitem {
            superitem.delete([self])
        }
    }
    
    public func superitemsToUpperLimit() -> [SKHOutlineItem<T>] {
        if isExpanded {
            assertionFailure("폴더이면서 열려 있다면 호출 자체를 하지 마라")
        }
        var result = [SKHOutlineItem<T>]()
        var currentItem = self
        var superitem = self.superitem
        if superitem == nil {
            assertionFailure("현재 손가락에 해당하는 아이템이 Root라면 호출 자체를 하지 마라")
        } else if superitem?.subitems?.last !== self {
            assertionFailure("현재 손가락에 해당하는 아이템이 superitem의 마지막 아이템이 아니라면 호출 자체를 하지 마라")
        }
        
        while superitem?.subitems?.last == currentItem && superitem != nil {
            result.append(superitem!)
            currentItem = superitem!
            superitem = superitem!.superitem
        } // 딱 한단계 빼고 다 모은다. nil은 없다.

        if result.last?.isTempRoot == false {
            if let item = result.last?.superitem {
                result.append(item)
            } else {
                assertionFailure("주어진 TempRoot를 사용해야한다")
            }
        }
        return result
    }
    
    // MARK: - Private Helper
    
    private func register(_ subitems: Array<SKHOutlineItem<T>>?) {
        guard let subitems = subitems
        else {
            return
        }
        for item in subitems {
            item.superitem = self
        }
    }
    
    private func unRegister(_ subitems: Array<SKHOutlineItem<T>>?) {
        guard let subitems = subitems
        else {
            return
        }
        for item in subitems {
            item.superitem = nil
        }
    }
    
    private func _recurrenceAllSubitems() -> [SKHOutlineItem<T>] {
        var all = [SKHOutlineItem<T>]()
        
        let getSubitemsBlock: (SKHOutlineItem<T>) -> Void = { current in
            all.append(current)
            if let subitems = current.subitems {
                for sub in subitems {
                    all += sub._recurrenceAllSubitems()
                }
            }
        }
        
        getSubitemsBlock(self)
        return all
    }
    
    private func _recurrenceAllSubitems(isExpanded: Bool) -> [SKHOutlineItem<T>] {
        var all = [SKHOutlineItem<T>]()
        
        let getSubViewsBlock: (SKHOutlineItem<T>) -> Void = { current in
            if current.isExpanded == isExpanded {
                all.append(current)
            }
            if let subitems = current.subitems {
                for sub in subitems {
                    all += sub._recurrenceAllSubitems(isExpanded: isExpanded)
                }
            }
        }
        
        getSubViewsBlock(self)
        return all
    }
    
    // MARK: - NSItemProviderReading

    public static var readableTypeIdentifiersForItemProvider: [String] {
        if #available(macOS 11, iOS 14, *) {
            return [UTType.data.identifier]
        } else {
            return [(kUTTypeData as String)]
        }
    }

    public static func object(
        withItemProviderData data: Data,
        typeIdentifier: String
    ) throws -> Self {
        do {
            let subject = try JSONDecoder().decode(Self.self, from: data)
            return subject
        }
        catch{
            fatalError("\(error.localizedDescription)")
        }
    }
    
    // MARK: - NSItemProviderWriting
    
    public static var writableTypeIdentifiersForItemProvider: [String] {
        if #available(macOS 11, iOS 14, *) {
            return [UTType.data.identifier]
        } else {
            return [(kUTTypeData as String)]
        }
    }
    
    public func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void
    ) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        
        do {
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        }
        catch {
            completionHandler(nil, error)
        }
        return progress
    }
    
    // MARK: - UNAVAILABLE

    @available(*, unavailable)
    override public init() {
        fatalError("init() has not been implemented")
    }
}

extension SKHOutlineItem {
    class LocationInfo: NSObject, NSCopying {
        
        var superitem: SKHOutlineItem?
        var afterItem: SKHOutlineItem?
        var beforeItem: SKHOutlineItem?
        
        init(superitem: SKHOutlineItem?, afterItem: SKHOutlineItem?, beforeItem: SKHOutlineItem?) {
            self.superitem = superitem
            self.afterItem = afterItem
            self.beforeItem = beforeItem
            super.init()
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? Self else {
                return false
            }
            if other === self {
                return true
            }
            return superitem == other.superitem && afterItem == other.afterItem && beforeItem == other.beforeItem
        }
        
        override var hash: Int {
            var hasher = Hasher()
            hasher.combine(superitem)
            hasher.combine(afterItem)
            hasher.combine(beforeItem)
            return hasher.finalize()
        }
        
        // MARK: - NSCopying
        
        func copy(with zone: NSZone? = nil) -> Any {
            let copy = SKHOutlineItem.LocationInfo.init(superitem: self.superitem, afterItem: self.afterItem, beforeItem: self.beforeItem)
            return copy
        }
        
        // MARK: - UNAVAILABLE
        
        @available(*, unavailable)
        override init() {
            fatalError("init() has not been implemented")
        }
    }
}

```

</details>

## Author

sonkoni(손관현), isomorphic111@gmail.com 

## License

This project is released under the MIT License. See [LICENSE](https://github.com/sonkoni/Collection-of-Toy-Projects/blob/main/LICENSE) for more information.
