//
//  LandingPageManager.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/22/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class LandingPageManager: CLBaseService {
    func callingSongHistoryApi(success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForSongHistory(), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveArrayResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict as NSArray?{
                    print(jdict)
                    // print(jsonDict)
                    success(self.getSongHistoryModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    
    func networkModelForSongHistory()->CLNetworkModel{
        let presenterRequestModel = CLNetworkModel.init(url: BASE_URL+GETSONGHISTORY, requestMethod_: "GET")
        return presenterRequestModel
    }
    
    func getSongHistoryModel(dict:NSArray) -> Any? {
        let historyResponseModel = SongHistoryResponseModel.init(songs: dict)
        return historyResponseModel
    }
}

class SongHistoryResponseModel:NSObject{
    var historyItems = [SongHistoryModel]()
    init(songs:NSArray) {
        if let _dict = songs as? [[String:Any?]]{
            for item in _dict{
                historyItems.append(SongHistoryModel.init(dict: item))
            }
        }
    }
}

class SongHistoryModel:NSObject{
    var title:String = ""
    var artist:String = ""
    var imagePath:String = ""
    var songDate:CLongLong = 0
    var isFavorited:Bool = false
    var isLiked:Bool = false
    init(dict:[String:Any?]) {
        if let value = dict["title"] as? String{
            title = String(value)
        }
        if let value = dict["artist"] as? String{
            artist = String(value)
        }
        if let value = dict["image_path"] as? String{
            imagePath = value
        }
        if let value = dict["playedat"] as? CLongLong{
            songDate = value
        }
        if let value = dict["liked_status"] as? Int{
            print(value)
            isLiked = Bool(truncating: value as NSNumber)
        }
        if let value = dict["favourite_status"] as? Int{
             isFavorited = Bool(truncating: value as NSNumber)
        }
    }
}
