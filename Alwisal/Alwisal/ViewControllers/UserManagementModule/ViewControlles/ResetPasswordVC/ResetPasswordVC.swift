//
//  ResetPasswordVC.swift
//  Alwisal
//
//  Created by Bibin Mathew on 4/28/18.
//  Copyright © 2018 SC. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseViewController {
    @IBOutlet weak var emailOrPhoneTF: UITextField!
    
    override func initView() {
        super.initView()
    }
    
    // MARK: Button Actions

    @IBAction func resetPasswordButtonAction(_ sender: UIButton) {
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
