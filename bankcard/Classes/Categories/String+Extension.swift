//
//  String+Extension.swift
//  bankcard
//
//  Created by xun on 17/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import Foundation

extension String {
    
    public func hexStringToUInt32() -> UInt32 {
        
        let scanner = Scanner(string: self)
        
        var uint32: UInt32 = 0
        
        scanner.scanHexInt32(&uint32)
        
        return uint32
    }
}

enum SubstringError: Error {
    
    case outbounds
}

extension String {
    
    /// get a letter with index
    public func letter(index: Int) -> String {
        
        return substring(from: index, length: 1)
    }
    
    /// get sunstring with beginIndex & length
    public func substring(from: Int, length:Int) -> String {
        
        var f = self.startIndex
        
        for _ in 0 ..< from {
            
            if f == self.endIndex {
                
                return ""
            }
            
            f = self.index(after: f)
        }
        
        var t = f
        
        for _ in from ..< length + from {
            
            if t == self.endIndex {
                return ""
            }
            
            t = self.index(after: t)
        }
        
        return self.substring(with: Range(uncheckedBounds: (lower: f, upper: t)))
    }
    
    /// string length
    public func length() -> Int {
        
        return self.distance(from: startIndex, to: endIndex)
    }
}

