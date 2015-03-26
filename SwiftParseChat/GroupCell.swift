//
//  GroupCell.swift
//  SwiftParseChat
//
//  Created by Justin (Zihao) Zhang on 3/26/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var labelGroupName: GroupCell!
    @IBOutlet weak var labelNumMembers: UILabel!
    @IBOutlet weak var labelMeetingDate: UILabel!
    //TODO: change
    func loadItem(groupName:String, meetingDate: String) {
        labelGroupName.textLabel?.text = groupName
        labelMeetingDate.text = meetingDate
    }
    
}
