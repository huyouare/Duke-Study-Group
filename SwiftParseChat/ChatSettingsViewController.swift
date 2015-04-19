//
//  ChatSettingsViewController.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 3/27/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Foundation

class ChatSettingsViewController: UITableViewController, UIActionSheetDelegate {

    let actionItems = [EDIT_GROUP_NAME, EDIT_DESCRIPTION, EDIT_TIME, EDIT_LOCATION, NOTIFY_ACTION, LEAVE_ACTION]
    var members = [PFUser]()
    var group: PFObject!
    var editAttribute:String!
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMembers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func loadMembers() {
        if self.group != nil {
            self.navBar.title = self.group[PF_GROUP_COURSE_NAME] as? String
            let users = self.group[PF_GROUP_USERS] as! [PFUser]!
            self.members.removeAll()
            self.members.extend(users)
            self.tableView.reloadData()
        }
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
            return self.members.count + 1
        case 1:
            return actionItems.count
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
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "newCell")
            if indexPath.row < self.members.count {
                var user = self.members[indexPath.row]
                cell.textLabel?.text = user[PF_USER_FULLNAME] as? String
                normalizeCell(cell)
                cell.accessoryType = UITableViewCellAccessoryType.None
                
                /* load user's picture */
                var userImageView = PFImageView()
                userImageView.file = user[PF_USER_PICTURE] as? PFFile
                userImageView.loadInBackground { (image: UIImage!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    }
                }
                if(userImageView.image == nil) {
                    cell.imageView?.image = UIImage(named: "profile_blank")
                } else {
                    cell.imageView?.image = userImageView.image
                }
                return cell
                
            } else { /* invite friends row */
                normalizeCell(cell)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.imageView?.image = UIImage(named: "invite")
                cell.textLabel?.text = "Add People"
                return cell
            }
            
        } else { /* settings */
            
            var action = actionItems[indexPath.row]
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "newCell")
            cell.textLabel?.text = action
            cell.detailTextLabel?.text = "Not Set"
            
            switch (action) {
                
            case NOTIFY_ACTION:
                normalizeCell(cell)
                cell.detailTextLabel?.text = ""
                return cell
                
            case LEAVE_ACTION:
                cell.textLabel?.textColor = UIColor.redColor()
                cell.detailTextLabel?.text = ""
                return cell
                
            case EDIT_GROUP_NAME:
                normalizeCell(cell)
                if self.group != nil {
                    if let name = self.group[PF_GROUP_NAME] as? String {
                        cell.detailTextLabel?.text = name
                    }
                }
                return cell
                
            case EDIT_LOCATION:
                normalizeCell(cell)
                if self.group != nil {
                    if let location = self.group[PF_GROUP_LOCATION] as? String {
                        cell.detailTextLabel?.text = location
                    }
                }
                return cell
                
            case EDIT_DESCRIPTION:
                normalizeCell(cell)
                if self.group != nil {
                    if let description = self.group[PF_GROUP_DESCRIPTION] as? String {
                        cell.detailTextLabel?.text = description
                    }
                }
                return cell
                
            case EDIT_TIME:
                normalizeCell(cell)
                if self.group != nil {
                    if let dateTime = self.group[PF_GROUP_DATETIME] as? NSDate {
                        let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(dateTime)
                        cell.detailTextLabel?.text = dateText + " " + JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(dateTime)
                    }
                }
                return cell
                
            default:
                normalizeCell(cell)
                return cell
            }
            
        }
    }
    
    func normalizeCell(cell:UITableViewCell) {
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.detailTextLabel?.text = ""
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { /* member section */
            if indexPath.row == self.members.count { /* add poeple part */
                var actionSheet: UIActionSheet!
                let user = PFUser.currentUser()
                if user[PF_USER_FACEBOOKID] == nil {
                    actionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles: "User Directory")
                } else {
                    actionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Facebook Friends", "User Directory")
                }
                actionSheet.showFromTabBar(self.tabBarController?.tabBar)
            } else { /* person profile */
                
            }
        } else { /* settings */
            var action = actionItems[indexPath.row]
            
            if action == LEAVE_ACTION {
                
                var leaveAlert = UIAlertController(title: "Leave Group?", message:"You won't get any new messages", preferredStyle: UIAlertControllerStyle.Alert)
                leaveAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
                    println("Cancelled leave group")
                }))
                
                leaveAlert.addAction(UIAlertAction(title: "Leave", style: .Default, handler: { (action:UIAlertAction!) in
                    self.removeSelfFromGroup()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                presentViewController(leaveAlert, animated: true, completion: nil)
                
            } else if action == NOTIFY_ACTION {
                
            } else if action == EDIT_TIME {
                self.editAttribute = action
                self.performSegueWithIdentifier("EditTimeSegue", sender: self)
            } else { /* text attribute settings */
                self.editAttribute = action
                self.performSegueWithIdentifier("EditTextSegue", sender: self)
            }
        }
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1: /* */
                break //TODO
            case 2:
                break //TODO
            default:
                break
            }
        }
    }
    
    func removeSelfFromGroup() {
        self.group.removeObject(PFUser.currentUser(), forKey: PF_GROUP_USERS)
        self.group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
            if error == nil {
                ProgressHUD.showSuccess(NETWORK_SUCCESS)
                println("Removed self from group \(self.group[PF_GROUP_NAME] as! String)")
            } else {
                ProgressHUD.showError(NETWORK_ERROR)
                println("%@", error)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTextSegue" {
            let createVC = segue.destinationViewController as! GroupTextEditViewController
            createVC.group = self.group
            createVC.editAttribute = self.editAttribute
        } else if segue.identifier == "EditTimeSegue" {
            let createVC = segue.destinationViewController as! GroupDateEditViewController
            createVC.group = self.group
            createVC.editAttribute = self.editAttribute
        }
    }
    
}
