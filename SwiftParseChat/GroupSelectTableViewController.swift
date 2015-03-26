//
//  GroupSelectTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/17/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

protocol GroupSelectTableViewControllerDelegate {
    func didSelectGroup(group: PFObject)
}

class GroupSelectTableViewController: UITableViewController {
    
    var course: [String: String]!
    var groups = [PFObject]()
    var selectedGroup: PFObject!
    var delegate: GroupSelectTableViewControllerDelegate!

    @IBOutlet var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroupData()
        refreshGroupTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadGroupData()
    }
    
    func loadGroupData() {
        if let subjectCode = course["subject_code"] {
            if let courseNumber = course["course_number"] {
                /* update navigation bar title */
                let titleString = subjectCode + " " + courseNumber
                self.navigationItem.title = titleString
                
                /* find groups for that course in Parse */
                let courseId = Utilities.getSemesterCode() + subjectCode + courseNumber
                var query = PFQuery(className: PF_USER_CLASS_NAME)
                query.whereKey(PF_USER_OBJECTID, equalTo: PFUser.currentUser())
//                query.includeKey(<#key: String!#>)
                
//                query.whereKey(PF_GROUP_COURSEID, equalTo: courseId)
//                query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
//                    if error == nil {
//                        for group in objects as [PFObject]! {
//                            if !self.hasGroup(group) {
//                                self.groups.append(group)
//                                NSLog("GroupSelectTableViewController: add group")
//                            }
//                        }
//                        self.refreshGroupTable()
//                        NSLog("GroupSelectTableViewController: finished loading course \(courseId)")
//                    } else {
//                        ProgressHUD.showError("Network error")
//                    }
//                })
                
                /* use strings as attributes */
                self.course["course_name"] = titleString
                self.course["course_id"] = courseId
            }
        }
    }
    
    func refreshGroupTable() {
        self.tableView.reloadData()
        /* show alternate view when no groups found */
        if self.groups.count > 0 {
            self.emptyView.hidden = true
        } else {
            self.emptyView.hidden = false
        }
    }
    
    func hasGroup(group:PFObject) -> Bool {
        for obj in self.groups {
            if Utilities.isIdenticalPFObject(obj, obj2: group) {
                return true
            }
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func createGroupButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("groupSelectToCreateSegue", sender: self)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups.count == 0 {
            return 0
        } else {
            return groups.count + 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == self.groups.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("newCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as GroupCell
        let curGroup:PFObject = self.groups[indexPath.item]
        //cell.loadItem(curGroup[PF_GROUP_NAME], meetingDate: curGroup[PF_GROUP_DATETIME])
        cell.loadItem(curGroup[PF_GROUP_NAME] as String, meetingDate: "none")
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.groups.count {
            self.performSegueWithIdentifier("groupSelectToCreateSegue", sender: self)
        }
        else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                if self.delegate != nil {
                    self.delegate.didSelectGroup(self.selectedGroup)
                }
            })
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupSelectToCreateSegue" {
            let createVC = segue.destinationViewController as CreateGroupTableViewController
            createVC.delegate = self.delegate
            createVC.course = self.course
        }
    }

}
