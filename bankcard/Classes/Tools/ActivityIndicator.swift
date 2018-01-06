//
//  ActivityIndicator.swift
//  bankcard
//
//  Created by xun on 2017/12/28.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class ActivityIndicator  {
    
    class IndicatorBackgroundView: UIView {
        
    }
    
    open class func showForView(view: UIView) {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        indicator.frame = CGRect(origin:.zero, size:CGSize(width: 100, height:100))
        indicator.center = view.frame.center()
        indicator.backgroundColor = UIColor(white: 0, alpha: 0.7)
        indicator.layer.cornerRadius = 5
        
        let bgView = IndicatorBackgroundView(frame: view.frame)
        
        if Thread.current.isMainThread {
            
            view.addSubview(bgView)
            view.addSubview(indicator)
        }
        else {
            DispatchQueue.main.async {
                view.addSubview(bgView)
                view.addSubview(indicator)
            }
        }
        
        indicator.startAnimating()
    }
    
    open class func hideForView(view: UIView) {
        
        for subview in view.subviews.reversed() {
            
            if subview.isKind(of: IndicatorBackgroundView.self){
                subview.removeFromSuperview()
            }
            else if subview.isKind(of: UIActivityIndicatorView.self) {
                
                (subview as! UIActivityIndicatorView).stopAnimating()
                subview .removeFromSuperview()
            }
        }
    }
}
