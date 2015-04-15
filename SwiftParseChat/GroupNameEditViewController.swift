//
//  GroupNameEditViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/6/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Foundation

class GroupNameEditViewController:UIViewController {
    var group: PFObject!
    
    @IBOutlet weak var nameField: UITextField!
    @IBAction func saveName(sender: AnyObject) {
        var name = nameField.text
        if count(name) > 0 {
            self.group[PF_GROUP_NAME] = nameField.text
            self.group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
                if error == nil {
                    ProgressHUD.showSuccess(NETWORK_SUCCESS)
                    println("Renamed group to \(self.group[PF_GROUP_NAME] as! String)")
                } else {
                    ProgressHUD.showError(NETWORK_ERROR)
                    println("%@", error)
                }
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = self.group[PF_GROUP_NAME] as? String
    }
}
