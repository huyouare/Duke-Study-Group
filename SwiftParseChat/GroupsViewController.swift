//
//  GroupViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
// Parse loaded from SwiftParseChat-Bridging-Header.h

class GroupsViewController: UITableViewController, UIAlertViewDelegate, GroupSelectTableViewControllerDelegate {
    
    var groups: [PFObject]! = []
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if PFUser.currentUser() != nil {
            self.loadGroups()
        }
        else {
            Utilities.loginUser(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroups() {
        var query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!)  in
            if error == nil {
                self.groups.removeAll()
                self.groups.extend(objects as [PFObject]!)
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                println(error)
            }
        }
    }
    
    /* // Old function
    func actionNew() {
        var alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            var textField = alertView.textFieldAtIndex(0);
            if let text = textField!.text {
                if countElements(text) > 0 {
                    var object = PFObject(className: PF_GROUPS_CLASS_NAME)
                    object[PF_GROUPS_NAME] = text
                    object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                        if success {
                            self.loadGroups()
                        } else {
                            ProgressHUD.showError("Network error")
                            println(error)
                        }
                    })
                }
            }
        }
    }
    */
    
    // MARK: - TableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var group = self.groups[indexPath.row]
        cell.textLabel?.text = group[PF_GROUPS_NAME] as? String
        
        var query = PFQuery(className: PF_CHAT_CLASS_NAME)
        query.whereKey(PF_CHAT_GROUPID, equalTo: group.objectId)
        query.orderByDescending(PF_CHAT_CREATEDAT)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if let chat = objects.first as? PFObject {
                let date = NSDate()
                let seconds = date.timeIntervalSinceDate(chat.createdAt)
                let elapsed = Utilities.timeElapsed(seconds);
                let countString = (objects.count > 1) ? "\(objects.count) messages" : "\(objects.count) message"
                cell.detailTextLabel?.text = "\(countString) \(elapsed)"
            } else {
                cell.detailTextLabel?.text = "0 messages"
            }
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var group = self.groups[indexPath.row]
        let groupId = group.objectId as String
        
        Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUPS_NAME] as String)
        
        self.performSegueWithIdentifier("groupChatSegue", sender: groupId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destinationViewController as ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as String
            chatVC.groupId = groupId
        } else if segue.identifier == "groupsToSubjectSegue" {
            let subjectVC = segue.destinationViewController.topViewController as SubjectTableViewController
            subjectVC.delegate = self
        }
    }
    
    // MARK: - GroupSelectTableViewController Delegate
    
    func didSelectGroup(group: PFObject) {
    }
}
