//
//  DukeLoginViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class DukeLoginViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var netIdField: UITextField!
    @IBOutlet var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.netIdField.delegate = self
        self.passwordField.delegate = self
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.netIdField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.netIdField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.login()
        }
        return true
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        self.login()
    }
    
    func login() {
        let netId = netIdField.text.lowercaseString
        let password = passwordField.text
        
        if count(netId) == 0 {
            ProgressHUD.showError("NetID field is empty.")
            return
        } else {
            ProgressHUD.showError("Password field is empty.")
        }
        
        ProgressHUD.show("Signing in...", interaction: true)
        
        //        PFUser.logInWithUsernameInBackground(email, password: password) { (user: PFUser!, error: NSError!) -> Void in
        //            if user != nil {
        //                PushNotication.parsePushUserAssign()
        //                ProgressHUD.showSuccess("Welcome back, \(user[PF_USER_FULLNAME])!")
        //                self.dismissViewControllerAnimated(true, completion: nil)
        //            } else {
        //                if let info = error.userInfo {
        //                    ProgressHUD.showError(info["error"] as String)
        //                }
        //            }
        //        }
    }
}
