//
//  LogInVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 3/27/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

class LogInVC: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    var isFromTabBar:Bool!
    var alwisalLogIn = AlwisalLogIN()
    override func initView() {
        super.initView()
        GIDSignIn.sharedInstance().clientID = Constant.AppKeys.googleClientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    // MARK:- Button Actions
    @IBAction func logInButtonAction(_ sender: UIButton) {
//        if let isTab = self.isFromTabBar as Bool?{
//            if(isTab == true){
//                self.dismiss(animated: true) {
//
//                }
//            }
//        }
//        else{
//            UserDefaults.standard.set(true, forKey: Constant.VariableNames.isLoogedIn)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.RootSettingNotification), object: nil)
//        }
        self.view.endEditing(true)
        if(validate()){
            callingLogInApi()
        }
    }
    @IBAction func buttonActionLoginWithFB(_ sender: UIButton) {
        ApplicationController.applicationController.loginType = .Facebook
        login(type: .Facebook)
    }
    @IBAction func buttonActionLoginWithGoogle(_ sender: UIButton) {
        ApplicationController.applicationController.loginType = .Google
        GIDSignIn.sharedInstance().signOut() //sign out first for other user login as a precaution
        GIDSignIn.sharedInstance().signIn() //call signin to google
    }
    @IBAction func buttonActionLoginWithTwitter(_ sender: UIButton) {
        ApplicationController.applicationController.loginType = .Twitter
        login(type: .Twitter)
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: Login Api Call
    
    func  callingLogInApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLogInApi(with: getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalLogInResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    User.deleteUser()
                    UserDefaults.standard.set(true, forKey: Constant.VariableNames.isLoogedIn)
                    UserDefaults.standard.set(model.userToken, forKey: Constant.VariableNames.userToken)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.RootSettingNotification), object: nil)
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
    func callSocialLogin(body: [String: String]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingSocialLogInApi(with: alwisalLogIn.getSocialLoginRequestBody(dict: body), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalLogInResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    UserDefaults.standard.set(true, forKey: Constant.VariableNames.isLoogedIn)
                    UserDefaults.standard.set(model.userToken, forKey: Constant.VariableNames.userToken)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.RootSettingNotification), object: nil)
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
    fileprivate func getRequestBody() -> String {
        alwisalLogIn.userName = userNameTF.text!
        alwisalLogIn.password = pwdTF.text!
        return alwisalLogIn.getRequestBody()
    }
    
    //MARK: Tap Gesture Actions
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    // MARK: TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTF{
            pwdTF.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Validation
    
    func validate()->Bool{
        var valid = true
        var messageString = ""
        if(userNameTF.text?.isEmpty)!{
            valid = false
            messageString = "الرجاء إدخال اسم المستخدم"
        }
        else if(pwdTF.text?.isEmpty)!{
            valid = false
            messageString = "يرجى إدخال كلمة المرور"
        }
        if valid == false{
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
    //MARK:- Social login
    func login(type: LoginType) {
        weak var weakSelf = self
        switch type {
        case .Facebook:
            
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email",], from: weakSelf) { (response, error) in
                if error == nil {
                    let result : FBSDKLoginManagerLoginResult = response!
                    if (result.grantedPermissions != nil) {
                        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result.token.tokenString, version: nil, httpMethod: "GET")
                       
                        req?.start(completionHandler: { (connection, userData, error) in
                            if (error == nil)
                            {
                                if let data = userData as? NSDictionary
                                {
                                    var firstName = ""
                                    if let name = data.object(forKey: "first_name") as? String{
                                       firstName = name
                                    }
                                    if let name = data.object(forKey: "name") as? String{
                                        firstName = name
                                    }
                                    
                                    if let email = data.object(forKey: "email") as? String
                                    {
                                        weakSelf?.callSocialLogin(body: ["user_email" : email,
                                                                         "displayName" :firstName])
                                    }
                                    else
                                    {
                                        weakSelf?.callSocialLogin(body: ["user_email" : "noemail@testmail.com",
                                                               "displayName" :firstName])
                                    }
                                }
                            }
                        })
                    }
                    else {
                        //show alert for have not permission
                        
                    }
                }
                else {
                    //show alert for eror
                    
                }
            }
            break
        case .Twitter:
            TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
                if (session != nil) {
                    /* print("signed in as \(session?.userName)");
                     print("AuthToken \(session?.authToken)");
                     print("AuthTokenSecret \(session?.authTokenSecret)");*/
                    weakSelf?.callSocialLogin(body: ["user_email" : "noemail@testmail.com",
                                                     "displayName" :(session?.userName)!])
                } else {
                    
                }
            })
            break
        default: break
            
        }
        
    }
}
extension LogInVC : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let loginUser = user {
            callSocialLogin(body: ["user_email" : loginUser.profile.email,
                                   "displayName" : loginUser.profile.name])
        }
    }
}
extension LogInVC : GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
}
