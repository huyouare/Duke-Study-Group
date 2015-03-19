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
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createGroupPressed(sender: AnyObject) {
        
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
