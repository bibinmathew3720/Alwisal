//
//  PlaylistView.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/26/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
protocol PlayListViewDelegate: class{
    func backButtonActionDelegate()
}

class PlaylistView: UIView,UITableViewDataSource,UITableViewDelegate,PlayListCellDelegate {
    @IBOutlet weak var recentlyPlayeedLabel: UILabel!
    @IBOutlet weak var playListTableView: UITableView!
    @IBOutlet weak var backArrowImageView: UIImageView!
    weak var delegate:PlayListViewDelegate?
    var songHistoryModel:SongHistoryResponseModel?
    override func awakeFromNib() {
       super.awakeFromNib()
        self.playListTableView.dataSource = self
        self.playListTableView.delegate = self
         self.playListTableView.register(UINib.init(nibName: "PlayListCell", bundle: nil), forCellReuseIdentifier: "playListCell")
        recentlyPlayeedLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
    func populateSongHistory(songHistory:SongHistoryResponseModel){
        songHistoryModel = songHistory
        self.playListTableView.reloadData()
    }
    
    //MARK: Table View Datasource and Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _model = songHistoryModel else {
            return 0
        }
        return _model.historyItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
            return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let playListCell = tableView.dequeueReusableCell(withIdentifier: "playListCell", for: indexPath) as! PlayListCell
        if let _model = songHistoryModel{
            playListCell.setHistoryCell(songHistory:(_model.historyItems[indexPath.row]))
        }
        if(indexPath.row == 0){
            playListCell.verticalLabel.text = "NOW"
            
        }
        else if(indexPath.row == 1){
            playListCell.verticalLabel.text = ""
        }
        else{
            playListCell.verticalLabel.text = ""
        }
        playListCell.delegate = self
        return playListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.backButtonActionDelegate()
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        delegate?.backButtonActionDelegate()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
