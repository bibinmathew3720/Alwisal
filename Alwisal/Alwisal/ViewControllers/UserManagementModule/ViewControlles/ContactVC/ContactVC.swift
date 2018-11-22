//
//  ContactVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 4/28/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ContactVC: BaseViewController {

    override func initView() {
        super.initView()
        addingNavigationBarView(title: "اتصل بنا", fromTabBar: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
