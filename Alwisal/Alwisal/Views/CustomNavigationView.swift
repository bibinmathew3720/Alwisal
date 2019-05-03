//
//  CustomNavigationView.swift
//  Alwisal
//
//  Created by Bibin Mathew on 3/27/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

protocol NavigationViewDelegate {
    func infoButtonActionDelegate()
    func hamburgerActionDelegate()
}

class CustomNavigationView: UIView {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var navigationBackImage: UIImageView!
    var navigationViewDelegate : NavigationViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
        navigationViewDelegate?.infoButtonActionDelegate()
        
    }
    
    @IBAction func hamburgerButtonAction(_ sender: UIButton) {
        navigationViewDelegate?.hamburgerActionDelegate()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
