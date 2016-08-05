//
//  GroupMemberCollectionViewCell.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/4/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit

class GroupMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    
    override func drawRect(rect: CGRect) {
        groupImageView.layer.cornerRadius = groupImageView.frame.width / 2
        groupImageView.clipsToBounds = true
    }
}
