//
//  ViewController.swift
//  UICollectionView Squared
//
//  Created by Richard Witherspoon on 12/25/18.
//  Copyright © 2018 Richard Witherspoon. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    // https://material-ui.com/style/color/
    //600s
    static let cyan            = UIColor(hex: 0x00ACC1)
 
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

