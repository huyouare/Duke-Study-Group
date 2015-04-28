//
//  RegisterViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import SHEmailValidator

class RegisterViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: SHEmailValidationTextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        self.tableView?.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            self.register()
        }
        return true
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        self.register()
    }
    
    func register() {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        
        if count(name) == 0 {
            ProgressHUD.showError("Name must be set")
            return
        }
        if !Utilities.validateEmail(self.emailField.text) {
            return
        }
        if count(password) == 0 {
            ProgressHUD.showError("Password must be set")
            return
        }
        if count(confirmPassword) == 0 || password != confirmPassword {
            ProgressHUD.showError("Passwords do not match")
            return
        }
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        var user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        user[PF_USER_EMAILCOPY] = email
        user[PF_USER_FULLNAME] = name
        user[PF_USER_FULLNAME_LOWER] = name.lowercaseString
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error == nil {
                PushNotication.parsePushUserAssign()
                ProgressHUD.showSuccess("Success")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let userInfo = error.userInfo {
                    ProgressHUD.showError(userInfo["error"] as! String)
                }
            }
        }
    }
    
    func validateEmail() -> Bool {
        var error: NSError?
        let validator = SHEmailValidator()
        validator.validateSyntaxOfEmailAddress(emailField.text, withError: &error)
        if error != nil {
            if let code = error?.code {
                switch UInt32(code) {
                case SHBlankAddressError.value:
                    ProgressHUD.showError("Email must be set")
                    break
//                case SHInvalidSyntaxError.value:
//                    ProgressHUD.showError("Email has invalid syntax")
//                    break
//                case SHInvalidUsernameError.value:
//                    ProgressHUD.showError("Email local portion is invalid")
//                    break
//                case SHInvalidDomainError.value:
//                    ProgressHUD.showError("Email domain is invalid")
//                    break
//                case SHInvalidTLDError.value:
//                    ProgressHUD.showError("Email TLD is invalid")
//                    break
                default:
                    ProgressHUD.showError("Invalid email")
                    break
                }
            }
            return false
        } else {
            return true
        }
    }

}
