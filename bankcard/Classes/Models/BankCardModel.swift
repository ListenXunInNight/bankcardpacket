//
//  BankCardModel.swift
//  bankcard
//
//  Created by xun on 17/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

enum BankOrganization: String {
    
    case visa = "VISA"
    case unionpay = "UNIONPAY"
    case jcb = "JCB"
    case diners = "DINERS"
    case mastercard = "MASTERCARD"
    case americaExpress = "AMERICA EXPRESS"
    case unknow = "UNKNOW"
}

class BankCardModel: Object {
    
    @objc dynamic var name: String? = nil
    @objc dynamic var type: String? = nil
    @objc dynamic var number: String? = nil
    @objc dynamic var skin: String = "#B4F2FB" 
    @objc dynamic var sign: String? = nil
    
    @objc dynamic var bank: String? = nil
    @objc dynamic var pwd: String? = nil
    @objc dynamic var organization: String = BankOrganization.unknow.rawValue
    var id = RealmOptional<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

/// DB Operation
extension BankCardModel {
    func save() {
        
        if self.id.value == nil {self.id = RealmOptional<Int>(Int(Date.timeIntervalSinceReferenceDate))}
        
        do {
            let realm = try! Realm()
            try realm.write {
                realm.add(self)
            }
        }
        catch {
            print(error)
        }
    }
    
    /// 更新银行卡数据
    ///
    /// - Parameters:
    ///   - card: 新数据模型
    ///   - save: 是否保存至数据库
    public func update(card: BankCardModel, save: Bool = false) {
        
        if save {
            let realm = try! Realm()
            try! realm.write {
                self.skin = card.skin
                self.pwd = card.pwd
                self.sign = card.sign
                self.organization = card.organization
            }
        }
        else {
            self.realm?.beginWrite()
            self.skin = card.skin
            self.pwd = card.pwd
            self.sign = card.sign
            self.organization = card.organization
            try! self.realm?.commitWrite()
        }
    }
    
    public func delete() {
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.delete(self)
        }
    }
}

extension BankCardModel {

    public static func ==(lhs: BankCardModel, rhs: BankCardModel) -> Bool {

        return  lhs.bank == rhs.bank &&
            lhs.name == rhs.name &&
            lhs.type == rhs.type &&
            lhs.sign == rhs.sign &&
            lhs.skin == rhs.skin &&

            lhs.pwd  == rhs.pwd &&
            lhs.number == rhs.number &&
            lhs.organization == rhs.organization
    }

    public static func !=(lhs: BankCardModel, rhs: BankCardModel) -> Bool {
        return !(lhs == rhs)
    }
}

extension BankCardModel {
    
    static let `default` = defaultCard()
    
    public func duplicate() -> BankCardModel {
        
        let card = BankCardModel()
        
        card.name = self.name
        card.type = self.type
        card.skin = self.skin
        card.pwd = self.pwd
        
        card.organization = self.organization
        card.number = self.number
        card.sign = self.sign
        card.bank = self.bank
        
        return card
    }
    
    public class func isValidNO(no: String) -> Bool {
        
        let check: Int = Int(no[no.index(before: no.endIndex) ..< no.endIndex])!
        var sum: Int = 0
        
        var flag = true
        
        for i in (0 ..< no.length() - 1).reversed() {
            
            var num = Int(no.letter(index: i))!
            
            if flag {
                num *= 2
                sum += num % 10 + num / 10
            }
            else {
                sum += num
            }
            flag = !flag
        }
        
        return check == 10 - sum % 10
    }
    
    public class func fetchBINInfo(no: String, 
                                   bankCardInfo: @escaping (_ card: BankCardModel?) -> Void) {
        
        Alamofire.request("http://www.cardcn.com/search.php", method:HTTPMethod.get, parameters: ["word":no]).response { (response) in
            
            guard response.error == nil else {
                bankCardInfo(nil)
                return
            }
            
            let text = String(data: response.data!, encoding: .utf8)!
            
            var info = [String:String]()
            
            let fields = text.components(separatedBy: "\n")

            for field in fields {
                
                if  field.contains("银行名称：") ||
                    field.contains("银行卡名：") ||
                    field.contains("银行卡种：") ||
                    field.contains("客服电话：") ||
                    field.contains("官方网址：") {
                    
                    let str =
                        field.replaceOccurrences("<[:ascii:]*>", string: "")
                        .replacingOccurrences(of: " ", with: "")
                        .replacingOccurrences(of: "\t", with: "")
                        .replacingOccurrences(of: "\r", with: "")
                        .replacingOccurrences(of: "</font>", with: "")
                        .replacingOccurrences(of: "</dt>", with: "")
                    
                    let keyValue = str.components(separatedBy: "：")

                    info[keyValue.first!] = keyValue.last!
                }
            }
            
            guard info.count != 0 else {
                bankCardInfo(nil)
                return
            }
            
            let card = BankCardModel()
            
            card.bank = info["银行名称"]
            card.name = info["银行卡名"]
            card.type = info["银行卡种"]
            card.number = no
            card.skin = "#F2DFB0"
            
            if  no.hasPrefix("62") ||
                no.hasPrefix("9") ||
                no.hasPrefix("60") {
                card.organization = BankOrganization.unionpay.rawValue
            }
            else if no.hasPrefix("35") {
                card.organization = BankOrganization.jcb.rawValue
            }
            else if no.hasPrefix("36") {
                card.organization = BankOrganization.diners.rawValue
            }
            else if no.hasPrefix("37") {
                card.organization = BankOrganization.americaExpress.rawValue
            }
            else if no.hasPrefix("4") {
                card.organization = BankOrganization.visa.rawValue
            }
            else if no.hasPrefix("5") {
                card.organization = BankOrganization.mastercard.rawValue
            }
            
            bankCardInfo(card)
        }
    }
    
    // MARK: private func
    private class func defaultCard() -> BankCardModel {
        
        let card = BankCardModel()
        
        card.name = "建设银行"
        card.type = "信用卡"
        card.skin = "#26B68E"
        card.sign = "张大彪"
        card.pwd = "342310"
        
        card.number = "6227 4536 7897 123"
        
        return card
    }
}

extension String {
    
    func replaceOccurrences(_ regularExpress:String, string withString: String) -> String {
        
        let regular = try! NSRegularExpression(pattern: regularExpress, options: .caseInsensitive)
        
        let arr = regular.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.length()))
        
        var str = self
        
        for result in arr {
            
            let substr = str.substring(from: result.range.location, length: result.range.length)
            
            str = str.replacingOccurrences(of: substr, with: "")
        }
        
        return str
    }
}
