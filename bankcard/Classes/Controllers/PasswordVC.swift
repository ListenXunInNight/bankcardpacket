//
//  PasswordVC.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit
import LocalAuthentication
import CryptoSwift

var NumberBtnBaseTag: Int = 1
var NumberLabBaseTag: Int = 101

class PasswordVC: UIViewController {
    
    enum Operation {
        
        case set
        case enter
        case modify
        case unknow
    }
    
    @IBOutlet weak var infoLab: UILabel!
    
    var charIndex: Int = -1
    var operation: Operation = .unknow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.Password == nil) {
            operation = .set
        }
        else if operation != .modify {
            operation = .enter
            useTouchID()
        }
        
        setNavigationItemTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    // MARK: Clicked Btn
    @IBAction func clickedNumberBtn(_ sender: UIButton) {
        
        guard charIndex < 5 else { return }
        
        charIndex += 1
        let lab = getLab(tag: NumberLabBaseTag + charIndex)
        lab.text = sender.titleLabel?.text
        
        guard charIndex == 5 else {return}
        
        var pwd = ""
        for i in 0...5 {
            pwd += getLab(tag: i + NumberLabBaseTag).text!
        }
        
        switch operation {
        case .set:
            setEnterPwd(pwd: pwd)
            break
        case .enter:
            if UserDefaults.Password == pwd.md5() {
                enter()
            } else {
                showPwdError()
            }
            break
        case .modify:
            setEnterPwd(pwd: pwd)
            break
        default: break
            
        }
        
    }
    
    @IBAction func clickedDeleteBtn(_ sender: UIButton) {
        
        guard charIndex >= 0 else {return}
        
        let lab = getLab(tag: NumberLabBaseTag + charIndex)
        lab.text = ""
        
        charIndex -= 1
    }
    

    func getLab(tag: Int) -> PwdCharLab {
        
        return view.viewWithTag(tag) as! PwdCharLab
    }
    
    func setEnterPwd(pwd: String) {
        
        weak var weakself = self
        
        let alert = Alert.alert(title: NSLocalizedString("Prompt", comment:""), message: localize("ConfirmOfSetPWD") + "\r\n\(pwd)", actions: [UIAlertAction(title: localize("Cancel"), style: .default, handler: nil), UIAlertAction(title: localize("Confirm"), style: .destructive, handler: { (action) in
            
            UserDefaults.Password = pwd.md5()
            
            weakself?.enter()
        })])
        
        Alert.show(alert: alert, onVC: self.navigationController!)
    }
    
    func showPwdError() {
        
        weak var weakself = self
        let alert = Alert.alert(title: localize("Prompt"), message: localize("WrongPWD"), actions: [UIAlertAction(title: "OK", style: .default, handler: { (a) in
            
            weakself?.clear()
        })])
        
        Alert.show(alert: alert, onVC: self.navigationController!)
    }
    
    func enter() {
        
        if operation == .modify {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            
            let nav = self.navigationController as! NavigationController
            
            if nav.cache.count == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BankCardListVC")
                
                self.navigationController?.setViewControllers([vc!], animated: true)
            }
            else {
                self.navigationController?.setViewControllers(nav.cache, animated: true)
            }
        }
    }
    
    func clear() {
        
        for i in 0...5 {
            
            getLab(tag: NumberLabBaseTag + i).text = ""
        }
        
        charIndex = -1
    }
    
    func setNavigationItemTitle() {
        
        if operation == .enter {
            self.navigationItem.title = NSLocalizedString("InputPWD", comment: "")
            self.infoLab.text = NSLocalizedString("InputPWDInfo", comment: "")
        }
        else {
            self.navigationItem.title = NSLocalizedString("SetPWD", comment: "")
            self.infoLab.text = NSLocalizedString("SetPWDInfo", comment: "")
        }
    }
    
    // MAKR: Private Method
    
    func useTouchID() {
        
        let ctx = LAContext()
        var error: NSError?
        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localize("UseTouchID"), reply: { (success, err) in
                
                if (success) {
                    
                    DispatchQueue.main.async {
                        self.enter()
                    }
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// UIStoryboard
extension PasswordVC {
    
    open class func passwordVC() -> PasswordVC {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "PassowrdVC") as! PasswordVC
        
        return vc
    }
}
