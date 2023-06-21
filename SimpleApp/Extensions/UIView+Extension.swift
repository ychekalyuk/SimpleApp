//
//  UIView+Extension.swift
//  SimpleApp
//
//  Created by Юрий Альт on 21.06.2023.
//

import UIKit.UIView

extension UIView {
    private func addAutolayoutSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    func addAutolayoutSubviews(_ views: UIView...) {
        views.forEach { addAutolayoutSubview($0) }
    }
}
