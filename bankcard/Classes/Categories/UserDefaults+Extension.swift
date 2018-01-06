//
//  NSUserDefaults.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    open static var Password: String? {
    
        get {
            return standard.value(forKey: "PASSWORD") as? String
        }
        set {
            
            standard.setValue(newValue!, forKey: "PASSWORD")
            standard.synchronize()
        }
    }
}
