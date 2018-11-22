//
//  AlwisalUtility.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class AlwisalUtility: NSObject {
    class func getJSONfrom(dictionary:[String:Any?]) -> String {
        var jsonString:String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
        guard let requestBody = jsonString else {
            return ""
        }
        return requestBody
    }
    
    class func showDefaultAlertwith(_title : String, _message : String, parentController : UIViewController){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:Constant.Messages.okString, style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
    
    class func showDefaultAlertwithCompletionHandler(_title : String, _message : String, parentController : UIViewController, completion:@escaping (_ okSuccess:Bool)->()){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constant.Messages.okString, style: .default, handler: { action in
            completion(true)
            switch action.style{
                
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        parentController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithOkOrCancel(_title : String, viewController:UIViewController, messageString:String, completion:@escaping (_ result:Bool) -> Void) {
        let alertController = UIAlertController(title: _title, message: messageString, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: Constant.Messages.okString, style: .default) { (action:UIAlertAction) in
            completion (true)
        }
        let noAction = UIAlertAction(title: Constant.Messages.cancelString, style: .default)  { (action:UIAlertAction) in
            completion (false)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        viewController.present(alertController, animated: true) {
        }
    }
    
    func convertDateInMillisecondsToString(dateInMilliseconds:CLongLong)->String{
        let date = NSDate(timeIntervalSince1970: TimeInterval(dateInMilliseconds))
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        print(formatter.string(from: date as Date))
        return formatter.string(from: date as Date)

    }
    
    func convertDateToString(dateString:String)->String{
        //2018-06-24 16:03:47
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: dateString)
        inputFormatter.dateFormat = "hh:mm aa"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    func convertDateWithTToString(dateString:String)->String{
        //2018-01-14T17:27:53
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let showDate = inputFormatter.date(from: dateString)
        inputFormatter.dateFormat = "MMM dd hh:mm aa"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
}
