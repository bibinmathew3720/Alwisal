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
