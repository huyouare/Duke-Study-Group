//
//  ProfilePasswordEditViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import UIKit

class ProfilePasswordEditViewController:UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repasswordField: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = EDIT_PASSWORD
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        let password = self.passwordField.text
        let repassword = self.repasswordField.text
        var user = PFUser.currentUser()
        
        if count(password) == 0 || count(repassword) == 0 {
            ProgressHUD.showError("Password must be set.")
            return
        }
        if password != repassword {
            ProgressHUD.showError("Passwords do not match!")
            return
        }
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        user[PF_USER_PASSWORD] = password
        user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
            if error == nil {
                ProgressHUD.showSuccess("Saved")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                ProgressHUD.showError("Email is already taken or network error")
            }
        })
    }
}
