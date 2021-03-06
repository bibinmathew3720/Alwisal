//
//  LandingPageVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/1/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVKit
import GoogleMobileAds
class LandingPageVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LandingCollectionCellDelegate {
    
    @IBOutlet weak var firstAdImageView: UIImageView!
    @IBOutlet weak var secondAdImageView: UIImageView!
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var leftHeadingLabel: UILabel!
    @IBOutlet weak var rightHeadingLabel: UILabel!
    @IBOutlet weak var rightSubHeadingLabel: UILabel!
    @IBOutlet weak var landingCollectionView: UICollectionView!
    @IBOutlet weak var landingPageTopLikeButton: UIButton!
    @IBOutlet weak var landingPageTopFavoriteButton: UIButton!
    
    @IBOutlet weak var newsVideoCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewBackView: UIView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var newsView: UIView!
    
    var newsResponseModel:NewsResponseModel?
    var newsVideosResponseModel:NewsWithVideosResponseModel?
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var leftArrowButton: UIButton!
    var artistInfoModel:ArtistInfoModel?
    var currentSong:String?
    var nowPlayingResponseModel:AlwisalNowPlayingResponseModel?
    var selectedVideoNewsIndex:Int = 0
    
    var newsPageIndex:Int = 1
    var noOfItems:Int = 10
    var newsWithVideosPageIndex:Int = 1
    
    var bannerView: DFPBannerView!

    var isNewsApiCompleted:Bool = false
    var isNewsVideoApiCompleted:Bool = false
    
    override func initView() {
        super.initView()
        initialisingAd()
        initialisingSecondAd()
        //collectionViewBackView.addShadowToControls()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotifications(aNot:)), name: Notification.Name(Constant.Notifications.PlayerArtistInfo), object: nil)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: Constant.VariableNames.isLoogedIn)
        if(isLoggedIn){
            MBProgressHUD.showAdded(to: self.view, animated: true)
                self.callingGetUserProfilesApi(withCompletion: { (completion) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.callingNewsWithVideosApi(withCompletion: { (completion) in
                        if(completion){
                            self.getLatestNewsApi()
                            //                    self.getSongHistory(success: { (model) in
                            //                        if let model = model as? SongHistoryResponseModel{
                            //                            self.songHistoryResponseModel = model
                            //                            self.landingCollectionView.reloadData()
                            //                            self.getLatestNewsApi()
                            //
                            //                            if((model.historyItems.count)>0){
                            //                                self.populateLastPlayedSongDetailsAtTop(lastSong: model.historyItems.first!)
                            //                            }
                            //                        }
                            //                    }) { (ErrorType) in
                            //
                            //                    }
                        }
                    });
                })
        }
        else{
            self.callingNewsWithVideosApi { (completion) in
                if(completion){
                     self.getLatestNewsApi()
                }
            }
//            self.callingNowPlayingApi { (completion) in
//                self.getSongHistory(success: { (model) in
//                    if let model = model as? SongHistoryResponseModel{
//                        self.songHistoryResponseModel = model
//                        self.landingCollectionView.reloadData()
//                        self.getLatestNewsApi()
//                    }
//                }) { (ErrorType) in
//
//                }
//            }
           
        }
      // self.addingTimerForCallingCurrentSongInfoApi()
    }
    
    func initialisingAd(){
        bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Constant.adUnitIdString
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
        bannerView.delegate = self
        firstAdImageView.addSubview(bannerView)
    }
    
    func initialisingSecondAd(){
        bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Constant.secondAdIdString
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
        secondAdImageView.addSubview(bannerView)
    }
    
