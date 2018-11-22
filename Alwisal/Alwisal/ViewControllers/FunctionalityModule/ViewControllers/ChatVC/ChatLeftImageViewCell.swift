//
//  ChatLeftImageViewCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/17/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ChatLeftImageViewCell: UITableViewCell {

    @IBOutlet weak var chatLeftImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialisation()
        // Initialization code
    }
    
    func initialisation(){
        self.chatLeftImageView.layer.borderColor = UIColor.white.cgColor
        self.chatLeftImageView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChatMessageDetails(chatMessageDetails:ChatModel){
         timeLabel.text = AlwisalUtility().convertDateToString(dateString: chatMessageDetails.chatOn)
    }

}
