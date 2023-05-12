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
}
