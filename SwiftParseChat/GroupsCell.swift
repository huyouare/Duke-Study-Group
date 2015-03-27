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
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var moreImageView: UILabel!
//    @IBOutlet var avatarImageViews: [PFImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(group: PFObject) {
        var currentUser = PFUser.currentUser()

        self.courseLabel.text = group[PF_GROUP_COURSE_NAME] as? String
        self.nameLabel.text = group[PF_GROUP_NAME] as? String
        
        let users = group[PF_GROUP_USERS] as [PFUser]!
//        for i in 0..<3 {
//            if i < users.count {
//                let user = users[i]
//                self.avatarImageViews[i].file = user[PF_USER_PICTURE] as? PFFile
//                self.avatarImageViews[i].loadInBackground({ (image: UIImage!, error: NSError!) -> Void in
//                    if error != nil {
//                        println(error)
//                    }
//                })
//            }
//        }
    }
    

}
