//
//  ChatSettingsViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 3/27/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation

class ChatSettingsViewController: UITableViewController, UIActionSheetDelegate {

    let actionItems = [NOTIFY_ACTION, LEAVE_ACTION]
    var groupId: String = ""
    var users = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* only support portrait */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.users.count
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60.0
        }
        return 0.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { /* member secion */
            
            let cell = tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as UITableViewCell
            var user = self.users[indexPath.row]
            cell.textLabel?.text = user[PF_USER_FULLNAME] as? String
            
            /* load user's picture */
            var userImageView = PFImageView()
            userImageView.file = user[PF_USER_PICTURE] as? PFFile
            userImageView.loadInBackground { (image: UIImage!, error: NSError!) -> Void in
                if error != nil {
                    println(error)
                }
            }
            cell.imageView?.image = userImageView.image
            cell.accessoryType = UITableViewCellAccessoryType.DetailButton
            return cell
            
        } else { /* settings */
            
            let cell = tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as UITableViewCell
            var action = actionItems[indexPath.row]
            cell.textLabel?.text = action
            if action == NOTIFY_ACTION { /* notifications */
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else if action == LEAVE_ACTION { /* leave group */
                cell.textLabel?.textColor = UIColor.redColor()
            }
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { /* member section */
            
        } else { /* settings */
            var action = actionItems[indexPath.row]
            
            if action == LEAVE_ACTION {
                
                var leaveAlert = UIAlertController(title: "Leave Group?", message:"You won't get any new messages", preferredStyle: UIAlertControllerStyle.Alert)
                leaveAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
                    NSLog("Cancelled leave group")
                }))
                
                leaveAlert.addAction(UIAlertAction(title: "Leave", style: .Default, handler: { (action:UIAlertAction!) in
                    //TODO: remove user from pointer array
                }))
                presentViewController(leaveAlert, animated: true, completion: nil)
                
            } else if action == NOTIFY_ACTION {
                
            }
        }
    }
    
}
