//
//  BankCardListVC.swift
//  bankcard
//
//  Created by xun on 2017/12/21.
//  Copyright © 2017年 xun. All rights reserved.
//

import UIKit
import RealmSwift

class BankCardListVC: UITableViewController, UITextFieldDelegate {
    
    lazy var addBBI: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(clickedAddBBI))
    }()
    
    lazy var noCardImageView: UIImageView = {
        
        let image = UIImage(named: "noCard")!
        let imageView = UIImageView(image:image)
        imageView.frame.size = image.size
        return imageView
    }()
    
    var cards = [BankCardModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = localize("Bankcards")
        self.navigationItem.rightBarButtonItem = self.addBBI
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        self.tableView.contentOffset = CGPoint(x:0, y:-8);
        
        self.tableView.addSubview(self.noCardImageView)
    
        self.noCardImageView.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                              y:UIScreen.main.bounds.height / 2 - 64)
        
        if cards.count == 0 {
            let realm = try! Realm()

            cards.append(contentsOf: realm.objects(BankCardModel.self))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func clickedAddBBI() {
        
        weak var weakself = self
        let alert = Alert.alert(title: localize("Prompt"), message: localize("InputBankCardNO"), actions: [
            UIAlertAction(title: localize("Cancel"), style: .default, handler: nil)])
        
        weak var weakalert = alert
        let confirmAction = UIAlertAction(title: localize("Confirm"), style: .destructive, handler: { (action) in
            
            let no = weakalert?.textFields?[0].text
            
            guard no != nil else {return}
            guard BankCardModel.isValidNO(no: no!) else {
                weakself?.banknoError(no: no!)
                return
            }
            
            for card in self.cards {
                if card.number == no {
                    weakself?.banknoExist(no: no!)
                    return
                }
            }
            
            weakself?.fetchBankcardInfo(no: no!)
        })

        alert.addAction(confirmAction)
        
        alert.addTextField { (tf) in
            
            tf.keyboardType = .phonePad
            tf.placeholder = localize("InputBankCardNO")
            tf.delegate = weakself
            tf.clearButtonMode = .whileEditing
        }
        
        DispatchQueue.main.async {

            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
    
        if cards.count == 0 {
            self.noCardImageView.isHidden = false
        }
        else {
            self.noCardImageView.isHidden = true
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCardCell", for: indexPath) as! BankCardCell
        
        cell.update(card: self.cards[indexPath.row])
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// 适配iOS 8
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .destructive, title: "remove", handler: { (action, index) in
            
            self.removeCellWith(indexPath: indexPath)
            tableView.isEditing = false
        })
        deleteAction.backgroundColor = tableView.backgroundColor

        let copyAction = UITableViewRowAction(style: .destructive, title: "copy", handler: { (action, index) in
            UIPasteboard.general.string = self.cards[indexPath.row].number
            tableView.isEditing = false
        })
        copyAction.backgroundColor = tableView.backgroundColor

        return [deleteAction, copyAction]
    }
    
    // MARK: - iOS 11
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .normal, title: nil) { (action, sourceview, completionHandler) in
            
            self.removeCellWith(indexPath: indexPath)
            completionHandler(true)
        }
        removeAction.backgroundColor = tableView.backgroundColor
        removeAction.image = UIImage(named: "remove")
        
        let copyAction = UIContextualAction(style: .normal, title: nil) { (action, sourceview, completionHandler) in
            
            UIPasteboard.general.string = self.cards[indexPath.row].number
            completionHandler(true)
        }
        copyAction.backgroundColor = tableView.backgroundColor
        copyAction.image = UIImage(named: "copy")
        
        return UISwipeActionsConfiguration(actions: [removeAction, copyAction])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = self.tableView.indexPath(for: sender as! UITableViewCell)!
        let vc: BankCardVC = segue.destination as! BankCardVC
        vc.bankcard = self.cards[index.row]
    }
    
    // MARK: Private Method
    private func fetchBankcardInfo(no: String) {
        
        ActivityIndicator.showForView(view: self.view)
        BankCardModel.fetchBINInfo(no: no) { (card) in
            
            ActivityIndicator.hideForView(view: self.view)
            
            guard card != nil else {
                let alert = Alert.alert(title: localize("Prompt"), message: localize("Can't Query Card Info"))
                
                Alert.show(alert: alert, onVC: self)
                return
            }
            
            self.cards.append(card!)
            self.tableView.reloadData()
            card?.save()
        }
    }
    
    private func banknoError(no: String) {
        
        let alert = Alert.alert(title: localize("Prompt"), message: no + localize("InvalidCardNO"))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func banknoExist(no: String) {
        
        let alert = Alert.alert(title: localize("Prompt"), message: no + "\n" + localize("ExistCardNO"))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func removeCellWith(indexPath: IndexPath) {
        
        self.cards[indexPath.row].delete()
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .left)
        self.cards.remove(at: indexPath.row)
        self.tableView.endUpdates()
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let regular = "^[0-9]{0,}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regular)
        
        return predicate.evaluate(with: string)
    }
}

extension BankCardCell {
    
    func update(card: BankCardModel) {
        
        self.bankcard = card
        
        self.bankNameLab.text = card.bank
        self.typeLab.text = card.type! + "（" + card.name! + "）"
        self.numberLab.text = self.codeNumber(card.number!)
        self.unionIcon.image = self.image(organization: card.organization)
        self.backgroundImageView.image = UIImage.skin(name: card.skin)
        
        var bank = card.bank!
        if bank != "中国银行" {
            bank = bank.replacingOccurrences(of: "中国", with: "")
        }
        
        self.logo.image = self.letterIcon(letter: bank.letter(index: 0))
    }
    
    func codeNumber(_ number: String) -> String {
        
        let arr = number.components(separatedBy: " ")
        
        var string = ""
        
        for _ in 0..<arr.count - 1 {
            
            string += "**** "
        }
        string += arr.last!
        
        return string
    }
    
    func image(organization: String ) -> UIImage? {
        
        let organization = BankOrganization(rawValue: organization)!
        
        switch organization {
        case .visa:
            return UIImage(named: "visa")
        case .jcb:
            return UIImage(named: "jcb")
        case .diners:
            return UIImage(named: "Diners Club")
        case .mastercard:
            return UIImage(named: "mastercard")
        case .unionpay:
            return UIImage(named: "bankunion")
        case .americaExpress:
            return UIImage(named: "American Express")
        default:
            return nil
        }
    }
    
    func letterIcon(letter: String) -> UIImage {
        
        return UIImage.image(letter: letter,
                      color:UIColor.color(RGB: 0x1E2427),
                      size: CGSize(width:30, height:30),
                      backgroundColor: .white)
    }
}
