//
//  AlwisalLogIN.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/13/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
public enum LoginType {
    case Email
    case Facebook
    case Google
    case Twitter
}
class AlwisalLogIN: NSObject {
    var userName : String  = ""
    var password : String = ""
    func getRequestBody()->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(userName, forKey: "user_login")
        dict.updateValue(password, forKey: "user_password")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    func getSocialLoginRequestBody(dict: [String: String])->String{
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
}
