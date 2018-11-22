//
//  ProfileCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/15/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

protocol ProfileCollectionCellDelegate: class {
    func closeButtonActionDelegateWithTag(tag:NSInteger)
}

class ProfileCell: UICollectionViewCell {
    @IBOutlet weak var callBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var songImageview: UIImageView!
    weak var delegate : ProfileCollectionCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        callBackView.layer.borderWidth = 0.5;
        callBackView.layer.borderColor = UIColor(red:0.39, green:0.40, blue:0.42, alpha:0.5).cgColor
        
    }
    func setFavoriteDetails(favoriteItem:FavoritesModel){
        titleLabel.text = favoriteItem.title
        subTitleLabel.text = ""
        
    }
    func setLikeDetails(likeItem:LikesModel){
        titleLabel.text = likeItem.title
        subTitleLabel.text = ""
        
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        delegate?.closeButtonActionDelegateWithTag(tag: self.tag)
    }
}


