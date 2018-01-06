//
//  BankCardVC.swift
//  bankcard
//
//  Created by xun on 17/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit

class BankCardVC: UITableViewController, UITextFieldDelegate {

    var bankcard: BankCardModel? = nil {
        willSet {
            tempCard = newValue?.duplicate()
            update(card: tempCard)
        }
    }
    
    var tempCard: BankCardModel? = nil
    
    lazy var saveBBI: UIBarButtonItem = {
        return UIBarButtonItem(title: localize("Save"), style: .plain, target: self, action: #selector(save))
    }()
    
    lazy var cancelBBI: UIBarButtonItem = {
        return UIBarButtonItem(title: localize("Cancel"), style: .plain, target: self, action: #selector(cancelEdit))
    }()
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var pwdTF: UITextField!
    
    @IBOutlet weak var skinLab: UILabel!
    @IBOutlet weak var skinImageView: UIImageView!
    @IBOutlet weak var signTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.navigationItem.title = localize("BankCard")
        skinImageView.layer.cornerRadius = 20
        skinImageView.layer.borderColor = UIColor.white.cgColor
        skinImageView.layer.borderWidth = 2
        
        self.tableView.keyboardDismissMode = .onDrag
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.update(card: tempCard)
        
        if tempCard! != bankcard! {
            
            beginEdit()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func update(card: BankCardModel?) {
        
        guard (card != nil) else {return}
        guard icon != nil else {return}
        
        var bank = card!.bank!
        if card?.bank != "中国银行" {
            bank = bank.replacingOccurrences(of: "中国", with: "")
        }
        
        icon.image = UIImage.image(letter: bank.letter(index: 0),
                                   color: UIColor.color(RGB: 0x1E2427),
                                   size: CGSize(width:80, height:80),
                                   backgroundColor: .white)
        nameLab.text = card?.bank
        typeLab.text = card?.type
        accountLab.text = card?.number
        pwdTF.text = card?.pwd
        
        skinLab.text = card?.skin
        skinImageView.image = UIImage.roundImage(size: CGSize(width:30, height:30), color: UIColor.color(RGB: UInt((card?.skin.replacingOccurrences(of: "#", with: "0x").hexStringToUInt32())!)))
        signTF.text = card?.sign
    }
    
    // MARK: - Btn Cicked
    @objc func save() {
        
        endEdit()
        bankcard?.update(card: tempCard!, save: true)
    }
    
    @objc func cancelEdit() {
        
        endEdit()
        tempCard = bankcard?.duplicate()
        self.update(card: tempCard)
    }
    
    @IBAction func clickedEditBtn(_ sender: UIButton) {
    
        if sender.superview == pwdTF.superview {
            
            pwdTF.becomeFirstResponder()
        }
        else if sender.superview == signTF.superview {
            
            signTF.becomeFirstResponder()
        }
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        
        accountLab.becomeFirstResponder()
        
        let menuController = UIMenuController.shared
        
        menuController.arrowDirection = .down
        menuController.setTargetRect(accountLab.bounds, in: accountLab)
        menuController.setMenuVisible(true, animated: true)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        tempCard?.pwd = pwdTF.text
        tempCard?.sign = signTF.text
        
        if tempCard! == bankcard! { endEdit() }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        beginEdit()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == pwdTF {
            if string.contains(" ") {return false}
        }
        return true
    }
    
    // MARK: End Eidt
    
    func beginEdit() {
        self.navigationItem.leftBarButtonItem = cancelBBI
        self.navigationItem.rightBarButtonItem = saveBBI
    }
    
    func endEdit() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination.isKind(of: SkinVC.classForCoder()) {
            
            let vc = segue.destination as! SkinVC
            
            vc.bankcard = tempCard
        }
    }
}
