//
//  CourseTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/9/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

protocol CourseTableViewControllerDelegate {
    func didSelectCourse(course: [String: String])
}

class CourseTableViewController: UITableViewController {
    
    var subject: NSDictionary!
    var courses: NSArray!
    var delegate: GroupSelectTableViewControllerDelegate!
    var selectedCourse: [String: String]!
    var subjectVC: SubjectTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        if let course = self.courses[indexPath.row] as? [String: String] {
            cell.textLabel?.text = course["course_number"]
            cell.detailTextLabel?.text = course["course_title"]
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        /* Retrieve course and append subject code and name */
        if let course = self.courses[indexPath.row] as? [String: String] {
            self.selectedCourse = course
            if let code = self.subject["code"] as? String {
                self.selectedCourse["subject_code"] = code
            }
            if let desc = self.subject["desc"] as? String {
                self.selectedCourse["subject_desc"] = desc
            }
            
            self.performSegueWithIdentifier("courseToGroupsSegue", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "courseToGroupsSegue" {
            let groupSelectVC = segue.destinationViewController as GroupSelectTableViewController
            groupSelectVC.delegate = self.delegate
            groupSelectVC.course = self.selectedCourse
            groupSelectVC.subjectVC = self.subjectVC
        }
    }

}
