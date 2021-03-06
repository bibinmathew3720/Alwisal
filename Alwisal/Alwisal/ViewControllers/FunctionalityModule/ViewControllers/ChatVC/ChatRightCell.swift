//
//  ChatRightCell.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/17/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ChatRightCell: UITableViewCell {
    @IBOutlet weak var chatMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChatMessageDetails(chatMessageDetails:ChatModel){
        chatMessageLabel.text = chatMessageDetails.message
        timeLabel.text = AlwisalUtility().convertDateToString(dateString: chatMessageDetails.chatOn)
    }

}
