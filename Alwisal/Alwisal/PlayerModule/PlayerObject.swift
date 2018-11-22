//
//  PlayerObject.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/24/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
let url = "http://uk7.internet-radio.com:8067"

class AlwisalPlayer : NSObject  {
    var player: AVPlayer?
    var playerItem: AVPlayerItem!
    static let defaultPlayer = AlwisalPlayer()
    func initiateAVPlayer(){
        //Player.play()
        //audioMetaData()
        playerItem = AVPlayerItem(url: NSURL(string: url)! as URL)
        player = AVPlayer(playerItem: playerItem)
    }
    func play() {
        playerItem.addObserver(self, forKeyPath: "timedMetadata", options: .new, context: nil)
        player?.play()
    }
    func pause(){
        playerItem.removeObserver(self, forKeyPath: "timedMetadata")
        player?.pause()
    }
    func mute()->Bool {
        if let playerObject = player {
            playerObject.isMuted  = true
            return true
        }
        else{
            return false
        }
    }
    func unmute()->Bool{
        if let playerObject = player{
            playerObject.isMuted  = false
            return true
        }
        else{
            return false
        }
    }
    func audioMetaData(){
        let asset = AVAsset(url: URL(string: url)!)
        let formatsKey = "availableMetadataFormats"
        asset.loadValuesAsynchronously(forKeys: [formatsKey]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: formatsKey, error: &error)
            print(asset.commonMetadata)
            if status == .loaded {
                for format in asset.availableMetadataFormats {
                    let metadata = asset.metadata(forFormat: format)
                    print(metadata.description)
                    // process format-specific metadata collection
                }
            }
        }
        
        let metadata = asset.commonMetadata
        let titleID = AVMetadataIdentifier.commonIdentifierDescription
        let titleItems = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: titleID)
        if let item = titleItems.first {
            // process title item
        }

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != "timedMetadata" { return }
        let data: AVPlayerItem = object as! AVPlayerItem
        if let timedMetaData = data.timedMetadata{
            for item in timedMetaData {
                NotificationCenter.default.post(name: Notification.Name(Constant.Notifications.PlayerArtistInfo), object: item.value as? String)
            }
        }
    }
    func checkingStatus(){
        let asset = AVAsset(url: URL.init(string: url)!)
        let playableKey = "playable"
        
        // Load the "playable" property
        asset.loadValuesAsynchronously(forKeys: [playableKey]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: playableKey, error: &error)
            switch status {
            case .loaded: break
            // Sucessfully loaded. Continue processing.
            case .failed: break
            // Handle error
            case .cancelled: break
            // Terminate processing
            default: break
                // Handle all other cases
            }
        }
    }
   

}
