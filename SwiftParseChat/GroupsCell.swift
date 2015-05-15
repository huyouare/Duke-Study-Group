//
//  GroupsCell.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
//    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var nextMeetingLabel: UILabel!
    
    @IBOutlet var moreImageView: UILabel!
    @IBOutlet var avatarImageViews: [PFImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func bindData(group: PFObject) {
        var currentUser = PFUser.currentUser()
        courseLabel.text = group[PF_GROUP_COURSE_NAME] as? String
        nameLabel.text = group[PF_GROUP_NAME] as? String
        var date = group[PF_GROUP_DATETIME] as? NSDate
        var location = group[PF_GROUP_LOCATION] as? String
        var dateSet = (date != nil)
        var locationSet = (location != nil && count(location!) > 0)
        let todayDate = NSDate()
        
        if dateSet {
            let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(date)
            if dateText == "Today" {
                dateTimeLabel.text = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(date)
                dateTimeLabel.textColor = UIColor.blueColor()
            } else {
                if date?.compare(todayDate) == NSComparisonResult.OrderedAscending { /* meeting date is past */
                    nextMeetingLabel.text = "Last Meeting:"
                }
                if dateText.rangeOfString(",") != nil {
                    dateTimeLabel.text = dateText.substringToIndex(dateText.rangeOfString(",")!.startIndex) //year is preceded by a colon
                } else {
                    dateTimeLabel.text = dateText
                }
                dateTimeLabel.textColor = UIColor.blackColor()
            }
        } else {
            locationLabel.enabled = false
        }
        
        if locationSet {
            if !dateSet {
                dateTimeLabel.text = location //set dateTimeLabel to location to provide a work around for issue #71
            } else {
                locationLabel.text = location
            }
        }
        
        if !dateSet && !locationSet {
            nextMeetingLabel.text = ""
            dateTimeLabel.text = ""
            locationLabel.text = ""
        }
        
        let users = group[PF_GROUP_USERS] as! [PFUser]!
        
        if users.count > avatarImageViews.count {
            moreImageView.hidden = false
            let moreCount = users.count - avatarImageViews.count
            countLabel.text = "+\(moreCount)"
            moreImageView.layer.cornerRadius = CGFloat(15.0)
            moreImageView.clipsToBounds = true
        } else {
            moreImageView.hidden = true
        }
        
        for i in 0..<avatarImageViews.count {
            if i < users.count {
                self.avatarImageViews[i].layer.cornerRadius = self.avatarImageViews[i].frame.size.width / 2
                self.avatarImageViews[i].layer.masksToBounds = true
                self.avatarImageViews[i].image = UIImage(named: "profile_blank") //placeholder image
                
                let user = users[i]
                let picFile = user[PF_USER_PICTURE] as? PFFile
                picFile?.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.avatarImageViews[i].image = UIImage(data:imageData)
                        }
                    }
                }
            }
        }
    }
    
    func clear() {
        courseLabel.text = ""
        nameLabel.text = ""
        nextMeetingLabel.text = "Next Meeting:"
        dateTimeLabel.text = ""
        locationLabel.text = ""
        locationLabel.enabled = true
        for i in 0..<avatarImageViews.count {
            self.avatarImageViews[i].image = nil
        }
        moreImageView.hidden = false
        countLabel.text = ""
    }

}
