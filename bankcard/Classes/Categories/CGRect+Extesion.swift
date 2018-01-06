//
//  CGRect+Extesion.swift
//  bankcard
//
//  Created by xun on 17/12/24.
//  Copyright © 2017年 xun. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    func center() -> CGPoint {
        
        return CGPoint(x:maxX / 2, y:maxY / 2)
    }
}
