//
//  AlwisalRegister.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/13/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class AlwisalRegister: NSObject {
    var emailid: String = ""
    var phone:String = ""
    var username = ""
    var password:String = ""
    
    func getRequestBody()->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(username, forKey: "user_login")
        dict.updateValue(emailid, forKey: "user_email")
        dict.updateValue(password, forKey: "user_password")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
}

class AlwisalRegisterResponseModel : NSObject{
    var statusMessage:String = ""
    var errorMessage:String = ""
    var errorCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["data"] as? String{
            statusMessage = value
        }
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
       
    }
}

class AlwisalLogInResponseModel : NSObject{
    var errorMessage:String = ""
    var errorCode:Int = 0
    var userToken:String = ""
    init(dict:[String:Any?]) {
      
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let value = dict["Usertoken"] as? String{
            userToken = value
        }
    }
}
