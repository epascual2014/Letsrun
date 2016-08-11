//
//  CircleView.swift
//  Letsrun
//
//  Created by Edrick Pascual on 8/10/16.
//  Copyright © 2016 Edge Designs. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
    
}
