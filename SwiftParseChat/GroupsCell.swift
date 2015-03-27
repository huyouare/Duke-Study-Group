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
    @IBOutlet var avatarImageViews: PFImageView!
    
    var group: PFObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(group: PFObject) {
        self.group = group
        var user = PFUser.currentUser()

        self.courseLabel.text = group[PF_GROUP_COURSE_NAME] as? String
        self.nameLabel.text = group[PF_GROUP_NAME] as? String
        
        
//        userImageView.file = user[PF_USER_PICTURE] as? PFFile
//        userImageView.loadInBackground { (image: UIImage!, error: NSError!) -> Void in
//            if error != nil {
//                println(error)
//            }
//        }
    }
    

}
