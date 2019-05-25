//
//  NewsCollectionCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/1/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class NewsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var songInfoLabel: UILabel!
    
    //For Video Type
    @IBOutlet weak var playIcon: UIImageView!
    
    func setCell(to model:NewsModel) -> () {
        songInfoLabel.text = model.title
        //singerNameLabel.text = model.artist
        dateLabel.text = AlwisalUtility().convertDateWithTToString(dateString: model.songDate)
        if model.videoThumbnailImageUrl.count > 0{
             guard let encodedUrlstring = model.videoThumbnailImageUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
            songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
        }
        else{
             guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
             songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
        }
    }
}
