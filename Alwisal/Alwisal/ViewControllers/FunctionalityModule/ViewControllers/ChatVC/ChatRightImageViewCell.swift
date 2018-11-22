//
//  ChatRightImageViewCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/17/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ChatRightImageViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chatRightImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialisation()
        // Initialization code
    }
    
    func initialisation(){
        self.chatRightImageView.layer.borderColor = UIColor.white.cgColor
        self.chatRightImageView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setChatMessageDetails(chatMessageDetails:ChatModel){
         timeLabel.text = AlwisalUtility().convertDateToString(dateString: chatMessageDetails.chatOn)
    }

}
