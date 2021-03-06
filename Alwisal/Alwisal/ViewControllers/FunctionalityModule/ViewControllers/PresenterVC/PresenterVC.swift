//
//  PresenterVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/15/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
import MBProgressHUD
enum PageType{
    case PresenterPage
    case NewsPage
    case ArticlesPage
    case EventsPage
    case ShowsPage
}
class PresenterVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PresentercCollectionCellDelegate {

    @IBOutlet weak var noItemsFoundLabel: UILabel!
    @IBOutlet weak var pressnterCollectionView: UICollectionView!
    
    var presentersResponseModel:PresenterResponseModel?
    var newsResponseModel:NewsResponseModelForInnerListing?
    var articlesResponseModel:ArticlesResponseModel?
    var eventsResponseModel:EventsResponseModel?
    var showsResponseModel:ShowsResponseModel?
    var pageType:PageType?
    var pageIndex:Int = 1
    var noOfItems:Int = 10
    let refreshControl = UIRefreshControl()
    var isRefreshControl:Bool = false
    override func initView() {
        super.initView()
        addRefreshControl()
        callingApis()
    }
    
    func addRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refreshControleAction(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            pressnterCollectionView.refreshControl = refreshControl
        } else {
            pressnterCollectionView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshControleAction(_ sender: Any) {
       self.isRefreshControl = true
        reInitialisingApiVariables()
    }
    
    func reInitialisingApiVariables(){
        pageIndex = 1
        callingApis()
    }
    
    func callingApis(){
        if (pageType == PageType.PresenterPage){
            getPresentersApi()
        }
        else if(pageType == PageType.NewsPage){
            getLatestNewsApi()
        }
        else if(pageType == PageType.ArticlesPage){
            getArticlesApi()
        }
        else if(pageType == PageType.EventsPage){
            getEventsApi()
        }
        else if (pageType == PageType.ShowsPage){
            getShowsApi()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (pageType == PageType.PresenterPage){
            addingNavigationBarView(title:MenuItems.menuPresenters,fromTabBar: false)
        }
        else if(pageType == PageType.NewsPage){
            addingNavigationBarView(title: MenuItems.menuNews,fromTabBar: false)
        }
        else if(pageType == PageType.ArticlesPage){
            addingNavigationBarView(title: MenuItems.menuArticles,fromTabBar: false)
        }
        else if(pageType == PageType.EventsPage){
            addingNavigationBarView(title: MenuItems.menuArticles,fromTabBar: false)
        }
        else if(pageType == PageType.ShowsPage){
            addingNavigationBarView(title: MenuItems.menuShows,fromTabBar: false)
        }
    }
    
    
    //MARK- Collection View Datasources
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.pageType == PageType.PresenterPage){
            guard let _model = presentersResponseModel else {
                return 0
            }
            if(_model.presenterItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.presenterItems.count
        }
        if(self.pageType == PageType.NewsPage){
            guard let _model = newsResponseModel else {
                return 0
            }
            if(_model.newsItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.newsItems.count
        }
        if(self.pageType == PageType.ArticlesPage){
            guard let _model = articlesResponseModel else {
                return 0
            }
            if(_model.articleItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.articleItems.count
        }
        if(self.pageType == PageType.EventsPage){
            guard let _model = eventsResponseModel else {
                return 0
            }
            if(_model.eventsItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.eventsItems.count
        }
        if(self.pageType == PageType.ShowsPage){
            guard let _model = showsResponseModel else {
                return 0
            }
            if(_model.showsItems.count == 0){
                self.noItemsFoundLabel.isHidden = false
            }
            return _model.showsItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PresenterCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presenterCell", for: indexPath) as! PresenterCollectionCell
        if let _model = presentersResponseModel{
            cell.setCell(to: _model.presenterItems[indexPath.row])
        }
        if let _model = newsResponseModel{
            cell.setNewsCell(model: _model.newsItems[indexPath.row])
        }
        if let _model = articlesResponseModel{
            cell.setArticleCell(model: _model.articleItems[indexPath.row])
        }
        if let _model = eventsResponseModel{
            cell.setEventsCell(model: _model.eventsItems[indexPath.row])
        }
        if let _model = showsResponseModel{
            cell.setShowsCell(model: _model.showsItems[indexPath.row])
        }
        cell.tag = indexPath.row
        cell.delegate = self;
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if pageIndex>0 {
            if (pageType == PageType.PresenterPage){
                if let preResponse = self.presentersResponseModel {
                    if indexPath.row == preResponse.presenterItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getPresentersApi()
                    }
                }
            }
            else if (pageType == PageType.EventsPage) {
                if let eventsResponse = self.eventsResponseModel {
                    if indexPath.row == eventsResponse.eventsItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getEventsApi()
                    }
                }
            }
            else if (pageType == PageType.NewsPage) {
                if let newsResponse = self.newsResponseModel {
                    if indexPath.row == newsResponse.newsItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getLatestNewsApi()
                    }
                }
            }
            else if (pageType == PageType.ArticlesPage) {
                if let articleResponse = self.articlesResponseModel {
                    if indexPath.row == articleResponse.articleItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getArticlesApi()
                    }
                }
            }
            else if (pageType == PageType.ShowsPage) {
                if let showsResponse = self.showsResponseModel {
                    if indexPath.row == showsResponse.showsItems.count - 1 {
                        pageIndex = pageIndex + 1
                        getShowsApi()
                    }
                }
            }
        }
    }
    
    // MARK: Collection Cell Delegates
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadDetailPageAtIndex(index: indexPath.row)
    }
    
