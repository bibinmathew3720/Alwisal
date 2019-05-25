//
//  SongInfoView.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/17/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
protocol SongInfoViewDelegate: class{
    func backButtonActionDelegateFromSongInfo()
}
class SongInfoView: UIView,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var songInfoBackImage: UIImageView!
    @IBOutlet weak var songInfoTableView: UITableView!
     weak var delegate:SongInfoViewDelegate?
    var nowPlayingInfo:AlwisalNowPlayingResponseModel?
    override func awakeFromNib() {
        songInfoTableView.dataSource = self
        songInfoTableView.delegate = self
        self.songInfoTableView.register(UINib.init(nibName: "SongInfoCell", bundle: nil), forCellReuseIdentifier: "songInfoCell")
         self.songInfoTableView.register(UINib.init(nibName: "SongInfoLastCell", bundle: nil), forCellReuseIdentifier: "songInfoLast")
    }
    
    func populateSongInfo(nowPlayingSongInfo:AlwisalNowPlayingResponseModel){
        nowPlayingInfo = nowPlayingSongInfo
        if let artistName = nowPlayingInfo?.artist{
            self.artistNameLabel.text = artistName
        }
        if let artistImage = nowPlayingInfo?.imagePath{
             guard let encodedUrlstring = artistImage.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else { return  }
            self.artistImageView.sd_setImage(with: URL(string: encodedUrlstring), placeholderImage: UIImage(named: Constant.ImageNames.placeholderArtistInfoImage))
        }
        self.songInfoTableView.reloadData()
    }
    
    //MARK: Table View Datasource and Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 3){
            let songInfoLastCell = tableView.dequeueReusableCell(withIdentifier: "songInfoLast", for: indexPath) as! SongInfoLastCell
            return songInfoLastCell
        }
        else{
            let songInfoCell = tableView.dequeueReusableCell(withIdentifier: "songInfoCell", for: indexPath) as! SongInfoCell
            if let _model = nowPlayingInfo{
                if(indexPath.row == 0){
                    songInfoCell.itemNameLabel.text = String(format: "Listeners - %d", _model.currentListeners)
                    songInfoCell.songImageView?.image = UIImage.init(named: "listeners")
                    
                }
                else if(indexPath.row == 1){
                    songInfoCell.itemNameLabel.text = String(format: "Peak Listeners - %d", _model.peakListeners)
                    songInfoCell.songImageView?.image = UIImage.init(named: "peakListeneres")
                }
                else if(indexPath.row == 2){
                    songInfoCell.itemNameLabel.text = String(format: "Stream Website : %@",_model.streamPath)
                    songInfoCell.songImageView?.image = UIImage.init(named: "streamwebsite")
                }
            }
            else{
                if(indexPath.row == 0){
                    songInfoCell.itemNameLabel.text = String(format: "Listeners - %@", "0")
                    songInfoCell.songImageView?.image = UIImage.init(named: "listeners")
                    
                }
                else if(indexPath.row == 1){
                    songInfoCell.itemNameLabel.text = String(format: "Peak Listeners - %@", "0")
                    songInfoCell.songImageView?.image = UIImage.init(named: "peakListeneres")
                }
                else if(indexPath.row == 2){
                    songInfoCell.itemNameLabel.text = String(format: "Stream Website :")
                    songInfoCell.songImageView?.image = UIImage.init(named: "streamwebsite")
                }
            }
            //songInfoCell.delegate = self
            return songInfoCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _model = nowPlayingInfo{
            if(indexPath.row == 2){
                if let url = URL(string: _model.streamPath) {
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:])
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.backButtonActionDelegateFromSongInfo()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.backButtonActionDelegateFromSongInfo()
    }
    
    //MARK: PlayList Cell Delegate
    
    func closeButtonActionDelegate(){
        delegate?.backButtonActionDelegateFromSongInfo()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
