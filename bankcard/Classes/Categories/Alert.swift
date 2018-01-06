//
//  Alert.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class Alert {
    
    public class func alert(title: String,
                            message:String) -> UIAlertController {
        
        return alert(title: title, message: message, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
    }
    
    public class func alert(title: String,
                            message: String,
                            actions: [UIAlertAction]) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            
            alertController.addAction(action)
        }
        
        return alertController
    }
    
    public class func show(alert:UIAlertController, onVC vc: UIViewController) {
        
        DispatchQueue.main.async {
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
