//
//  PresenterDetailVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/15/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
class PresenterDetailVC: BaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var presentersModel:PresenterModel?
    var newsModel:NewsModel?
    var articlesModel:ArticlesModel?
    var eventsModel:EventsModel?
    var pageType:PageType?
    
    override func initView() {
        super.initView()
        if let _model = presentersModel{
            addingNavigationBarView(title: "العروض",fromTabBar: false)
            self.populatePresenterData()
             getPresenterDetails()
        }
        if let model = newsModel{
            addingNavigationBarView(title: "أخبار",fromTabBar: false)
            self.populateNewsData()
        }
        if let model = articlesModel{
            addingNavigationBarView(title: "مقالات",fromTabBar: false)
            self.populateArtcilesData()
        }
        if let model = eventsModel{
            addingNavigationBarView(title: "أحداث",fromTabBar: false)
            self.populateEventsData()
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        if let _model = presentersModel{
            loadWebUrl(webUrlString: (_model.twitterLink))
        }
        if let model = newsModel{
            loadWebUrl(webUrlString: (model.twitterLink))
        }
        if let model = articlesModel{
            loadWebUrl(webUrlString: (model.twitterLink))
        }
        if let model = eventsModel{
            loadWebUrl(webUrlString: (model.twitterLink))
        }
    }
    
    @IBAction func fbButtonAction(_ sender: UIButton) {
        if let _model = presentersModel{
            loadWebUrl(webUrlString: (_model.fbLink))
        }
        if let model = newsModel{
            loadWebUrl(webUrlString: (model.fbLink))
        }
        if let model = articlesModel{
            loadWebUrl(webUrlString: (model.fbLink))
        }
        if let model = eventsModel{
            loadWebUrl(webUrlString: (model.fbLink))
        }
    }
    @IBAction func emailButtonAction(_ sender: UIButton) {
    }
    
    //MARK: Get Presenter Details
    
    func  getPresenterDetails(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PresenterModuleManager().callingPresenterDetailsApi(with: (presentersModel?.id)! , success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? PresenterModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.presentersModel = model
                    self.populatePresenterData()
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func populatePresenterData(){
        self.headingLabel.text = self.presentersModel?.title.removeHtmlTags()
        self.subheadingLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (self.presentersModel?.songDate)!)
        self.detailLabel.text = self.presentersModel?.content.removeHtmlTags()
        profileImageView.sd_setImage(with: URL(string: (self.presentersModel?.imagePath)!), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateNewsData(){
        self.headingLabel.text = self.newsModel?.title.removeHtmlTags()
        self.subheadingLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (self.newsModel?.songDate)!)
        self.detailLabel.text = self.newsModel?.content.removeHtmlTags()
        profileImageView.sd_setImage(with: URL(string: (self.newsModel?.imagePath)!), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateArtcilesData(){
        self.headingLabel.text = self.articlesModel?.title.removeHtmlTags()
        self.subheadingLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (self.articlesModel?.songDate)!)
        self.detailLabel.text = self.articlesModel?.content.removeHtmlTags()
        profileImageView.sd_setImage(with: URL(string: (self.articlesModel?.imagePath)!), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    func populateEventsData(){
        self.headingLabel.text = self.eventsModel?.title.removeHtmlTags()
        self.subheadingLabel.text = AlwisalUtility().convertDateWithTToString(dateString: (self.eventsModel?.songDate)!)
        self.detailLabel.text = self.eventsModel?.content.removeHtmlTags()
        profileImageView.sd_setImage(with: URL(string: (self.eventsModel?.imagePath)!), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UILabel {
    func showHtmlText(dataStr: String){
        let attrStr = try! NSAttributedString(
            data: (dataStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        self.attributedText = attrStr
        self.textAlignment = NSTextAlignment.justified
        self.contentMode = .scaleToFill
        //self.font = UIFont(name: "PTSans-Narrow", size: 18.0)
        self.adjustsFontSizeToFitWidth = true
        self.sizeToFit()
    }
}

extension String {
    mutating func removeHtmlTags()->String{
        let tagsRemovedString = self.replacingOccurrences(of: "<[^>]+>", with: "", options:String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
            "", options:.regularExpression, range: nil)
        return tagsRemovedString
    }
}
