//
//  UIView+Extensions.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 02/09/22.
//

import UIKit

extension UIView {
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
