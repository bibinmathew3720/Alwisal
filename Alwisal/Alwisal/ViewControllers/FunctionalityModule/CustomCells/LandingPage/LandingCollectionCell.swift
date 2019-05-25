//
//  LandingCollectionCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/8/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit


protocol LandingCollectionCellDelegate: class {
    func likeButtonActionDelegateWithTag(tag:NSInteger)
    func favoriteButtonActionDelegateWithTag(tag:NSInteger)
}
class LandingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    weak var delegate : LandingCollectionCellDelegate?
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        delegate?.likeButtonActionDelegateWithTag(tag: self.tag)
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        delegate?.favoriteButtonActionDelegateWithTag(tag: self.tag)
    }
    
    func setCell(to model:SongHistoryModel) -> () {
//        profileIcon.loadImageUsingCache(withUrl: model.trainerPic)
        settingBorderToLandingCellInnerView()
        songNameLabel.text = model.title
        singerNameLabel.text = model.artist
        timeLabel.text = AlwisalUtility().convertDateInMillisecondsToString(dateInMilliseconds: model.songDate)
        guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
         singerImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
        favoriteButton.isSelected = model.isFavorited
        likeButton.isSelected = model.isLiked
    }
    func settingBorderToLandingCellInnerView(){
        self.innerView.layer.borderWidth = 1
        self.innerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
}
