//
//  CopyLab.swift
//  bankcard
//
//  Created by xun on 17/12/24.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class CopyLab: UILabel {

    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        return action == #selector(copy(_:))
    }
    
    open override func copy(_ sender: Any?) {
        
        UIPasteboard.general.string = self.text
    }

}
