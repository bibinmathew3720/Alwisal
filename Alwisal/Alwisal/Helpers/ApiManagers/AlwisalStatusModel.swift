//
//  AlwisalStatusModel.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/13/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class AlwisalStatusModel: NSObject {
    var statusCode:Int = 000
    var statusMessage:String = ""
    init(dict:[String:Any?]){
        if let  value = dict["statusCode"] as? Int{
            statusCode = value
        }
        if let  value = dict["statusMessage"] as? String{
            statusMessage = value
        }
    }
}
