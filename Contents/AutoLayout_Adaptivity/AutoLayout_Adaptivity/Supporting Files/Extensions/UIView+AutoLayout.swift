//
//  UIView+AutoLayout.swift
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-13
//  ----------------------------------------------------------------------
//


import UIKit

public extension UIView {
    @discardableResult
    func mgrPinEdgesToSuperviewEdges()  -> [NSLayoutConstraint] {
        assert(superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = leadingAnchor.constraint(equalTo: superview!.leadingAnchor)
        let c2 = trailingAnchor.constraint(equalTo: superview!.trailingAnchor)
        let c3 = topAnchor.constraint(equalTo: superview!.topAnchor)
        let c4 = bottomAnchor.constraint(equalTo: superview!.bottomAnchor)
        c1.isActive = true
        c2.isActive = true
        c3.isActive = true
        c4.isActive = true
        return [c1, c2, c3, c4]
    }
    
    @discardableResult
    func mgrPinEdgesToSuperviewLayoutMarginsGuide()  -> [NSLayoutConstraint] {
        assert(superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = leadingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.leadingAnchor)
        let c2 = trailingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.trailingAnchor)
        let c3 = topAnchor.constraint(equalTo: superview!.layoutMarginsGuide.topAnchor)
        let c4 = bottomAnchor.constraint(equalTo: superview!.layoutMarginsGuide.bottomAnchor)
        c1.isActive = true
        c2.isActive = true
        c3.isActive = true
        c4.isActive = true
        return [c1, c2, c3, c4]
    }
    
    @discardableResult
    func mgrPinEdgesToSuperviewSafeAreaLayoutGuide()  -> [NSLayoutConstraint] {
        assert(superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor)
        let c2 = trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor)
        let c3 = topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor)
        let c4 = bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor)
        c1.isActive = true
        c2.isActive = true
        c3.isActive = true
        c4.isActive = true
        return [c1, c2, c3, c4]
    }
    
    @discardableResult
    func mgrPinEdgesToSuperviewCustomMargins(_ customMargins: UIEdgeInsets)  -> [NSLayoutConstraint] {  // 5,5,5,5 이면 안쪽으로 5만큼 파고든다.
        assert(superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = topAnchor.constraint(equalTo: superview!.topAnchor, constant: customMargins.top)
        let c2 = leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: customMargins.left)
        let c3 = superview!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: customMargins.right)
        let c4 = superview!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: customMargins.bottom)
        c1.isActive = true
        c2.isActive = true
        c3.isActive = true
        c4.isActive = true
        return [c1, c2, c3, c4]
    }
    
    @discardableResult
    func mgrPinHorizontalEdgesToSuperviewEdges()  -> [NSLayoutConstraint] { // leading, trailing만 super view에 맞춘다.
        assert(superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = leadingAnchor.constraint(equalTo: superview!.leadingAnchor)
        let c2 = trailingAnchor.constraint(equalTo: superview!.trailingAnchor)
        c1.isActive = true
        c2.isActive = true
        return [c1, c2]
    }
    
    @discardableResult
    func mgrPinVerticalEdgesToSuperviewEdges()  -> [NSLayoutConstraint] { // top, bottom만 super view에 맞춘다.
        assert(superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = topAnchor.constraint(equalTo: superview!.topAnchor)
        let c2 = bottomAnchor.constraint(equalTo: superview!.bottomAnchor)
        c1.isActive = true
        c2.isActive = true
        return [c1, c2]
    }
}
