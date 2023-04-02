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

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach({
            self.addArrangedSubview($0)
        })
    }
}

// MARK: - UIButton Extension
extension UIButton {
    // Brilla
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
}
