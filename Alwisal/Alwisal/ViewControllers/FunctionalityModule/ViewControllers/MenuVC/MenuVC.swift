//
//  MenuVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/8/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

struct MenuItems {
    static var firstItem = "تسجيل دخول"//Log in
    static var showItem = "البرامج"//Shows
    static var secondItem = "العروض" //Offers
    static var thirdItem = "أخبار" //News
    static var fourthItem = "مقالات" //Articles
    static var fifthItem = "أحداث" //Events
    static var sixthItem = "اتصل بنا" //call us
    
    static var logOutItem = "الخروج" //Logout
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
            menuList = [MenuItems.logOutItem,MenuItems.showItem,MenuItems.secondItem,MenuItems.thirdItem,MenuItems.fourthItem,MenuItems.sixthItem]
        }
        else{
            self.tableViewHeightConstraint.constant = 300
            menuList = [MenuItems.firstItem,MenuItems.showItem,MenuItems.secondItem,MenuItems.thirdItem,MenuItems.fourthItem,MenuItems.sixthItem]
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
            if(indexPath.row == 1){
                addingAlertControllerForLogout()
            }
            else{
                if(indexPath.row == 0){
                    loadPageAtIndex(index: 0)
                }
                else{
                    loadPageAtIndex(index: indexPath.row-1)
                }
            }
        }
        else{
            if(indexPath.row == 0){
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
        if(selIndex == 0){//Need to load profile Page
            let userProfileVC = storyBoard.instantiateViewController(withIdentifier: "userProfileViewController") as! UserProfileViewController
            return userProfileVC
        }
        if(selIndex == 1){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
            presenterVC.pageType = PageType.ShowsPage
            return presenterVC
        }
        if(selIndex == 2){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
            presenterVC.pageType = PageType.PresenterPage
            return presenterVC
        }
        if(selIndex == 3){
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
            presenterVC.pageType = PageType.NewsPage
            return presenterVC
        }
        else if(selIndex == 4){//Articles
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
            presenterVC.pageType = PageType.ArticlesPage
            return presenterVC
        }
//        else if(selIndex == 5){//Events
//            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC") as! PresenterVC
//            presenterVC.pageType = PageType.EventsPage
//            return presenterVC
//        }
        else if(selIndex == 5){//Contacts
            let webViewVC = storyBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            webViewVC.webViewType = .contactUs
            return webViewVC
        }
        else{
            let presenterVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC")
            return presenterVC
        }
    
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
