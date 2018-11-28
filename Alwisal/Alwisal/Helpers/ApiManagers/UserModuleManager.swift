 //
//  UserModuleManager.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/12/18.
//  Copyright © 2018 SC. All rights reserved.
//

import Foundation
class UserModuleManager: CLBaseService {
    func callingSignUpApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForRegister(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
    
    }
    
    func getModel(dict:[String : Any?]) -> Any? {
        let registerReponseModel = AlwisalRegisterResponseModel.init(dict:dict)
        return registerReponseModel
    }
    
    func networkModelForRegister(with body:String)->CLNetworkModel{
        let registerRequestModel = CLNetworkModel.init(url: BASE_URL+REGISTER_URL, requestMethod_: "POST")
        registerRequestModel.requestBody = body
        return registerRequestModel
    }
    
    //MARK :Log In Api
    
    func callingLogInApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForLogin(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getLogInResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    
    
    func networkModelForLogin(with body:String)->CLNetworkModel{
        let logInModel = CLNetworkModel.init(url: BASE_URL+LOGIN_URL, requestMethod_: "POST")
        logInModel.requestBody = body
        return logInModel
    }
    
    func getLogInResponseModel(dict:[String:Any])->Any?{
        let logInResponseModel = AlwisalLogInResponseModel.init(dict:dict)
        return logInResponseModel
    }
    //MARK:- Social Log In Api
    
    func callingSocialLogInApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForSocialLogin(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getLogInResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    func networkModelForSocialLogin(with body:String)->CLNetworkModel{
        let logInModel = CLNetworkModel(url: BASE_URL + SOCIAL_LOGIN_URL, requestMethod_: "POST")
        logInModel.requestBody = body
        return logInModel
    }
    //MARK : Forgot Password Api
    
    
    func callingForgotPasswordApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForForgotPassword(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getForgotResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForForgotPassword(with body:String)->CLNetworkModel{
        let forgotPasswordModel = CLNetworkModel.init(url: BASE_URL+FORGOTPASSWORD_URL, requestMethod_: "POST")
        forgotPasswordModel.requestBody = body
        return forgotPasswordModel
    }
    
    func getForgotResponseModel(dict:[String:Any])->Any?{
        let forgotResponseModel = AlwisalForgotResponseModel.init(dict:dict)
        return forgotResponseModel
    }
    
    //Calling Favorite Api
    
    func callingFavoriteApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForFavorite(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getAddToFavoriteResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForFavorite(with body:String)->CLNetworkModel{
        let favoriteModel = CLNetworkModel.init(url: BASE_URL+ADDTOFAVORITE, requestMethod_: "POST")
        favoriteModel.requestBody = body
        return favoriteModel
    }
    
    func getAddToFavoriteResponseModel(dict:[String:Any])->Any?{
        let forgotResponseModel = AlwisalAddToFavoriteResponseModel.init(dict:dict)
        return forgotResponseModel
    }
    
   
    
    //MARK: Calling Like Api
    
    func callingLikeApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForLike(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getAddToLikeResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForLike(with body:String)->CLNetworkModel{
        let likeModel = CLNetworkModel.init(url: BASE_URL+ADDTOLIKE, requestMethod_: "POST")
        likeModel.requestBody = body
        return likeModel
    }
    
    func getAddToLikeResponseModel(dict:[String:Any])->Any?{
        let addToLikeResponseModel = AlwisalAddToLikeResponseModel.init(dict:dict)
        return addToLikeResponseModel
    }
    
    //MARK: Get User Profiles
    
    func callingGetUserProfilesApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelGetUserProfiles(), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.userProfileResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelGetUserProfiles()->CLNetworkModel{
        let getProfileModel = CLNetworkModel.init(url: BASE_URL+GETUSERPROFILEDETAILS, requestMethod_: "GET")
        return getProfileModel
    }
    
    func userProfileResponseModel(dict:[String:Any])->Any?{
        let userProfileResponseModel = AlwisalUserProfileResponseModel.init(dict:dict)
        return userProfileResponseModel
    }
    
    //MARK: Calling Update Profile Api
    
    func callingUpdateProfileApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForUpdateProfile(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(AlwisalUpdateProfileResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForUpdateProfile(with body:String)->CLNetworkModel{
        let updateRequestModel = CLNetworkModel.init(url: BASE_URL+UPDATEPROFILEDETAILS, requestMethod_: "POST")
        updateRequestModel.requestBody = body
        return updateRequestModel
    }
    
    func getModelForUpdateProfile(dict:[String : Any?]) -> Any? {
        let registerReponseModel = AlwisalUserProfileResponseModel.init(dict:dict)
        return registerReponseModel
    }
    
    //MARK: Calling User Likes Api
    
    func callingUserLikesApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForUserLikes(with:""), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(LikesResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
    }
    
    func networkModelForUserLikes(with body:String)->CLNetworkModel{
        let registerRequestModel = CLNetworkModel.init(url: BASE_URL+GETUSERLIKES, requestMethod_: "GET")
        return registerRequestModel
    }
    
    //MARK: Calling User Favorites Api
    
    func callingUserFavoritesApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForUserFavorites(with:""), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(FavoritesResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
    }
    
    func networkModelForUserFavorites(with body:String)->CLNetworkModel{
        let registerRequestModel = CLNetworkModel.init(url: BASE_URL+GETUSERFAVORITES, requestMethod_: "GET")
        return registerRequestModel
    }
    
    //MARK :Chat Messages Api
    
    func callingChatMessagesApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForChatMessages(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getChatResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func getChatResponseModel(dict:[String:Any])->Any?{
        let chatResponseModel = ChatResponseModel.init(dict:dict)
        return chatResponseModel
    }
    
    func networkModelForChatMessages(with body:String)->CLNetworkModel{
        let chatModel = CLNetworkModel.init(url: BASE_URL+GETCHATMESSAGES, requestMethod_: "GET")
        chatModel.requestBody = body
        return chatModel
    }
    
    func callingSendChatMessageApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelSendChatMessage(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
                    success(self.getChatSendResponseModel(dict: jdict["newBlock"] as! [String : Any]) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelSendChatMessage(with body:String)->CLNetworkModel{
        let logInModel = CLNetworkModel.init(url: BASE_URL+SEND_CHAT_MESSAGE, requestMethod_: "POST")
        logInModel.requestBody = body
        return logInModel
    }
    
    func getChatSendResponseModel(dict:[String:Any])->Any?{
        let chatModel = ChatModel.init(dict:dict)
        return chatModel
    }
    
}
 
 
 
 class AlwisalAddToFavoriteResponseModel : NSObject{
    var errorMessage:String = ""
    var errorCode:Int = 0
    var userToken:String = ""
    var favorite:Bool = false
    init(dict:[String:Any?]) {
        
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let value = dict["favourite"] as? Bool{
            favorite = value
        }
    }
 }
 
 class AlwisalAddToLikeResponseModel : NSObject{
    var errorMessage:String = ""
    var errorCode:Int = 0
    var userToken:String = ""
    var liked:Bool = false
    init(dict:[String:Any?]) {
        
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let value = dict["liked"] as? Bool{
            liked = value
        }
    }
 }
 
 class AlwisalUserProfileResponseModel : NSObject{
    var errorMessage:String = ""
    var errorCode:Int = 0
    var id:Int = 0
    var age:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var gender:String = ""
    var location:String = ""
    var nationality:String = ""
    var phoneNo:String = ""
    var userEmail:String = ""
    var userLogin:String = ""
    init(dict:[String:Any?]) {
        
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let data = dict["data"] as? AnyObject{
            if let value = data["ID"] as? Int{
                id = value
            }
            if let value = data["age"] as? String{
                age = value
            }
            if let value = data["first_name"] as? String{
                firstName = value
            }
            if let value = data["last_name"] as? String{
                lastName = value
            }
            if let value = data["gender"] as? String{
                gender = value
            }
            if let value = data["location"] as? String{
                location = value
            }
            if let value = data["nationality"] as? String{
                nationality = value
            }
            if let value = data["phone_number"] as? String{
                phoneNo = value
            }
            if let value = data["user_email"] as? String{
                userEmail = value
            }
            if let value = data["user_login"] as? String{
                userEmail = value
            }
        }
    }
 }
 
 class AlwisalUpdateProfile: NSObject {
    var first_name : String  = ""
    var last_name : String = ""
    var email : String = ""
    var phone_number : String = ""
    var age : String = ""
    var gender : String = ""
    var address : String = ""
    var nationality:String = ""
    var user_password:String = ""
    func getRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        dict.updateValue(first_name as AnyObject, forKey: "first_name")
        //dict.updateValue(last_name, forKey: "last_name")
        //dict.updateValue(email, forKey: "email")
        dict.updateValue(phone_number as AnyObject, forKey: "phone_number")
       // dict.updateValue(age, forKey: "age")
        //dict.updateValue(gender, forKey: "gender")
        dict.updateValue(address as AnyObject, forKey: "location")
       // dict.updateValue(nationality, forKey: "nationality")
        print(dict)
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
   
 }
 
 class AlwisalUpdateProfileResponseModel : NSObject{
    var errorMessage:String = ""
    var errorCode:Int = 0
    var statusMessage:String = ""
    init(dict:[String:Any?]) {
        
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let value = dict["data"] as? String{
            statusMessage = value
        }
    }
 }
 
 class LikesResponseModel:NSObject{
    var likeItems = [LikesModel]()
    var errorMessage:String = ""
    var errorCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let _dict = dict["data"] as? NSArray{
            for item in _dict{
                likeItems.append(LikesModel.init(dict: item as! [String : Any?]))
            }
        }
    }
 }
 
 class LikesModel:NSObject{
    var id:Int64 = 0
    var title:String = ""
 
    init(dict:[String:Any?]) {
        if let value = dict["ID"] as? Int64{
            id = value
        }
        if let value = dict["post_title"] as? String{
            title = value
        }
    }
 }
 
 class FavoritesResponseModel:NSObject{
    var favoriteItems = [FavoritesModel]()
    var errorMessage:String = ""
    var errorCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        if let _dict = dict["data"] as? NSArray{
            for item in _dict{
                favoriteItems.append(FavoritesModel.init(dict: item as! [String : Any?]))
            }
        }
    }
 }
 
 class FavoritesModel:NSObject{
    var id:Int64 = 0
    var title:String = ""
    
    init(dict:[String:Any?]) {
        if let value = dict["ID"] as? Int64{
            id = value
        }
        if let value = dict["post_title"] as? String{
            title = value
        }
    }
 }
 
 
 class ChatResponseModel:NSObject{
    var chatItems = [ChatModel]()
    var errorMessage:String = ""
    var errorCode:Int = 0
    var uploadDir:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["error"] as? Int{
            errorCode = value
        }
        
        if let value = dict["upload_dir"] as? String{
            uploadDir = value
        }
        if let _dict = dict["data"] as? NSArray{
            for item in _dict{
                chatItems.append(ChatModel.init(dict: item as! [String : Any?]))
            }
        }
    }
 }
 
 class ChatModel:NSObject{
    var chatId:String = ""
    var chatOn:String = ""
    var filePath:String = ""
    var fromUser:String = ""
    var message:String = ""
    var status:String = ""
    var toUser:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["chat_id"] as? String{
            chatId = value
        }
        if let value = dict["chat_on"] as? String{
            chatOn = value
        }
        if let value = dict["file_path"] as? String{
            filePath = value
        }
        if let value = dict["from_user"] as? String{
            fromUser = value
        }
        if let value = dict["from_user"] as? Int64{
            fromUser = String(value)
        }
        if let value = dict["message"] as? String{
            message = value
        }
        if let value = dict["status"] as? String{
            status = value
        }
        if let value = dict["to_user"] as? String{
            toUser = value
        }
        if let value = dict["to_user"] as? Int64{
            fromUser = String(value)
        }
        
    }
 }

