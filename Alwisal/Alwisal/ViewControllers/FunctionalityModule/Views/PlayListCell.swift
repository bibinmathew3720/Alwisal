//
//  PlayListCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 5/26/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit
protocol PlayListCellDelegate: class{
    
}
class PlayListCell: UITableViewCell {

    @IBOutlet weak var verticalLabel: UILabel!
    @IBOutlet weak var singerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    weak var delegate:PlayListCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        verticalLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHistoryCell(songHistory:SongHistoryModel){
        titleLabel.text = songHistory.title
        singerNameLabel.text = songHistory.artist
        timeLabel.text = AlwisalUtility().convertDateInMillisecondsToString(dateInMilliseconds: songHistory.songDate)
        singerImageView.sd_setImage(with: URL(string: songHistory.imagePath), placeholderImage: UIImage(named: Constant.ImageNames.profilePlaceholderImage))
    }
    
}
