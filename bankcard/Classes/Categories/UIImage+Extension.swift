//
//  UIImage+Extension.swift
//  bankcard
//
//  Created by xun on 2017/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit
import CoreGraphics

enum IconStyle {
    
    case min
    case large
}


extension UIImage {
    
    public class func roundCornerImage(size: CGSize,
                                       color: UIColor,
                                       radius: CGFloat) -> UIImage {
    
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        let bezier = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                                  cornerRadius: radius)
        bezier.addClip()
        color.setFill()
        ctx?.fill(CGRect(origin: .zero, size: size))
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public class func image(letter: String,
                            color: UIColor,
                            size: CGSize,
                            backgroundColor: UIColor) -> UIImage {
        
        let radius = size.width / 2
        
        let attributed = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: size.width * 0.66), NSAttributedStringKey.foregroundColor: color]
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        let bezier = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                                  cornerRadius: radius)
        bezier.addClip()
        backgroundColor.setFill()
        ctx?.fill(CGRect(origin: .zero, size: size))
        
        letter.draw(at:CGPoint(x:radius * 0.33, y:radius * 0.33),withAttributes: attributed)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public class func roundImage(size: CGSize, color: UIColor) -> UIImage {
        
        return UIImage.roundCornerImage(size: size, color: color, radius: size.width / 2)
    }
    
    public func saveSkin(name: String) {
        
        let data = UIImagePNGRepresentation(self)
        
        do {
            try data?.write(to: URL(fileURLWithPath: FileManager.SkinDirectory + "/\(name)"))
        }
        catch {
        }
    }
    
    public class func skin(name: String) -> UIImage {
        
        let finalName = name.replacingOccurrences(of: "#", with: "")
        let path = FileManager.SkinDirectory + "/" + finalName
        
        if FileManager.default.fileExists(atPath: path) == false {
            
            let width = UIScreen.main.bounds.size.width
            
            let hex: UInt32 = ("0x" + finalName).hexStringToUInt32()
            
            let image = UIImage.roundCornerImage(size: CGSize(width: width, height: 80), color: UIColor.color(RGB:UInt(hex)), radius: 5)
            
            image.saveSkin(name: finalName)
            
            return image
        }
        else {
            
            return UIImage(named: path)!
        }
    }
    
    public class func skinThumbnail(name: String) -> UIImage {
        
        let path = FileManager.SkinDirectory + "/" + name + "." + ThumbnailExtension
        
        return UIImage(named: path)!
    }
    
    public class func defaultSkin() -> UIImage {
        
        return UIImage.skin(name: "#91B7BD")
    }
}
