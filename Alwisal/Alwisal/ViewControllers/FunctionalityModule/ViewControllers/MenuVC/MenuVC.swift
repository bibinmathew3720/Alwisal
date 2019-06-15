//
//  MenuVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/8/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

struct MenuItems {
    //static var fifthItem = "أحداث" //Events
   
    
    static var menuLogin = "تسجيل دخول" //Log in
    static var menuPresenters = "فريق الوصال"  //Presenters
    static let menuShows = "البرامج" //Shows
    static let menuNews = "أخبار" //News
    static let menuArticles = "مقالات" //Articles
    static let menuContactUs = "اتصل بنا" //Contact Us
    
    static let menuLogout = "الخروج" //Logout
}

class MenuVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var menuList: [String] = []
    var isLoggedIn:Bool!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
        if(isLoggedIn){
            self.tableViewHeightConstraint.constant = 350
            menuList = [MenuItems.menuArticles,MenuItems.menuNews,MenuItems.menuShows,MenuItems.menuPresenters,MenuItems.menuLogout,MenuItems.menuContactUs]
        }
        else{
            self.tableViewHeightConstraint.constant = 300
            menuList = [MenuItems.menuArticles,MenuItems.menuNews,MenuItems.menuShows,MenuItems.menuPresenters,MenuItems.menuLogin,MenuItems.menuContactUs]
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.menuTableView.reloadData()
    }
    
    //MARK: Button Actions

    @IBAction func whatsAppButtonAction(_ sender: UIButton) {
        if let url = URL(string: Constant.whatsAppLink) {
            UIApplication.shared.open(url, options: [:])
        }
        //loadWebUrl(webUrlString:Constant.whatsAppLink)
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        loadWebUrl(webUrlString:Constant.twitterLink)
    }
    @IBAction func fbButtonAction(_ sender: UIButton) {
        loadWebUrl(webUrlString:Constant.facebookLink)
    }
    @IBAction func instahramButtonAction(_ sender: UIButton) {
        loadWebUrl(webUrlString:Constant.instagramLink)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Table View Datasources
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let loggedIn = isLoggedIn{
            if(loggedIn){
                return menuList.count+1
            }
            else{
                return menuList.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isLoggedIn){
            if(indexPath.row == 0){
                let profileCell : MenuProfileTVC = tableView.dequeueReusableCell(withIdentifier: "menuProfileCell") as! MenuProfileTVC
                profileCell.setUserDetails()
                return profileCell
            }
        }
        let menuCell : MenuTVC! = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTVC
        menuCell.backgroundColor = UIColor.clear
        if(isLoggedIn){
            menuCell.itemNameLabel.text = menuList[indexPath.row-1]
        }
        else{
            menuCell.itemNameLabel.text = menuList[indexPath.row]
        }
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isLoggedIn){
            if(indexPath.row == 5){
                addingAlertControllerForLogout()
            }
            else{
                loadPageAtIndex(index: indexPath.row)
            }
        }
        else{
            if(indexPath.row == 4){//Login
                UserDefaults.standard.set(false, forKey: Constant.VariableNames.isLoogedIn)
                navigateToLogInPage()
            }
            else{
                loadPageAtIndex(index: indexPath.row)
            }
        }
    }
    
    func addingAlertControllerForLogout(){
        AlwisalUtility.showAlertWithOkOrCancel(_title: Constant.AppName, viewController: self, messageString: Constant.Messages.logoutMessage) { (success) in
            if success{
                self.processAfterLogout()
                self.isLoggedIn = false
                self.menuTableView.reloadData()
            }
        }
    }
    
    func loadPageAtIndex(index:Int){
        let tabBarCntlr = self.slideMenuController()?.mainViewController as! UITabBarController
        let selectedIndex = tabBarCntlr.selectedIndex
        let navCntlr = tabBarCntlr.viewControllers![selectedIndex] as! UINavigationController
        self.slideMenuController()?.closeRight()
        let lastVC = navCntlr.viewControllers.last
        let viewControllerAtIndex = getViewControllerAtMenuIndex(selIndex: index)
        navCntlr.pushViewController(viewControllerAtIndex, animated: true)
    }
    
    func getViewControllerAtMenuIndex(selIndex:NSInteger)->UIViewController{
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if (self.isLoggedIn){
            if(selIndex == 0){//Need to load profile Page
                let userProfileVC = storyBoard.instantiateViewController(withIdentifier: "userProfileViewController") as! UserProfileViewController
                return userProfileVC
            }
            if(selIndex == 1){//Articles
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.ArticlesPage
                return presenterVC
            }
            if(selIndex == 2){//News
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.NewsPage
                return presenterVC
            }
            if(selIndex == 3){//Shows
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.ShowsPage
                return presenterVC
            }
            if(selIndex == 4){//Presenters
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.PresenterPage
                return presenterVC
            }
            if(selIndex == 6){//Contact Us
                let webViewVC = storyBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                webViewVC.webViewType = .contactUs
                return webViewVC
            }
        }
        else{
            if(selIndex == 0){//Articles
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.ArticlesPage
                return presenterVC
            }
            if(selIndex == 1){//News
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.NewsPage
                return presenterVC
            }
            if(selIndex == 2){//Shows
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.ShowsPage
                return presenterVC
            }
            if(selIndex == 3){//Presenters
                let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
                presenterVC.pageType = PageType.PresenterPage
                return presenterVC
            }
            if(selIndex == 5){//Contact Us
                let webViewVC = storyBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                webViewVC.webViewType = .contactUs
                return webViewVC
            }
        }
        
        let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
        presenterVC.pageType = PageType.ArticlesPage
        return presenterVC //Default
        
       
//        else if(selIndex == 5){//Events
//            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
//            presenterVC.pageType = PageType.EventsPage
//            return presenterVC
//        }
    
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
