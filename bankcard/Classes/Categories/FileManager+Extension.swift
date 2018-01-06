//
//  NSFileManager+Extension.swift
//  bankcard
//
//  Created by xun on 2017/12/22.
//  Copyright © 2017年 xun. All rights reserved.
//

import Foundation

extension FileManager {
    
    static private let DocumentDirectory: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    static public let SkinDirectory = DocumentDirectory + "/skin"
    
    static public let DBPath = DocumentDirectory + "/bankcard.database"
}
