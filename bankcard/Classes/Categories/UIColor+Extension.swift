//
//  UIColor.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

extension UIColor {
    
    open class func color(RGB: UInt) -> UIColor {
        
        var rgb = RGB
        let blue = rgb & 0xff
        rgb >>= 8
        let green = rgb & 0xff
        rgb >>= 8
        let red = rgb & 0xff
        
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: 1)
    }
    
    open class func color(rgba RGBA: UInt) -> UIColor {
        
        var rgba = RGBA
        
        let alpha = rgba & 0xff;
        rgba >>= 8
        let blue = rgba & 0xff
        rgba >>= 8
        let green = rgba & 0xff
        rgba >>= 8
        let red = rgba & 0xff
        
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: CGFloat(alpha) / 255.0)
    }
    
    open class func color(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        
        return UIColor(red: r / 255.0,
                       green: g / 255.0,
                       blue: b / 255.0,
                       alpha: 1)
    }
    
    open class func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        
        return UIColor(red: r / 255.0,
                       green: g / 255.0,
                       blue: b / 255.0,
                       alpha: a / 255.0)
    }
}
