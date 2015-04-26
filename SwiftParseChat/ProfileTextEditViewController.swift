//
//  ProfileTextEditViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import UIKit

class ProfileTextEditViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    var editAttribute: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.title = editAttribute
        var user = PFUser.currentUser()
        
        switch (editAttribute) {
        case EDIT_PROFILE_NAME:
            self.textField.text = user[PF_USER_FULLNAME] as? String
            break
        case EDIT_EMAIL:
            self.textField.text = user[PF_USER_EMAIL] as? String
            break
        default:
            self.textField.text = ""
        }
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        let attribute = self.textField.text
        var user = PFUser.currentUser()
        
        if count(attribute) > 0 {
            switch (self.editAttribute) {
            case EDIT_PROFILE_NAME:
                user[PF_USER_FULLNAME] = attribute
                user[PF_USER_FULLNAME_LOWER] = attribute.lowercaseString
                break
            case EDIT_EMAIL:
                if !Utilities.validateEmail(attribute) {
                    return
                }
                user[PF_USER_EMAIL] = attribute
                break
            default:
                println("save unknown attribute")
            }
            
            user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if error == nil {
                    ProgressHUD.showSuccess("Saved")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    ProgressHUD.showError("Email is already taken or network error")
                }
            })
        } else {
            ProgressHUD.showError("Text field must not be empty")
        }
    }
}