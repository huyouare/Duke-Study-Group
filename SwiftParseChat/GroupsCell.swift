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

        self.courseLabel.text = group[PF_GROUP_COURSE_NAME] as? String
        self.nameLabel.text = group[PF_GROUP_NAME] as? String
        var date = group[PF_GROUP_DATETIME] as? NSDate
        var location = group[PF_GROUP_LOCATION] as? String
        if date != nil {
            let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(date)
            if dateText == "Today" {
                self.dateTimeLabel.text = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(date)
            } else {
                self.dateTimeLabel.text = dateText
            }
            self.locationLabel.text = location
        } else if location != nil && countElements(location!) > 0 {
            self.dateTimeLabel.removeFromSuperview()
            self.locationLabel.text = location
        } else {
            nextMeetingLabel.text = ""
            dateTimeLabel.text = ""
            locationLabel.text = ""
        }
        
        let users = group[PF_GROUP_USERS] as [PFUser]!
        
        if users.count > self.avatarImageViews.count {
            self.moreImageView.hidden = false
            let moreCount = users.count - self.avatarImageViews.count
            self.countLabel.text = "+\(moreCount)"
            self.moreImageView.layer.cornerRadius = CGFloat(15.0)
            self.moreImageView.clipsToBounds = true
        } else {
            self.moreImageView.hidden = true
        }
        for i in 0..<self.avatarImageViews.count {
            if i < users.count {
                self.avatarImageViews[i].layer.cornerRadius = self.avatarImageViews[i].frame.size.width / 2
                self.avatarImageViews[i].layer.masksToBounds = true
                
                let user = users[i]
                self.avatarImageViews[i].file = user[PF_USER_PICTURE] as? PFFile
                self.avatarImageViews[i].loadInBackground(nil)
            }
        }
    }
    

}
