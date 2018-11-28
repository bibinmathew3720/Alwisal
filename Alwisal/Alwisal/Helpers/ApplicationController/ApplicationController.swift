//
//  ApplicationController.swift
//  Fetch
//
//  Created by Bibin Mathew on 6/26/18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit


class ApplicationController: NSObject {
    static let applicationController = ApplicationController()
    var loginType:LoginType = .Manual
    static var deviceToken:String?
    static var isGuestLoggedIn:Bool = false
    var isLogin:Bool = false
    private override init() {
        super.init()
    }
}
