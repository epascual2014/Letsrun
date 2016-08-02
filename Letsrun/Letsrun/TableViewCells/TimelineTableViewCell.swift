//
//  TimelineTableViewCell.swift
//  Letsrun
//
//  Created by Edrick Pascual on 7/19/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupRunsLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    
    override func drawRect(rect: CGRect) {
        groupImageView.layer.cornerRadius = groupImageView.frame.width / 2
        groupImageView.clipsToBounds = true
    }
    
    
}