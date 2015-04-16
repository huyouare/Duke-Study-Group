//
//  GroupTextEditViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 4/16/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Foundation

class GroupTextEditViewController:UIViewController {
    
    var group: PFObject!
    var editAttribute:String!

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var attributeField: UITextField!
    @IBAction func saveButton(sender: AnyObject) {
        var attribute = attributeField.text
        if count(attribute) > 0 {
            switch (editAttribute) {
            case EDIT_GROUP_NAME:
                self.group[PF_GROUP_NAME] = attribute
            case EDIT_LOCATION:
                self.group[PF_GROUP_LOCATION] = attribute
            case EDIT_DESCRIPTION:
                self.group[PF_GROUP_DESCRIPTION] = attribute
            default:
                self.group[PF_GROUP_NAME] = attribute
            }
            
            self.group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
                if error == nil {
                    ProgressHUD.showSuccess(NETWORK_SUCCESS)
                    println("Changed group's \(self.editAttribute) to \(attribute)")
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
        switch (editAttribute) {
        case EDIT_GROUP_NAME:
            attributeField.text = self.group[PF_GROUP_NAME] as? String
            navigationBar.title = EDIT_GROUP_NAME
        case EDIT_LOCATION:
            attributeField.text = self.group[PF_GROUP_LOCATION] as? String
            navigationBar.title = EDIT_LOCATION
        case EDIT_DESCRIPTION:
            attributeField.text = self.group[PF_GROUP_DESCRIPTION] as? String
            navigationBar.title = EDIT_DESCRIPTION
        default:
            attributeField.text = ""
            navigationBar.title = ""
        }
    }

}