//
//  UserProfileViewController.swift
//  Alwisal
//
//  Created by praveen raj on 11/06/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
enum SegmentType{
    case segmentTypeProfileDetails
    case segmentTypeLikes
    case segmentTypeFavorites
}

class UserProfileViewController: BaseViewController, UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ProfileCollectionCellDelegate {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var collectionviewLikes: UICollectionView!
    @IBOutlet weak var viewLikes: UIView!
    
    var segmentType:SegmentType?
    var userResponseModel:AlwisalUserProfileResponseModel?
    var alwisalUpdateProfile = AlwisalUpdateProfile()
    var alwisalUserLikes: LikesResponseModel?
    var alwisalUserFavorites: FavoritesResponseModel?
    
    override func initView() {
        super.initView()
        customization()
        addingNavigationBarView(title: "الملف الشخصي",fromTabBar: false)
        segmentType = SegmentType.segmentTypeProfileDetails
        callingGetUserProfilesApi()
    }
    
    func customization() {
        textfieldEmail.isUserInteractionEnabled = false
        textfieldPhone.isUserInteractionEnabled = false
        textfieldAddress.isUserInteractionEnabled = false
        textfieldEmail.delegate = self
        textfieldPhone.delegate = self
        textfieldAddress.delegate = self
        self.settingBorderColorToView(view: self.emailView)
        self.settingBorderColorToView(view: self.phoneView)
        self.settingBorderColorToView(view: self.addressView)
    }
    
