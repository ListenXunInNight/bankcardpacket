//
//  AppInit.swift
//  bankcard
//
//  Created by xun on 2017/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

let ThumbnailExtension = "thumbnail"

class AppInit {
    
    class func CreateSkinDirectory() -> Bool {
        
        if (FileManager.default.fileExists(atPath: FileManager.SkinDirectory) == false) {
            
            do {
                try FileManager.default.createDirectory(atPath: FileManager.SkinDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                return false
            }
        }

        return true
    }
    
    public class func GenerateSkinThumbnail() {
    
        let file = Bundle.main.path(forResource: "color", ofType: "ini")
        
        do {
            let string = try String(contentsOfFile: file!)
            
            let arr = string.components(separatedBy: "\n")
            
            let fm = FileManager.default
            
            for str in arr {
                
                if str.hasPrefix("#") {
                    
                    for color in str.components(separatedBy: ";") {
                        
                        let path = FileManager.SkinDirectory + "/" + color + "." + ThumbnailExtension
                        
                        if !fm.fileExists(atPath: path) {
                            
                            createSkinThumbnail(name: color, path: path)
                        }
                    }
                }
            }
        }
        catch {}
    }
    
    private class func createSkinThumbnail(name: String, path: String) {
        
        let rgb = name.replacingOccurrences(of: "#", with: "0x").hexStringToUInt32()
        
        let image = UIImage.skinThumbnail(color: UIColor.color(RGB: UInt(rgb)))
        
        let data = UIImagePNGRepresentation(image)
        
        do {
            try data?.write(to: URL(fileURLWithPath: path))
        }
        catch {
            print(error)
        }
    }
}

extension UIImage {
    
    class func skinThumbnail(color: UIColor) -> UIImage {
        
        let size = CGSize(width:50,height:50)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.addArc(center: CGPoint(x:25, y:25), radius: 24, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        ctx?.setStrokeColor(UIColor.white.cgColor)
        ctx?.setLineWidth(2)
        ctx?.setFillColor(color.cgColor)
        ctx?.drawPath(using: .fillStroke)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
