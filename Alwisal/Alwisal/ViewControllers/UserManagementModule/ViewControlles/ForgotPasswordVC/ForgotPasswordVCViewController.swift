//
//  ForgotPasswordVCViewController.swift
//  Alwisal
//
//  Created by Bibin Mathew on 4/28/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
class ForgotPasswordVCViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTF: UITextField!
    var alwisalForgotPassword = AlwisalForgotPassword()
    override func initView() {
        super.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Actions

    @IBAction func forgotPwdButtonAction(_ sender: UIButton) {
        if(validate()){
            callingForgotPasswordApi()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: validation
    
    func validate()->Bool{
        var valid = true
        var messageString = ""
        if(emailTF.text?.isEmpty)!{
            valid = false
            messageString = "الرجاء إدخال معرف البريد الإلكتروني"
        }
        if valid == false{
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
    
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Tap Gesture Action
    
    @IBAction func tapGestureAction(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: Calling Forgot Password Api
    
    func  callingForgotPasswordApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingForgotPasswordApi(with: getRequestBody(), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalForgotResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    AlwisalUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message: model.statusMessage, parentController: self, completion: { (okSuccess) in
                        self.navigationController?.popViewController(animated: true)
                    })
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
        alwisalForgotPassword.email = emailTF.text!
        return alwisalForgotPassword.getRequestBody()
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
