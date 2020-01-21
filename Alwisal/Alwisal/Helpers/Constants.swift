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
    
    struct Titles {
        static let muteText = "كتم" //Mute
        static let soundText = "الصوت" //The sound
    }
    
    static let sharingUrlString = "https://www.wisal.fm/"
    static let facebookLink = "https://www.facebook.com/AlWisal"
    static let twitterLink = "https://twitter.com/al_wisal"
    static let instagramLink = "https://www.instagram.com/al_wisal/"
    static let whatsAppLink = "https://api.whatsapp.com/send?text=%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9%20%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9%20-%20Al%20Wisal%20http://wisal.fm/cms"
    static let contactUsUrlString = "http://test.wisal.fm/contact?app=1"
    static let showsUrlString = "http://wisal.fm/cms/shows"
    static let podCastUrlString = "https://www.wisal.fm/cms/podcasts"
    
    static let adUnitIdString = "/96098159/AW_MobileAppBanner_320x50_1"
    static let secondAdIdString = "/96098159/AW_MobileAppBanner_320x50_2"
}

