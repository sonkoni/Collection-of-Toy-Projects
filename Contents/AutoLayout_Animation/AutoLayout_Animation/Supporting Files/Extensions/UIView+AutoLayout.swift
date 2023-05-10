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
        assert(self.superview != nil, "Superview 는 nil 이어서는 안된다.")
        self.translatesAutoresizingMaskIntoConstraints = false
        let c1 = self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor)
        let c2 = self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor)
        let c3 = self.topAnchor.constraint(equalTo: self.superview!.topAnchor)
        let c4 = self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor)
        c1.isActive = true
        c2.isActive = true
        c3.isActive = true
        c4.isActive = true
        return [c1, c2, c3, c4]
    }
}
