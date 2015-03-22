//
//  CreateGroupTableViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/17/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class CreateGroupTableViewController: UITableViewController {

    var course: [String: String]!
    var delegate: GroupSelectTableViewControllerDelegate!
    
    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var groupNameField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    
    @IBOutlet var dateTimeCell: UITableViewCell!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var noneButton: UIButton!
    
    var noneSelected = true
    var expanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.courseLabel.text = self.course["course_name"]
        self.noneButton.highlighted = true
        self.datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User actions
    
    @IBAction func dateButtonPressed(sender: UIButton) {
        dateTimePressed()
    }

    func dateTimePressed() {
        self.noneSelected = false
        self.noneButton.highlighted = true
        self.dateButton.titleLabel?.alpha = 1.0
        self.datePicker.alpha = 1.0
    }
    
    func datePickerChanged(datePicker: UIDatePicker) {
        dateTimePressed()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var date = dateFormatter.stringFromDate(datePicker.date)
        self.dateButton.setTitle(date, forState: UIControlState.Normal)
    }
    
    @IBAction func noneButtonPressed(sender: UIButton) {
        self.noneSelected = true
        self.dateButton.highlighted = true
        self.dateButton.titleLabel?.alpha = 0.25
        self.datePicker.alpha = 0.25
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createGroupPressed(sender: AnyObject) {
        let course = self.course["course_name"]
        let groupName = groupNameField.text
        if countElements(groupName) > 0 {
            let description = descriptionField.text //TODO: add column to relation and constants
            var date = "" //TODO: add column to relation and constants
            if noneSelected {
                date = "none"
            } else {
                date = self.dateButton.titleLabel?.text ?? ""
            }
            
            var group = PFObject(className: PF_GROUPS_CLASS_NAME)
            group[PF_GROUPS_NAME] = groupName
            group[PF_GROUPS_COURSEID] = self.course["course_id"]
            group.saveInBackgroundWithBlock ({ (success: Bool, error: NSError!) -> Void in
                if success {
                    ProgressHUD.showSuccess("Saved")
                    NSLog("Group \(group[PF_GROUPS_NAME]) created for class: \(group[PF_GROUPS_COURSEID])")
                } else {
                    ProgressHUD.showError("Network Error")
                    NSLog("%@", error)
                }
            })
        } else {
            ProgressHUD.showError("Group name field must not be empty")
        }
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
