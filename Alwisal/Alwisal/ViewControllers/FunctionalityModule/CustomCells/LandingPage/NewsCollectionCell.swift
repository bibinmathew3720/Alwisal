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
        songImageView.sd_setImage(with: URL(string: model.imagePath), placeholderImage: UIImage(named: Constant.ImageNames.placeholderImage))
    }
}
