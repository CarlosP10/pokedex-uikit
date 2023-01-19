//
//  Extensions.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/18/23.
//

import UIKit

extension UIView {
    /// Add multiple Views
    /// - Parameter views: Collections of views
    func addSubviews(_ views: UIView...) {
        views.forEach({
            self.addSubview($0)
        })
    }
}
