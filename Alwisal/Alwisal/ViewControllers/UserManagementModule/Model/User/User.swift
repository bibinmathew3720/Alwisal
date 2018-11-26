//
//  User.swift
//  Fetch
//
//  Created by Bibin Mathew on 6/27/18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject {
    
    static func saveUserData(userProfile:AlwisalUpdateProfile){
        var loginUser:User?
        if let user = User.getUser() {
            loginUser = user
        } else {
            loginUser = CoreDataHandler.sharedInstance.newEntityForName(entityName: "User") as? User
        }
        loginUser?.name = userProfile.first_name
        loginUser?.phoneNumber = userProfile.phone_number
        loginUser?.address = userProfile.address
        loginUser?.email = userProfile.email
        CoreDataHandler.sharedInstance.saveContext()
    }

    class func getUser() -> User? {
        let detailsArrayPost:NSArray = CoreDataHandler.sharedInstance.getAllDatas(entity: "User") as NSArray
        if (detailsArrayPost.count != 0) {
            return detailsArrayPost.object(at: 0) as? User
        }
        return nil
    }

    class func deleteUser() {
        CoreDataHandler.sharedInstance.deleteAllData(name: "User")
        CoreDataHandler.sharedInstance.saveContext()
    }
}
