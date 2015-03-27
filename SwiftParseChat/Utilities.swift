//
//  Utilities.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation

class Utilities {
    
    class func loginUser(target: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("navigationVC") as UINavigationController
        target.presentViewController(welcomeVC, animated: true, completion: nil)
        
    }
    
    class func postNotification(notification: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
    }
    
    class func timeElapsed(seconds: NSTimeInterval) -> String {
        var elapsed: String
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(suffix) ago"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(suffix) ago"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days" : "day"
            elapsed = "\(days) \(suffix) ago"
        }
        return elapsed
    }
    
    class func isIdenticalPFObject(obj1:PFObject, obj2:PFObject) -> Bool {
        if  obj1.parseClassName == obj2.parseClassName && obj1.objectId == obj2.objectId {
            return true
        }
        return false
    }
    
    class func getSemesterCode() -> String {
        let springMonths:[Int] = [1, 2, 3, 4, 5]
        let summerMonths:[Int] = [6, 7, 8]
        let fallMonths:[Int] = [9, 10, 11, 12]
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        let month = components.month
        let year = components.year
        var seasonCode = ""
        if contains(springMonths, month) {
            seasonCode = "SPRING"
        } else if contains(summerMonths, month) {
            seasonCode = "SUMMER"
        } else if contains(fallMonths, month) {
            seasonCode = "FALL"
        }
        var yearStr = String(year)
        var yearCode = (yearStr as NSString).substringFromIndex(2)
        var semesterCode = seasonCode + yearCode
        NSLog("Utilities: Semester code is \(semesterCode)")
        return semesterCode
    }
}

