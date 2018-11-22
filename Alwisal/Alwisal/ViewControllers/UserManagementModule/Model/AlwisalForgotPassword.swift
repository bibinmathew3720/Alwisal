//
//  AlwisalForgotPassword.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/15/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class AlwisalForgotPassword: NSObject {
    var email : String  = ""
    func getRequestBody()->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(email, forKey: "email_id")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
}

class AlwisalForgotResponseModel : NSObject{
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

