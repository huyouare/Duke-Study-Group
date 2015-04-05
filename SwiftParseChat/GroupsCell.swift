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
//        self.descriptionLabel.text = group[PF_GROUP_DESCRIPTION] as? String
//        self.descriptionLabel.removeFromSuperview()
        var date = group[PF_GROUP_DATETIME] as? NSDate
        if date != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateTimeLabel.text = dateFormatter.stringFromDate(date!)
        }
        locationLabel.text = group[PF_GROUP_LOCATION] as? String
        
        let users = group[PF_GROUP_USERS] as [PFUser]!
        
        if users.count > self.avatarImageViews.count {
            let moreCount = users.count - self.avatarImageViews.count
            self.countLabel.text = "+\(moreCount)"
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
