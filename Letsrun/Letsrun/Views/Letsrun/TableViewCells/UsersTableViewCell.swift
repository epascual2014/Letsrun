//
//  UsersTableViewCell.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/25/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit
import Firebase

protocol UsersTableViewCellDelegate: class {
    
    func cell(cell: UsersTableViewCell, didSelectFollowUser user: Users)
    func cell(cell: UsersTableViewCell, didSelectUnfollowUser user: Users)
    
}

class UsersTableViewCell: UITableViewCell {
    
    var delegate: UsersTableViewCellDelegate?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLoginameLabel: UILabel!
    @IBOutlet weak var addOrRemoveFriendButton: UIButton!
    
    override func drawRect(rect: CGRect) {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
    }
    
    var user: Users? {
        didSet {
            userLoginameLabel.text = user?.loginName

            if let userImageUrl = user?.imageProfileUrl {
                userImageView.loadImageUsingCacheWithUrlString(userImageUrl)
            }
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            // Change the state of the button whethere it is possible to be add friend.
            if let userCanFollow = canFollow {
                addOrRemoveFriendButton.selected = !userCanFollow
            }
        }
    }
    
    @IBAction func addOrRemoveFriendTapped(sender: AnyObject) {
        if let thisUserCanFollow = canFollow where thisUserCanFollow == true {
            self.canFollow = false
           delegate?.cell(self, didSelectFollowUser: user!)
           
        } else {
            self.canFollow = true
           delegate?.cell(self, didSelectUnfollowUser: user!)
        }
        
    }
    
}
