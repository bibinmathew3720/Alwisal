//
//  MenuProfileTVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 6/3/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class MenuProfileTVC: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(setUserDetails), name: NSNotification.Name(rawValue: Constant.Notifications.UserProfileNotification), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func setUserDetails(){
        if let nameString = UserDefaults.standard.value(forKey: Constant.VariableNames.userName) {
            nameLabel.text = nameString as! String
        }
    }

}
