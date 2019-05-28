//
//  Constants.swift
//  Alwisal
//
//  Created by Bibin Mathew on 4/30/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
struct Constant{
    static let AppName = "الوصال"
    struct Notifications{
        static let RootSettingNotification = "com.alwisal.initNotification"
        static let UserProfileNotification = "com.alwisal.userProfileNotification"
        static let PlayerArtistInfo = "com.alwisal.artistInfoNotification"
    }
    struct VariableNames {
        static let isLoogedIn = "isLoggedIn"
        static let userToken = "userToken"
        static let userName = "userName"
        static let userImage = "userImage"
        static let userId = "userId"
    }
    
    struct Colors {
        static let commonGrayColor = UIColor(red:0.39, green:0.40, blue:0.42, alpha:1.0)
        static let commonRoseColor = UIColor(red:0.60, green:0.05, blue:0.37, alpha:1.0) //9A0C5F
    }
    
    struct ErrorMessages {
        static let noNetworkMessage = "لا يوجد اتصال إنترنت. يرجى التحقق من إعدادات الاتصال الخاصة بك وحاول مرة أخرى!"
        static let serverErrorMessamge = "يتعذر الاتصال بالخادم ، يرجى المحاولة بعد قليل."
    }
    
    struct ImageNames {
        static let placeholderImage = "placeholder"
        static let placeholderArtistInfoImage = "songDefaultImage"
        static let profilePlaceholderImage = "placeholder"
        static let leftArrowImage = "leftArrow"
        struct tabImages{
            static let soundIcon = "soundIcon"
            static let muteIcon = "muteIcon"
            static let playIcon = "playIcon"
            static let pauseIcon = "pauseIcon"
        }
    }
    
    struct SegueIdentifiers {
        static let presenterToPresenterDetailSegue = "presenterToDetail"
        static let landingToNewsList = "landingToNewsList"
        static let landingToPresenterDetail = "landingToPrsenterDetails"
        static let landingToWebView = "landingToWebView"
    }
    struct AppKeys {
        static let googleClientID = "338103195232-0l3102r119pifji42ge14km2qhm14teh.apps.googleusercontent.com"
        static let twitterConsumerKey = "x0oIx3qZN9PLTxfXxnxbjB7jA"
        static let twitterConsumerSecret = "NtKfWYpxSyqS2HMx1YBtLrOoAuRZZ4zswe8joewEmrupPPny8E"
        static let artistInfoKey = "665b8ff2830d494379dbce3fb3b218a9"
    }
    
    struct Messages {
        static let okString = "حسنا"
        static let cancelString = "إلغاء"
        static let logInMessage = "الرجاء تسجيل الدخول لاستخدام هذه الميزة"
        static let InfoNotAvaliable = "المعلومات غير متوفرة"
        static let logoutMessage = "هل ترغب بالخروج؟"
        
    }
    static let sharingUrlString = "http://alwisal.radio.net/"
    static let facebookLink = "https://www.facebook.com/"
    static let twitterLink = "http://www.twitter.com/"
    static let whatsAppLink = "https://api.whatsapp.com/send?text=%D8%AF%D8%B9%D9%88%D8%A9%20%D9%85%D9%86%20%D8%AE%D8%A7%D8%AF%D9%85%20%D8%A7%D9%84%D8%AD%D8%B1%D9%85%D9%8A%D9%86%20%D8%A7%D9%84%D8%B4%D8%B1%D9%8A%D9%81%D9%8A%D9%86%20%D9%84%D8%AC%D9%84%D8%A7%D9%84%D8%A9%20%D8%A7%D9%84%D8%B3%D9%84%D8%B7%D8%A7%D9%86%20%D9%84%D8%AD%D8%B6%D9%88%D8%B1%20%D8%A7%D9%84%D9%82%D9%85%D8%A9%20%D8%A7%D9%84%D8%AE%D9%84%D9%8A%D8%AC%D9%8A%D8%A9%20%D8%A7%D9%84%D8%B7%D8%A7%D8%B1%D8%A6%D8%A9%20http://wisal.fm/cms/2019/05/24859"
    static let contactUsUrlString = "http://test.wisal.fm/contact?app=1"
    static let showsUrlString = "http://wisal.fm/cms/shows"
}

