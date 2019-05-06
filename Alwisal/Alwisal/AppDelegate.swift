//
//  AppDelegate.swift
//  Alwisal
//
//  Created by Bibin Mathew on 3/27/18.
//  Copyright © 2018 SC. All rights reserved.
//
//app.bayie.BayieMobileApp
import UIKit
import CoreData
import AVFoundation
import IQKeyboardManagerSwift
import TwitterKit
import TwitterCore
import GoogleSignIn
import FBSDKLoginKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        initWindow()
        NotificationCenter.default.addObserver(self, selector: #selector(noticationObserverAction), name: NSNotification.Name(rawValue: Constant.Notifications.RootSettingNotification), object: nil)
        UIApplication.shared.statusBarStyle = .lightContent
        //Since iOS 7.0 UITextAttributeTextColor was replaced by NSForegroundColorAttributeName
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        //Twitter configuration
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:Constant.AppKeys.twitterConsumerKey, consumerSecret:Constant.AppKeys.twitterConsumerSecret)
        
        return true
    }
    
    @objc func noticationObserverAction(){
        initWindow()
    }
    
    func initWindow(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
       // if (isLoggedIn){
            window?.rootViewController = initialisingTabBar()
//        }
//        else{
//            let loginVC = storyBoard.instantiateViewController(withIdentifier: "logInVC")
//            let logInNavController = UINavigationController.init(rootViewController: loginVC)
//            window?.rootViewController = logInNavController
//        }
    }
    
    func initialisingTabBar()->ExSlideMenuController{
        let tabBarController = UITabBarController.init()
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
        chatVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: "firstTabSelected", unselectedImage: "firstTabSelected", title: "الوصل") //Chat
        let firstNavVC = UINavigationController.init(rootViewController: chatVC)
        
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordVC")
        secondVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: "secondTabSelected", unselectedImage: "secondTabSelected", title: "قائمة التشغيل")//Play List
        let secondNavVC = UINavigationController.init(rootViewController: secondVC)
        
         let landingPageVC = storyBoard.instantiateViewController(withIdentifier: "LandingPageVC")
         landingPageVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.playIcon, unselectedImage: Constant.ImageNames.tabImages.playIcon, title: "")
        landingPageVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        //landingPageVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let landingNavVC = UINavigationController.init(rootViewController: landingPageVC)
        
        let fourthVC = storyBoard.instantiateViewController(withIdentifier: "ContactVC")
         fourthVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: Constant.ImageNames.tabImages.soundIcon, unselectedImage: Constant.ImageNames.tabImages.soundIcon, title: "الصوت") // The sound
        let fourthNavVC = UINavigationController.init(rootViewController: fourthVC)
        
        let fifthVC = storyBoard.instantiateViewController(withIdentifier: "PresenterVC")
        fifthVC.tabBarItem = settingTabBarItemFontsAndImages( selectedImageName: "fifthTabSelected", unselectedImage: "fifthTabSelected", title: "شارك") //Participate
        let fifthNavVC = UINavigationController.init(rootViewController: fifthVC)
        
        tabBarController.viewControllers = [firstNavVC,secondNavVC,landingNavVC,fourthNavVC,fifthNavVC];
        customisingTabBarController(tabBarCnlr: tabBarController)
        tabBarController.selectedIndex = 2;
         let menuVC = storyBoard.instantiateViewController(withIdentifier: "menuVC")
        
         //let contactVC = storyBoard.instantiateViewController(withIdentifier: "ContactVC")
        let slideMenu = ExSlideMenuController(mainViewController: tabBarController, rightMenuViewController: menuVC)
        //let slideMenuController = ExSlideMenuController(mainViewController: tabBarController, leftMenuViewController:contactVC , rightMenuViewController: menuVC)
        return slideMenu
    }
    
    func settingTabBarItemFontsAndImages(selectedImageName:String,unselectedImage:String,title:String)->UITabBarItem{
         let tabBarItem = UITabBarItem.init(title: title, image: UIImage.init(named: unselectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: selectedImageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
               // tabBarItem.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
        tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tabBarItem
    }
    
    func customisingTabBarController(tabBarCnlr:UITabBarController){
      // UITabBar.appearance().backgroundColor = UIColor.red
        //UITabBar.appearance().isTranslucent = false
        //UITabBar.appearance().backgroundImage = UIImage(named: "tabBarBG")
        let appearance = UITabBarItem.appearance()
        let attributes = [kCTFontAttributeName:UIFont(name: "Mada-Bold", size: 25)]
        appearance.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white], for:.normal)
        appearance.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white], for:.selected)
        //appearance.setTitleTextAttributes(attributes as [NSAttributedStringKey : Any], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        tabBarCnlr.tabBar.barTintColor = Constant.Colors.commonRoseColor
        //UITabBar.appearance().contentMode = .scaleAspectFit
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var appUrl: Bool = false
        switch ApplicationController.applicationController.loginType {
            
        case .Facebook:
            appUrl = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        case .Google:
            appUrl = GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
        case .Twitter:
            appUrl = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        default: print("default")
        }
        return appUrl
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Alwisal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

