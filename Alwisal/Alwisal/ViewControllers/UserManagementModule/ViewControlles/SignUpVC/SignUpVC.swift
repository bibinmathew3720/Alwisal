//
//  SignUpVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 3/27/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
class SignUpVC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    @IBOutlet weak var createAnAccountButton: UIButton!
    var alwisalRegister = AlwisalRegister()
    override func initView() {
        super.initView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        if(validate() == true){
            callingSignUpApi()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Sign Up Api
    
    func  callingSignUpApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingSignUpApi(with: getRequestBody(), success: {
            (model) in
           MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalRegisterResponseModel{
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
            
            print(ErrorType)
        }
    }
    
    fileprivate func getRequestBody() -> String {
        alwisalRegister.username = usernameTF.text!
        alwisalRegister.emailid = emailTF.text!
        alwisalRegister.password = passwordTF.text!
        return alwisalRegister.getRequestBody()
    }
    
    //MARK: Tap Gesture Actions
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == usernameTF){
            emailTF.becomeFirstResponder()
        }
        else if(textField == emailTF){
            passwordTF.becomeFirstResponder()
        }
        else if(textField == passwordTF){
            confirmPwdTF.becomeFirstResponder()
        }
        else if(textField == confirmPwdTF){
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: Validation
    
    func validate()->Bool{
//        else if(emailTF.text?.isValidEmail())!{
//            valid = false
//            messageString = "الرجاء إدخال معرف البريد الإلكتروني الصحيح"
//        }
        var valid = true
        var messageString = ""
        if(usernameTF.text?.isEmpty)!{
            valid = false
            messageString = "الرجاء إدخال اسم المستخدم"
        }
        else if(emailTF.text?.isEmpty)!{
            valid = false
            messageString = "الرجاء إدخال معرف البريد الإلكتروني"
        }
        else if(passwordTF.text?.isEmpty)!{
            valid = false
            messageString = "يرجى إدخال كلمة المرور"
        }
        else if(confirmPwdTF.text?.isEmpty)!{
            valid = false
            messageString = "من فضلك أدخل كلمة مرور تأكيد"
        }
        else if(passwordTF.text != confirmPwdTF.text){
            valid = false
            messageString = "عدم تطابق كلمة المرور"
        }
        if valid == false{
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
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
