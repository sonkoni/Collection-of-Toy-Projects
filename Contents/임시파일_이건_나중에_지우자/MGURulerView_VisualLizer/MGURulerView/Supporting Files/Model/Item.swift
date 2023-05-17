//
//  Item.swift
//  MGUNeoSegControl
//
//  Created by Kwan Hyun Son on 2022/10/10.
//

import Foundation
final class Item {
    
    // MARK: - Property
    let title: String
    let detailText: String?
    fileprivate let identifier = UUID()
    
    
    // MARK: - 생성 & 소멸
    init(title: String, detailText: String?) {
        self.title = title
        self.detailText = detailText
    }
}

extension Item: Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Item: Sendable { }
