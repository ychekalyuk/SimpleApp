//
//  UIColor+Extension.swift
//  SimpleApp
//
//  Created by Юрий Альт on 21.06.2023.
//

import UIKit.UIColor

extension UIColor {
    enum SimpleApp {
        enum Main {
            static let background = UIColor.gray
            static let tableViewBackground = UIColor.gray
            static let tableViewCellBackground = UIColor.lightGray
        }
        
        enum Details {
            static let background = UIColor.gray
            static let artistNameLabelText = UIColor.cyan
            static let trackNameLabelText = UIColor.yellow
        }
    }
}
