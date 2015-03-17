//
//  SubjectTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/9/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController {

    var subjects: NSArray!
    var courses: NSArray!
    var delegate: GroupSelectTableViewControllerDelegate!
    var selectedSubject: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = NSBundle.mainBundle().pathForResource("courses", ofType: "json") {
            if let jsonData = NSData.dataWithContentsOfMappedFile(path) as? NSData {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                self.subjects = jsonResult.objectForKey("subjects") as NSArray!
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        if let subject = self.subjects[indexPath.row] as? NSDictionary {
            if let subjectCode = subject["code"] as? String {
                cell.textLabel?.text = subjectCode
            }
            if let subjectDesc = subject["desc"] as? String {
                cell.detailTextLabel?.text = subjectDesc
            }
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let subject = self.subjects[indexPath.row] as? NSDictionary {
            if let courses = subject["courses"] as? NSArray {
                self.selectedSubject = subject
                self.courses = courses
                self.performSegueWithIdentifier("subjectToCourseSegue", sender: self)
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "subjectToCourseSegue" {
            let courseVC = segue.destinationViewController as CourseTableViewController
            courseVC.delegate = self.delegate
            courseVC.subject = self.selectedSubject
            courseVC.courses = self.courses
            courseVC.subjectVC = self
        }
    }

}
