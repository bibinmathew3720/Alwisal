//
//  WebViewVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 7/21/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class WebViewVC: BaseViewController,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    override func initView() {
        super.initView()
        initialisation()
    }
    
    func initialisation(){
        addingNavigationBarView(title: "اتصل بنا", fromTabBar: false)
       loadWebViewurl()
    }
    
    func loadWebViewurl(){
        let url = URL(string:Constant.contactUsUrlString)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let unwrappedUrl = url {
            let request = URLRequest(url: unwrappedUrl)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    self.webView.loadRequest(request)
                }
                else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print("ERROR:\(error)")
                }
            }
            task.resume()
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