    //MARK- Collection View Datasources
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.segmentType == SegmentType.segmentTypeLikes){
            guard let _model = alwisalUserLikes else {
                return 0
            }
            return _model.likeItems.count
        }
        else if(self.segmentType == SegmentType.segmentTypeFavorites){
            guard let _model = alwisalUserFavorites else {
                return 0
            }
            return _model.favoriteItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCell
        if(self.segmentType == SegmentType.segmentTypeLikes){
            if let _model = alwisalUserLikes{
                cell.setLikeDetails(likeItem: _model.likeItems[indexPath.row])
            }
        }
        if(self.segmentType == SegmentType.segmentTypeFavorites){
            if let _model = alwisalUserFavorites{
                cell.setFavoriteDetails(favoriteItem: _model.favoriteItems[indexPath.row])
            }
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: Collection Cell Delegates
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func closeButtonActionDelegateWithTag(tag:NSInteger){
        if(segmentType == SegmentType.segmentTypeLikes){
            self.callingLikeApi( index: tag)
        }
        else if(segmentType == SegmentType.segmentTypeFavorites){
            self.callingAddToFavoriteApi(index: tag)
        }
    }
    
    func settingBorderColorToView(view:UIView){
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = UIColor(red:0.39, green:0.40, blue:0.42, alpha:0.5).cgColor
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        if(self.validate()){
            self.callingUpdateProfileApi()
        }
    }
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 2 {
            segmentType = SegmentType.segmentTypeProfileDetails
            viewProfile.isHidden = false
            viewLikes.isHidden = true
        } else if(sender.selectedSegmentIndex == 1){
            segmentType = SegmentType.segmentTypeFavorites
            callingGetUserFavoritesApi()
            viewProfile.isHidden = true
            viewLikes.isHidden = false
        }
        else if(sender.selectedSegmentIndex == 0){
            segmentType = SegmentType.segmentTypeLikes
            callingGetUserLikesApi()
            viewProfile.isHidden = true
            viewLikes.isHidden = false
        }
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func actionEmailEdit(_ sender: Any) {
        textfieldEmail.isUserInteractionEnabled = true
        textfieldPhone.isUserInteractionEnabled = false
        textfieldAddress.isUserInteractionEnabled = false
        textfieldEmail.becomeFirstResponder()
    }
    
    @IBAction func actionPhoneEdit(_ sender: Any) {
        textfieldEmail.isUserInteractionEnabled = false
        textfieldPhone.isUserInteractionEnabled = true
        textfieldAddress.isUserInteractionEnabled = false
        textfieldPhone.becomeFirstResponder()
    }
    
    @IBAction func actionAddressEdit(_ sender: Any) {
        textfieldEmail.isUserInteractionEnabled = false
        textfieldPhone.isUserInteractionEnabled = false
        textfieldAddress.isUserInteractionEnabled = true
        textfieldAddress.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Get User Profiles
    
    func callingGetUserProfilesApi(){
        UserModuleManager().callingGetUserProfilesApi(with: "", success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalUserProfileResponseModel{
                self.userResponseModel = model
                self.populateUserDetails()
                
            }
        }) {(ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    func populateUserDetails(){
        alwisalUpdateProfile.first_name = (self.userResponseModel?.firstName)!
        alwisalUpdateProfile.last_name = (self.userResponseModel?.lastName)!
        alwisalUpdateProfile.email = (self.userResponseModel?.userEmail)!
        alwisalUpdateProfile.phone_number = (self.userResponseModel?.phoneNo)!
         alwisalUpdateProfile.age = (self.userResponseModel?.age)!
        alwisalUpdateProfile.gender = (self.userResponseModel?.gender)!
        alwisalUpdateProfile.address = (self.userResponseModel?.location)!
        alwisalUpdateProfile.nationality = (self.userResponseModel?.nationality)!
        
        //Populating Fields
        if let user = User.getUser(){
           
            self.textfieldPhone.text = user.phoneNumber
            self.textfieldEmail.text = self.userResponseModel?.userEmail
            self.textfieldAddress.text = user.address
            
            //self.textfieldPhone.text = (self.userResponseModel?.phoneNo)!
            //self.textfieldEmail.text = (self.userResponseModel?.userEmail)!
            //self.textfieldAddress.text = (self.userResponseModel?.location)!
        }
         self.labelProfileName.text = (self.userResponseModel?.firstName)!+" "+(self.userResponseModel?.lastName)!
        
    }
    
    //MARK: Update User Profiles
    
    func  callingUpdateProfileApi(){
        alwisalUpdateProfile.email = self.textfieldEmail.text!;
        alwisalUpdateProfile.phone_number = self.textfieldPhone.text!
        alwisalUpdateProfile.address = self.textfieldAddress.text!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingUpdateProfileApi(with:getRequestBodyForUpdateProfile() , success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalUpdateProfileResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    User.saveUserData(userProfile: self.alwisalUpdateProfile)
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.statusMessage, parentController: self)
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
    
    func getUpdateReqBody()->String{
            var dictionary:[String:AnyObject] = [String:AnyObject]()
            //dict.updateValue(first_name as AnyObject, forKey: "first_name")
            //dict.updateValue(last_name, forKey: "last_name")
            //dict.updateValue(email, forKey: "email")
            dictionary.updateValue("10345678" as AnyObject, forKey: "phone_number")
            // dict.updateValue(age, forKey: "age")
            //dict.updateValue(gender, forKey: "gender")
            dictionary.updateValue("My Adddresw" as AnyObject, forKey: "location")
            // dict.updateValue(nationality, forKey: "nationality")
            print(dictionary)
            return AlwisalUtility.getJSONfrom(dictionary: dictionary)
    }
    
    fileprivate func getRequestBodyForUpdateProfile() -> String {
        return alwisalUpdateProfile.getRequestBody()
    }
    
    func validate()->Bool{
        var valid = true
        var messageString = ""
       if(self.textfieldEmail.text?.isEmpty)!{
            valid = false
            messageString = "الرجاء إدخال معرف البريد الإلكتروني"
        }
        if valid == false{
            AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: messageString, parentController: self)
        }
        return valid
    }
    
    //MARK - Get User Likes
    
    func callingGetUserLikesApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingUserLikesApi(with:"" , success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? LikesResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                   self.alwisalUserLikes = model
                    self.collectionviewLikes.reloadData()
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
    
    //MARK - Get User Favorites
    
    func callingGetUserFavoritesApi(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingUserFavoritesApi(with:"" , success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? FavoritesResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserFavorites = model
                    self.collectionviewLikes.reloadData()
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
    
    //MARK : Calling Favorite Api
    
    func  callingAddToFavoriteApi(index:NSInteger){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingFavoriteApi(with: getFavoriteRequestBody(favoriteModel:(alwisalUserFavorites?.favoriteItems[index])!), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToFavoriteResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserFavorites?.favoriteItems.remove(at: index)
                    self.collectionviewLikes.reloadData()
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
    
    func getFavoriteRequestBody(favoriteModel:FavoritesModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(favoriteModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK : Calling Like Api
    
    func  callingLikeApi(index:NSInteger){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLikeApi(with: getLikeRequestBody(likeModel:(alwisalUserLikes?.likeItems[index])!), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToLikeResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    self.alwisalUserLikes?.likeItems.remove(at: index)
                    self.collectionviewLikes.reloadData()
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
    
    func getLikeRequestBody(likeModel:LikesModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(likeModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
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
