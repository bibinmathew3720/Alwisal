//
//  YouTubeVideoVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/4/19.
//  Copyright © 2019 SC. All rights reserved.
//

import UIKit

class YouTubeVideoVC: BaseViewController {
    var newsModel:NewsModel?
    @IBOutlet weak var webView: UIWebView!
    
    override func initView() {
        super.initView()
        loadWebView()
    }
    
    func loadWebView(){
        if let news = newsModel{
            webView.loadHTMLString(news.videoUrl, baseURL: nil)
            webView.scalesPageToFit = true
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
