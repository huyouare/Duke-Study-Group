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
    var subjectVC: SubjectTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let code = course["subject_code"] {
            if let number = course["course_number"] {
                let courseId = code + number
                var query = PFQuery(className: PF_GROUPS_CLASS_NAME)
                query.whereKey(PF_GROUPS_COURSEID, equalTo: courseId)
                query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        if count(objects) > 0 {
                            for group in objects as [PFObject]! {
                                groups.append(group)
                            }
                        } else {
                            // No groups found
                        }
                    } else {
                        ProgressHUD.showError("Network error")
                    }
                })
//                var object = PFObject(className: PF_GROUPS_CLASS_NAME)
//                object[PF_GROUPS_NAME] =
//                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
//                    if success {
//                        self.loadGroups()
//                    } else {
//                        ProgressHUD.showError("Network error")
//                        println(error)
//                    }
//                })
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as UITableViewCell

        self.subjectVC.dismissViewControllerAnimated(true, completion: { () -> Void in
            if self.delegate != nil {
                /* Retrieve course and append subject code and name */
                
                self.delegate.didSelectGroup(self.selectedGroup)
            }
        })
        

        
        return cell
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
