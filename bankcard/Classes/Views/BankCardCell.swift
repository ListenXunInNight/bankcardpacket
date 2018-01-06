//
//  BankCardCell.swift
//  bankcard
//
//  Created by xun on 2017/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class BankCardCell: UITableViewCell {
    
    open var bankcard: BankCardModel? = nil
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var bankNameLab: UILabel!
    @IBOutlet weak var numberLab: UILabel!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var unionIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if subview.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
            
            for btn in subview.subviews as! [UIButton] {
                
                btn.setImage(UIImage(named: (btn.titleLabel?.text)!), for: .normal)
                btn.setTitle("", for: .normal)
            }
        }
    }
}
