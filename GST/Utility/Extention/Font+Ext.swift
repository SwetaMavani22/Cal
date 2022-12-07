//
//  Font+Ext.swift
//  mExpense
//
//  Created by user1 on 26/10/21.
//

import Foundation
import UIKit

public enum Montserrat: String {
    case Bold
    case Medium
    case Regular
    case SemiBold
}

public extension UIFont {
    
    class func MontserratFont(size: CGFloat, weight: Montserrat) -> UIFont {
        if let font = UIFont(name: "Montserrat-\(weight)", size: size) {
            return font
        }
        else{
            fatalError("Font not found Montserrat-\(weight)")
        }
    }
}

