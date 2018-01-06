//
//  NavigationController.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    /// App entrn background use cache storage viewscontrollers
    var cache = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    @objc func appEnterBackground() {
        
        let last = self.viewControllers.last
        
        guard !(last?.isKind(of: PasswordVC.self))! else {
            return
        }
        cache.removeAll()
        cache.append(contentsOf: self.viewControllers)
        
        let pwdvc = PasswordVC.passwordVC()
        pwdvc.operation = .enter
        
        self.setViewControllers([pwdvc], animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