    func addingTimerForCallingCurrentSongInfoApi(){
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        print("Calling Current Song Info Api")
        self.callingNowPlayingApi { (completion) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setBlackgradientOnBottomOfView(gradientView: self.songImageView)
        let navigationBar = addingNavigationBarView(title: "الوصل", fromTabBar: true)
        navigationBar.headingLabel.isHidden = true
        navigationBar.logoImageView.isHidden = false
        navigationBar.refreshIcon.isHidden = false
        navigationBar.leftHomeIcon.isHidden = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constant.Notifications.PlayerArtistInfo), object: nil)
    }
    
    override func infoButtonActionDelegate() {
        self.newsPageIndex = 1
        self.newsWithVideosPageIndex = 1
        self.callingNewsWithVideosApi { (completion) in
            if(completion){
                self.getLatestNewsApi()
            }
        }
    }
    
    //MARK:- Notification Observer
    @objc func receiveNotifications(aNot: Notification) {
        //self.currentSong = aNot.object as? String
        if let name = aNot.object as? String {
            let arr = name.components(separatedBy: " -")
            if arr.count > 0 {
                print(arr[0])
               // getArtistInfo(name: arr[0])
            }
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if let currentSong = self.currentSong{
            if(self.isUserLoggedIn()){
                self.callingAddToFavoriteApiForCurrentSong(soName: currentSong,buttton:sender )
            }
        }
    }
    
    func  callingAddToFavoriteApiForCurrentSong(soName:String,buttton:UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingFavoriteApi(with: getFavoriteRequestBodyForCurrentSong(songName: soName), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToFavoriteResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    buttton.isSelected = model.favorite
                    //self.landingCollectionView.reloadData()
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
    
    func getFavoriteRequestBodyForCurrentSong(songName:String)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songName, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        if let nowPlayingResponse = self.nowPlayingResponseModel{
            self.loadSongInfoView(nowPlayingInfo: nowPlayingResponse)
        }
        else{
            AlwisalUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message:Constant.Messages.InfoNotAvaliable, parentController: self, completion: { (okSuccess) in
                
            })
        }
//        if let art = self.artistInfoModel{
//            self.loadSongInfoView(artistInfo: art)
//        }
//        else{
//            AlwisalUtility.showDefaultAlertwithCompletionHandler(_title: Constant.AppName, _message:Constant.Messages.InfoNotAvaliable, parentController: self, completion: { (okSuccess) in
//
//            })
//        }
    }
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if let currentSong = self.currentSong{
            if(self.isUserLoggedIn()){
                self.callingLikeApiForCurrentSong(soName: currentSong,button:sender )
            }
        }
    }
    
    //MARK : Calling Like Api For Current Song
    
    func  callingLikeApiForCurrentSong(soName:String,button:UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLikeApi(with: getLikeRequestBodyForCurrentSong(songName: soName), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToLikeResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    button.isSelected = model.liked
                    self.landingCollectionView.reloadData()
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
    
    func getLikeRequestBodyForCurrentSong(songName:String)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songName, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    @IBAction func recentlyPlayedButtonAction(_ sender: UIButton) {
        self.loadPlayListView(at: self.tabBarController!)
    }
    
    //MARK:- Collection View Datasources
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == newsVideoCollectionView{
            let page = scrollView.contentOffset.x / scrollView.frame.size.width;
            self.selectedVideoNewsIndex = Int(page)
            if self.selectedVideoNewsIndex <= 0{
                self.leftArrowButton.isHidden = true
            }
            else{
                self.leftArrowButton.isHidden = false
            }
            if let _model = newsVideosResponseModel{
                if ((self.selectedVideoNewsIndex+1) >= _model.newsItems.count){
                    self.rightArrowButton.isHidden = true
                }
                else{
                    self.rightArrowButton.isHidden = false
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.newsCollectionView){
            guard let _model = newsResponseModel else {
                return 0
            }
            return _model.newsItems.count
        }
        else if (collectionView == self.newsVideoCollectionView){
            guard let _model = newsVideosResponseModel else {
                return 0
            }
            return _model.newsItems.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.newsVideoCollectionView){
            let cell:NewsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCollectionCell
            if let _model = newsVideosResponseModel{
                cell.setCell(to: _model.newsItems[indexPath.row])
                if self.selectedVideoNewsIndex <= 0{
                    self.leftArrowButton.isHidden = true
                }
                else{
                   self.leftArrowButton.isHidden = false
                }
                if ((self.selectedVideoNewsIndex+1) >= _model.newsItems.count){
                    self.rightArrowButton.isHidden = true
                }
                else{
                   self.rightArrowButton.isHidden = false
                }
            }
            return cell
        }
        else{
            let cell:NewsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCollectionCell
            if let _model = newsResponseModel{
                cell.setCell(to: _model.newsItems[indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
       if (collectionView == newsVideoCollectionView){
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: (collectionView.frame.size.width - 5)/2, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView == newsVideoCollectionView){
            return 0
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView == newsVideoCollectionView){
            return 0
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.newsCollectionView){
            if let _model = newsResponseModel{
                performSegue(withIdentifier: Constant.SegueIdentifiers.landingToPresenterDetail, sender: _model.newsItems[indexPath.row])
            }
        }
        else if (collectionView == self.newsVideoCollectionView){
            if let _model = newsVideosResponseModel{
                let news = _model.newsItems[indexPath.row]
                performSegue(withIdentifier: Constant.SegueIdentifiers.landingToWebView, sender: news)
//                self.playVideoWithNewsDetails(newsDetail: news)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        print("--------Index----------")
        print(indexPath.row)
        if collectionView == newsCollectionView{
            if newsPageIndex>0 {
                if let newsResponse = self.newsResponseModel {
                    if self.isNewsApiCompleted{
                        if indexPath.row == 0{
                            newsPageIndex = newsPageIndex + 1
                            getLatestNewsApi()
                        }
                    }
//                    if indexPath.row == newsResponse.newsItems.count - 1 {
//                        newsPageIndex = newsPageIndex + 1
//                        getLatestNewsApi()
//                    }
                }
            }
        }
        else if collectionView == newsVideoCollectionView{
            if newsWithVideosPageIndex>0 {
                if let newsVideoResponse = self.newsVideosResponseModel {
                    if self.isNewsVideoApiCompleted{
                        if indexPath.row == 0 {
                            newsWithVideosPageIndex = newsWithVideosPageIndex + 1
                            callingNewsWithVideosApi { (status) in
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Playing News Video 
    
    func playVideoWithNewsDetails(newsDetail:NewsModel){
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //MARK:- Webservice Calls
    
    func callingNowPlayingApi(withCompletion:@escaping (Bool)-> ()){
        ArtistInfoManager().callingNowPlayingApi(with: "", success: { (repsonse) in
            withCompletion(true)
            if let model = repsonse as? AlwisalNowPlayingResponseModel{
                self.nowPlayingResponseModel = model
                self.populateCurrentSngInfo()
                self.updateNowPlayingInfoView(nowPlayingInfo: model)
            }
            
        }) { (error) in
            withCompletion(false)
        }
    }
    
    func populateCurrentSngInfo(){
        if let playingResModel = self.nowPlayingResponseModel {
            self.rightHeadingLabel.text = playingResModel.title
            self.rightSubHeadingLabel.text = playingResModel.artist
            self.landingPageTopLikeButton.isSelected = playingResModel.likeStatus
            self.landingPageTopFavoriteButton.isSelected = playingResModel.favoriteStatus
            self.currentSong = playingResModel.artist+" - "+playingResModel.title
            DispatchQueue.main.async {
                
                 guard let encodedUrlstring = playingResModel.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
                self.songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
            }
        }
    }
    
    func getArtistInfo(name: String) {
        ArtistInfoManager().callingGetArtistInfoApi(with: name, success: { (model) in
            let artistInfo = model as! ArtistInfoModel
            self.artistInfoModel = artistInfo
            self.rightHeadingLabel.text = name
            self.rightSubHeadingLabel.text = self.artistInfoModel?.artistName
            self.landingPageTopLikeButton.isSelected = false
            self.landingPageTopFavoriteButton.isSelected = false
            
            DispatchQueue.main.async {
                 guard let encodedUrlstring = artistInfo.artistImage!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
                self.songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
            }
            
        }) { (error) in
            
        }
    }
    func getLatestNewsApi(){
        self.isNewsApiCompleted = false
        MBProgressHUD.showAdded(to: self.newsView, animated: true)
        NewsModuleManager().callingGetNewsListApi(with: self.newsPageIndex, noOfItem: self.noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.newsView, animated: true)
            if let model = model as? NewsResponseModel{
                if (self.newsPageIndex == 1){
                    self.newsResponseModel = nil
                }
                if let newsRespone = self.newsResponseModel {
                    //newsRespone.newsItems.append(contentsOf: model.newsItems)
                    
                    let totalIndices = model.newsItems.count - 1 // We get this value one time instead of once per iteration.
                    var reversedNews = [NewsModel]()
                    for arrayIndex in 0...totalIndices {
                        reversedNews.append(model.newsItems[totalIndices - arrayIndex])
                    }
                    
                    for item in reversedNews{
                        newsRespone.newsItems.insert(item, at: 0)
                    }
                    self.newsCollectionView.reloadData()
                    self.newsCollectionView.scrollToItem(at: IndexPath.init(row: model.newsItems.count - 1, section: 0), at: .left, animated: false)
                }
                else{
                    self.newsResponseModel = model
                    self.newsCollectionView.reloadData()
                    self.newsCollectionView.scrollToItem(at: IndexPath.init(row: model.newsItems.count - 1, section: 0), at: .left, animated: false)
                }
                
                if model.newsItems.count<self.noOfItems {
                    self.newsPageIndex = -1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  self.isNewsApiCompleted = true
                }
                
            }
           
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.newsView, animated: true)
            self.isNewsApiCompleted = true
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func callingNewsWithVideosApi(withCompletion:@escaping (Bool)-> ()){
        print("---------Page Index ----")
        print(newsWithVideosPageIndex)
        isNewsVideoApiCompleted = false
        MBProgressHUD.showAdded(to: self.collectionViewBackView, animated: true)
        NewsModuleManager().callingGetNewsListWithVideosApi(with: self.newsWithVideosPageIndex, noOfItem: noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.collectionViewBackView, animated: true)
            withCompletion(true)
            if let model = model as? NewsWithVideosResponseModel{
                if (self.newsWithVideosPageIndex == 1){
                    self.newsVideosResponseModel = nil
                }
                if let newsRespone = self.newsVideosResponseModel {
                    let totalIndices = model.newsItems.count - 1 // We get this value one time instead of once per iteration.
                    var reversedNews = [NewsModel]()
                    for arrayIndex in 0...totalIndices {
                        reversedNews.append(model.newsItems[totalIndices - arrayIndex])
                    }
                    
                    for item in reversedNews{
                        newsRespone.newsItems.insert(item, at: 0)
                    }
                    self.newsVideoCollectionView.reloadData()
                    self.newsVideoCollectionView.scrollToItem(at: IndexPath.init(row: model.newsItems.count, section: 0), at: .left, animated: false)
                }
                else{
                    self.newsVideosResponseModel = model
                    self.newsVideoCollectionView.reloadData()
                    self.newsVideoCollectionView.scrollToItem(at: IndexPath.init(row: model.newsItems.count - 1, section: 0), at: .left, animated: false)
                }
                if model.newsItems.count<self.noOfItems {
                    self.newsWithVideosPageIndex = -1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  self.isNewsVideoApiCompleted = true
                }
            }
            
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.collectionViewBackView, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            withCompletion(false)
        }
    }
    
    func likeButtonActionDelegateWithTag(tag: NSInteger) {
        if(isUserLoggedIn()){
            if let _model = songHistoryResponseModel{
                self.callingLikeApi(songHistory: _model.historyItems[tag])
            }
        }
    }
    
    func favoriteButtonActionDelegateWithTag(tag: NSInteger) {
        if(isUserLoggedIn()){
            if let _model = songHistoryResponseModel{
                self.callingAddToFavoriteApi(songHistory: _model.historyItems[tag])
            }
        }
        
    }
    //MARK : Calling Favorite Api
    
    func  callingAddToFavoriteApi(songHistory:SongHistoryModel){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingFavoriteApi(with: getFavoriteRequestBody(songHistoryModel: songHistory), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToFavoriteResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    songHistory.isFavorited = model.favorite
                    self.landingCollectionView.reloadData()
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
    
    func getFavoriteRequestBody(songHistoryModel:SongHistoryModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songHistoryModel.artist+" - "+songHistoryModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK : Calling Like Api
    
    func  callingLikeApi(songHistory:SongHistoryModel){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserModuleManager().callingLikeApi(with: getLikeRequestBody(songHistoryModel: songHistory), success: {
            (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let model = model as? AlwisalAddToLikeResponseModel{
                if model.errorCode == 1{
                    AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: model.errorMessage, parentController: self)
                }
                else{
                    songHistory.isLiked = model.liked
                    self.landingCollectionView.reloadData()
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
    
    func getLikeRequestBody(songHistoryModel:SongHistoryModel)->String{
        var dict:[String:String] = [String:String]()
        dict.updateValue(songHistoryModel.artist+" - "+songHistoryModel.title, forKey: "title")
        return AlwisalUtility.getJSONfrom(dictionary: dict)
    }
    
    //MARK: Prepare Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constant.SegueIdentifiers.landingToNewsList){
            let presentersVC = segue.destination as! PresenterVC
            presentersVC.pageType = PageType.NewsPage
        }
        else if(segue.identifier == Constant.SegueIdentifiers.landingToPresenterDetail){
            let presentDetail = segue.destination as! PresenterDetailVC
            presentDetail.newsModel = sender as? NewsModel
            presentDetail.pageType = PageType.NewsPage
        }
        else if (segue.identifier == Constant.SegueIdentifiers.landingToWebView){
            let youtubeVideoVC = segue.destination as! YouTubeVideoVC
            youtubeVideoVC.newsModel = sender as? NewsModel
        }
    }
    
    //MARK: Get User Profiles
    
    func callingGetUserProfilesApi(withCompletion:@escaping (Bool)-> ()){
        UserModuleManager().callingGetUserProfilesApi(with: "", success: { (model) in
            if let model = model as? AlwisalUserProfileResponseModel{
                //UserDefaults.standard.set(model.firstName+" "+model.lastName, forKey: Constant.VariableNames.userName)
                UserDefaults.standard.set(model.userEmail, forKey: Constant.VariableNames.userName)
                UserDefaults.standard.set(model.id, forKey: Constant.VariableNames.userId)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notifications.UserProfileNotification), object: nil)
                withCompletion(true)
                
            }
        }) {(ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
            withCompletion(false)
        }
    }
    
    func populateLastPlayedSongDetailsAtTop(lastSong:SongHistoryModel){
        guard let modal = self.nowPlayingResponseModel else{
            self.currentSong = lastSong.artist+" - "+lastSong.title
             guard let encodedUrlstring = lastSong.imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
            self.songImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
            self.rightHeadingLabel.text = lastSong.title
            self.rightSubHeadingLabel.text = lastSong.artist
            return
        }
    }

    @IBAction func topVideoImageRightButtonAction(_ sender: UIButton) {
        if let videoResponse = self.newsVideosResponseModel{
            if videoResponse.newsItems.count > (selectedVideoNewsIndex+1){
                selectedVideoNewsIndex = selectedVideoNewsIndex + 1
                newsVideoCollectionView.scrollToItem(at: IndexPath.init(row: selectedVideoNewsIndex, section: 0), at: .centeredHorizontally, animated: true)
                if videoResponse.newsItems.count <= (selectedVideoNewsIndex+1){
                    self.rightArrowButton.isHidden = true
                }
                if selectedVideoNewsIndex>0{
                    self.leftArrowButton.isHidden = false
                }
            }
        }
    }
    
    @IBAction func topVideoImageLeftButtonAction(_ sender: UIButton) {
        
        selectedVideoNewsIndex = selectedVideoNewsIndex - 1
        newsVideoCollectionView.scrollToItem(at: IndexPath.init(row: selectedVideoNewsIndex, section: 0), at: .centeredHorizontally, animated: true)
        if let videoResponse = self.newsVideosResponseModel{
            if(selectedVideoNewsIndex <= 0){
                self.leftArrowButton.isHidden = true
            }
            if videoResponse.newsItems.count > (selectedVideoNewsIndex+1){
                self.rightArrowButton.isHidden = false
            }
        }
    }
}


extension UIView {
    func addShadowToControls() {
        self.layer.shadowColor = UIColor(red:15/255, green:33/255, blue:61/255, alpha:0.28).cgColor
        layer.shadowOffset = CGSize(width: 2.3, height: 3.3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        layer.masksToBounds = false
    }
    
}

extension LandingPageVC:GADAdSizeDelegate{
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        //let height = adSize.size.height
        //let width = adSize.size.width
    }
}

extension LandingPageVC:GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
       // AlwisalUtility.showDefaultAlertwith(_title: "Ad Error", _message: error.description, parentController: self)
    }
}

extension LandingPageVC:GADAppEventDelegate{
    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print(name)
        print(info)
        
    }
}
