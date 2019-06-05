//
//  PresenterCollectionCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/15/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

protocol PresentercCollectionCellDelegate: class {
    func backButtonActionDelegateWithTag(tag:NSInteger)
    func twitterButtonActionDelegateWithTag(tag:NSInteger)
    func fbButtonActionDelegateWithTag(tag:NSInteger)
}

class PresenterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    
     weak var delegate : PresentercCollectionCellDelegate?
    
    func setCell(to model:PresenterModel) -> () {
        mainLabel.text = model.title
        subLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (model.songDate))
        
        //subLabel.text = model.content
        settingBorderToLandingCellInnerView()
         guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        userImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setNewsCell(model:NewsModel)->(){
        mainLabel.text = model.title
        subLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (model.songDate))
        //subLabel.text = model.content
        settingBorderToLandingCellInnerView()
        guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        userImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setArticleCell(model:ArticlesModel)->(){
        mainLabel.text = model.title
        subLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (model.songDate))
        //subLabel.text = model.content
        settingBorderToLandingCellInnerView()
         guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        userImageView.sd_setImage(with: URL(string:encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setEventsCell(model:EventsModel)->(){
        mainLabel.text = model.title
        subLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (model.songDate))
        //subLabel.text = model.content
        settingBorderToLandingCellInnerView()
        guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        userImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func setShowsCell(model:ShowsModel)->(){
        mainLabel.text = model.title
        subLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (model.songDate))
        //subLabel.text = model.content
        settingBorderToLandingCellInnerView()
        guard let encodedUrlstring = model.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
        userImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func settingBorderToLandingCellInnerView(){
        self.innerView.layer.borderWidth = 1
        self.innerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    //MARK: Button Actions
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.backButtonActionDelegateWithTag(tag: self.tag)
    }
    @IBAction func faButtonAction(_ sender: UIButton) {
        delegate?.fbButtonActionDelegateWithTag(tag: self.tag)
    }
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        delegate?.twitterButtonActionDelegateWithTag(tag: self.tag)
    }
}
