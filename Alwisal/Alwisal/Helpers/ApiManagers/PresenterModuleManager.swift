//
//  PresenterModuleManager.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/17/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class PresenterModuleManager: CLBaseService {
    func callingPresentersListApi(with pegeNumber:Int,noOfItem:Int, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForPresenter(pageNumber: pegeNumber, noOfItems: noOfItem), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveArrayResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict as NSArray?{
                    print(jdict)
                   // print(jsonDict)
                    success(self.getPresenterModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func callingPresenterDetailsApi(with prsenterId:Int, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForPresenterDetail(presenterId: prsenterId), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getPresenerDetailModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    
    func networkModelForPresenter(pageNumber:Int,noOfItems:Int)->CLNetworkModel{
        let ParaMeter = "per_page=\(noOfItems)&page=\(pageNumber)"
        let presenterRequestModel = CLNetworkModel.init(url: BASE_URL+GETPRESENTERS+ParaMeter, requestMethod_: "GET")
        return presenterRequestModel
    }
    
    func networkModelForPresenterDetail(presenterId:Int)->CLNetworkModel{
        let ParaMeter = "\(presenterId)"
        let presenterDetailRequestModel = CLNetworkModel.init(url: BASE_URL+GETPRESENTERDETAILS+ParaMeter, requestMethod_: "GET")
        return presenterDetailRequestModel
    }
    
    func getPresenterModel(dict:NSArray) -> Any? {
        let presenterResponseModel = PresenterResponseModel.init(presenters: dict)
        return presenterResponseModel
    }
    
    func getPresenerDetailModel(dict:[String : Any?]) -> Any? {
        let presenterDetailResponseModel = PresenterModel.init(dict: dict)
        return presenterDetailResponseModel
    }
}

class PresenterResponseModel:NSObject{
    var presenterItems = [PresenterModel]()
    init(presenters:NSArray) {
        if let _dict = presenters as? [[String:Any?]]{
            for item in _dict{
                presenterItems.append(PresenterModel.init(dict: item))
            }
        }
    }
}

class PresenterModel:NSObject{
    var id:Int = 0
    var title:String = ""
    var content:String = ""
    var imagePath:String = ""
    var songDate:String = ""
    var fbLink:String = ""
    var twitterLink:String  = ""
    var statusMessage:String = ""
    var errorMessage:String = ""
    var errorCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["id"] as? Int{
            id = value
        }
        if let value = dict["title"] as? AnyObject{
            if let titleString = value["rendered"] as? String{
               title = titleString
            }
        }
        if let value = dict["content"] as? AnyObject{
            if let contentString = value["rendered"] as? String{
               // let str = contentString.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                let string = contentString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                content = string
            }
        }
        if let value = dict["featured_image"] as? AnyObject{
            if let imageurl = value["blog_ft_thumb"] as? String{
                imagePath = imageurl
            }
        }
        if let value = dict["date"] as? String{
            songDate = value
        }
        
        if let value = dict["custom_fields"] as? AnyObject{
            if let fbUrlArray = value["facebook_link"] as? NSArray{
                fbLink = fbUrlArray[0] as! String
            }
        }
        if let value = dict["custom_fields"] as? AnyObject{
            if let twitterUrlArray = value["twitter_link"] as? NSArray{
                twitterLink = twitterUrlArray[0] as! String
            }
        }
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
    }
}
