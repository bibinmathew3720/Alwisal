//
//  ArtistInfoManager.swift
//  Alwisal
//
//  Created by Appcircle on 17/06/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ArtistInfoManager: CLBaseService {
    func callingGetArtistInfoApi(with name:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForArtistInfo(artistName: name), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                success(ArtistInfoModel(info: jsonDict! as NSDictionary))
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
    }
    
    func networkModelForArtistInfo(artistName:String)->CLNetworkModel{
        let ParaMeter = "artist=\(artistName)&api_key=\(Constant.AppKeys.artistInfoKey)&format=json"
        let newsRequestModel = CLNetworkModel.init(url: BASE_URL_ARTIST_INFO+GETARTISTINFO+ParaMeter, requestMethod_: "GET")
        return newsRequestModel
    }
    
    //Calling Now Playing Song Api
    
    func callingNowPlayingApi(with name:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForNowPlayingApi(), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                success(self.nowPlayingResponseModel(dict: jsonDict!) as Any)
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
    }
    
    func networkModelForNowPlayingApi()->CLNetworkModel{
        let nowPlayingModel = CLNetworkModel.init(url: BASE_URL+NOW_PLAYING_URL, requestMethod_: "GET")
        return nowPlayingModel
    }
    
    func nowPlayingResponseModel(dict:[String:Any])->Any?{
        let nowPlayingResponseModel = AlwisalNowPlayingResponseModel.init(dict:dict)
        return nowPlayingResponseModel
    }
}

class ArtistInfoModel:NSObject{
    var artistName: String?
    var artistImage: String?
    var listenersCount: String?
    var playCount: String?
    
    init(info: NSDictionary) {
        artistName = info.value(forKeyPath: "artist.name") as? String
        listenersCount = info.value(forKeyPath: "artist.stats.listeners") as? String
        playCount = info.value(forKeyPath: "artist.stats.playcount") as? String
        if let images = info.value(forKeyPath: "artist.image") as? NSArray {
            let imageData = images[2] as! NSDictionary
            artistImage = imageData["#text"] as? String ?? "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
            if artistImage == "" {
                artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
            }
        }
        else {
            artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
        }
        
    }
    
    init(lastSong: SongHistoryModel) {
//        artistName = info.value(forKeyPath: "artist.name") as? String
//        listenersCount = info.value(forKeyPath: "artist.stats.listeners") as? String
//        playCount = info.value(forKeyPath: "artist.stats.playcount") as? String
//        if let images = info.value(forKeyPath: "artist.image") as? NSArray {
//            let imageData = images[1] as! NSDictionary
//            artistImage = imageData["#text"] as? String ?? "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//            if artistImage == "" {
//                artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//            }
//        }
//        else {
//            artistImage = "http://test.wisal.fm/wp-content/themes/wisal/assets/images/default_artwork.jpg"
//        }
//        
    }
}

class AlwisalNowPlayingResponseModel : NSObject{
    var peakListeners:CLongLong = 0
    var severgenere:String = ""
    var avgTime:CLongLong = 0
    var likeStatus:Bool = false
    var imagePath:String = ""
    var currentListeners:CLongLong = 0
    var title:String = ""
    var maxListeners:CLongLong = 0
    var uniqueListeners:CLongLong = 0
    var artist:String = ""
    var favoriteStatus:Bool = false
    var streamPath:String = ""
    init(dict:[String:Any?]) {
        print(dict)
        if let value = dict["peaklisteners"] as? CLongLong {
            peakListeners = value
        }
        if let value = dict["servergenre"] as? String {
            severgenere = value
        }
        if let value = dict["averagetime"] as? CLongLong {
            avgTime = value
        }
        if let value = dict["liked_status"] as? Int {
            likeStatus = Bool(truncating: value as NSNumber)
        }
        if let value = dict["image_path"] as? String {
            imagePath = value
        }
        if let value = dict["currentlisteners"] as? CLongLong {
            currentListeners = value
        }
        if let value = dict["title"] as? String {
            title = value
        }
        if let value = dict["maxlisteners"] as? CLongLong {
            maxListeners = value
        }
        if let value = dict["uniquelisteners"] as? CLongLong {
            uniqueListeners = value
        }
        if let value = dict["artist"] as? String {
            artist = value
        }
        if let value = dict["serverurl"] as? String {
            streamPath = value
        }
        if let value = dict["favourite_status"] as? Int {
            favoriteStatus = Bool(truncating: value as NSNumber)
        }
    }
}