    func backButtonActionDelegateWithTag(tag: NSInteger) {
        loadDetailPageAtIndex(index: tag)
    }
    
    func loadDetailPageAtIndex(index:Int){
        if let _model = presentersResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.presenterItems[index])
        }
        if let _model = newsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.newsItems[index])
        }
        if let _model = articlesResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.articleItems[index])
        }
        if let _model = eventsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.eventsItems[index])
        }
        if let _model = showsResponseModel{
            performSegue(withIdentifier: Constant.SegueIdentifiers.presenterToPresenterDetailSegue, sender: _model.showsItems[index])
        }
    }
    
    func twitterButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            let selModel = _model.presenterItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = newsResponseModel{
            let selModel = _model.newsItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = articlesResponseModel{
            let selModel = _model.articleItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = eventsResponseModel{
            let selModel = _model.eventsItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
        if let _model = showsResponseModel{
            let selModel = _model.showsItems[tag]
            loadWebUrl(webUrlString: (selModel.twitterLink))
        }
    }
    
    func fbButtonActionDelegateWithTag(tag: NSInteger) {
        if let _model = presentersResponseModel{
            let selModel = _model.presenterItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = newsResponseModel{
            let selModel = _model.newsItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = articlesResponseModel{
            let selModel = _model.articleItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = eventsResponseModel{
            let selModel = _model.eventsItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
        if let _model = showsResponseModel{
            let selModel = _model.showsItems[tag]
            loadWebUrl(webUrlString: (selModel.fbLink))
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  getPresentersApi(){
        if (!isRefreshControl){
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        PresenterModuleManager().callingPresentersListApi(with: self.pageIndex, noOfItem: self.noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if let model = model as? PresenterResponseModel{
                if (self.pageIndex == 1){
                    self.presentersResponseModel = nil
                }
                if let presentersRespone = self.presentersResponseModel {
                    presentersRespone.presenterItems.append(contentsOf: model.presenterItems)
                }
                else{
                    self.presentersResponseModel = model
                }
                self.pressnterCollectionView.reloadData()
                if model.presenterItems.count<self.noOfItems {
                    self.pageIndex = -1
                }
            }
        }) { (ErrorType) in
             MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getLatestNewsApi(){
        if (!self.isRefreshControl){
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        NewsModuleManager().callingGetNewsListForInnerPageApi(with: self.pageIndex, noOfItem: self.noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if let model = model as? NewsResponseModelForInnerListing{
                if (self.pageIndex == 1){
                    self.newsResponseModel = nil
                }
                if let newsRespone = self.newsResponseModel {
                    newsRespone.newsItems.append(contentsOf: model.newsItems)
                }
                else{
                    self.newsResponseModel = model
                }
                self.pressnterCollectionView.reloadData()
                if model.newsItems.count<self.noOfItems {
                    self.pageIndex = -1
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getArticlesApi(){
        if (!self.isRefreshControl){
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        ArticlesManager().callingGetArticlesListApi(with: self.pageIndex, noOfItem: self.noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if let model = model as? ArticlesResponseModel{
                if (self.pageIndex == 1){
                    self.articlesResponseModel = nil
                }
                if let articlesRespone = self.articlesResponseModel {
                    articlesRespone.articleItems.append(contentsOf: model.articleItems)
                }
                else{
                    self.articlesResponseModel = model
                }
                self.pressnterCollectionView.reloadData()
                if model.articleItems.count<self.noOfItems {
                    self.pageIndex = -1
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    func getEventsApi(){
        if (!self.isRefreshControl){
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        EventsManager().callingGetEventsListApi(with: self.pageIndex, noOfItem: self.noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if let model = model as? EventsResponseModel{
                if (self.pageIndex == 1){
                    self.eventsResponseModel = nil
                }
                if let eventsRespone = self.eventsResponseModel {
                    eventsRespone.eventsItems.append(contentsOf: model.eventsItems)
                }
                else{
                    self.eventsResponseModel = model
                }
                self.pressnterCollectionView.reloadData()
                if model.eventsItems.count<self.noOfItems {
                    self.pageIndex = -1
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    //Get Shows Api
    
    func getShowsApi(){
        if (!self.isRefreshControl){
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        ShowsManager().callingGetShowsListApi(with: self.pageIndex, noOfItem: self.noOfItems, success: { (model) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if let model = model as? ShowsResponseModel{
                if (self.pageIndex == 1){
                    self.showsResponseModel = nil
                }
                if let showsRespone = self.showsResponseModel {
                    showsRespone.showsItems.append(contentsOf: model.showsItems)
                }
                else{
                    self.showsResponseModel = model
                }
                self.pressnterCollectionView.reloadData()
                if model.showsItems.count<self.noOfItems {
                    self.pageIndex = -1
                }
            }
        }) { (ErrorType) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isRefreshControl = false
            self.refreshControl.endRefreshing()
            if(ErrorType == .noNetwork){
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.noNetworkMessage, parentController: self)
            }
            else{
                AlwisalUtility.showDefaultAlertwith(_title: Constant.AppName, _message: Constant.ErrorMessages.serverErrorMessamge, parentController: self)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constant.SegueIdentifiers.presenterToPresenterDetailSegue){
            let presentDetail = segue.destination as! PresenterDetailVC
            if let _model = presentersResponseModel{
                presentDetail.presentersModel = sender as? PresenterModel
                presentDetail.pageType = PageType.PresenterPage
            }
            if let _model = newsResponseModel{
                presentDetail.newsModel = sender as? NewsModel
                presentDetail.pageType = PageType.NewsPage
            }
            if let _model = articlesResponseModel{
                presentDetail.articlesModel = sender as? ArticlesModel
                presentDetail.pageType = PageType.ArticlesPage
            }
            if let _model = eventsResponseModel{
                presentDetail.eventsModel = sender as? EventsModel
                presentDetail.pageType = PageType.EventsPage
            }
            if let _model = showsResponseModel{
                presentDetail.showsModel = sender as? ShowsModel
                presentDetail.pageType = PageType.ShowsPage
            }
        }
    }

}
