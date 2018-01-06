//
//  PwdCharLab.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class PwdCharLab: UILabel {

    private var m_noneView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.color(r: 22, g: 24, b: 27)
        view.layer.shadowColor = UIColor.green.cgColor
        view.layer.shadowOffset = CGSize(width:0, height:1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    override var text: String? {
        
        didSet {
            
            m_noneView.isHidden = ((text?.lengthOfBytes(using: .utf8)) != nil &&
                                    text?.lengthOfBytes(using: .utf8)  != 0 )
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.size.height / 2;
        
        self.font = UIFont.boldSystemFont(ofSize: width * 1.5)
        
        m_noneView.frame = CGRect(origin:.zero,
                                  size: CGSize(width:width,height:width ))
        m_noneView.center = CGPoint(x:frame.size.width / 2, y: frame.size.height / 2)
        m_noneView.layer.cornerRadius = width / 2
        addSubview(m_noneView)
    }
    
}
