//
//  YouTubeVideoVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/4/19.
//  Copyright © 2019 SC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class YouTubeVideoVC: BaseViewController {
    var newsModel:NewsModel?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var bannerView: DFPBannerView!
    @IBOutlet weak var adView: UIView!
    
    override func initView() {
        super.initView()
        loadWebView()
        initialisingAd()
    }
    
    func initialisingAd(){
        bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Constant.adUnitIdString
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
        adView.addSubview(bannerView)
    }
    
    func loadWebView(){
        if let news = newsModel{
            self.titleLabel.text = news.title.removeHtmlTags()
            let appendingString = "<style type=\"text/css\">.embed-youtube {overflow: hidden;padding-bottom: 56.25%;position: relative;height: 0;}.embed-youtube iframe {left: 0;top: 0;height: 100%;width: 100%;position: absolute;}</style>"
            webView.loadHTMLString(appendingString + news.videoUrl, baseURL: nil)
            //webView.scalesPageToFit = true
            //[webView loadHTMLString:news.videoUrl baseURL:nil];
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let news = newsModel{
            let navigationBar = addingNavigationBarView(title: "", fromTabBar: true)
            navigationBar.headingLabel.isHidden = true
            navigationBar.logoImageView.isHidden = false
        }
    }
    
    @IBAction func fbButtonAction(_ sender: UIButton) {
        var linkString = ""
        var titleString = ""
        if let _model = newsModel{
            linkString = _model.linkString
            titleString = _model.title
        }
        let fbLinkString = "http://www.facebook.com/share.php?u=\(linkString)&t=\(titleString)"
        loadWebUrl(webUrlString:fbLinkString)
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        var linkString = ""
        var titleString = ""
        if let _model = newsModel{
            linkString = _model.linkString
            titleString = _model.title
        }
        let twitterLinkString = "http://twitter.com/intent/tweet?text=\(titleString)&url=\(linkString)"
        loadWebUrl(webUrlString:twitterLinkString)
    }
    
    @IBAction func whatsAppButtonAction(_ sender: UIButton) {
        var linkString = ""
        var titleString = ""
        if let _model = newsModel{
            linkString = _model.linkString
            titleString = _model.title
        }
        let whatsAppLinkString = "https://api.whatsapp.com/send?text=\(titleString)\(linkString)"
        loadWebUrl(webUrlString:whatsAppLinkString)
        
    }
    
    @IBAction func bufferButtonAction(_ sender: UIButton) {
        var linkString = ""
        var titleString = ""
        if let _model = newsModel{
            linkString = _model.linkString
            titleString = _model.title
        }
        let bufferLinkString = "http://buffer.com/add?text=\(titleString)&url=\(linkString)"
        loadWebUrl(webUrlString:bufferLinkString)
    }
    
    @IBAction func copyToClispBoardButtonAction(_ sender: UIButton) {
        var linkString = ""
        var titleString = ""
        if let _model = newsModel{
            linkString = _model.linkString
            titleString = _model.title
        }
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = linkString
        AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: "نسخ إلى الحافظة", parentController: self)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
